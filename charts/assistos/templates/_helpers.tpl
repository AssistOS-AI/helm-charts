{{/*
Expand the name of the chart.
*/}}
{{- define "assistos.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "assistos.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "assistos.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "assistos.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "assistos.labels" -}}
helm.sh/chart: {{ include "assistos.chart" . }}
{{ include "assistos.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "assistos.selectorLabels" -}}
app.kubernetes.io/name: {{ include "assistos.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "assistos.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "assistos.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "assistos.pvc" -}}
{{- if .Values.persistence.existingClaim }}
{{- .Values.persistence.existingClaim }}
{{- else }}
{{- include "assistos.fullname" . }}
{{- end }}
{{- end }}

{{/*
Configuration env.json
*/}}
{{- define "assistos.envJson" -}}
{
  "PSK_TMP_WORKING_DIR": "tmp",
  "PSK_CONFIG_LOCATION": "../apihub-root/external-volume/config",
  "DEV": {{ required "config.dev must be set" .Values.config.dev | quote}},
  "VAULT_DOMAIN": {{ required "config.vaultDomain must be set" .Values.config.vaultDomain | quote}},
  "BUILD_SECRET_KEY": {{ required "config.buildSecretKey must be set" .Values.config.buildSecretKey | quote}},
  "SSO_SECRETS_ENCRYPTION_KEY": {{ required "config.ssoSecretsEncryptionKey must be set" .Values.config.ssoSecretsEncryptionKey | quote}},
  "BDNS_ROOT_HOSTS": "http://127.0.0.1:8080",
  "OPENDSU_ENABLE_DEBUG": {{ required "config.dev must be set" .Values.config.dev | quote}},
  "BASE_URL": {{ required "config.productionBaseUrl must be set" .Values.config.productionBaseUrl | quote}},
  "LOG_LEVEL": {{ required "config.logLevel must be set" .Values.config.logLevel | quote}}
}
{{- end }}

{{/*
Configuration apihub.json.
*/}}
{{- define "assistos.apihubJson" -}}
{
    "storage": "../apihub-root",
    "lightDBStorage": "../data-volume/lightDB",
    "externalStorage": "../data-volume",
    "workers": 1,
    "port": 8080,
    "preventRateLimit": true,
    "activeComponents": [
        "bdns",
        "bricking",
        "anchoring",
        "enclave",
        "mq",
        "secrets",
        "versionlessDSU",
        "llms",
        "users-storage",
        "document",
        "spaces-storage",
        "knowledge-storage",
        "applications-storage",
        "server-flow-apis",
        "personalities-storage",
        "chat",
        "subscribers",
        "webhook",
        "tasks",
        "logger",
        "flows",
        "telegram-chat",
        "lightDBEnclave",
        "staticServer"
    ],
    "componentsConfig": {
        "staticServer": {
            "excludedFiles": [
                ".*.secret"
            ],
            "root": "../apihub-root/"
        },
        "bricking": {},
        "anchoring": {},
        "llms": {
            "module": "./../../apihub-components/llms"
        },
        "users-storage": {
            "module": "./../../apihub-components/users-storage"
        },
        "document": {
            "module": "./../../apihub-components/document"
        },
        "spaces-storage": {
            "module": "./../../apihub-components/spaces-storage"
        },
        "chat": {
            "module": "./../../apihub-components/chat"
        },
        "personalities-storage": {
            "module": "./../../apihub-components/personalities-storage"
        },
        "applications-storage": {
            "module": "./../../apihub-components/applications-storage"
        },
        "server-flow-apis": {
            "module": "./../../apihub-components/applications-storage"
        },
        "subscribers": {
            "module": "./../../apihub-components/subscribers"
        },
        "flows": {
            "module": "./../../apihub-components/flows"
        },
        "webhook": {
            "module": "./../../apihub-components/webhook"
        },
        "tasks": {
            "module": "./../../apihub-components/tasks"
        },
        "logger": {
            "module": "./../../apihub-components/logger"
        },
        "telegram-chat": {
            "module": "./../../apihub-components/telegram-chat"
        }
    },
    "responseHeaders": {
        "X-Frame-Options": "SAMEORIGIN",
        "X-XSS-Protection": "1; mode=block"
    },
    "enableRequestLogger": true,
    "enableJWTAuthorisation": false,
    "enableOAuth": false
}
{{- end }}
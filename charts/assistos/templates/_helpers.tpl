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
  "CLOUD_ENCLAVE_DOMAIN": {{ required "config.cloudEnclaveDomain must be set" .Values.config.cloudEnclaveDomain | quote}},
  "BUILD_SECRET_KEY": {{ required "config.buildSecretKey must be set" .Values.config.buildSecretKey | quote}},
  "CLOUD_ENCLAVE_CONFIG_LOCATION": {{ required "config.cloudEnclaveConfigLocation must be set" .Values.config.cloudEnclaveConfigLocation | quote}},
  "CLOUD_ENCLAVE_SECRET": {{ required "config.cloudEnclaveSecret must be set" .Values.config.cloudEnclaveSecret | quote}},
  "SSO_SECRETS_ENCRYPTION_KEY": {{ required "config.ssoSecretsEncryptionKey must be set" .Values.config.ssoSecretsEncryptionKey | quote}},
  "BDNS_ROOT_HOSTS": "http://127.0.0.1:8080",
  "OPENDSU_ENABLE_DEBUG": {{ required "config.dev must be set" .Values.config.dev | quote}},
  "BASE_URL": {{ required "config.productionBaseUrl must be set" .Values.config.productionBaseUrl | quote}},
  "LOG_LEVEL": {{ required "config.logLevel must be set" .Values.config.logLevel | quote}},
  "SENDGRID_API_KEY": {{ required "config.sendgridApiKey must be set" .Values.config.sendgridApiKey | quote}},
  "APP_SENDER_EMAIL": {{ required "config.appSenderEmail must be set" .Values.config.appSenderEmail | quote}},
  "SENDGRID_SENDER_EMAIL": {{ required "config.sendgridSenderEmail must be set" .Values.config.sendgridSenderEmail | quote}},
  "MAILJET_API_KEY": {{ required "config.mailjetApiKey must be set" .Values.config.mailjetApiKey | quote}},
  "MAILJET_SECRET_KEY": {{ required "config.mailjetSecretKey must be set" .Values.config.mailjetSecretKey | quote}},
  "AUTH_API_PREFIX": {{ required "config.authApiPrefix must be set" .Values.config.authApiPrefix | quote}},
  "LOGS_FOLDER": {{ required "config.logsFolder must be set" .Values.config.logsFolder | quote}},
  "AUDIT_FOLDER": {{ required "config.auditFolder must be set" .Values.config.auditFolder | quote}},
  "SERVERLESS_ID": {{ required "config.serverlessId must be set" .Values.config.serverlessId | quote}},
  "SERVERLESS_STORAGE": {{ required "config.serverlessStorage must be set" .Values.config.serverlessStorage | quote}},
  "APP_NAME": {{ required "config.appName must be set" .Values.config.appName | quote}},
  "RP_ID": {{ required "config.rpId must be set" .Values.config.rpId | quote}},
  "ORIGIN": {{ required "config.origin must be set" .Values.config.origin | quote}},
  "NODE_ENV": {{ required "config.nodeEnv must be set" .Values.config.nodeEnv | quote}},
  "LLM_PROVIDERS_FOLDER": {{ required "config.llmProvidersFolder must be set" .Values.config.llmProvidersFolder | quote}},
  "SYSADMIN_EMAIL": {{ required "config.sysadminEmail must be set" .Values.config.sysadminEmail | quote}},
  "SYSADMIN_SPACE": {{ required "config.sysadminSpace must be set" .Values.config.sysadminSpace | quote}},
  "SYSTEM_MINT_AMOUNT": {{ required "config.systemMintAmount must be set" .Values.config.systemMintAmount }},
  "FOUNDER_PERCENTAGE": {{ required "config.founderPercentage must be set" .Values.config.founderPercentage }}
}
{{- end }}

{{/*
Configuration apihub.json.
*/}}
{{- define "assistos.apihubJson" -}}
{
    "storage": "../apihub-root",
    "workers": 1,
    "lightDBStorage": "../apihub-root/external-volume/lightDB",
    "externalStorage": "../apihub-root/external-volume",
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
        "Gatekeeper",
        "proxy",
        "globalServerlessAPI",
        "llms",
        "document",
        "knowledge-storage",
        "chat",
        "subscribers",
        "tasks",
        "logger",
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
        "document": {
            "module": "./../../apihub-components/document"
        },
        "globalServerlessAPI": {
            "module": "./../../apihub-components/globalServerlessAPI"
        },
        "chat": {
            "module": "./../../apihub-components/chat"
        },
        "subscribers": {
            "module": "./../../apihub-components/subscribers"
        },
        "tasks": {
            "module": "./../../apihub-components/tasks"
        },
        "logger": {
            "module": "./../../apihub-components/logger"
        },
        "telegram-chat": {
            "module": "./../../apihub-components/telegram-chat"
        },
        "Gatekeeper": {
            "module": "./../../apihub-components/Gatekeeper"
        }
    },
    "responseHeaders": {
        "X-Frame-Options": "SAMEORIGIN",
        "X-XSS-Protection": "1; mode=block",
        "Content-Security-Policy": "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; object-src 'none'; base-uri 'self'"
    },
    "enableRequestLogger": true,
    "enableJWTAuthorisation": false,
    "enableOAuth": false,
    "enableLocalhostAuthorization": false
}
{{- end }}
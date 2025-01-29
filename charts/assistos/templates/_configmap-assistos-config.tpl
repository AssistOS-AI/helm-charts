{{- /*
Template for Configmap.

Arguments to be passed are 
- $ (index 0)
- . (index 1)
- suffix (index 2)
- dictionary (index 3) for annotations used for defining helm hooks.

See https://blog.flant.com/advanced-helm-templating/
*/}}
{{- define "assistos.configmap-assistos-config" -}}
{{- $ := index . 0 }}
{{- $suffix := index . 2 }}
{{- $annotations := index . 3 }}
  {{- with index . 1 }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "assistos.fullname" . }}-config{{ $suffix | default "" }}
  namespace: {{ template "assistos.namespace" . }}
  {{- with $annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "assistos.labels" . | nindent 4 }}
data:
    config.json: |-
    {{- if .Values.config.overrides.configJson }}
    {{ .Values.config.overrides.configJson | indent 4 }}
    {{- else }}
        {
          "ENVIRONMENT_MODE": {{ .Values.config.environmentMode | quote }},
          "PRODUCTION_BASE_URL": {{ .Values.config.productionBaseUrl | quote }},
          "DEVELOPMENT_BASE_URL": "http://localhost:8080",
          "SERVER_ROOT_FOLDER": "./apihub-root",
          "SECURITY_MODULE_PATH": "./apihub-space-core/securityModule.json",
          "STORAGE_VOLUME_PATH": "./data-volume",
          "CLEAN_STORAGE_VOLUME_ON_RESTART": {{ .Values.config.cleanStorageVolumeOnRestart | quote }},
          "CREATE_DEMO_USER": false,
          "REGENERATE_TOKEN_SECRETS_ON_RESTART": false,
          "LLMS_SERVER_DEVELOPMENT_BASE_URL": "http://localhost:8079",
          "LLMS_SERVER_PRODUCTION_BASE_URL": {{ .Values.config.llmsServerProductionBaseUrl | quote }},
          "S3": {{ .Values.config.s3 | quote }}
        }
    {{- end }}

    securityConfig.json: |-
    {{- if .Values.config.overrides.securityConfigJson }}
    {{ .Values.config.overrides.securityConfigJson | indent 4 }}
    {{- else }}
        {
          "SERVER_ROOT_FOLDER": "./apihub-root",
          "JWT": {
            "secretContainerName": "JWT",
            "AccessToken": {
              "typ": "JWT",
              "algorithm": "HS256",
              "expiresIn": {
                "minutes": 15
              },
              "issuer": "AssistOS",
              "audience": "AssistOS"
            },
            "RefreshToken": {
              "typ": "JWT",
              "algorithm": "HS256",
              "expiresIn": {
                "days": 30
              },
              "issuer": "AssistOS",
              "audience": "AssistOS"
            },
            "EmailToken": {
              "typ": "JWT",
              "algorithm": "HS256",
              "expiresIn": {
                "hours": 1
              },
              "issuer": "AssistOS",
              "audience": "AssistOS"
            }
          }
        }

    {{- end }}

{{- end }}
{{- end }}

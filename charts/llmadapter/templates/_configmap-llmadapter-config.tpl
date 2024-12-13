{{- /*
Template for Configmap.

Arguments to be passed are 
- $ (index 0)
- . (index 1)
- suffix (index 2)
- dictionary (index 3) for annotations used for defining helm hooks.

See https://blog.flant.com/advanced-helm-templating/
*/}}
{{- define "llmadapter.configmap-llmadapter-config" -}}
{{- $ := index . 0 }}
{{- $suffix := index . 2 }}
{{- $annotations := index . 3 }}
  {{- with index . 1 }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: llmadapter-config{{ $suffix | default "" }}
  namespace: {{ template "llmadapter.namespace" . }}
  {{- with $annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "llmadapter.labels" . | nindent 4 }}
data:
    config.json: |-
    {{- if .Values.config.overrides.configJson }}
    {{ .Values.config.overrides.configJson | indent 4 }}
    {{- else }}
        {
          "PORT": {{ .Values.service.port }},
          "APIHUB_URL": {{ .Values.config.productionBaseUrl | quote }},
          "S3_URL": {{ .Values.config.s3Url | quote }}
        }
    {{- end }}

{{- end }}
{{- end }}
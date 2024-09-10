{{- /*
Template for Secret.

Arguments to be passed are 
- $ (index 0)
- . (index 1)
- suffix (index 2)
- dictionary (index 3) for annotations used for defining helm hooks.

See https://blog.flant.com/advanced-helm-templating/
*/}}
{{- define "assistos.secret" -}}
{{- $ := index . 0 }}
{{- $suffix := index . 2 }}
{{- $annotations := index . 3 }}
{{- with index . 1 }}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "assistos.fullname" . }}{{ $suffix | default "" }}
  namespace: {{ template "assistos.namespace" . }}
  {{- with $annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "assistos.labels" . | nindent 4 }}
type: Opaque
data:
  env.json: |-
{{- if .Values.config.overrides.envJson }}
{{ .Values.config.overrides.envJson | b64enc | indent 4 }}
{{- else }}
{{ include "assistos.envJson" . | b64enc | indent 4 }}
{{- end }}

  apihub.json: |-
{{- if .Values.config.overrides.apihubJson }}
{{ .Values.config.overrides.apihubJson | b64enc | indent 4 }}
{{- else }}
{{ include "assistos.apihubJson" . | b64enc | indent 4 }}
{{- end }}

  emailConfig.json: |-
{{ .Values.config.overrides.emailConfigJson | b64enc | indent 4 }}

{{- end }}
{{- end }}
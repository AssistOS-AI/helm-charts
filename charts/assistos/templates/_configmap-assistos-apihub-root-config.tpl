{{- /*
Template for Configmap for assistOS-configs.json.

Arguments to be passed are 
- $ (index 0)
- . (index 1)
- suffix (index 2)
- dictionary (index 3) for annotations used for defining helm hooks.

See https://blog.flant.com/advanced-helm-templating/
*/}}
{{- define "assistos.configmap-assistos-apihub-root-config" -}}
{{- $ := index . 0 }}
{{- $suffix := index . 2 }}
{{- $annotations := index . 3 }}
  {{- with index . 1 }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "assistos.fullname" . }}-apihub-root-config{{ $suffix | default "" }}
  namespace: {{ template "assistos.namespace" . }}
  {{- with $annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "assistos.labels" . | nindent 4 }}
data:
  assistOS-configs.json: |-
  {{- if .Values.config.overrides.assistOSConfigsJson }}
    {{ .Values.config.overrides.assistOSConfigsJson | indent 4 }}
  {{- else }}
    {
      "defaultApplicationName": "Space",
      "services": [
        {
          "name": "ValidationService",
          "path": "./wallet/core/services/ValidationService.js"
        }
      ],
      "docsConverterUrl": {{ .Values.config.docsConverterUrl | quote }}
    }
  {{- end }}
  {{- end }}
{{- end -}} 
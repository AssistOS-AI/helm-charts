{{- /*
Template for Configmap for DocsConverter configuration.

Arguments to be passed are 
- $ (index 0)
- . (index 1)
- suffix (index 2)
- dictionary (index 3) for annotations used for defining helm hooks.

See https://blog.flant.com/advanced-helm-templating/
*/}}
{{- define "docsconverter.configmap-docsconverter-config" -}}
{{- $ := index . 0 }}
{{- $suffix := index . 2 }}
{{- $annotations := index . 3 }}
  {{- with index . 1 }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "docsconverter.fullname" . }}-config{{ $suffix | default "" }}
  namespace: {{ template "docsconverter.namespace" . }}
  {{- with $annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "docsconverter.labels" . | nindent 4 }}
data:
  docsconverter-config.json: |-
    {
      "docsConverterUrl": {{ .Values.config.docsConverterUrl | quote }}
    }
  {{- end }}
{{- end -}}
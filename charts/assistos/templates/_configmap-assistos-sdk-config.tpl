{{- /*
Template for Configmap for AssistOS SDK.

Arguments to be passed are 
- $ (index 0)
- . (index 1)
- suffix (index 2)
- dictionary (index 3) for annotations used for defining helm hooks.

See https://blog.flant.com/advanced-helm-templating/
*/}}
{{- define "assistos.configmap-assistos-sdk-config" -}}
{{- $ := index . 0 }}
{{- $suffix := index . 2 }}
{{- $annotations := index . 3 }}
  {{- with index . 1 }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "assistos.fullname" . }}-sdk-config{{ $suffix | default "" }}
  namespace: {{ template "assistos.namespace" . }}
  {{- with $annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "assistos.labels" . | nindent 4 }}
data:
  config.json: |-
    {
      "docsConverterUrl": {{ .Values.config.docsConverterUrl | quote }}
    }
  {{- end }}
{{- end -}}

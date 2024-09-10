{{- /*
Template for Configmap.

Arguments to be passed are 
- $ (index 0)
- . (index 1)
- suffix (index 2)
- dictionary (index 3) for annotations used for defining helm hooks.

See https://blog.flant.com/advanced-helm-templating/
*/}}
{{- define "assistos.configmap-domains" -}}
{{- $ := index . 0 }}
{{- $suffix := index . 2 }}
{{- $annotations := index . 3 }}
{{- with index . 1 }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "assistos.fullname" . }}-domains{{ $suffix | default "" }}
  namespace: {{ template "assistos.namespace" . }}
  {{- with $annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "assistos.labels" . | nindent 4 }}
data:
  # Mapped to https://github.com/pharmaledgerassoc/assistos-workspace/tree/v1.3.0/apihub-root/external-volume/config/domains
  # e.g. 'epipoc.json'
  {{ required "config.domain must be set" .Values.config.domain }}.json: |-
{{- if .Values.config.overrides.domainConfigJson }}
{{ .Values.config.overrides.domainConfigJson | indent 4 }}
{{- else }}
    {
      "anchoring": {
        "type": "FS"
      }
    }
{{- end }}

  # Mapped to https://github.com/pharmaledgerassoc/assistos-workspace/tree/v1.3.0/apihub-root/external-volume/config/domains
  # e.g. 'companyname.json'
  {{ required "config.subDomain must be set" .Values.config.subDomain }}.json: |-
{{- if .Values.config.overrides.subDomainConfigJson }}
{{ .Values.config.overrides.subDomainConfigJson | indent 4 }}
{{- else }}
    {
      "anchoring": {
        "type": "FS"
      }
    }
{{- end }}

  # e.g. 'vault.companyname.json'
  {{ required "config.vaultDomain must be set" .Values.config.vaultDomain }}.json: |-
{{- if .Values.config.overrides.vaultDomainConfigJson }}
{{ .Values.config.overrides.vaultDomainConfigJson | indent 4 }}
{{- else }}
    {
      "anchoring": {
        "type": "FS"
      }
    }
{{- end }}

{{- end }}
{{- end }}
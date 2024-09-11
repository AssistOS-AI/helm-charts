{{- /*
Template for Configmap.

Arguments to be passed are 
- $ (index 0)
- . (index 1)
- suffix (index 2)
- dictionary (index 3) for annotations used for defining helm hooks.

See https://blog.flant.com/advanced-helm-templating/
*/}}
{{- define "assistos.configmap-llmos-config" -}}
{{- $ := index . 0 }}
{{- $suffix := index . 2 }}
{{- $annotations := index . 3 }}
  {{- with index . 1 }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: llmos-config{{ $suffix | default "" }}
  namespace: {{ template "assistos.namespace" . }}
  {{- with $annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    {{- include "assistos.labels" . | nindent 4 }}
data:
    config.json: |-
    {{- if .Values.config.overrides.llmosConfigJson }}
    {{ .Values.config.overrides.llmosConfigJson | indent 4 }}
    {{- else }}
        {
          "PORT": {{ .Values.service.llmos.port }},
          "APIHUB_URL": {{ .Values.config.productionBaseUrl | quote }},
          "S3_URL": {{ .Values.config.s3Url | quote }}
        }
    {{- end }}

    supportedCompanies.json: |-
    {{- if .Values.config.overrides.supportedCompaniesJson }}
    {{ .Values.config.overrides.supportedCompaniesJson | indent 4 }}
    {{- else }}
        [
            {
                "company": "OpenAI",
                "authentication": [
                    "APIKey"
                ],
                "models": [
                    {
                        "name": "GPT-3.5-Turbo",
                        "type": "text"
                    },
                    {
                        "name": "GPT-4o",
                        "type": "text"
                    },
                    {
                        "name": "GPT-4",
                        "type": "text"
                    },
                    {
                        "name": "DALL-E-2",
                        "type": "image",
                        "size": [
                            "256x256",
                            "512x512",
                            "1024x1024"
                        ],
                        "style": [
                            "natural",
                            "vivid"
                        ],
                        "quality": [
                            "standard",
                            "hd"
                        ],
                        "variants": 4
                    },
                    {
                        "name": "DALL-E-3",
                        "type": "image",
                        "size": [
                            "1024x1024",
                            "1792x1024",
                            "1024x1792"
                        ],
                        "style": [
                            "natural",
                            "vivid"
                        ],
                        "quality": [
                            "standard",
                            "hd"
                        ],
                        "variants": 4
                    }
                ]
            },
            {
                "company": "PlayHT",
                "authentication": [
                    "APIKey",
                    "userId"
                ],
                "models": [
                    {
                        "name": "PlayHT2.0",
                        "type": "audio"
                    },
                    {
                        "name": "PlayHT2.0-Turbo",
                        "type": "audio"
                    }
                ]
            },
            {
                "company": "MidJourney",
                "authentication": [
                    "APIKey"
                ],
                "models": [
                    {
                        "name": "MidJourney",
                        "type": "image",
                        "buttons": {
                            "U1": "Upscale V1",
                            "U2": "Upscale V2",
                            "U3": "Upscale V3",
                            "U4": "Upscale V4",
                            "V1": "Variation V1",
                            "V2": "Variation V2",
                            "V3": "Variation V3",
                            "V4": "Variation V4",
                            "Zoom Out 2x": "Zoom Out 2x",
                            "Zoom Out 1.5x": "Zoom Out 1.5x",
                            "Vary (Strong)": "Vary (Strong)",
                            "Vary (Subtle)": "Vary (Subtle)",
                            "Vary (Region)": "Vary (Region)",
                            "⬅\uFE0F": "Pan Left",
                            "➡\uFE0F": "Pan Right",
                            "⬆\uFE0F": "Pan Up",
                            "⬇\uFE0F": "Pan Down",
                            "Make Square": "Make Square",
                            "Upscale (2x)": "Upscale (2x)",
                            "Upscale (4x)": "Upscale (4x)",
                            "Redo Upscale (2x)": "Redo Upscale (2x)",
                            "Redo Upscale (4x)": "Redo Upscale (4x)",
                            "Upscale (Creative)": "Upscale (Creative)",
                            "Upscale (Subtle)": "Upscale (Subtle)",
                            "\uD83D\uDD04": "\uD83D\uDD04",
                            "Cancel Job": "Cancel Job"
                        }
                    }
                ]
            },
            {
                "company": "Synclabs",
                "authentication": [
                    "APIKey"
                ],
                "models": [
                    {
                        "name": "sync-1.6.0",
                        "type": "video"
                    },
                    {
                        "name": "sync-1.5.0",
                        "type": "video"
                    }
                ]
            }
        ]

    {{- end }}

{{- end }}
{{- end }}

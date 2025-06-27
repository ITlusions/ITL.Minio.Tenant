{{/* vim: set filetype=mustache: */}}
{{/*
Renders a value that contains template.
Usage:
{{ include "minio-operator.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "minio-operator.render" -}}
  {{- if typeIs "string" .value }}
    {{- tpl .value .context }}
  {{- else }}
    {{- tpl (.value | toYaml) .context }}
  {{- end }}
{{- end -}}

{{/*
Generates environment variable exports for MinIO tenant configuration.
Usage:
{{ include "minio-operator.envExports" . }}
*/}}
{{- define "minio-operator.envExports" -}}
export MINIO_ROOT_USER={{ .Values.tenant.configSecret.accessKey | default "nwa" | quote }}
export MINIO_ROOT_PASSWORD={{ .Values.tenant.configSecret.secretKey | default (randAlphaNum 20) | b64enc | quote }}
export CONSOLE_TLS_PORT={{ .Values.tenant.consoleTlsPort | default "443" | quote }}
export CONSOLE_TLS_HOSTNAME={{ .Values.tenant.consoleTlsHostname | default "example-console.dev.itlusions.com" | quote }}
export MINIO_BROWSER_REDIRECT_URL={{ .Values.tenant.minioBrowserRedirectUrl | default "https://example-console.dev.itlusions.com/" | quote }}
export MINIO_IDENTITY_OPENID_CONFIG_URL=https://sts.itlusions.com/realms/itlusions/.well-known/openid-configuration
export MINIO_IDENTITY_OPENID_CLIENT_ID=minio
export MINIO_IDENTITY_OPENID_CLIENT_SECRET={{ .Values.tenant.configSecret.openidClientSecret | quote }}
export MINIO_IDENTITY_OPENID_REDIRECT_URI=https://itlminio01.dev.itlusions.com/oauth_callback
export MINIO_IDENTITY_OPENID_SCOPES=openid,profile,email
export MINIO_IDENTITY_OPENID_CLAIM_NAME=policy
{{- end -}}


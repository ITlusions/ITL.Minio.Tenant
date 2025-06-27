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
Generates shell export statements for MinIO tenant environment variables, including OpenID settings if enabled.
Usage:
{{ include "minio-operator.envExports" . }}
*/}}
{{- define "minio-operator.envExports" -}}
export MINIO_ROOT_USER={{ .Values.tenant.configSecret.accessKey | default "nwa" | quote }}
export MINIO_ROOT_PASSWORD={{ .Values.tenant.configSecret.secretKey | default (randAlphaNum 20) | b64enc | quote }}
export CONSOLE_TLS_PORT={{ .Values.tenant.consoleTlsPort | default "443" | quote }}
export CONSOLE_TLS_HOSTNAME={{ .Values.tenant.consoleTlsHostname | default "example-console.dev.itlusions.com" | quote }}
export MINIO_BROWSER_REDIRECT_URL={{ .Values.tenant.minioBrowserRedirectUrl | default "https://example-console.dev.itlusions.com/" | quote }}
{{- $_ := set .Values.tenant.openid "enabled" true }}
{{- if .Values.tenant.openid.enabled }}
export MINIO_IDENTITY_OPENID_CONFIG_URL={{ .Values.tenant.openid.configUrl | default "https://sts.itlusions.com/realms/itlusions/.well-known/openid-configuration" | quote }}
export MINIO_IDENTITY_OPENID_CLIENT_ID={{ .Values.tenant.openid.clientId | default "minio" | quote }}
export MINIO_IDENTITY_OPENID_CLIENT_SECRET={{ .Values.tenant.openid.clientSecret | default "example-secret" | quote }}
export MINIO_IDENTITY_OPENID_REDIRECT_URI={{ .Values.tenant.openid.redirectUri | default "https://itlminio01.dev.itlusions.com/oauth_callback" | quote }}
export MINIO_IDENTITY_OPENID_SCOPES={{ .Values.tenant.openid.scopes | default "openid,profile,email" | quote }}
export MINIO_IDENTITY_OPENID_CLAIM_NAME={{ .Values.tenant.openid.claimName | default "policy" | quote }}
{{- end }}
{{- end -}}

{{/*
Renders environment variables if present.
Usage:
{{ include "minio-operator.envList" .Values.tenant }}
*/}}
{{- define "minio-operator.envList" -}}
{{- with (dig "env" (list) .) }}
env:{{ toYaml . | nindent 2 }}
{{- end }}
{{- end -}}
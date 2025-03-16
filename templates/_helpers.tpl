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

{{- define "randomString" -}}
{{- $length := 16 -}}
{{- $charset := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" -}}
{{- $password := "" -}}
{{- range seq 1 $length -}}
  {{- $index := randInt (len $charset) -}}
  {{- $password = printf "%s%s" $password (index $charset $index) -}}
{{- end -}}
{{- $password -}}
{{- end -}}

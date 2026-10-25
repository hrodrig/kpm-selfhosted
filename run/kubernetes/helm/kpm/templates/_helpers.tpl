{{/*
Expand the name of the chart.
*/}}
{{- define "kpm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
fullname is the release name when it already contains the chart name.
*/}}
{{- define "kpm.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "kpm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "kpm.labels" -}}
helm.sh/chart: {{ include "kpm.chart" . }}
app.kubernetes.io/name: {{ include "kpm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "kpm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kpm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "kpm.image" -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end }}

{{- define "kpm.claimName" -}}
{{- if .Values.persistence.existingClaim }}
{{- .Values.persistence.existingClaim }}
{{- else }}
{{- printf "%s-store" (include "kpm.fullname" .) }}
{{- end }}
{{- end }}

{{- define "kpm.httpEnabled" -}}
{{- if or .Values.server.enabled .Values.mcp.enabled -}}
true
{{- end }}
{{- end }}

{{- define "kpm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- include "kpm.fullname" . }}
{{- else }}
{{- include "kpm.fullname" . }}
{{- end }}
{{- end }}

{{- define "kpm.clientId" -}}
{{- if .Values.config.clientId }}
{{- .Values.config.clientId }}
{{- else if eq .Values.sampler "cronjob" }}
kpm-cron
{{- else }}
kpm-daemon
{{- end }}
{{- end }}

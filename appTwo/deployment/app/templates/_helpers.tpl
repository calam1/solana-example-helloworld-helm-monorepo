{{/*
Expand the name of the chart.
*/}}
{{- define "solana-helm-two.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "solana-helm-two.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "solana-helm-two.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "solana-helm-two.labels" -}}
helm.sh/chart: {{ include "solana-helm-two.chart" . }}
app: {{ include "solana-helm-two.name" . }}
version: {{ default .Chart.AppVersion .Values.tag }}
{{ include "solana-helm-two.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- include "solana-helm-two.fakeLabels" . }}
{{- end }}

{{- define "solana-helm-two-db.labels" -}}
helm.sh/chart: {{ include "solana-helm-two.chart" . }}
app: {{ include "solana-helm-two.name" . }}
version: {{ default .Chart.AppVersion .Values.tag }}
{{ include "solana-helm-two-db.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- include "solana-helm-two.fakeLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "solana-helm-two.selectorLabels" -}}
app.kubernetes.io/name: {{ include "solana-helm-two.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "solana-helm-two-db.selectorLabels" -}}
app.kubernetes.io/name: {{ include "solana-helm-two.name" . }}-db
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
fake labels
*/}}
{{- define "solana-helm-two.fakeLabels" -}}
{{- if .Values.teamname }}
fake.com/managed-by-team: {{ .Values.teamname }}
{{- end -}}
{{- if .Values.reponame }}
fake.com/repo: {{ .Values.reponame }}
{{- end -}}
{{- end -}}

{{/*
Image Repository
*/}}
{{- define "solana-helm-two.container" -}}
{{- if .Values.image.registry }}
{{- .Values.image.registry -}}
    /
{{- end -}}
{{- .Values.image.repository -}}
:
{{- .Values.image.tag | default .Chart.AppVersion }}
{{- end -}}

{{ define "solana-helm-two-db.dbServiceHost" -}}
{{- if eq .Values.db.type "local" -}}
{{- include "solana-helm-two-db.fullname" . -}}
{{- else -}}
{{- .Values.db.serviceHost -}}
{{- end -}}
{{- end }}

{{- define "solana-helm-two-db.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 60 | trimSuffix "-" }}-db
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 60 | trimSuffix "-" }}-db
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 60 | trimSuffix "-" }}-db
{{- end }}
{{- end }}
{{- end }}

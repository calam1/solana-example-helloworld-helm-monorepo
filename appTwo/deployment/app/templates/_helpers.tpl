{{/*
Expand the name of the chart.
*/}}
{{- define "solana-helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "solana-helm.fullname" -}}
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
{{- define "solana-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "solana-helm.labels" -}}
helm.sh/chart: {{ include "solana-helm.chart" . }}
app: {{ include "solana-helm.name" . }}
version: {{ default .Chart.AppVersion .Values.tag }}
{{ include "solana-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- include "solana-helm.fakeLabels" . }}
{{- end }}

{{- define "solana-helm-db.labels" -}}
helm.sh/chart: {{ include "solana-helm.chart" . }}
app: {{ include "solana-helm.name" . }}
version: {{ default .Chart.AppVersion .Values.tag }}
{{ include "solana-helm-db.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- include "solana-helm.fakeLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "solana-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "solana-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "solana-helm-db.selectorLabels" -}}
app.kubernetes.io/name: {{ include "solana-helm.name" . }}-db
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
fake labels
*/}}
{{- define "solana-helm.fakeLabels" -}}
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
{{- define "solana-helm.container" -}}
{{- if .Values.image.registry }}
{{- .Values.image.registry -}}
    /
{{- end -}}
{{- .Values.image.repository -}}
:
{{- .Values.image.tag | default .Chart.AppVersion }}
{{- end -}}

{{ define "solana-helm-db.dbServiceHost" -}}
{{- if eq .Values.db.type "local" -}}
{{- include "solana-helm-db.fullname" . -}}
{{- else -}}
{{- .Values.db.serviceHost -}}
{{- end -}}
{{- end }}

{{- define "solana-helm-db.fullname" -}}
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

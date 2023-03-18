---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "solana-helm.fullname" . }}
  labels:
    {{- include "solana-helm.labels" . | nindent 4 }}
  {{- with .Values.deployment.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if not .Values.deployment.autoscaling.enabled }}
  replicas: {{ .Values.deployment.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "solana-helm.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "solana-helm.labels" . | nindent 8 }}
      annotations:
        {{- tpl ( .Values.deployment.pod.annotations | toYaml ) . | nindent 8 }}
    spec:
      {{- with .Values.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      containers:
        - name: {{ .Chart.Name }}
          command: [ "/bin/sh","-c" ]
          args: [ 'source /vault/secrets/db-creds && source /vault/secrets/audit-creds && npx prisma generate && npm start' ]
          {{- if .Values.deployment.startScript }}
          {{- tpl ( .Values.deployment.startScript) . | nindent 10 }}
          {{- end }}
          image: {{ include "solana-helm.container" . }}
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            {{- toYaml .Values.deployment.ports | nindent 12 }}
          {{- if hasKey .Values.deployment "livenessProbe" }}
          livenessProbe:
            {{- toYaml .Values.deployment.livenessProbe | nindent 12}}
          {{- end }}
          {{- if hasKey .Values.deployment "readinessProbe" }}
          readinessProbe:
            {{- toYaml .Values.deployment.readinessProbe | nindent 12}}
          {{- end }}
          {{- if .Values.deployment.env }}
          env:
            {{- tpl ( .Values.deployment.env) . | nindent 12 }}
          {{- end }}
          resources:
            {{- toYaml .Values.deployment.resources | nindent 12 }}

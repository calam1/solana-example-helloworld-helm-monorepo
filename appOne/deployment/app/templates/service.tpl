---
apiVersion: v1
kind: Service
metadata:
  name: {{ include "solana-helm.fullname" . }}
  labels:
    {{- include "solana-helm.labels" . | nindent 4 }}
  {{- with .Values.service.annotations }}
  annotations:
    {{- range $key, $value := . }}
    {{ $key }}: |
    {{- tpl $value $ | nindent 6 }}
    {{- end }}
  {{- end }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "solana-helm.selectorLabels" . | nindent 4 }}

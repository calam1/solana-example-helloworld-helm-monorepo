---
apiVersion: v1
kind: Service
metadata:
  name: {{ include "solana-helm-two.fullname" . }}
  labels:
    {{- include "solana-helm-two.labels" . | nindent 4 }}
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
    {{- include "solana-helm-two.selectorLabels" . | nindent 4 }}

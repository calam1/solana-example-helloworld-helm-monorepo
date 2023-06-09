{{- if .Values.gateway.enabled }}
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: {{ include "solana-helm-two.fullname" . }}
  labels:
    {{- include "solana-helm-two.labels" . | nindent 4 }}
spec:
  hosts:
    - {{ .Values.fqdn }}
  gateways:
    - {{ include "solana-helm-two.fullname" . }}
  http:
  - route:
    - destination:
        port:
          number: 80
        host: {{ include "solana-helm-two.fullname" . }}
{{- end }}

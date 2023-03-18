{{- if .Values.gateway.enabled }}
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: {{ include "solana-helm-one.fullname" . }}
  labels:
    {{- include "solana-helm-one.labels" . | nindent 4 }}
spec:
  hosts:
    - {{ .Values.fqdn }}
  gateways:
    - {{ include "solana-helm-one.fullname" . }}
  http:
  - route:
    - destination:
        port:
          number: 80
        host: {{ include "solana-helm-one.fullname" . }}
{{- end }}

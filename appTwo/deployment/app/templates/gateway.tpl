{{- if .Values.gateway.enabled }}
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  annotations:
    type: internal
  name: {{ include "solana-helm.fullname" . }}
  labels:
    {{- include "solana-helm.labels" . | nindent 4 }}
spec:
  selector:
    istio: ilbgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - {{ .Values.fqdn }}
    tls:
      httpsRedirect: {{ .Values.gateway.httpsRedirect }}
  {{- if .Values.gateway.tlsCredentialName }}
  - port:
      number: 443
      name: https
      protocol: HTTPS
    hosts:
    - {{ .Values.fqdn }}
    tls:
      credentialName: {{ .Values.gateway.tlsCredentialName }}
      mode: SIMPLE
  {{- end }}
{{- end }}

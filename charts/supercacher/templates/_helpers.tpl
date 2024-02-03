{{/* vim: set filetype=helm: */}}
{{/*
    Expand the name of the chart.
*/}}
{{- define "supercacher.name" -}}
{{- default .Chart.Name $.Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
    Create a default fully qualified app name.
    We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
    If release name contains chart name it will be used as a full name.
*/}}
{{- define "supercacher.fullname" -}}
{{- if $.Values.fullnameOverride -}}
{{- $.Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name $.Values.nameOverride -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
    Create chart name and version as used by the chart label.
*/}}
{{- define "supercacher.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
    Common labels
*/}}
{{- define "supercacher.labels" -}}
{{- include "supercacher.selectorLabels" $ }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ include "supercacher.chart" $ | quote }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- if $.Values.datadog.enabled }}
tags.datadoghq.com/env: {{ default "ci" $.Values.envName | quote }}
tags.datadoghq.com/service: {{ include "supercacher.name" $ }}
{{- if $.Values.datadog.unifiedServiceTagging }}
tags.datadoghq.com/version: {{ $.Values.version | quote }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
    Selector labels
*/}}
{{- define "supercacher.selectorLabels" -}}
app.kubernetes.io/name: {{ include "supercacher.name" $ | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
app.kubernetes.io/app: "supercacher"
{{- end }}

{{/*
    Create the name of the service account to use
*/}}
{{- define "supercacher.serviceAccountName" -}}
{{- if $.Values.serviceAccount.create -}}
{{- default (include "supercacher.fullname" .) $.Values.serviceAccount.name -}}
{{- else }}
{{- default "default" $.Values.serviceAccount.name }}
{{- end }}
{{- end }}

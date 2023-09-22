#!/bin/bash

# Repository-Name
repository_name="microservice"

# Verzeichnis zum Helm-Chart
chart_dir="./microservice"

# Chartmuseum Url
chart_url="http://localhost:8080"

# Add Helm Charts to repository
helm repo add $repository_name $chart_url
# Update Helm repository
helm repo update
# Package Helm Charts
helm package $chart_dir
# Lint Helm Charts
helm lint $chart_dir

# Prüfen, ob das Helm-Plugin 'helm-push' installiert ist
if ! helm plugin list | grep -q "cm-push"; then
  echo "Das Helm-Plugin 'cm-push' ist nicht installiert. Es wird jetzt installiert..."
  helm plugin install https://github.com/chartmuseum/helm-push
fi

# Helm-Chart veröffentlichen
helm cm-push --force $chart_dir $chart_url --username root --password root
#!/usr/bin/env bash

GIT_REPO=$(cat git_repo)
GIT_TOKEN=$(cat git_token)

export KUBECONFIG=$(cat .kubeconfig)
NAMESPACE=$(cat .namespace)
COMPONENT_NAME=$(jq -r '.name // "my-module"' gitops-output.json)
BRANCH=$(jq -r '.branch // "main"' gitops-output.json)
SERVER_NAME=$(jq -r '.server_name // "default"' gitops-output.json)
LAYER=$(jq -r '.layer_dir // "2-services"' gitops-output.json)
TYPE=$(jq -r '.type // "base"' gitops-output.json)
QMGR_NAME=$(jq -r '.queue_manager // "telco-cloud"' gitops-output.json)
CONFIG_MAP=$(jq -r '.config_map // "oms-queue-config"' gitops-output.json)

cat gitops-output.json

mkdir -p .testrepo

git clone https://${GIT_TOKEN}@${GIT_REPO} .testrepo

cd .testrepo || exit 1

find . -name "*"

if [[ ! -f "argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml" ]]; then
  echo "ArgoCD config missing - argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"
  exit 1
fi

echo "Printing argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"
cat "argocd/${LAYER}/cluster/${SERVER_NAME}/${TYPE}/${NAMESPACE}-${COMPONENT_NAME}.yaml"

if [[ ! -f "payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml" ]]; then
  echo "Application values not found - payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml"
  exit 1
fi

echo "Printing payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml"
cat "payload/${LAYER}/namespace/${NAMESPACE}/${COMPONENT_NAME}/values.yaml"

count=0
until kubectl get namespace "${NAMESPACE}" 1> /dev/null 2> /dev/null || [[ $count -eq 20 ]]; do
  echo "Waiting for namespace: ${NAMESPACE}"
  count=$((count + 1))
  sleep 15
done

if [[ $count -eq 20 ]]; then
  echo "Timed out waiting for namespace: ${NAMESPACE}"
  exit 1
else
  echo "Found namespace: ${NAMESPACE}. Sleeping for 30 seconds to wait for everything to settle down"
  sleep 30
fi


echo "Checking if Config Map has been created"
kubectl get cm ${CONFIG_MAP}  -n  ${NAMESPACE}


WAIT_COUNT=20
count=0
until [[ $(kubectl get queuemanager ${QMGR_NAME}  -n  ${NAMESPACE} -o jsonpath="{.status.phase}") == "Running" ||  $count -eq ${WAIT_COUNT} ]]; do
  echo "Waiting for Queue Manager/${QMGR_NAME} in ${NAMESPACE}"
  count=$((count + 1))
  sleep 60
done

if [[ $count -eq 20 ]]; then
  echo "Timed out waiting for Queue Manager/${QMGR_NAME} in ${NAMESPACE}"
  exit 1
else
  kubectl get queuemanager ${QMGR_NAME} -n  ${NAMESPACE}
  echo "Successfully created Queue manager: ${QMGR_NAME} with config map: ${CONFIG_MAP}"
fi

if [[ $(kubectl get cm ${CONFIG_MAP}  -n  ${NAMESPACE} | grep ${CONFIG_MAP} | awk '{print $1}') == ${CONFIG_MAP}  ]]; then
  echo "Config Map ${CONFIG_MAP} has been created"
  kubectl describe cm ${CONFIG_MAP}
  else
    echo "Did not find Config Map ${CONFIG_MAP} in namespace: ${NAMESPACE}" || exit 1
fi


kubectl get all -n "${NAMESPACE}"
kubectl rollout status "sts/${QMGR_NAME}-ibm-mq" -n "${NAMESPACE}"

cd ..
rm -rf .testrepo

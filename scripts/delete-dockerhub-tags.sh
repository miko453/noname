#!/bin/bash
set -e

# 确保必要变量存在
if [[ -z "$DOCKERHUB_USERNAME" || -z "$DOCKERHUB_TOKEN" || -z "$REPO_NAME" || -z "$TAGS" ]]; then
  echo "Usage: DOCKERHUB_USERNAME, DOCKERHUB_TOKEN, REPO_NAME and TAGS must be set"
  exit 1
fi

# 登录 Docker Hub 获取 JWT token
TOKEN=$(curl -s -H "Content-Type: application/json" \
  -X POST -d "{\"username\": \"$DOCKERHUB_USERNAME\", \"password\": \"$DOCKERHUB_TOKEN\"}" \
  https://hub.docker.com/v2/users/login/ | jq -r .token)

if [[ -z "$TOKEN" || "$TOKEN" == "null" ]]; then
  echo "Failed to get Docker Hub token"
  exit 1
fi

# 删除指定 tag
for TAG in $TAGS; do
  echo "Deleting tag $TAG from $REPO_NAME..."
  HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -X DELETE \
    -H "Authorization: JWT $TOKEN" \
    "https://hub.docker.com/v2/repositories/$REPO_NAME/tags/$TAG/")

  if [[ "$HTTP_CODE" == "204" ]]; then
    echo "Tag $TAG deleted successfully."
  elif [[ "$HTTP_CODE" == "404" ]]; then
    echo "Tag $TAG not found, skipping."
  else
    echo "Failed to delete tag $TAG, HTTP status: $HTTP_CODE"
  fi
done

#!/usr/bin/env bash

set -e
declare -A TYPES=(
  ["breaking"]="Breaking Changes"
  ["feat"]="Features"
  ["fix"]="Bug Fixes"
  ["perf"]="Performance Improvements"
  ["revert"]="Reverts"
  ["docs"]="Documentation"
  ["style"]="Styles"
  ["chore"]="Miscellaneous Chores"
  ["refactor"]="Code Refactoring"
  ["test"]="Tests"
  ["build"]="Build System"
  ["ci"]="CI/CD Pipeline"
  ["other"]="Other Changes"
)
declare -A RELEASE_NOTES=(
  ["breaking"]=""
  ["feat"]=""
  ["fix"]=""
  ["perf"]=""
  ["revert"]=""
  ["docs"]=""
  ["style"]=""
  ["chore"]=""
  ["refactor"]=""
  ["test"]=""
  ["build"]=""
  ["ci"]=""
  ["other"]=""
)

LAST_TAG=$(git describe --abbrev=0 --tags 2>/dev/null || echo "v0.0.0_0")
GITHUB_REPO=$(git config --get remote.origin.url | sed -e 's/.*github.com[:/]\(.*\)\.git/\1/')
GITHUB_REPO_COMMIT_URL="https://github.com/${GITHUB_REPO}/commit/"
COMMIT_MESSAGES=$(git log --format="%s (#%h)" "${LAST_TAG}"..HEAD 2>/dev/null || git log --format="%s ([%h](${GITHUB_REPO_COMMIT_URL}%h)")
IFS=$'\n'
for MSG in ${COMMIT_MESSAGES}; do
  COMMIT_TYPE=$(echo "${MSG}" | cut -d':' -f1 | xargs)
  COMMIT_SCOPE=$(echo "${COMMIT_TYPE}" | cut -d'(' -f2 | cut -d')' -f1 | xargs)
  COMMIT_TYPE=$(echo "${COMMIT_TYPE}" | cut -d'(' -f1 | xargs)
  COMMIT_DESCRIPTION=$(echo "${MSG}" | cut -d':' -f2- | xargs)
  if [[ -z "${COMMIT_TYPE}" ]]; then
    COMMIT_TYPE="other"
  fi
  COMMIT_DESCRIPTION_WITH_SCOPE="${COMMIT_DESCRIPTION}"
  if [[ -n "${COMMIT_SCOPE}" ]]; then
    COMMIT_DESCRIPTION_WITH_SCOPE="**${COMMIT_SCOPE}:** ${COMMIT_DESCRIPTION}"
  fi
  RELEASE_NOTES["${COMMIT_TYPE}"]="${RELEASE_NOTES["${COMMIT_TYPE}"]}"$'\n'"- ${COMMIT_DESCRIPTION_WITH_SCOPE}"
done

RELEASE_NOTES_BODY="## Release Notes"
for TYPE in "${!TYPES[@]}"; do
  if [[ -n "${RELEASE_NOTES["${TYPE}"]}" ]]; then
    RELEASE_NOTES_BODY="${RELEASE_NOTES_BODY}"$'\n'"### ${TYPES["${TYPE}"]}"$'\n'"${RELEASE_NOTES["${TYPE}"]}"$'\n'
  fi
done

echo "${RELEASE_NOTES_BODY}" > RELEASE_NOTES.md

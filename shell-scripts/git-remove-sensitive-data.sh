#! /bin/bash
# https://docs.github.com/en/github/authenticating-to-github/removing-sensitive-data-from-a-repository

git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch PATH-TO-YOUR-FILE-WITH-SENSITIVE-DATA" \
  --prune-empty --tag-name-filter cat -- --all
  
git push origin --force --all

#git for-each-ref --format="delete %(refname)" refs/original | git update-ref --stdin
#git reflog expire --expire=now --all
#git gc --prune=now

#!/bin/bash
ssh-add /Users/gaigai/.ssh/github_id_rsa
git add .
git commit -m "$1"
git push

#!/bin/bash
ssh-add /Users/gaigai/.ssh/id_rsa_hub
git add .
git commit -m "$0"
git push

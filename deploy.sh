#!/bin/sh

wintersmith build

cd "$(git rev-parse --show-toplevel)/build" \
  && rm -rf .git \
  && git init . \
  && git remote add origin git@github.com:grace-notes/grace-notes.github.io.git \
  && git add -f . \
  && git commit -m "deploying" \
  && git push origin master -f


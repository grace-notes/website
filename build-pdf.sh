#!/bin/bash

for topic in contents/topics/*.md
do
  echo "Processing $topic..."
  pandoc --data-dir=./pandoc $topic -o ./build/topics/$(basename $topic | sed 's/\.md$/.pdf/')
done

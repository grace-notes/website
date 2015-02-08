#!/bin/bash

for topic in contents/topics/*.md
do
  echo "Processing $topic..."
  pandoc $topic -o ${topic%.md}.pdf
done

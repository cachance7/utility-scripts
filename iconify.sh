#!/bin/bash

set -eu

file="$1"
sizes=(32 48 64 96 128 256 512)

if [[ -z "$file" ]]; then
  echo "must provide path to image file as first argument" >&2
  exit 1
fi

filedir="$(dirname $(realpath "$file"))"

if [[ -z "$filedir" ]]; then
  echo "filedir is empty" >&2
  exit 1
fi

filename="$(basename "$file")"
extension="${filename##*.}"
filename="${filename%.*}"

if [[ -z "$filename" ]]; then
  echo "filename is empty" >&2
  exit 1
fi

if [[ -z "$extension" ]]; then
  echo "extension is empty" >&2
  exit 1
fi

for s in ${sizes[@]}; do
  convert "$file" -thumbnail "${s}x${s}>" \
    -background transparent \
    -unsharp 0x.5 \
    -gravity center \
    -extent ${s}x${s} "${filedir}/${filename}-${s}x${s}.${extension}"
done

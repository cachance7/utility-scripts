#!/bin/bash

set -eu

file="$1"
declare -a sizes=(
  "57 apple-icon-57x57.png"
  "60 apple-icon-60x60.png"
  "72 apple-icon-72x72.png"
  "76 apple-icon-76x76.png"
  "114 apple-icon-114x114.png"
  "120 apple-icon-120x120.png"
  "144 apple-icon-144x144.png"
  "152 apple-icon-152x152.png"
  "180 apple-icon-180x180.png"
  "192 android-icon-192x192.png"
  "16 favicon-16x16.png"
  "32 favicon-32x32.png"
  "48 favicon-32x32.png"
  "96 favicon-96x96.png"
  "192 favicon-192x192.png"
  "512 favicon-512x512.png"
)

if [[ -z "$file" ]]; then
  echo "must provide path to image file as first argument" >&2
  exit 1
fi

filedir="$(dirname $(realpath "$file"))"
outdir="${filedir}/favicon"

if [[ -z "$filedir" ]]; then
  echo "filedir is empty" >&2
  exit 1
fi

filename="$(basename "$file")"
extension="${filename##*.}"

if [[ -z "$extension" ]]; then
  echo "extension is empty" >&2
  exit 1
fi

mkdir -p "$outdir"

for pair in "${sizes[@]}"; do
  read -a strarr <<< "$pair"
  s=${strarr[0]}
  name=${strarr[1]}

  convert "$file" -thumbnail "${s}x${s}>" \
    -background transparent \
    -unsharp 0x.5 \
    -gravity center \
    -extent ${s}x${s} "${outdir}/${name}"
done

convert -background transparent "$file" -define icon:auto-resize=16,24,32,48,64,72,96,128,256 "${outdir}/favicon.ico"

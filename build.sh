#!/bin/bash
#
# Build jekyll site and store site files in ./_site
# © 2019 Cotes Chung
# Published under MIT License


help() {
   echo "Usage:"
   echo
   echo "   bash build.sh [options]"
   echo
   echo "Options:"
   echo "   -b, --baseurl <URL>   The site relative url that start with slash, e.g. '/project'"
   echo "   -h, --help            Print the help information"
}


init() {
  set -eu

  if [[ -d .container ]]; then
    rm -rf .container
  fi

  if [[ -d _site ]]; then
    rm -rf _site
  fi

  if [[ -d ../.chirpy-cache ]]; then
    rm -rf ../.chirpy-cache
  fi

  mkdir ../.chirpy-cache
  cp -r *   ../.chirpy-cache
  cp -r .git ../.chirpy-cache

  mv ../.chirpy-cache .container
}


CMD="JEKYLL_ENV=production bundle exec jekyll b"

while [[ $# -gt 0 ]]
do
  opt="$1"
  case $opt in
    -b|--baseurl)
      if [[ $2 == \/* ]]
      then
        CMD+=" -b $2"
      else
        help
        exit 1
      fi
      shift
      shift
      ;;
    -h|--help)
      help
      exit 0
      ;;
    *)
      # unknown option
      help
      exit 1
      ;;
  esac
done

init

cd .container

echo "$ cd $(pwd)"
python _scripts/tools/init_all.py

echo "\$ $CMD"
eval $CMD

echo "$(date) - Build success, the Site files placed in _site."

mv _site ..

cd .. && rm -rf .container

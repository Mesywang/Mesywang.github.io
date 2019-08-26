#!/bin/bash
#
# Run jekyll site at http://127.0.0.1:4000
# © 2019 Cotes Chung
# Published under MIT License


set -eu

help() {
   echo "Usage:"
   echo
   echo "   bash run.sh [options]"
   echo
   echo "Options:"
   echo "     -H, --host    <HOST>    Host to bind to"
   echo "     -P, --port    <PORT>    Port to listen on"
   echo "     -b, --baseurl <URL>     The site relative url that start with slash, e.g. '/project'"
   echo "     -h, --help              Print the help information"
}

cleanup() {
   cd ../
   rm -rf .container
}

init() {

  if [[ -d .container ]]; then
    rm -rf .container
  fi

  if [[ -d ../.chirpy-cache ]]; then
    rm -rf ../.chirpy-cache
  fi

  mkdir ../.chirpy-cache
  cp -r * ../.chirpy-cache
  cp -r .git  ../.chirpy-cache

  mv ../.chirpy-cache .container

  trap cleanup INT
}


cmd="bundle exec jekyll s"

while (( $# ))
do
  opt="$1"
  case $opt in
    -H|--host)
      cmd+=" -H $2"
      shift # past argument
      shift # past value
      ;;
    -P|--port)
      cmd+=" -P $2"
      shift
      shift
      ;;
    -b|--baseurl)
      if [[ $2 == \/* ]]
      then
        cmd+=" -b $2"
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

python _scripts/tools/init_all.py

echo "\$ $cmd"
eval $cmd

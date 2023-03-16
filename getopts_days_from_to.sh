#!/bin/bash

usage() {
  echo "Usage: $0 [-d <days>] [-f <from_date>] [-t <to_date>]" 1>&2;
  exit 1;
}

while getopts ":d:f:t:" opt; do
  case ${opt} in
    d )
      days=${OPTARG}
      ;;
    f )
      from_date=${OPTARG}
      ;;
    t )
      to_date=${OPTARG}
      ;;
    * )
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [[ -z "${days}" ]] && [[ -z "${from_date}" ]] && [[ -z "${to_date}" ]]; then
  usage
fi

if [[ -n "${days}" ]]; then
  find . -type f -mtime -$days -printf "%p %s\n"
elif [[ -n "${from_date}" ]] && [[ -n "${to_date}" ]]; then
  find . -type f -newermt "${from_date}" ! -newermt "${to_date}" -printf "%p %s\n"
else
  usage
fi

#!/bin/bash
# Authenticates to a salesforce org via auth url
setdefaultusername=false
setdefaultdevhubusername=false

usage () { echo "Usage: [ -u AUTHURL ] [-a SETALIAS] [-d] [-s]"; }

while getopts ':u:a:ds' option
do
    case "$option" in
        u)  authurl=${OPTARG};;
        a)  alias=${OPTARG};;
        d)  setdefaultdevhubusername=true;;
        s)  setdefaultusername=true;;
        h)  usage; exit;;
        \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
        :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
        *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
    esac
done

if [ -z "${authurl}" ]
then
  echo "You must specify an authurl"
  exit 1
fi

file=$(mktemp)
echo $authurl > $file

sfdxcmd="sfdx auth:sfdxurl:store --sfdxurlfile ${file} --json"

if [ ! -z "${alias}" ]
then
  sfdxcmd="${sfdxcmd} --setalias ${alias}"
fi

if [ "${setdefaultusername}" = true ]
then
  sfdxcmd="${sfdxcmd} --setdefaultusername"
fi

if [ "${setdefaultdevhubusername}" = true ]
then
  sfdxcmd="${sfdxcmd} --setdefaultdevhubusername"
fi

echo "Executing: ${sfdxcmd}"
eval "${sfdxcmd} >&2"

rm $file
#!/bin/bash
# Authenticates to a salesforce org via JWT
setdefaultusername=false
setdefaultdevhubusername=false

usage () { echo "Usage: [ -u USERNAME ] [ -f JWTKEYFILE ] [ -i CLIENTID ] [-r INSTANCEURL] [-w AUDIENCE] [-a SETALIAS] [-d] [-s]"; }

while getopts ':u:f:i:r:w:a:ds' option
do
    case "$option" in
        u)  username=${OPTARG};;
        f)  jwtkeyfile=${OPTARG};;
        i)  clientid=${OPTARG};;
        r)  instanceurl=${OPTARG};;
        w)  audience=${OPTARG};;
        a)  alias=${OPTARG};;
        d)  setdefaultdevhubusername=true;;
        s)  setdefaultusername=true;;
        h)  usage; exit;;
        \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
        :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
        *  ) echo "Unimplemented option: -$OPTARG" >&2; exit 1;;
    esac
done

if [ -z "${username}" ]
then
  echo "You must specify a username"
  exit 1
fi

if [ -z "${jwtkeyfile}" ]
then
  echo "You must specify a private key file"
  exit 1
fi

if [ -z "${clientid}" ]
then
  echo "You must specify a client id"
  exit 1
fi

if [ -z "${instanceurl}" ]
then
  echo "You must specify an instance url"
  exit 1
fi

if [ -z "${instanceurl}" ]
then
  echo "You must specify an instance url"
  exit 1
fi

if [ ! -z "${audience}" ]
then
  echo "Overriding default audience with: ${audience}"
  export SFDX_AUDIENCE_URL=${audience}
fi

sfdxcmd="sfdx auth:jwt:grant --username ${username} --jwtkeyfile ${jwtkeyfile} --clientid ${clientid} --instanceurl ${instanceurl} --json"

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
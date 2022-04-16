#!/bin/bash
# Installs a sfdx plugin
# Arguments:
#     $1 = name of the plugin

echo 'y' | sfdx plugins:install $1

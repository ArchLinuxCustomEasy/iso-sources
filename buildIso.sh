#!/bin/bash

# Name: buildIso.sh
# Description: Build an ISO image of ALICE based on custom settings
# Author: Titux Metal <tituxmetal[at]lgdweb[dot]fr>
# Url: https://github.com/ArchLinuxCustomEasy/iso-sources
# Version: 1.0
# Revision: 2021.09.17
# License: MIT License

workspace="$HOME/ALICE-workspace"
sourcesDir="$(pwd)/archiso/"
customFiles="$(pwd)/custom/"
outDirectory="$(pwd)/out/"
workDirectory="$(pwd)/work/"
logFile="$(pwd)/$(date +%T).log"

# Helper function for printing messages $1 The message to print
printMessage() {
  message=$1
  tput setaf 2
  echo "-------------------------------------------"
  echo "$message"
  echo "-------------------------------------------"
  tput sgr0
}

# Helper function to handle errors
handleError() {
  clear
  set -uo pipefail
  trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR
}

isRootUser() {
  if [[ ! "$EUID" = 0 ]]; then
    printMessage "Please Run As Root"
    exit 0
  fi
  printMessage "Ok to continue running the script"
  sleep .5
}

changeOwner() {
  newOwner=$1
  directoryName=$2
  printMessage "Change owner of ${directoryName} to ${newOwner}"
  chown -R ${newOwner} ${directoryName}
  sleep .5
}

removeDirectory() {
  dirName=$1
  printMessage "Cleanup ${dirName} directory"
  [ -d ${dirName}/ ] && rm -rf ${dirName}
}

copyFiles() {
  source=$1
  target=$2
  message=$3
  printMessage "${message}"
  cp -R ${source} ${target}
  sleep .5
}

runMkarchiso() {
  printMessage "Start of building the ISO image"
  mkarchiso -v -w ${workDirectory} -o ${outDirectory} ${sourcesDir}
}

cleanUpWorkspace() {
  removeDirectory "${sourcesDir}"
  removeDirectory "${outDirectory}"
  removeDirectory "${workDirectory}"
  sleep .5
}

preBuild() {
  cleanUpWorkspace
  printMessage "Create ${sourcesDir}"
  mkdir -p ${sourcesDir}
  sleep .5
}

prepareWorkspace() {
  preBuild
  copyFiles "/usr/share/archiso/configs/releng/*" "${sourcesDir}" "Copy archiso files from the system to the local archiso directory"
  copyFiles "${customFiles}*" "${sourcesDir}" "Copy custom files in archiso directory"
  git clone https://github.com/ArchLinuxCustomEasy/scripts.git ${sourcesDir}/airootfs/root/scripts
  changeOwner "root:root" "${sourcesDir}"
}

postBuild() {
  printMessage "Copy iso from ${outDirectory} to ${workspace}"
  cp ${outDirectory}alice-*.iso $(pwd)
  cleanUpWorkspace
  changeOwner "1000:1000" "$(pwd)"
}

main() {
  handleError
  isRootUser
  prepareWorkspace
  runMkarchiso
  postBuild
}

time main

exit 0

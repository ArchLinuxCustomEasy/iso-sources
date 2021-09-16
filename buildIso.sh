#!/bin/bash

# Name: buildIso.sh
# Description: Build an ISO image of ALICE base on custom settings
# Author: Tuxi Metal <tuximetal[at]lgdweb[dot]fr>
# Url: https://github.com/custom-archlinux/iso-sources
# Version: 1.0
# Revision: 2021.06.27
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

# Cleanup before build
preBuild() {
  removeDirectory "${sourcesDir}"
  removeDirectory "${outDirectory}"
  removeDirectory "${workDirectory}"
  sleep .5
  printMessage "Create archiso directory"
  mkdir -p ${sourcesDir}
  sleep .5  
}

main() {
  handleError
  isRootUser
  preBuild
  copyFiles "/usr/share/archiso/configs/releng/*" ${sourcesDir} "Copy archiso files from the system to the local archiso directory"
  copyFiles "${customFiles}*" "${sourcesDir}" "Copy custom files in archiso directory"
  git clone https://github.com/ArchLinuxCustomEasy/scripts.git ${sourcesDir}/airootfs/root/scripts
  changeOwner "root:root" "${sourcesDir}"
  runMkarchiso
  changeOwner "1000:1000" "$(pwd)"

  printMessage "All is done!"

  exit 0
}

time main
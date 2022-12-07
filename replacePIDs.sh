#!/bin/bash

function hardCodePIDs()
{
	gitWorkDirectory="$PWD"
	cd ${gitWorkDirectory}/weblogic-azure
	pwd
	pidKeys=`cat weblogic-azure-vm/arm-oraclelinux-wls/src/main/resources/pid.properties | cut -f1 -d"=" | grep -v '#' | grep -v "^$"`
	for pidKey in $pidKeys
	do
		value=`cat weblogic-azure-vm/arm-oraclelinux-wls/src/main/resources/pid.properties | grep -w "^$pidKey" | cut -f2 -d"="`
		pidString='${'${pidKey}'}'
		jsonFiles=`find . -name *.json`
		for jsonFile in $jsonFiles
		do
			echo "Replacing $pidString with $value in $jsonFile"
			sed -i "s|$pidString|$value|g" $jsonFile 
		done
	done
	git status
	checkSuccess $? "Git status failed"
}

PWD="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

hardCodePIDs

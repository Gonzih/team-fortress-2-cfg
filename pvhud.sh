#!/bin/bash
# Put me inside Team Fortress 2/tf directory

# First cd'ing to the dir we reside in
cd "$(dirname "$0")"

# PVHUD download url
PV_URL="http://dl.dropbox.com/u/1565165/pvhud_dl.html"

# Functions

# look at installation status
pv_getlocalstatus() {
	PV_LOCAL_VER=0
	[[ -f pvhud/HUDversion.txt ]] && \
		PV_LOCAL_VER="$(cat pvhud/HUDversion.txt)"
	printf "Local: ${PV_LOCAL_VER}\n"
}

# grab the html
pv_gethtml() {
        PV_HTML="$(wget -q -O - "${PV_URL}")"
}

# parse it
pv_parsehtml() {
	PV_ZIP_URL="$(printf "${PV_HTML}" | \
			grep -B 1 DOWNLOAD | \
			head -n 1 | \
			sed "s/<a href='//g;s/'>//g")"
	printf "Archive URL: ${PV_ZIP_URL}\n"
	PV_REMOTE_VER="$(printf "${PV_HTML}" | \
			grep "^PVHUD v" | \
			awk '{print $2}' | \
			sed 's/v//g;s/,//g')"
	printf "Remote: ${PV_REMOTE_VER}\n"
}

pv_dlhud() {
        if [ ! -d dir ]; then
                mkdir pvhud
        fi
        printf "Downloading the HUD...\n"
        wget -nv -O pvhud/HUDfiles.zip "${PV_ZIP_URL}" 2>&1
        return $?
}

# install the HUD
pv_installhud() {
	unzip -qo pvhud/HUDfiles.zip -d custom/ && \
	printf "Successfully installed PVHUD!\n"
	printf "${PV_REMOTE_VER}" > pvhud/HUDversion.txt
}

pv_getlocalstatus
pv_gethtml
pv_parsehtml

if [ $PV_LOCAL_VER -lt $PV_REMOTE_VER ]; then
	pv_dlhud && \
	pv_installhud && \
fi

exit 0

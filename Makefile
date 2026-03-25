#BUILD SETTINGS
BUILD_FOLDER = build
PACKAGE_FILE = ${BUILD_FOLDER}/usermgr.zip
##################################

SHELL := bash

all: ${BUILD_FOLDER}
	@echo -n "Creating package ${PACKAGE_FILE}..."
	@cd src && zip -rq ../${PACKAGE_FILE} *
	@echo "complete"

${BUILD_FOLDER}:
	@[[ ! -d build ]] && mkdir ${BUILD_FOLDER}

clean:
	rm -rf ${BUILD_FOLDER}

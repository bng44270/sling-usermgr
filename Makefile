#BUILD SETTINGS
BUILD_FOLDER = build
PACKAGE_FILE = ${BUILD_FOLDER}/usermgr.zip
##################################

define checkfile
$(if $(shell which $(1)),,$(error "Binary not found: $(1)"))
endef

SHELL := bash

all: ${BUILD_FOLDER}
	$(call checkfile,zip)
	@echo -n "Creating package ${PACKAGE_FILE}..."
	@cd src && zip -rq ../${PACKAGE_FILE} *
	@echo "complete"

${BUILD_FOLDER}:
	@[[ ! -d build ]] && mkdir ${BUILD_FOLDER}

clean:
	rm -rf ${BUILD_FOLDER}

#BUILD SETTINGS
BUILD_FOLDER = build
SRC_FOLDER = src
PACKAGE_FILE = ${BUILD_FOLDER}/usermgr.zip
M4_FOLDER = m4
MANIFEST_M4 = ${M4_FOLDER}/MANIFEST.MF.m4
PROPERTY_M4 = ${M4_FOLDER}/properties.xml.m4
MANIFEST_TARGET = ${SRC_FOLDER}/META-INF/MANIFEST.MF
PROPERTY_TARGET = ${SRC_FOLDER}/META-INF/vault/properties.xml
##################################

define checkfile
$(if $(shell which $(1)),,$(error "Binary not found: $(1)"))
endef

SHELL := bash

all: ${BUILD_FOLDER}
	@echo -n "Checking dependencies..."
	$(call checkfile,zip)
	$(call checkfile,m4)
	$(call checkfile,git)
	@echo "complete"
	@echo -n "Setting version..."
	@m4 -DVERSIONFIELD="$$(git rev-parse --short HEAD)" ${MANIFEST_M4} > ${MANIFEST_TARGET}
	@m4 -DVERSIONFIELD="$$(git rev-parse --short HEAD)" ${PROPERTY_M4} > ${PROPERTY_TARGET}
	@echo "complete"
	@echo -n "Creating package ${PACKAGE_FILE}..."
	@cd src && zip -rq ../${PACKAGE_FILE} *
	@echo "complete"

${BUILD_FOLDER}:
	@[[ ! -d build ]] && mkdir ${BUILD_FOLDER}

clean:
	rm -rf ${BUILD_FOLDER}

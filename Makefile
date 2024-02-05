#BUILD SETTINGS
TMP_FOLDER = tmp
LIB_FOLDER = lib
USERS_FILE = ${TMP_FOLDER}/users.json
CONF_FILE = ${TMP_FOLDER}/server.txt
GET_USER_LIST = ${LIB_FOLDER}/getusers.py
GET_USER_PATH = ${LIB_FOLDER}/getuserpath.py
##################################

SHELL := bash

define newdefine
@read -p "$(1) [$(3)]: " thisset ; [[ -z "$$thisset" ]] && echo "#define $(2) $(3)" >> $(4) || echo "#define $(2) $$thisset" | sed 's/\/$$//g' >> $(4)
endef

define newdefinestr
@read -p "$(1) [$(3)]: " thisset ; [[ -z "$$thisset" ]] && echo "#define $(2) \"$(3)\"" >> $(4) || echo "#define $(2) \"$$thisset\"" | sed 's/\/$$//g' >> $(4)
endef

define getdefine
$$((cpp -P <<< "$$(cat $(1) ; echo "$(2)")") | sed 's/"//g')
endef

#####
# Sling build-specific macros
#####
define httpdownload
curl -s -u $(call slingauthstr) $(call slingurlstr,$(1)) > $(2)
endef

define slingauthstr
$(call getdefine,tmp/server.txt,SLINGUSER):$(call getdefine,tmp/server.txt,SLINGPASS)
endef

define slingurlstr
$(call getdefine,tmp/server.txt,PROTO)://$(call getdefine,tmp/server.txt,HOSTPORT)$(1)
endef

define slingmkcol
curl -s -u $(call slingauthstr) -X MKCOL $(call slingurlstr,$(1)) > /dev/null
endef

define slinguploadfile
curl -s -u $(call slingauthstr) -T $(1) $(call slingurlstr,$(2)) > /dev/null
endef

define slingsetproperty
curl -X POST -s -u $(call slingauthstr) -F"$(1)" $(call slingurlstr,$(2)) > /dev/null
endef


all: tmp/users.json
	$(call slingmkcol,/apps/users)
	$(call slingmkcol,/apps/users/edit)
	$(call slingmkcol,/apps/users/manage)
	$(call slinguploadfile,useredit.html,/apps/users/edit/html.esp)
	$(call slinguploadfile,usermgr.html,/apps/users/manage/html.esp)
	$(call slinguploadfile,webrequest.js,/etc/clientlibs/webrequest.js)
	python3 ${GET_USER_LIST} -f ${USERS_FILE} | while read THISUSR; do \
		USERPATH="$$(python3 ${GET_USER_PATH} -f ${USERS_FILE} -u $$THISUSR)" ; \
		$(call slingsetproperty,sling:resourceType=users/edit,$${USERPATH}.html) ; \
		$(call slingsetproperty,uid=$${THISUSR},$${USERPATH}.html) ; \
	done
	$(call slingsetproperty,sling:resourceType=users/manage,/apps/users)

clean:
	rm -rf tmp

tmp/server.txt: tmp
	$(call newdefine,Enter protocol,PROTO,http,tmp/server.txt)
	$(call newdefine,Enter host and port,HOSTPORT,localhost:8080,tmp/server.txt)
	$(call newdefine,Enter sling user,SLINGUSER,admin,tmp/server.txt)
	$(call newdefine,Enter sling password,SLINGPASS,admin,tmp/server.txt)

tmp/users.json: tmp/server.txt
	$(call httpdownload,/system/userManager/user.1.json,tmp/users.json)

tmp:
	mkdir tmp

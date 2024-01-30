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

all: tmp/users.json
	curl -s -u $(call getdefine,tmp/server.txt,SLINGUSER):$(call getdefine,tmp/server.txt,SLINGPASS) -X MKCOL $(call getdefine,tmp/server.txt,PROTO)://$(call getdefine,tmp/server.txt,HOSTPORT)/apps/users > /dev/null
	curl -s -u $(call getdefine,tmp/server.txt,SLINGUSER):$(call getdefine,tmp/server.txt,SLINGPASS) -X MKCOL $(call getdefine,tmp/server.txt,PROTO)://$(call getdefine,tmp/server.txt,HOSTPORT)/apps/users/edit > /dev/null
	curl -s -u $(call getdefine,tmp/server.txt,SLINGUSER):$(call getdefine,tmp/server.txt,SLINGPASS) -X MKCOL $(call getdefine,tmp/server.txt,PROTO)://$(call getdefine,tmp/server.txt,HOSTPORT)/apps/users/manage > /dev/null
	curl -s -u $(call getdefine,tmp/server.txt,SLINGUSER):$(call getdefine,tmp/server.txt,SLINGPASS) -X MKCOL $(call getdefine,tmp/server.txt,PROTO)://$(call getdefine,tmp/server.txt,HOSTPORT)/content/newuser > /dev/null
	curl -s -u $(call getdefine,tmp/server.txt,SLINGUSER):$(call getdefine,tmp/server.txt,SLINGPASS) -T useredit.html $(call getdefine,tmp/server.txt,PROTO)://$(call getdefine,tmp/server.txt,HOSTPORT)/apps/users/edit/html.esp > /dev/null
	curl -s -u $(call getdefine,tmp/server.txt,SLINGUSER):$(call getdefine,tmp/server.txt,SLINGPASS) -T usermgr.html $(call getdefine,tmp/server.txt,PROTO)://$(call getdefine,tmp/server.txt,HOSTPORT)/apps/users/manage/html.esp > /dev/null
	python3 ${GET_USER_LIST} -f ${USERS_FILE} | while read THISUSR; do \
		USERPATH="$$(python3 ${GET_USER_PATH} -f ${USERS_FILE} -u $$THISUSR)" ; \
		curl -s -u $(call getdefine,tmp/server.txt,SLINGUSER):$(call getdefine,tmp/server.txt,SLINGPASS) -F"sling:resourceType=users/edit" $(call getdefine,tmp/server.txt,PROTO)://$(call getdefine,tmp/server.txt,HOSTPORT)$$USERPATH.html > /dev/null ; \
		curl -s -u $(call getdefine,tmp/server.txt,SLINGUSER):$(call getdefine,tmp/server.txt,SLINGPASS) -F"uid=$$THISUSR" $(call getdefine,tmp/server.txt,PROTO)://$(call getdefine,tmp/server.txt,HOSTPORT)$$USERPATH.html > /dev/null ; \
	done
	curl -s -u $(call getdefine,tmp/server.txt,SLINGUSER):$(call getdefine,tmp/server.txt,SLINGPASS) -F"sling:resourceType=users/manage" $(call getdefine,tmp/server.txt,PROTO)://$(call getdefine,tmp/server.txt,HOSTPORT)/content/usermgr.html > /dev/null

clean:
	rm -rf tmp

tmp/server.txt: tmp
	$(call newdefine,Enter protocol,PROTO,http,tmp/server.txt)
	$(call newdefine,Enter host and port,HOSTPORT,localhost:8080,tmp/server.txt)
	$(call newdefine,Enter sling user,SLINGUSER,admin,tmp/server.txt)
	$(call newdefine,Enter sling password,SLINGPASS,admin,tmp/server.txt)

tmp/users.json: tmp/server.txt
	curl -s -u $(call getdefine,tmp/server.txt,SLINGUSER):$(call getdefine,tmp/server.txt,SLINGPASS) $(call getdefine,tmp/server.txt,PROTO)://$(call getdefine,tmp/server.txt,HOSTPORT)/system/userManager/user.1.json > tmp/users.json

tmp:
	mkdir tmp

all: tmp/userlist.txt
	curl -s -u $$(grep '^USER' tmp/server.txt | sed 's/^USER //g'):$$(grep '^PASS' tmp/server.txt | sed 's/^PASS //g') -X MKCOL $$(grep '^PROTO' tmp/server.txt | sed 's/^PROTO //g')://$$(grep '^HOST' tmp/server.txt | sed 's/^HOST //g')/apps/users > /dev/null
	curl -s -u $$(grep '^USER' tmp/server.txt | sed 's/^USER //g'):$$(grep '^PASS' tmp/server.txt | sed 's/^PASS //g') -X MKCOL $$(grep '^PROTO' tmp/server.txt | sed 's/^PROTO //g')://$$(grep '^HOST' tmp/server.txt | sed 's/^HOST //g')/apps/users/edit > /dev/null
	curl -s -u $$(grep '^USER' tmp/server.txt | sed 's/^USER //g'):$$(grep '^PASS' tmp/server.txt | sed 's/^PASS //g') -X MKCOL $$(grep '^PROTO' tmp/server.txt | sed 's/^PROTO //g')://$$(grep '^HOST' tmp/server.txt | sed 's/^HOST //g')/apps/users/manage > /dev/null
	curl -s -u $$(grep '^USER' tmp/server.txt | sed 's/^USER //g'):$$(grep '^PASS' tmp/server.txt | sed 's/^PASS //g') -X MKCOL $$(grep '^PROTO' tmp/server.txt | sed 's/^PROTO //g')://$$(grep '^HOST' tmp/server.txt | sed 's/^HOST //g')/content/newuser > /dev/null
	curl -s -u $$(grep '^USER' tmp/server.txt | sed 's/^USER //g'):$$(grep '^PASS' tmp/server.txt | sed 's/^PASS //g') -T useredit.html $$(grep '^PROTO' tmp/server.txt | sed 's/^PROTO //g')://$$(grep '^HOST' tmp/server.txt | sed 's/^HOST //g')/apps/users/edit/html.esp > /dev/null
	curl -s -u $$(grep '^USER' tmp/server.txt | sed 's/^USER //g'):$$(grep '^PASS' tmp/server.txt | sed 's/^PASS //g') -T usermgr.html $$(grep '^PROTO' tmp/server.txt | sed 's/^PROTO //g')://$$(grep '^HOST' tmp/server.txt | sed 's/^HOST //g')/apps/users/manage/html.esp > /dev/null
	cat tmp/userlist.txt | xargs -L1 -ITHISUSER bash -c 'THISUSR="THSIUSER" ; curl -s -u $$(grep "^USER" tmp/server.txt | sed "s|^USER ||g"):$$(grep "^PASS" tmp/server.txt | sed "s|^PASS ||g") -F"sling:resourceType=users/edit" $$(grep "^PROTO" tmp/server.txt | sed "s|^PROTO ||g")://$$(grep "^HOST" tmp/server.txt | sed "s|^HOST ||g")/home/users/$${THISUSR:0:1}/$$THISUSR.html > /dev/null'
	cat tmp/userlist.txt | xargs -L1 -ITHISUSER bash -c 'THISUSR="THISUSER" ; curl -s -u $$(grep "^USER" tmp/server.txt | sed "s|^USER ||g"):$$(grep "^PASS" tmp/server.txt | sed "s|^PASS ||g") -F"uid=$$THISUSER" $$(grep "^PROTO" tmp/server.txt | sed "s|^PROTO ||g")://$$(grep "^HOST" tmp/server.txt | sed "s|^HOST ||g")/home/users/$${THISUSR:0:1}/$$THISUSR.html > /dev/null'

clean:
	rm -rf tmp

tmp/server.txt: tmp
	@echo "PROTO $$(read -p "Enter protocol [http]: " proto ; [[ -z "$$proto" ]] && echo "http" || echo "$$proto" )" > tmp/server.txt
	@echo "HOST $$(read -p "Enter host and port [localhost:8080]: " hostport ; [[ -z "$$hostport" ]] && echo "localhost:8080" || echo "$$hostport" )" >> tmp/server.txt
	@echo "USER $$(read -p "Enter sling username [admin]: " slinguser ; [[ -z "$$slinguser" ]] && echo "admin" || echo "$$slinguser" )" >> tmp/server.txt
	@echo "PASS $$(read -p "Enter sling password [admin]: " slingpass ; [[ -z "$$slingpass" ]] && echo "admin" || echo "$$slingpass" )" >> tmp/server.txt

tmp/userlist.txt: tmp tmp/server.txt
	curl -s $$(grep '^PROTO' tmp/server.txt | sed 's/^PROTO //g')://$$(grep '^HOST' tmp/server.txt | sed 's/^HOST //g')/system/userManager/user.1.json  | sed 's/}$$/\n}/;s/^{/{\n/g;s/},/},\n/g' | awk 'BEGIN { FS=":" } { print $$1 }' | egrep -v '{|}' | sed 's/"//g' | grep -v anonymous > tmp/userlist.txt	

tmp:
	mkdir tmp

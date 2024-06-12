BEGIN {
	mod = 0;
}
/>Browse Content</  {
	print "                            <li id=\"user-mgr-link\"><a href=\"/apps/users.html\" title=\"User Manager\">User Manager</a></li>";
	print; 
	mod = 1;
}
/logout.*document\.querySelector.*login-signedin/ {
	print;
	print "                var userMgrLink = document.querySelector('#user-mgr-link');";
	mod = 1;
}
/logout\.style\.display.*block/ {
	print;
	print "                    userMgrLink.style.display = 'block';";
	mod = 1;
}
/logout\.style\.display.*none/ {
	print;
	print "                    userMgrLink.style.display = 'none';";
	mod = 1;
}
{
	if (mod == 1) { 
		mod = 0;
	} 
	else { 
		print; 
	} 
}

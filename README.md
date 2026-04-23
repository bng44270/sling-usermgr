# sling-usermgr
### Pre-Install
This application is designed to work with the Apache Sling Feature Model Launcher.  If you are using Debian, you can use [this script](https://github.com/bng44270/bash-utils/blob/main/install-sling.sh) to automatically download and install Sling along with dependencies (curl, gawk, unzip, and the newest openjdk version).  
  
### NOTE:  All actions performed on the Sling instance will require admin access
  
### Installing
1. Clone repository  
2. Run ```make``` (note the location of the package ZIP file)  
3. Navigate to ```http://hosname-ip:8080/bin/packages.html``` and upload the package ZIP file  
4. Install the newly uploaded version.  The version of the uploaded package will match the active commit ID of the Git repository.  To verify the version run ```git branch -v``` from within the repository to confirm the commit ID.  
  
### Using  
After the package is installed navigate to ```http://hosname-ip:8080/apps/users.html```  

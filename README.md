# sling-usermgr
### Pre-Install
This application is designed to work with the Apache Sling Feature Model Launcher.  If you are using Debian, you can use [this script](https://github.com/bng44270/bash-utils/blob/main/install-sling.sh) to automatically download and install Sling along with dependencies (curl, gawk, unzip, and the newest openjdk version).  
  
### Installing
1. Clone repository
2. ```make```
3. Upload/install ```build/usermgr.zip``` package onto Sling instance  
  
#### NOTE:  the version of the uploaded package will match the active commit ID of the Git repository
  
### Using
1. Go to your Sling instance (ex. hostname-ip:8080)
2. Click the **Login** link and authenticate as `admin`
3. Once authenticated, navigate to ```http://hosname-ip:8080/apps/users.html``` 

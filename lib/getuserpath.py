from arguments import Arguments
from os.path import exists as file_exists
from json import loads as json_parse
from sys import exit

args = Arguments()

jsonfilepath = args.Get("f")
username = args.Get("u")
if jsonfilepath and username:
  if file_exists(jsonfilepath):
    userobj = {}
    
    with open(jsonfilepath,"r") as f:
      userobj = json_parse(''.join(f.readlines()))
    
    validusers = [a for a in userobj.keys()]

    if username in validusers:
      print(userobj[username]["path"])
    else:
      print(f"Error:  username does not exist ({username})")
      exit(1)
  else:
    print(f"Error:  file not found ({jsonfilepath})")
    exit(1)
else:
  print("usage: getuserpath.py -f <JSON-file> -u <username>")
  exit(1)
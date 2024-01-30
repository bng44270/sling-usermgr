from arguments import Arguments
from os.path import exists as file_exists
from json import loads as json_parse
from sys import exit

args = Arguments()

jsonfilepath = args.Get("f")
if jsonfilepath:
  if file_exists(jsonfilepath):
    userobj = {}
    
    with open(jsonfilepath,"r") as f:
      userobj = json_parse(''.join(f.readlines()))
    
    validusers = [a for a in userobj.keys()]

    print("\n".join(validusers))
  else:
    print(f"Error:  file not found ({jsonfilepath})")
    exit(1)
else:
  print("usage: getuserpath.py -f <JSON-file> -u <username>")
  exit(1)
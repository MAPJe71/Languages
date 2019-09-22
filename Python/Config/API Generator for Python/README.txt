V1.2 - 11 October 2011

This python script generates a custom python.xml file for advanced auto-completion features within Notepad++.
The python.xml file has to be copied in the folder: \Notepad++\plugins\APIs\ (you might rename the existing python.xml file or simply overwrite it).

To use the auto-completion features within Notepad++, enable the option in Settings | Preferences | Backup/Auto-Completion | Enable auto-completion on each input.

As input, I recommend to create a python script containing all public and user-defined modules you usually use, for instance create the following file: my_imports.py and type in:
import sys, cgi, os, re, subprocess
import cx_Oracle as oracle
from rdkit import Chem
sys.path.append("/home/python/my_python_modules/")
import my_module

Finally, run the python script:
python generate_python_autocomplete.py < my_imports.py > python.xml
Save the file under \Notepad++\plugins\APIs\python.xml
Restart Notepad++; you're done!

The built-in functions are added by default. Please have a look at the code for additional options (or run "generate_python_autocomplete.py --help").

Revisions:
 V1.2 - 11 October 2011 - Added list of reserved keywords (keyword.kwlist) and True, False, None
 V1.1 - 25 May 2011 - Original release

G. Gerebtzoff
October 2011

/*/--------------------------------------------------------------------------------------------------------//
*** Header Start ******** Do Not Change This Line ********* Header Start ******** Do Not Change This Line ***


-- Purpose:
-----------   
		
	A WerwacKScripts script
	3dsMax Supported Versions:	2010 and more
	Contact: -
	Website: -
	Copyright: WerwacKScripts
	
-- Install:
-----------

	--- Template: Add your code here ---
	Drag and drop WkProjectToolbar.mzp inside 3dsMax.
	You can create a macroscript button or launch the script by a script command call.
	
	To create a macroscript button:
	-------------------------------
	
	Launch 3DSMax. In the menu toolbar, choose "Customize", then "Customize User Interface". Choose
	"WerwacKScripts" in the "Category" dropdownlist, then select the script you want to install and
	drag and drop the associated icon on the desired toolbar. If no toolbar exist, you can create
	one by clicking on the button "new" at the right of the "Category" dropdownlist. 

	If the script name appears several times in the list, one or more previous verions are still
	installed on your system. 

	To run the script, just click on the button you just added. 
	

	
-- Use:
-------
   --- Template: Add your code here ---

    
-- Package files:
-----------------
   	
    
-- Notes:
---------

-- to do:
---------

	
-- Known troubles:
------------------  


-- Version history:
-------------------


-- V1.0: (2011/03/24)
		- basic version



*** Header End ******** Do Not Change This Line ************* Header End ******** Do Not Change This Line ***
//--------------------------------------------------------------------------------------------------------/*/

fn WkCallback_MyFunction =
(
	messagebox "MyFunction"
)

lCallbackFunctionStr =""
--lCallbackFunctionStr += "fn WkCallback_MyFunction = \n"
lCallbackFunctionStr += "( \n"
lCallbackFunctionStr += "		format\"WkCallback PreSave called\\n\" \n"
lCallbackFunctionStr += "		if undefined != WkCallback_MyFunction do WkCallback_MyFunction()"
lCallbackFunctionStr += ") \n"


callbacks.addScript #filePreSave lCallbackFunctionStr id:#WkCallback_LocalFolder

callbacks.removeScripts #filePreSave id:#WkCallback_LocalFolder

callbacks.show #filePreSave id:#WkCallback_LocalFolder

callbacks.broadcastCallback #filePreSave






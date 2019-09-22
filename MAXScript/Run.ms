/*/--------------------------------------------------------------------------------------------------------//
*** Header Used For Versionning ** Do Not Change ** Header Used For Versionning ** Do Not Change ************

	Run.ms:
		This script is called by mzp.run when a .mzp package is being installed.
		It calls Drop.ms and acts the same except that it doesn't display any GUI.
		
*** Header Used For Versionning ** Do Not Change ** Header Used For Versionning ** Do Not Change ************
//--------------------------------------------------------------------------------------------------------/*/

global gbWkScriptsPackageBeingInstalled			-- used by WkToolsUpdater when scripts are automatically installed through the network

(
	format "run\n"
	try	fileIn (getdir #temp + "\\Drop.ms")
	catch messagebox ("Cannot launch installer main script:\n\n    " + (getdir #temp + "\\Drop.ms") + "\n\nPlease contact the script support") title:"MZP Run.ms - Error: Drop script cannot be launched"
)

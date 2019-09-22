	/* 
		Static struct ObjectMethods 
		Second line
	*/
	struct ObjectMethods
	(
		/* Remove duplicate from instanced objects */
		fn RemoveInstances &objectsArray =
		(
		),

		/* Get only materials from top level */
		fn GetMaterials objectsArray excludeStandardProperty:false =
		(
			SomeStructMethods.GetMaterials objectsArray
		),

		/* Get only textures from top level */
		fn GetTextureMaps objectsArray =
		(

		),

private 

		/* ObjectMethods Get only filenames from top level */
		fn GetFileNames objectsArray =
		(
		),
		
		fn OnGetMaxFileAssetItems sender e = (
			if e != undefined and classOf e.FileName == String	do (
			local assetItems = KstudioFileAssetMetadata.GetFileAssetMetadata e.FileName;
			if ( classOf assetItems == Array  and assetItems.Count > 0 ) do(
					e.Result = assetItems;
				)
			)
		),
		
		on create do()
	)

	
	/* 
		Static struct TextureMapsMethods 
		Second line
	*/
	struct TextureMapsMethods
	(
		/* Remove duplicate from instanced objects */
		fn RemoveInstances &objectsArray =
		(
		),

		/* Get only materials from top level */
		fn GetMaterials objectsArray excludeStandardProperty:false =
		(

		),

		/* Get only textures from top level */
		fn GetTextureMaps objectsArray =
		(

		),

		/* Get only filenames from top level */
		fn GetFileNames objectsArray =
		(
		),
		
		
		on create do() 
	)
	
		
	/* 
		Initialized struct SomeStructMethods 
		Second line	
	*/
	struct SomeStructMethods
	(
		/* Remove duplicate from instanced objects */
		fn RemoveInstances &objectsArray =
		(
			
		),

		fn GetMaterials objectsArray excludeStandardProperty:false =
		(

		),

		/* Get only textures from top level */
		fn GetTextureMaps objectsArray =
		(
			SomeStructMethods.GetTextureMaps 
		),

		/* Get only filenames from top level */
		fn GetFileNames objectsArray =
		(
		)
	)
	
/* Get only filenames from top level */
fn GetFileNames objectsArray =
(
)
		
SomeStruct = SomeStructMethods()

/* CTRL+Click => navigate to ObjectMethods.GetFileNames */
ObjectMethods.GetFileNames objectsArray
ObjectMethods.OnGetMaxFileAssetItems sender e

/* CTRL+Click => navigate to TextureMapsMethods.GetFileNames */
TextureMapsMethods.GetFileNames objectsArray

/* 
	This is initialazed structure
	Now plugin can't detect the initialized structures, so we can try search for function with same name into all structures.
	In case, if found only one struct - we navigate to them. If we find multiply structures - display all of them in the list with ability to choise and navigate to desired.
*/
SomeStruct.GetFileNames objectsArray

/* 
	Function outside the structure. 
	Navigate to function and ignore functions with same name used into structures
*/
GetFileNames

SomeStructMethods.GetMaterials objectsArray
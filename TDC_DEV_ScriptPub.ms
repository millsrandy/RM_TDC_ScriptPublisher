/* 
	TO-DO LIST

	- Add "Import Files" button to ScriptDepot that will force popup of ScriptPub
	
	- Check if PUB-TOOLS exists, ask user where PUB-TOOLS is located, 
	if it doesn't exist ask if they'd like to create a PUB-TOOLS folder
	
	- package MISSING assets (bmp & txt) with final distro
	

*/

LibDir = DevDir + "/LIBS/"

-- LIBRARIES
::filein @"D:\TDCertification\DEV\LIBS\lib_CharChange.ms"
::filein @"D:\TDCertification\DEV\LIBS\lib_VerCheck.ms"
::filein @"D:\TDCertification\DEV\LIBS\lib_Stream_File.ms"
::filein @"D:\TDCertification\DEV\LIBS\lib_SearchStringBlock.ms"
::filein @"D:\TDCertification\DEV\LIBS\lib_TextWrap.ms"


-- PREDEFINED VARIABLES
scriptMissingAsset = true
typeMissing = true
_FileType = ".ms"
Limiter = 300
Missing_ImageFile = DevDir + "/SCRIPTS/ASSETS/ScriptDepot_MissingAssets/missing.bmp"
Missing_TextFile = DevDir + "/SCRIPTS/ASSETS/ScriptDepot_MissingAssets/missing.txt"

global Contents_TextFile
global Contents_AssetFile
global Contents_ImageFile

global Text_Title
global Text_Author
global Text_Category
global Text_Description

global PubTools_Folder
global catFolder
global SRCscriptPath
global SRCscriptName
global scriptAuthorName
global scriptDescription

global destPubPath
global scriptPubPath
--global SRC_script

/* global Dest_Pub
global DevDir */

--global pickeditm
global scriptcatitm
--global scriptcat

SD = #()
CatList = #() -- # categories
ScriptList = #() -- # complete paths to each script
ScriptList_ShortList = #() -- # just the names of the scripts

----------------------------------------------------------------
-- #1 SCAN DIR
----------------------------------------------------------------
ScriptDepot = DevDir + "/SCRIPTS/PUB_TOOLS/"
ScriptList = GetDirectories (ScriptDepot + "*." + "*.")

for i = 1 to ScriptList.count do
(
	tmpString = filterstring (ScriptList[i]) "\\"
	CatList[i] = tmpString[tmpString.count]
	ScriptList_ShortList[i] = #()
	ScriptList[i] = GetDirectories (ScriptList[i] + "*." + "*.")
	
	for n = 1 to ScriptList[i].count do
	(
		tmpString = filterstring (ScriptList[i][n]) "\\"
		ScriptList_ShortList[i][n] = tmpString[tmpString.count]
		CharChange (ScriptList[i][n]) "\\" "/"
		ScriptList[i][n] = newstring
		
	)
	
	for i = ScriptList.count to 1 by -1 do
	(
	 	if (ScriptList[i].count) == 0 then
	 	(
	 		deleteitem CatList i
	 		deleteitem ScriptList i
	 		deleteitem ScriptList_ShortList i
	 		
	 	)

	)
	 	
)



-- FUNCTIONS
	-- SRC_Script = SRCscriptPath -- move down to PUBLISH button before running final

fn GetScript _SRC_Script = 
	(
	
	if (doesDirectoryExist (PubTools_Folder)) == true then
		(
			if (doesDirectoryExist (destPubPath + "/PUB/")) == false then
				(
					SD[1] = destPubPath + "/DEV/"
					SD[2] = destPubPath + "/PUB/"
					SD[3] = destPubPath + "/PUB/v001/"
				
					for i = 1 to SD.count do
						(
							makeDir (SD[i])
						)
					
					-- Copy script file, rename to new input name and move to /PUB/v001/ folder						
					copyFile SRCscriptPath (scriptPubPath + ".ms")
						
					-- Copy bmp image, rename to new input name and move to /PUB/v001/ folder
					scriptTemplateBmp = "D:\TDCertification\DEV\SCRIPTS\ASSETS\ScriptDepot_Images\bmp\TDC_ScriptDepot_Icons_01.bmp"
					copyFile scriptTemplateBmp (scriptPubPath + ".bmp")
						
					-- Print ScriptName, Author Name and Description to .txt file using template				
					output_name = (scriptPubPath + ".txt")
					if output_name != undefined then
					(
						output_file = createfile output_name
						format "%\n" "[TITLE]" to:output_file
						format "%\n" scriptName to:output_file
						format "\n" to:output_file
						format "%\n" "[CATEGORY]" to:output_file
						format "%\n" scriptcatitm to:output_file
						format "\n" to:output_file
						format "%\n" "[AUTHOR]" to:output_file
						format "%\n" scriptAuthorName to:output_file
						format "\n" to:output_file
						format "%\n" "[DESCRIPTION]" to:output_file
						format "%\n" scriptDescription to:output_file
						format "\n" to:output_file
						format "%\n" "[END]" to:output_file
						close output_file
					)
						
				)
				else
				(
					--scriptPUB_Dir = destPubPath + "/PUB/"
					scriptPUB_Dir
					CharChange (scriptPUB_Dir) "/" "\\"
					scriptPUB_Dir = newstring
					scriptPubDir_List = getDirectories (scriptPUB_Dir + "*.")
					if scriptPubDir_List.count == 0 then (MakeDir (scriptPUB_Dir + "v000"))
					VerCheck scriptPubPath _FileType false
					
					OldPath = VerPath
					VerInt = VerInt + 1
						
					if (VerInt < 10) then -- default (for 1 digit)
						(
							VerNum = (substring VerNum 1 3) + (VerInt as string)
							VerPath = substring VerPath 1 (VerPath.count - 2) + (VerInt as string) + "\\"
						
						)
						else if (VerInt > 9 and VerInt < 100) then -- (for 2 digits)
						(
							VerNum = (substring VerNum 1 2) + (VerInt as string)
							VerPath = substring VerPath 1 (VerPath.count - 3) + (VerInt as string) + "\\"
							
						)
						else if (VerInt > 99) then -- (for 3 digits)
						(
							VerNum = "v" + (VerInt as string)
							VerPath = substring VerPath 1 (VerPath.count - 4) + (VerInt as string) + "\\"
							
						)
						
					Dest_Pub = VerPath
					MakeDir Dest_Pub
					removedir (scriptPub_Dir + "v000")
						
					-- Publish MS File
					copyFile SRCscriptPath (Dest_Pub + scriptName + ".ms")
					
					-- Publish BMP File
					scriptUpdateBmp = "D:\TDCertification\DEV\SCRIPTS\ASSETS\ScriptDepot_Images\bmp\TDC_ScriptDepot_Icons_01.bmp"
					copyFile scriptUpdateBmp (Dest_Pub + scriptName + ".bmp")
						
					-- Publish TXT File
					output_name = (Dest_Pub + scriptName + ".txt")
					if output_name != undefined then
						(
							output_file = createfile output_name
							format "%\n" "[TITLE]" to:output_file
							format "%\n" scriptName to:output_file
							format "\n" to:output_file
							format "%\n" "[CATEGORY]" to:output_file
							format "%\n" scriptcatitm to:output_file
							format "\n" to:output_file
							format "%\n" "[AUTHOR]" to:output_file
							format "%\n" scriptAuthorName to:output_file
							format "\n" to:output_file
							format "%\n" "[DESCRIPTION]" to:output_file
							format "%\n" scriptDescription to:output_file
							format "\n" to:output_file
							format "%\n" "[END]" to:output_file
							close output_file
						)
					
					)
		)
				
		else
		(
			messagebox ("PUB_TOOLS folder does not exist!")
		)
		
	)
	



-- PRE RUN LIBRARIES --
::filein @"D:\TDCertification\DEV\LIBS\lib_GetAsset.ms"
_ScriptAssetItem = ScriptList[1][1]
ChooseItem _ScriptAssetItem
scriptcatitm = 1

-- GUI
try(DestroyDialog _gui) catch()
rollout _gui "Script Publisher"
(
	edittext script_location "File location" width:450 align:#center
	button _choosefiles "choose files..."
	dropdownList _CategoryDropdown "Choose Category" items:CatList selection:scriptcatitm width:150 pos:[130,55]
	edittext _ScriptNameInput "Script Name" text:"Script Name.." width:300 pos:[20,105] 
	edittext _AuthorNameInput "Author Name" text:"Author Name.." width:300 pos:[20,125]
	edittext _DescriptionInput "Description" text:"Description or HELP info.." width:375 height:400 pos:[20,145]
	radiobuttons _ScriptType labels:#("DEV Script", "PUB Script") pos:[300,60] columns:1 default:0
	button _publish "Publish" pos:[410,450] height:40 width:90
	button _ScriptDepotDir "Script Depot Dir" pos:[410,420]
	
 	fn	Check_ScriptMissingAsset =
	(
		if scriptMissingAsset == true then
			(
				_ScriptNameInput.enabled = false
				_AuthorNameInput.enabled = false
				_DescriptionInput.enabled = false
				_CategoryDropdown.enabled = false
				_ScriptType.enabled = false

			)
			else
			(
				_ScriptNameInput.enabled = false
				_AuthorNameInput.enabled = false
				_DescriptionInput.enabled = false
				_CategoryDropdown.enabled = true
				_ScriptType.enabled = true

			)
	
	)
	
	fn	Check_typeMissing =
	(
		if typeMissing == true then
			(
				_ScriptNameInput.enabled = false
				_AuthorNameInput.enabled = false
				_DescriptionInput.enabled = false
				_ScriptType.enabled = false

			)
			else
			(
				_ScriptNameInput.enabled = true
				_AuthorNameInput.enabled = true
				_DescriptionInput.enabled = true
				_CategoryDropdown.enabled = true
				_ScriptType.enabled = true

			)
	
	)
	
	-- ONLY IF NEEDED:
	
	fn Refresh_DisplayContent =  -- Always run AFTER 'ChooseItem'
	(
		scriptcat = (CatList[scriptcatitm])
		_CategoryDropdown.selection = scriptcatitm
		_AuthorNameInput.Text = (Text_Author)
		_DescriptionInput.Text = (Text_Description)
	
	)
	
	on _GUI open do
	(
		ChooseItem (ScriptList[1][1])
		global scriptcatitm = 1
		global scriptcat = (CatList[scriptcatitm])
		Refresh_DisplayContent()
		
		if scriptMissingAsset == true then
		(
			_ScriptNameInput.enabled = false
			_AuthorNameInput.enabled = false
			_DescriptionInput.enabled = false
			_CategoryDropdown.enabled = false
			_ScriptType.enabled = false

		)


	)
	
	
	on _choosefiles pressed do
	(
		SRCscriptPath = getOpenFileName caption: "open file" types: "ms (*.ms)|*.ms|py (*.py)|*.py|ALL|*.*|"
		if SRCscriptPath != undefined then (
			script_location.text = SRCscriptPath
			CharChange (SRCscriptPath) "\\" "/"
			SRCscriptPath = newstring
			SRCscriptName = getFilenameFile SRCscriptPath
			_ScriptNameInput.text = SRCscriptName
			
			
  			fn doesSRCExist _SRC =
 			for i = 1 to ScriptList_ShortList.count do (
				if ScriptList_ShortList[i][i] == _SRC then (
					scriptcatitm = i
					--_CategoryDropdown.selection = scriptcatitm
					ChooseItem SRCscriptPath
					Refresh_DisplayContent()
				)
				else (
					--messagebox "script doesn't exist"
				
				)
			)
			
			doesSRCExist SRCscriptName
			
			scriptMissingAsset = false
			Check_scriptMissingAsset()
			
			--Refresh_DisplayContent()
		

		)
		else (
			scriptMissingAsset = true
			Check_scriptMissingAsset()
			
		)
		
	)

	
		on _CategoryDropdown selected scriptcat do
	(
		scriptcatitm = scriptcat
		
		Refresh_DisplayContent()

	)
	
	
	on _ScriptType changed state do
	(
		--scriptcat = (CatList[scriptcatitm])
		catFolder = ScriptDepot + scriptcat
		destPubPath = catFolder + "/" + SRCscriptName

		if _ScriptType.state == 0 then (
			typemissing = true
			Check_typeMissing()
		)
		else if _ScriptType.state == 1 then (
			scriptPUB_Dir = destPubPath + "/DEV/"
			typeMissing = false
			Check_typeMissing()
		)
		else if _ScriptType.state == 2 then (
			scriptPUB_Dir = destPubPath + "/PUB/"
			typeMissing = false
			Check_typeMissing()
		)
		
		--_ScriptNameInput.text = SRCscriptName
		--_CategoryDropdown.selection = scriptcatitm
		--_AuthorNameInput.Text = (Text_Author)
		--_DescriptionInput.Text = (Text_Description)
		
		Refresh_DisplayContent()
		
	)
	
	
	on _ScriptDepotDir pressed do
	(
		ShellLaunch @"D:\TDCertification\DEV\SCRIPTS\PUB_TOOLS" ""
		
	)
 	
	
	on _publish pressed do
	(
		if (_ScriptNameInput.text != "Script Name..") and (script_location != undefined) then
		(	
			PubTools_Folder = DevDir + "/SCRIPTS/PUB_TOOLS"
			scriptName = _ScriptNameInput.text
			scriptAuthorName = _AuthorNameInput.text
			scriptDescription = _DescriptionInput.text
			
			GetScript SRCscriptPath
			
			Open_ScriptDepot = @"D:\TDCertification\DEV\SCRIPTS\DEV\ScriptDepot\ScriptDepot_v004.ms"
			VerCheck Open_ScriptDepot ".ms" true
			
			::filein Open_ScriptDepot
		)
		else
		(
			Messagebox "Please choose a script file AND name your script"
			
		)
			
		
	)
	
	
)
CreateDialog _gui width:520
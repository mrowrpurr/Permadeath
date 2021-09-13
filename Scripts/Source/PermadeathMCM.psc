scriptName PermadeathMCM extends SKI_ConfigBase
{This is the MCM config for the Permadeath mod}

event OnConfigInit()
    ModName = "Permadeath"
    Pages = new string[1]
    Pages[0] = "Characters"
endEvent

event OnPageReset(string page)
    if page == ""
        LoadCustomContent("Permadeath\\MCM.dds")
    else
        UnloadCustomContent()
    endIf

    if page == "Characters"
        AddHeaderOption("Character Name")
        AddHeaderOption("Lasted Until")
        AddCharacterInfoRows()
    endIf
endEvent

function AddCharacterInfoRows()
    int characters = JValue.readFromDirectory("Data\\Permadeath\\Characters")
    string[] characterKeys = JMap.allKeysPArray(characters)
    int index = 0
    while index < characterKeys.Length
        string characterKey = characterKeys[index]
        int character = JMap.getObj(characters, characterKey)
        AddTextOption(JMap.getStr(character, "name"), "Level " + JMap.getInt(character, "level"))
        AddTextOption(JMap.getInt(character, "days") + " days,  " + JMap.getInt(character, "hours") + " hours", "")
        index += 1
    endWhile
endFunction


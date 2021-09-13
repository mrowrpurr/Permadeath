Scriptname PermadeathPlayer extends ReferenceAlias  
{This represents the player
and will catch the OnDeath events!}

Message Property PermadeathResurrectionDialog  Auto  

string CHARACTERS_FOLDER = "Data\\Permadeath\\Characters"
string THIS_CHARACTER_FILENAME
string THIS_CHARACTER_ID

; When the mod is run for the
; first time (for THIS CHARACTER)
event OnInit()
    Debug.Trace("Mod Installed")
    InitializeCharacterID()
    InitializeThisCharacter()
endEvent

function InitializeCharacterID()
    THIS_CHARACTER_ID = "Character_" + \
        Utility.RandomInt(1, 1000000000) + \
        "_" + Utility.RandomInt(1, 1000000000)
endFunction

function InitializeThisCharacter()
    THIS_CHARACTER_FILENAME = CHARACTERS_FOLDER + "\\" + THIS_CHARACTER_ID + ".json"

    ; Make a new file for this character which will
    ; track things like when they died
    int playerData = JMap.object()
    JMap.setStr(playerData, "name", GetActorReference().GetActorBase().GetName())
    JValue.writeToFile(playerData, THIS_CHARACTER_FILENAME)
endFunction

event OnDeath(Actor akKiller)
    Debug.Trace("Player died")
    int playerData = GetPlayerData()
    JMap.setInt(playerData, "dead", 1)
    SavePlayerData(playerData)
    ; Set the time that they died
endEvent

event OnPlayerLoadGame()
    Debug.Trace("Checking if Dead... " + IsDead)
    if IsPermadead
        Debug.QuitGame()
    elseIf IsDead
        FadeToBlackAndHold()
        RegisterForSingleUpdate(1.0)
        int yes = 0
        int no = 1
        Debug.Trace("Opening the dialog")
        int result = PermadeathResurrectionDialog.Show()
        if result == yes
            int playerData = GetPlayerData()
            JMap.setInt(playerData, "dead", 0)
            SavePlayerData(playerData)
            FadeFromBlack()
        else
            IsPermadead = true 
            GetActorReference().Kill()
            Game.QuitToMainMenu()
        endIf
    endIf
endEvent

bool property IsDead
    bool function get()
        int playerData = GetPlayerData()
        return JMap.getInt(playerData, "dead") == 1
    endFunction
endProperty

bool property IsPermadead
    bool function get()
        int playerData = GetPlayerData()
        return JMap.getInt(playerData, "permadead") == 1
    endFunction
    function set(bool value)
        int playerData = GetPlayerData()
        if value
            JMap.setInt(playerData, "permadead", 1)
        else
            JMap.setInt(playerData, "permadead", 0)
        endIf
        SavePlayerData(playerData)
    endFunction
endProperty

int function GetPlayerData()
    return JValue.readFromFile(THIS_CHARACTER_FILENAME)
endFunction

function SavePlayerData(int playerData)
    JValue.writeToFile(playerData, THIS_CHARACTER_FILENAME)
endFunction

; Fades the screen to black and holds it there.  Call FadeFromBlack() to reverse it.
Function FadeToBlackAndHold() global
    ImageSpaceModifier FadeToBlackImod = Game.GetFormFromFile(0x0f756d, "Skyrim.esm")\
        as ImageSpaceModifier
    ImageSpaceModifier FadeToBlackHoldImod = Game.GetFormFromFile(0x0f756e, "Skyrim.esm")\
        as ImageSpaceModifier
    FadeToBlackImod.Apply()
    Utility.Wait(2)
    FadeToBlackImod.PopTo(FadeToBlackHoldImod)
EndFunction

; Fades the screen from black back to normal.  Reverses the effects of FadeToBlackAndHold().
Function FadeFromBlack() global
    ImageSpaceModifier FadeToBlackHoldImod = Game.GetFormFromFile(0x0f756e, "Skyrim.esm")\
        as ImageSpaceModifier
    ImageSpaceModifier FadeToBlackBackImod = Game.GetFormFromFile(0x0f756f, "Skyrim.esm")\
        as ImageSpaceModifier
    Utility.Wait(2)
    FadeToBlackHoldImod.PopTo(FadeToBlackBackImod)
    FadeToBlackHoldImod.Remove()
EndFunction
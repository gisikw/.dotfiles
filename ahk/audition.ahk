#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2

; Bindings
.::AddMarker()
XButton1::DeleteSelectionAndJumpToNextMarker()
F5::PauseAudition()
$Esc::PauseAudition()
; NumpadSub::Suspend
CapsLock::Suspend
^!r::Reload

; WIP Bindings
Pause::SetAuditionSeconds(4025.2)
F11::AlertCurrentTimecode()
F9::GrabRoomTone()
; F10::TrimSilence()
F10::TryAutoUpdate()
F8::KeyboardLED(4, "Switch", 0)

TryAutoUpdate() {
  shell := ComObjCreate("WScript.Shell")
  launch := "cmd.exe /c git pull origin master > temp.txt"
  exec := shell.Run(launch, 0, true)
  FileDelete, temp.txt
  MsgBox Updating to latest script version
  Reload
}

; Todo
; - Shortcut display
; - Punch in recording:
;   - Pre-play and record
;   - Stop, copy, undo, paste, mark, de-select (remove duplicate marker)
; - Trim silence
;   - Open silence detection
;   - Scan
;   - When finished (try tabbing and copy-pasting? Detect when we can finally add to clipboard?)
;   - Select last timecode
;   - Set playhead to 100ms later
;   - Delete
;   - Select first timecode
;   - Move to end of selection (w)
;   - Set playhead to 100ms before
;   - Delete
;   - Return to effects rack
;   - (consider pasting in room tone)
; GetAuditionTimecode not reliable

TrimSilence() {
  WinGetText, OutputVar, a
  msgbox, %OutputVar%
  ; Send, {Esc}{Alt}sds
  ; Sleep, 100
  ; Send, {Tab 6}{Enter}
  ; MsgBox Close this dialog when silence is done scanning
  ; Send, +{Tab}{End}
  ; seconds := GetAuditionSeconds()
  ; MsgBox We want to do stuff with %seconds%
  ; Send, {Tab 6}{Ctrl Down}c{Ctrl Up}
  ; MsgBox %clipboard%
}

GrabRoomTone() {
  SetAuditionSeconds(2)
  ControlSend, DroverLord - Window Class20, {Ctrl Down}d{Ctrl Up}, Adobe Audition
  ControlSend, DroverLord - Window Class20, o, Adobe Audition
  ControlSend, DroverLord - Window Class20, {Ctrl Down}2c{CtrlUp}, Adobe Audition
  Sleep, 100
  SetAuditionSeconds(1)
  ControlSend, DroverLord - Window Class20, {Ctrl Down}d{Ctrl Up}, Adobe Audition
  ControlSend, DroverLord - Window Class20, o, Adobe Audition
  ControlSend, DroverLord - Window Class20, {Ctrl Down}3c{CtrlUp}, Adobe Audition
  Sleep, 100
  ControlSend, DroverLord - Window Class20, {Ctrl Down}1d{Ctrl Up}, Adobe Audition
  MsgBox Copied room tone to clipboards 2 and 3
}

GetAuditionTimecode() {
  Clipboard =
  ControlSend, DroverLord - Window Class20, {Alt Down}21{Alt Up}{Shift Down}{Tab}{Shift Up}, Adobe Audition
  Sleep, 100
  ControlSend, Edit2, {Ctrl Down}c{Ctrl Up}{Enter}{Tab}, Adobe Audition
  Return Clipboard
}

GetAuditionSeconds() {
  setformat, float, 0.3
  timecode := GetAuditionTimecode()
  StringSplit, Parts, timecode, :
  if (Parts0 = 3) {
    Seconds := (Parts1 * 3600) + (Parts2 * 60) + Parts3
    Return Seconds
  } else {
    Seconds := (Parts1 * 60) + Parts2
    Return Seconds
  }
}

SetAuditionTimecode(timecode) {
  Clipboard = %timecode%
  ControlSend, DroverLord - Window Class20, {Alt Down}21{Alt Up}{Shift Down}{Tab}{Shift Up}, Adobe Audition
  Sleep, 100
  ControlSend, Edit2, {Ctrl Down}v{Ctrl Up}{Enter}{Tab}, Adobe Audition
}

SetAuditionSeconds(seconds) {
  hours := floor(seconds / 3600)
  remainder := mod(seconds, 3600)
  minutes := floor(remainder / 60)
  seconds := mod(seconds, 60)
  seconds := floor(seconds * 1000)
  seconds := (seconds / 1000)
  timecode := hours . ":" . minutes . ":" . seconds
  SetAuditionTimecode(timecode)
}

DeleteSelectionAndJumpToNextMarker() {
  Send, {Del}{Home}^!{Right}
}

AlertCurrentTimecode() {
  time := GetAuditionSeconds()
  MsgBox %time%
}

AddMarker() {
  SoundBeep, 1200, 100
  ControlSend, DroverLord - Window Class20, {m}, Adobe Audition
}

PauseAudition() {
  SoundBeep, 200, 100
  ControlSend, DroverLord - Window Class20, {F12}, Adobe Audition
}

/*

    Keyboard LED control for AutoHotkey_L
        http://www.autohotkey.com/forum/viewtopic.php?p=468000#468000

    KeyboardLED(LEDvalue, "Cmd", Kbd)
        LEDvalue  - ScrollLock=1, NumLock=2, CapsLock=4
        Cmd       - on/off/switch
        Kbd       - index of keyboard (probably 0 or 2)

*/

KeyboardLED(LEDvalue, Cmd, Kbd=0)
{
  SetUnicodeStr(fn,"\Device\KeyBoardClass" Kbd)
  h_device:=NtCreateFile(fn,0+0x00000100+0x00000080+0x00100000,1,1,0x00000040+0x00000020,0)

  If Cmd= switch  ;switches every LED according to LEDvalue
   KeyLED:= LEDvalue
  If Cmd= on  ;forces all choosen LED's to ON (LEDvalue= 0 ->LED's according to keystate)
   KeyLED:= LEDvalue | (GetKeyState("ScrollLock", "T") + 2*GetKeyState("NumLock", "T") + 4*GetKeyState("CapsLock", "T"))
  If Cmd= off  ;forces all choosen LED's to OFF (LEDvalue= 0 ->LED's according to keystate)
    {
    LEDvalue:= LEDvalue ^ 7
    KeyLED:= LEDvalue & (GetKeyState("ScrollLock", "T") + 2*GetKeyState("NumLock", "T") + 4*GetKeyState("CapsLock", "T"))
    }

  success := DllCall( "DeviceIoControl"
              ,  "ptr", h_device
              , "uint", CTL_CODE( 0x0000000b     ; FILE_DEVICE_KEYBOARD
                        , 2
                        , 0             ; METHOD_BUFFERED
                        , 0  )          ; FILE_ANY_ACCESS
              , "int*", KeyLED << 16
              , "uint", 4
              ,  "ptr", 0
              , "uint", 0
              ,  "ptr*", output_actual
              ,  "ptr", 0 )

  NtCloseFile(h_device)
  return success
}

CTL_CODE( p_device_type, p_function, p_method, p_access )
{
  Return, ( p_device_type << 16 ) | ( p_access << 14 ) | ( p_function << 2 ) | p_method
}


NtCreateFile(ByRef wfilename,desiredaccess,sharemode,createdist,flags,fattribs)
{
  VarSetCapacity(objattrib,6*A_PtrSize,0)
  VarSetCapacity(io,2*A_PtrSize,0)
  VarSetCapacity(pus,2*A_PtrSize)
  DllCall("ntdll\RtlInitUnicodeString","ptr",&pus,"ptr",&wfilename)
  NumPut(6*A_PtrSize,objattrib,0)
  NumPut(&pus,objattrib,2*A_PtrSize)
  status:=DllCall("ntdll\ZwCreateFile","ptr*",fh,"UInt",desiredaccess,"ptr",&objattrib
                  ,"ptr",&io,"ptr",0,"UInt",fattribs,"UInt",sharemode,"UInt",createdist
                  ,"UInt",flags,"ptr",0,"UInt",0, "UInt")
  return % fh
}

NtCloseFile(handle)
{
  return DllCall("ntdll\ZwClose","ptr",handle)
}


SetUnicodeStr(ByRef out, str_)
{
  VarSetCapacity(out,2*StrPut(str_,"utf-16"))
  StrPut(str_,&out,"utf-16")
}

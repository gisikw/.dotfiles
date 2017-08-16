#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
SetTitleMatchMode, 2

; Bindings
.::AddMarker()
XButton1::DeleteSelectionAndJumpToNextMarker()
F5::PauseAudition()
$Esc::PauseAudition()
F10::AutoUpdate()
^`::Suspend
^!r::Reload
F1::AddQCMarker()
F2::JumpToPreviousMarker()

; WIP Bindings
Pause::SetAuditionSeconds(4025.2)
F11::AlertCurrentTimecode()
F9::GrabRoomTone()
; F10::TrimSilence()

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

AddQCMarker() {
  ControlSend, DroverLord - Window Class20, m, Adobe Audition
  InputBox, Label, Marker, Please enter a label, , , , , , , , QC Note
  if ErrorLevel {
    ControlSend, DroverLord - Window Class20, {Ctrl down}0{Ctrl up}, Adobe Audition
  } else {
    ControlSend, DroverLord - Window Class20, /, Adobe Audition
    ControlSend, Edit2, {Shift down}%Label%{Shift up}{Enter}, Adobe Audition
  }
}

JumpToPreviousMarker() {
  ControlSend, DroverLord - Window Class20, {Ctrl down}{Alt down}{Left}{Alt up}{Ctrl up}, Adobe Audition
}

AutoUpdate() {
  shell := ComObjCreate("WScript.Shell")
  launch := "cmd.exe /c git pull origin master > temp.txt"
  exec := shell.Run(launch, 0, true)
  FileDelete, temp.txt
  MsgBox Updating to latest script version
  Reload
}

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
  ControlSend, DroverLord - Window Class20, {Ctrl Down}{Shift Down}{Space}{Shift Up}{Ctrl Up}, Adobe Audition
}

#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

SetTitleMatchMode, 2

; Jump to first marker, centered on screen
XButton1::
  Send, {Del}
  Send, {Home}
  Send, ^!{Right}
Return

Pause::
  Send, {Space}
  Sleep, 100
  SoundBeep, 1200, 100
  ControlSend, DroverLord - Window Class20, ^c, Adobe Audition
  ControlSend, DroverLord - Window Class20, ^z, Adobe Audition
  ControlSend, DroverLord - Window Class20, ^v, Adobe Audition
Return

; Send a Marker command to Adobe Audition even while backgrounded
.::
 SoundBeep, 1200, 100
 ControlSend, DroverLord - Window Class20, {m}, Adobe Audition
Return

; Send a Pause command to Adobe Audition even while backgrounded
F5::
 SoundBeep, 200, 100
 ControlSend, DroverLord - Window Class20, {F12}, Adobe Audition
Return

Esc::
 SoundBeep, 200, 100
 ControlSend, DroverLord - Window Class20, {F12}, Adobe Audition
Return

; TODO: See if it's possible to merge these two commands (detect the scanning
; step is done)
F10::
  Send, {Esc}{Alt}sds
  Send, {Tab 6}{Enter}
Return

F11::
  Send, +{Tab}{End}

  ; FIXME
  ; Copy timecode, add 100 ms, paste timecode, enter
  Send, {Del}

  Send, {Home}

  ; FIXME
  ; Send, w ; Move playhead to end of selection
  ; Copy timecode, subtract 100 ms, paste timecode, enter
  Send, {Del}

  Send, !0
Return

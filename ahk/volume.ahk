#Warn,UseUnsetLocal
#NoEnv
#SingleInstance force
SetBatchLines,-1

SoundGet,Volume
Volume:=Round(Volume)
TrayTip:="Alt+LeftArrow or Alt+RightArrow to adjust volume" . "`nCurrent Volume=" . Volume
TrayIconFile:=A_WinDir . "\System32\DDORes.dll" ; get tray icon from DDORes.dll
TrayIconNum:="-2032" ; use headphones as tray icon (icon 2032 in DDORes)
Menu,Tray,Tip,%TrayTip%
Menu,Tray,Icon,%TrayIconFile%,%TrayIconNum%
Return

!PgDn::
SetTimer,SliderOff,1000
SoundSet,-1
Gosub,DisplaySlider
Return
!PgUp::
SetTimer,SliderOff,1000
SoundSet,+1
Gosub,DisplaySlider
Return

SliderOff:
Progress,Off
Return

DisplaySlider:
SoundGet,Volume
Volume:=Round(Volume)
MaxX := A_ScreenWidth - 310
MaxY := A_ScreenHeight - 150
Progress, b x%MaxX% y%MaxY%, %Volume%, Volume
Progress %Volume%
TrayTip:="Alt+LeftArrow or Alt+RightArrow to adjust volume" . "`nCurrent Volume=" . Volume
Menu,Tray,Tip,%TrayTip%
Return
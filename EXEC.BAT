echo off
tasm main.asm /t /zi
if errorlevel==1 goto fin
tlink main obj\pik obj\images obj\fonte obj\epic obj\titre obj\global/v
main
:fin

:vector3.sub  <a:vector3> <b:vector3> <result:vector3*>
for /F "tokens=1-6 delims= " %%A in ("%~1 %~2") do (
    set /a "_x=%%A-%%D, _y=%%B-%%E, _z=%%C-%%F"
    set "%~3=!_x! !_y! !_z!"
)
set "_x="
set "_y="
set "_Z="
exit /B

:vector3.norm  <a:vector3> <result:vector3*>
for /F "tokens=1-3 delims= " %%A in ("%~1") do (
    set /a "x=((%%A*%%A)>>8) + ((%%B*%%B)>>8) + ((%%C*%%C)>>8),b=%sqrt(x)%"
    if not "!b!" == "0" (
        set /a "a=%%A,_x=%div(a,b)%, a=%%B,_y=%div(a,b)%,a=%%C,_z=%div(a,b)%"
        set "%~2=!_x! !_y! !_z!"
    ) else set "%~2=0 0 0"
)
set "_x="
set "_y="
set "_z="
exit /B

:vector3.dot  <a:vector3> <b:vector3> <return:int*>
for /F "tokens=1-6 delims= " %%A in ("%~1 %~2") do (
    set /a "%~3=((%%A*%%D)>>8) + ((%%B*%%E)>>8) + ((%%C*%%F)>>8)"
)
exit /B

:vector3.cross  <a:vector3> <b:vector3> <return:vector3*>
for /F "tokens=1-6 delims= " %%A in ("%~1 %~2") do (
    set /a "_x=((%%B*%%F)>>8) - ((%%C*%%E)>>8), _y=((%%C*%%D)>>8) - ((%%A*%%F)>>8), _z=((%%A*%%E)>>8) - ((%%B*%%D)>>8)"
    set "%~3=!_x! !_y! !_z!"
)
set "_x="
set "_y="
set "_z="
exit /B

:vector3.trans  <vector:vector3> <translation:matrix4x4>
for /F "tokens=1-19 delims= " %%A in ("%~2 %~1") do (
    set /a "_x=((%%Q*%%A)>>8) + ((%%R*%%E)>>8) + ((%%S*%%I)>>8) + %%M"
    set /a "_y=((%%Q*%%B)>>8) + ((%%R*%%F)>>8) + ((%%S*%%J)>>8) + %%N"
    set /a "_z=((%%Q*%%C)>>8) + ((%%R*%%G)>>8) + ((%%S*%%K)>>8) + %%O"
    set "%~3=!_x! !_y! !_z!"
)
set "_x="
set "_y="
set "_z="
exit /B

:vector3.trans_w  <vector:vector3> <translation:matrix4x4>
for /F "tokens=1-19 delims= " %%A in ("%~2 %~1") do (
    set /a "b=((%%Q*%%D)>>8) + ((%%R*%%H)>>8) + ((%%S*%%L)>>8) + %%P"
    set /a "a=((%%Q*%%A)>>8) + ((%%R*%%E)>>8) + ((%%S*%%I)>>8) + %%M, _x=%div(a,b)%"
    set /a "a=((%%Q*%%B)>>8) + ((%%R*%%F)>>8) + ((%%S*%%J)>>8) + %%N, _y=%div(a,b)%"
    set /a "a=((%%Q*%%C)>>8) + ((%%R*%%G)>>8) + ((%%S*%%K)>>8) + %%O, _z=%div(a,b)%"
    set "%~3=!_x! !_y! !_z!"
)
set "_x="
set "_y="
set "_z="
exit /B

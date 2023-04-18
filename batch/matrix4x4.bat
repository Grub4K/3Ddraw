:matrix4x4.mul  <a:matrix4x4> <b:matrix4x4> <result:matrix4x4*>
for /F "tokens=1-16 delims= " %%a in ("%~1") do (
    for /F "tokens=1-16 delims= " %%A in ("%~2") do (
        set /a "_a=((%%a*%%A)>>8) + ((%%b*%%E)>>8) + ((%%c*%%I)>>8) + ((%%d*%%M)>>8)"
        set /a "_b=((%%a*%%B)>>8) + ((%%b*%%F)>>8) + ((%%c*%%J)>>8) + ((%%d*%%N)>>8)"
        set /a "_c=((%%a*%%C)>>8) + ((%%b*%%G)>>8) + ((%%c*%%K)>>8) + ((%%d*%%O)>>8)"
        set /a "_d=((%%a*%%D)>>8) + ((%%b*%%H)>>8) + ((%%c*%%L)>>8) + ((%%d*%%P)>>8)"
        set /a "_e=((%%e*%%A)>>8) + ((%%f*%%E)>>8) + ((%%g*%%I)>>8) + ((%%h*%%M)>>8)"
        set /a "_f=((%%e*%%B)>>8) + ((%%f*%%F)>>8) + ((%%g*%%J)>>8) + ((%%h*%%N)>>8)"
        set /a "_g=((%%e*%%C)>>8) + ((%%f*%%G)>>8) + ((%%g*%%K)>>8) + ((%%h*%%O)>>8)"
        set /a "_h=((%%e*%%D)>>8) + ((%%f*%%H)>>8) + ((%%g*%%L)>>8) + ((%%h*%%P)>>8)"
        set /a "_i=((%%i*%%A)>>8) + ((%%j*%%E)>>8) + ((%%k*%%I)>>8) + ((%%l*%%M)>>8)"
        set /a "_j=((%%i*%%B)>>8) + ((%%j*%%F)>>8) + ((%%k*%%J)>>8) + ((%%l*%%N)>>8)"
        set /a "_k=((%%i*%%C)>>8) + ((%%j*%%G)>>8) + ((%%k*%%K)>>8) + ((%%l*%%O)>>8)"
        set /a "_l=((%%i*%%D)>>8) + ((%%j*%%H)>>8) + ((%%k*%%L)>>8) + ((%%l*%%P)>>8)"
        set /a "_m=((%%m*%%A)>>8) + ((%%n*%%E)>>8) + ((%%o*%%I)>>8) + ((%%p*%%M)>>8)"
        set /a "_n=((%%m*%%B)>>8) + ((%%n*%%F)>>8) + ((%%o*%%J)>>8) + ((%%p*%%N)>>8)"
        set /a "_o=((%%m*%%C)>>8) + ((%%n*%%G)>>8) + ((%%o*%%K)>>8) + ((%%p*%%O)>>8)"
        set /a "_p=((%%m*%%D)>>8) + ((%%n*%%H)>>8) + ((%%o*%%L)>>8) + ((%%p*%%P)>>8)"
    )
)
set "%~3=!_a! !_b! !_c! !_d! !_e! !_f! !_g! !_h! !_i! !_j! !_k! !_l! !_m! !_n! !_o! !_p!"
set "_a="
set "_b="
set "_c="
set "_d="
set "_e="
set "_f="
set "_g="
set "_h="
set "_i="
set "_j="
set "_k="
set "_l="
set "_m="
set "_n="
set "_o="
set "_p="
exit /B

:matrix4x4.look_at_rh  <eye:matrix4x4> <target:matrix4x4> <up:vector3> <view:matrix4x4*>
call :vector3.sub "%~1" "%~2" z_axis
call :vector3.norm "!z_axis!" z_axis

call :vector3.cross "%~3" "!z_axis!" x_axis
call :vector3.norm "!x_axis!" x_axis

call :vector3.cross "!z_axis!" "!x_axis!" y_axis
call :vector3.norm "!y_axis!" y_axis

:: negate eye vector
call :vector3.sub "0 0 0" "%~1" eye

call :vector3.dot "!x_axis!" "!eye!" ex
call :vector3.dot "!y_axis!" "!eye!" ey
call :vector3.dot "!z_axis!" "!eye!" ez

for /F "tokens=1-12 delims= " %%A in ("!x_axis! !y_axis! !z_axis! !ex! !ey! !ez!") do (
    set "%~4=%%A %%D %%G 0 %%B %%E %%H 0 %%C %%F %%I 0 %%J %%K %%L 256"
)
set "x_axis="
set "y_axis="
set "z_axis="
set "eye="
set "ex="
set "ey="
set "ez="
exit /B

:matrix4x4.perspective_fov_rh  <fov:num> <aspect:num> <z_near:num> <z_far:num> <result:matrix4x4*>
:: HACK: In order to not implement tan, we hardcode the 1/tan(0.78/2) as 623
set /a "a=height=623, b=%~2, width=%div(a,b)%, b=%~3-%~4, a=%~4, f_range=%div(a,b)%, a=(f_range*%~3)>>8"
set "%~5=!width! 0 0 0 0 !height! 0 0 0 0 !f_range! -256 0 0 !a! 0"
set "a="
set "b="
set "width="
set "height="
set "f_range="
exit /B

:matrix4x4.trans  <point:vector3> <result:matrix4x4*>
set "%~2=256 0 0 0 0 256 0 0 0 0 256 0 %~1 256"
exit /B

:matrix4x4.rot_x  <angle:int> <result:matrix4x4>
set /a "x=%~1, s=%sin(x)%"
set /a "x=%~1, c=%cos(x)%"
set "%~2=256 0 0 0 0 !c! !s! 0 0 -!s! !c! 0 0 0 0 256"
exit /B

:matrix4x4.rot_y  <angle:int> <result:matrix4x4>
set /a "x=%~1, s=%sin(x)%"
set /a "x=%~1, c=%cos(x)%"
set "%~2=!c! 0 -!s! 0 0 256 0 0 !s! 0 !c! 0 0 0 0 256"
exit /B

:matrix4x4.rot_z  <angle:int> <result:matrix4x4>
set /a "x=%~1, s=%sin(x)%"
set /a "x=%~1, c=%cos(x)%"
set "%~2=!c! !s! 0 0 -!s! !c! 0 0 0 0 256 0 0 0 0 256"
exit /B

:matrix4x4.yaw_pitch_roll  <yaw:int> <pitch:int> <roll:int> <result:matrix4x4*>
call :matrix4x4.rot_x %~2 %~4
call :matrix4x4.rot_y %~3 rot_temp
call :matrix4x4.mul "!%~4!" "!rot_temp!" %~4
call :matrix4x4.rot_z %~1 rot_temp
call :matrix4x4.mul "!rot_temp!" "!%~4!" %~4
set "rot_temp="
exit /B

:vector3.sub
:vector3.norm
:vector3.cross
:vector3.dot
vector3.bat %*

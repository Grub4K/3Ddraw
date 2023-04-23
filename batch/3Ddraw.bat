@echo off
setlocal
set /a "res_x=40, res_y=30"
:: set /a "res_x=100, res_y=75"

setlocal disableDelayedExpansion

set ^"\n=^
%= These lines are required =%
^" do not remove
set ^"LF=^^^%\n%%\n%^%\n%%\n%^^"

call :renderer.setup

setlocal enableDelayedExpansion
call :renderer.setup_delayed


:: Some math functions for fixed points with radix 8
set "abs(x)=((x>>31|1)*x)"
set "div(a,b)=((a<<8)/b)"

set "sqrt(x)=(a=x,b=x*128>>8"
for /L %%a in (1 1 10) do (
    set "sqrt(x)=!sqrt(x)!,b=((b+((a<<8)/b))*128>>8)"
)
set "sqrt(x)=!sqrt(x)!,b)"

set "cos(x)=a=(x / 402) %% 4, x=x %% 402"
set "cos(x)=%cos(x)%, x=(a&1) * (402-x) + ((a&1)^1) * x"
set "cos(x)=%cos(x)%, x=(x*x>>8), ((((a^(a>>1))&1)<<1)-1) * (256 - ((x*128)>>8) + (((x*x)>>8)*11>>8))"
set "sin(x)=(x-=402, %cos(x)%)"
set "cos(x)=(%cos(x)%)"

:: Once per aspect ratio change
call :matrix4x4.perspective_fov_rh 200 341 3 256 projection
echo %projection%

:: once per camera move
call :matrix4x4.look_at_rh "0 0 2560" "0 0 0" "0 256 0" view
call :matrix4x4.mul "!view!" "!projection!" view
echo %view%

set /a "__x=0, __y=0, yaw=200, pitch=300"

for /L %%. in () do (
    set /a "yaw+=10, pitch+=15"

    call :matrix4x4.trans "!__x! !__y! 0" world
    echo %world%
    call :matrix4x4.yaw_pitch_roll !yaw! !pitch! 0 rotation
    echo %rotation%
    call :matrix4x4.mul "!world!" "!rotation!" world
    echo %world%

    call :matrix4x4.mul "!world!" "!view!" transform
    echo %transform%

    set /a "counter=0"
    for %%# in (
        "-256 256 256"
        "256 256 256"
        "-256 -256 256"
        "256 -256 256"
        "-256 256 -256"
        "256 256 -256"
        "256 -256 -256"
        "-256 -256 -256"
    ) do (
        call :renderer.project "%%~#" "!transform!" point[!counter!]
        set /a "counter+=1"
    )
    set /a "counter-=1"
    for %%# in (
        "0 1 2"
        "1 2 3"
        "1 3 6"
        "1 5 6"
        "0 1 4"
        "1 4 5"
        "2 3 7"
        "3 6 7"
        "0 2 7"
        "0 4 7"
        "4 5 6"
        "4 6 7"
    ) do for /F "tokens=1-3 delims= " %%A in ("%%~#") do (
        call :renderer.draw_line  !point[%%A]! !point[%%B]! . 255 255 000
        call :renderer.draw_line  !point[%%B]! !point[%%C]! . 255 255 000
        call :renderer.draw_line  !point[%%C]! !point[%%A]! . 255 255 000
    )
    for /L %%@ in (0 1 !counter!) do (
        %@renderer.put_pixel% !point[%%@]! # 000 000 255
        set "point[%%@]="
    )
    %@renderer.draw%

    choice /c:wasdqe /t:1 /d:e
    if not errorlevel 6 (
        if errorlevel 5 (
            exit
        ) else if errorlevel 4 (
            set /a "__x+=20"
        ) else if errorlevel 3 (
            set /a "__y+=20"
        ) else if errorlevel 2 (
            set /a "__x-=20"
        ) else if errorlevel 1 (
            set /a "__y-=20"
        )
    )
)
exit /B

:matrix4x4.perspective_fov_rh
:matrix4x4.yaw_pitch_roll
:matrix4x4.look_at_rh
:matrix4x4.trans
:matrix4x4.mul
matrix4x4.bat %*

:renderer.setup
:renderer.setup_delayed
:renderer.project
:renderer.draw_line
renderer.bat %*

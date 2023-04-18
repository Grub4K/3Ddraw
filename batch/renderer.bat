:renderer.setup
set @renderer.put_pixel=for %%# in (1 2) do if %%#==2 (%LF%
    for /F "tokens=1-5" %%1 in ("!args!") do (%LF%
        if %%1 GEQ 0 if %%1 lss !res_x! (%LF%
            if %%2 GEQ 0 if %%2 lss !res_y! (%LF%
                set /a "start=%%2*(%res_x%+1)+%%1, end=start+1"%LF%
                for /f "tokens=1-2" %%6 in ("!start! !end!") do (%LF%
                    set "renderer.buffer=!renderer.buffer:~0,%%6!%%3!renderer.buffer:~%%7!"%LF%
                )%LF%
            )%LF%
        )%LF%
    )%LF%
) else set args=

exit /B

:renderer.setup_delayed
for /F "tokens=1 delims==" %%a in ('set "@"') do (
    set "%%a=!%%a:    =!"
)

set "c="
for /L %%a in (1 1 %res_x%) do set "c=!c! "
for /L %%a in (1 1 %res_y%) do set "renderer.clear_line=!renderer.clear_line!!c!!\n!"
set "c="

set "renderer.buffer=!renderer.clear_line!"

set "@renderer.draw=cls & echo(^!renderer.buffer^! & set renderer.buffer=^!renderer.clear_line^!"

exit /B

:renderer.draw_line  <start_x:int> <start_y:int> <end_x:int> <end_y:int> <r:int> <g:int> <b:int>
set /a "x=%~1 - %~3, dx=%abs(x)%"
set /a "x=%~2 - %~4, dy=%abs(x)%"
set /a "x=%~1, y=%~2"

if %~1 lss %~3 (
    set "sx=1"
) else set "sx=-1"

if %~2 lss %~4 (
    set "sy=1"
) else set "sy=-1"

if !dy! gtr !dx! (
    set /a "max=dy"
) else set /a "max=dx"

set /a "threshold=dx-dy, dy=-dy"

for /L %%. in (1 1 !max!) do (
    %@renderer.put_pixel% !x! !y! %~5 %~6 %~7

    set /a "error=2*threshold"
    if !error! gtr !dy! (
        set /a "threshold+=dy, x+=sx"
    )
    if !error! lss !dx! (
        set /a "threshold+=dx, y+=sy"
    )
)
exit /B

:renderer.project  <vertex:vector3> <transformation:matrix4x4> <result:(int, int)*>
call :vector3.trans_w "%~1" "%~2" %~3
for /F "tokens=1,2 delims= " %%A in ("!%~3!") do (
    set /a "_x=((%%A*res_x)>>8) + res_x/2, _y=((-%%B*res_y)>>8) + res_y/2"
)
set "%~3=!_x! !_y!"
set "_x="
set "_y="
exit /B

:vector3.trans_w %*
vector3.bat %*

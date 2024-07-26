@echo off
setlocal enabledelayedexpansion

if not exist calc.exe title ERROR&echo This script requires calc.exe ^(https://cmdlinecalc.sourceforge.io/^) to work&pause&exit


:go_back
cls
title Simple Batch DC cirucit solver by leov30
echo Select DC circuit to solve
echo ------------------------------
echo:
echo 1. Parallel
echo 2. Series
echo:
set /p _opt="Enter Option: "

if "%_opt%"=="1" (set _opt=parallel
)else if "%_opt%"=="2" (set _opt=serie
)else goto :go_back

echo:
set /p "_n=How many resistance are in %_opt%?: " || goto :go_back
if "%_n%"=="0" goto :go_back
cls

rem // *********** alternative input 1 *********************
rem // user will need to un-comment the lines depending on the input method to use


echo Enter Total ^(Source^)&echo ----------------------
set /p "_rt=R (Ohms): " || set _rt=0
set /p "_vt=V (V): " || set _vt=0

set /p "_tmp=I (mA): " || set _tmp=0
for /f %%h in ('calc !_tmp!*0.001') do set _it=%%h

set /p "_tmp=P (mW): " || set _tmp=0
for /f %%h in ('calc !_tmp!*0.001') do set _pt=%%h

cls
for /l %%g in (1,1,%_n%) do (
	echo:&echo #%%g Resistance&echo ----------------------
	set /p "_r%%g=R (Ohms): " || set _r%%g=0
	set /p "_v%%g=V (V): " || set _v%%g=0
	
	set /p "_tmp=I (mA): " || set _tmp=0
	for /f %%h in ('calc !_tmp!*0.001') do set _i%%g=%%h
	
	set /p "_tmp=P (W): " || set _tmp=0
	for /f %%h in ('calc !_tmp!*0.001') do set _p%%g=%%h
)


rem // *********** alternative input method 2 **********************

REM echo:&echo Enter Resistance ^(Ohms^)
REM echo ---------------------
REM set /p "_rt=Total: " || set _rt=0
REM for /l %%g in (1,1,%_n%) do set /p "_r%%g=R%%g: " || set _r%%g=0

REM echo:&echo Enter Voltage ^(Volts^)
REM echo ---------------------
REM set /p "_vt=Total: " || set _vt=0
REM for /l %%g in (1,1,%_n%) do set /p "_v%%g=V%%g: " || set _v%%g=0

REM echo:&echo Enter Current ^(milli-Amp^)
REM echo ---------------------
REM set /p "_it=Total: " || set _it=0
REM for /f %%h in ('calc %_it%*0.001') do set _it=%%h

REM for /l %%g in (1,1,%_n%) do (
	REM set /p "_tmp=I%%g: " || set _tmp=0
	REM for /f %%h in ('calc !_tmp!*0.001') do set _i%%g=%%h
REM )

REM echo:&echo Enter Power ^(milli-Watts^)
REM echo ---------------------
REM set /p "_pt=Total: " || set _pt=0
REM for /f %%h in ('calc %_pt%*0.001') do set _pt=%%h

REM for /l %%g in (1,1,%_n%) do (
	REM set /p "_tmp=P%%g: " || set _tmp=0
	REM for /f %%h in ('calc !_tmp!*0.001') do set _p%%g=%%h
	
REM )



set _xr=0&set _xv=0&set _xv=0&set _xi=0&set _xp=0
set _loop=0
:loop

set _y=0

if !_xr! equ 0 (
	set _xr=1
	for /l %%g in (1,1,%_n%) do if "!_r%%g!"=="0" set _xr=0&set _y=1
	if "!_rt!"=="0" set _xr=0&set _y=1
)

if !_xv! equ 0 (
	set _xv=1
	for /l %%g in (1,1,%_n%) do if "!_v%%g!"=="0" set _xv=0&set _y=1
	if "!_vt!"=="0" set _xv=0&set _y=1
)

if !_xi! equ 0 (
	set _xi=1
	for /l %%g in (1,1,%_n%) do if "!_i%%g!"=="0" set _xi=0&set _y=1
	if "!_it!"=="0" set _xi=0&set _y=1
)

if !_xp! equ 0 (
	set _xp=1
	for /l %%g in (1,1,%_n%) do if "!_p%%g!"=="0" set _xp=0&set _y=1
	if "!_pt!"=="0" set _xp=0&set _y=1
)

if !_xi! equ 0 call :get_i
if !_xv! equ 0 call :get_v
if !_xr! equ 0 call :get_r
if !_xp! equ 0 call :get_p


REM set _y=0
REM for /l %%g in (1,1,%_n%) do if "!_r%%g!"=="0" call :get_r & set /a _y+=1
REM for /l %%g in (1,1,%_n%) do if "!_i%%g!"=="0" call :get_i & set /a _y+=1

REM for /l %%g in (1,1,%_n%) do if "!_v%%g!"=="0" call :get_v & set /a _y+=1
REM for /l %%g in (1,1,%_n%) do if "!_p%%g!"=="0" call :get_p & set /a _y+=1


REM if "!_rt!"=="0" call :get_r & set /a _y+=1
REM if "!_it!"=="0" call :get_i & set /a _y+=1
REM if "!_vt!"=="0" call :get_v & set /a _y+=1
REM if "!_pt!"=="0" call :get_p & set /a _y+=1

set /a _loop+=1

	REM echo !_xv!
	echo       	Ohms	^|	Volts	^|	mAmps	^|	mWatts
	echo       	-------------------------------------------------------------------------------
	for /l %%g in (1,1,%_n%) do echo Re__%%g:	!_r%%g!	^|	!_v%%g!	^|	!_i%%g!	^|	!_p%%g!
	echo       	-------------------------------------------------------------------------------
	echo Total:	!_rt!	^|	!_vt!	^|	!_it!	^|	!_pt!
	echo:

if !_loop! geq 5 title ERROR&echo Cant find a solution&pause&goto :go_back
if %_y% neq 0 goto :loop

cls
for /f %%h in ('calc !_it!*1000') do set _it=%%h
for /f %%h in ('calc !_pt!*1000') do set _pt=%%h

(echo ;Ohms;Volts;mAmps;mWatts)>output.csv 

for /l %%g in (1,1,%_n%) do (
	for /f %%h in ('calc !_i%%g!*1000') do set _i%%g=%%h
	for /f %%h in ('calc !_p%%g!*1000') do set _p%%g=%%h
	
	(echo R%%g;!_r%%g!;!_v%%g!;!_i%%g!;!_p%%g!)>>output.csv


)

(echo Total;%_rt%;%_vt%;%_it%;%_pt%) >>output.csv

call :option_view 3

:menu_view
call :check_error
echo:
echo ==========================
echo 1. Do another one
echo 2. Table view
echo 3. List view
echo 4. List view alt
echo 5. Exit
echo:
choice /m "Select Option: " /c:12345
if %errorlevel% equ 1 goto :go_back
if %errorlevel% equ 2 call :option_view 1
if %errorlevel% equ 3 call :option_view 2
if %errorlevel% equ 4 call :option_view 3
if %errorlevel% equ 5 exit

goto :menu_view


rem // ------------------------- end  of script --------------------------------------------

:option_view
cls

if %1 equ 1 (
	echo       	Ohms	^|	Volts	^|	mAmps	^|	mWatts
	echo       	-------------------------------------------------------------------------------
	for /l %%g in (1,1,%_n%) do echo Re__%%g:	!_r%%g!	^|	!_v%%g!	^|	!_i%%g!	^|	!_p%%g!
	echo       	-------------------------------------------------------------------------------
	echo Total:	!_rt!	^|	!_vt!	^|	!_it!	^|	!_pt!
)



if %1 equ 2 (
	echo:&echo Resistance&echo -----------------
	for /l %%g in (1,1,%_n%) do echo R_%%g: !_r%%g! Ohms
	echo Total: !_rt! Ohms&echo:
	
	echo:&echo Voltage&echo -----------------
	for /l %%g in (1,1,%_n%) do echo V_%%g: !_v%%g! V
	echo Total: !_vt! V&echo:

	echo:&echo Current&echo -----------------
	for /l %%g in (1,1,%_n%) do echo I_%%g: !_i%%g! mA
	echo Total: !_it! mA&echo:

	echo:&echo Power&echo -----------------
	for /l %%g in (1,1,%_n%) do echo P_%%g: !_p%%g! mW
	echo Total: !_pt! mW&echo:
	
)

if %1 equ 3 (
	echo:&echo Totals:&echo ------------------
	echo !_rt! Ohms
	echo !_vt! V
	echo !_it! mA
	echo !_pt! mW

	for /l %%g in (1,1,%_n%) do (
		echo:&echo Re_%%g:&echo ------------------
		echo !_r%%g! Ohms
		echo !_v%%g! V
		echo !_i%%g! mA
		echo !_p%%g! mW
	)

)

exit /b



:check_error
echo:
rem //power sum
set _sum=0
for /l %%g in (1,1,%_n%) do for /f %%h in ('calc !_p%%g!+!_sum!') do set _sum=%%h
if not "!_pt!"=="!_sum!" echo ERROR: Total power and sum dind't match: !_pt! = !_sum!

if %_opt%==serie (
	rem //voltage sum
	set _sum=0
	for /l %%g in (1,1,%_n%) do for /f %%h in ('calc !_v%%g!+!_sum!') do set _sum=%%h
	if not "!_vt!"=="!_sum!" echo ERROR: Total voltage and sum dind't match: !_vt! = !_sum!
	
	for /l %%g in (1,1,%_n%) do if not "!_i%%g!"=="!_it!" echo ERROR: Total current didn't match: !_i%%g! = !_it!

)

if %_opt%==parallel (
	rem //current sum
	set _sum=0
	for /l %%g in (1,1,%_n%) do for /f %%h in ('calc !_i%%g!+!_sum!') do set _sum=%%h
	if not "!_it!"=="!_sum!" echo ERROR: Total current and sum dind't match: !_it! = !_sum!
	
	for /l %%g in (1,1,%_n%) do if not "!_v%%g!"=="!_vt!" echo ERROR: Total voltage didn't match: !_v%%g! = !_vt!

)

exit /b

:get_i

rem //all current should be the same in series, wont check for miss match

for /l %%g in (1,1,%_n%) do (
	if "!_i%%g!"=="0" (
		if not "!_v%%g!"=="0" if not "!_r%%g!"=="0" for /f %%h in ('calc !_v%%g!/!_r%%g!') do set _i%%g=%%h
		if not "!_p%%g!"=="0" if not "!_v%%g!"=="0" for /f %%h in ('calc !_p%%g!/!_v%%g!') do set _i%%g=%%h
		if not "!_p%%g!"=="0" if not "!_r%%g!"=="0" for /f %%h in ('calc sqrt^(!_p%%g!/!_r%%g!^)') do set _i%%g=%%h
	)
)

rem //total
if "!_it!"=="0" (
	if not "!_vt!"=="0" if not "!_rt!"=="0" for /f %%h in ('calc !_vt!/!_rt!') do set _it=%%h
	if not "!_pt!"=="0" if not "!_vt!"=="0" for /f %%h in ('calc !_pt!/!_vt!') do set _it=%%h
	if not "!_pt!"=="0" if not "!_rt!"=="0" for /f %%h in ('calc sqrt^(!_pt!/!_rt!^)') do set _it=%%h
)
	
	
rem //if i total still not known in series, get it from any resistance
if %_opt%==serie if "!_it!"=="0" for /l %%g in (1,1,%_n%) do if not "!_i%%g!"=="0" set _it=!_i%%g!


rem //fill in table for series for a known i total
if %_opt%==serie if not "!_it!"=="0" for /l %%g in (1,1,%_n%) do set _i%%g=%_it%

rem //test for unkonws, use voltage divider for series
set _x=0&set _index=0
for /l %%g in (1,1,%_n%) do if "!_i%%g!"=="0" (
	set /a _x+=1
	set _index=%%g
)


rem //fine one missing current value in parallel
set _sum=0
if %_opt%==parallel if not "%_it%"=="0" if not "%_rt%"=="0" if %_x% equ 1 if !_r%_index%! neq 0 (
	for /l %%g in (1,1,%_n%) do for /f %%h in ('calc !_it!*!_rt!/!_r%_index%!') do set _i!_index!=%%h
	set _x=0
)

rem //fine one missing current  value in parallel
set _sum=0
if %_opt%==parallel if not "%_it%"=="0" if %_x% equ 1 (
	for /l %%g in (1,1,%_n%) do for /f %%h in ('calc !_i%%g!+!_sum!') do set _sum=%%h
	for /f %%g in ('calc !_it!-!_sum!') do set _i!_index!=%%g
	set _x=0
)


rem // for total current not known in parallel, add all branches currrents
if %_opt%==parallel if "!_it!"=="0" if !_x! equ 0 (
	for /l %%g in (1,1,%_n%) do for /f %%h in ('calc !_i%%g!+!_it!') do set _it=%%h

)

exit /b

:get_p

for /l %%g in (1,1,%_n%) do (
	if "!_p%%g!"=="0" (
		if not "!_v%%g!"=="0" if not "!_i%%g!"=="0" for /f %%h in ('calc !_v%%g!*!_i%%g!') do set _p%%g=%%h
		if not "!_i%%g!"=="0" if not "!_r%%g!"=="0" for /f %%h in ('calc !_i%%g!*!_i%%g!*!_r%%g!') do set _p%%g=%%h
		if not "!_v%%g!"=="0" if not "!_r%%g!"=="0" for /f %%h in ('calc !_v%%g!*!_v%%g!/!_r%%g!') do set _p%%g=%%h
	)
)

rem //total
if "!_pt!"=="0" (
	if not "!_vt!"=="0" if not "!_it!"=="0" for /f %%h in ('calc !_vt!*!_it!') do set _pt=%%h
	if not "!_it!"=="0" if not "!_rt!"=="0" for /f %%h in ('calc !_it!*!_it!*!_rt!') do set _pt=%%h
	if not "!_vt!"=="0" if not "!_rt!"=="0" for /f %%h in ('calc !_vt!*!_vt!/!_rt!') do set _pt=%%h
)


rem // WIP find one missng power values *************

rem //test for unkonws
for /l %%g in (1,1,%_n%) do if "!_p%%g!"=="0" exit /b

rem //sum all powers
if "!_pt!"=="0" (
	for /l %%g in (1,1,%_n%) do (		
			for /f %%h in ('calc !_p%%g!+!_pt!') do set _pt=%%h
	)
)

exit /b

:get_r

rem //calculate unknown resistance

for /l %%g in (1,1,%_n%) do (
	if "!_r%%g!"=="0" (
		
		if not "!_v%%g!"=="0" if not "!_i%%g!"=="0" for /f %%h in ('calc !_v%%g!/!_i%%g!') do set _r%%g=%%h
		if not "!_v%%g!"=="0" if not "!_p%%g!"=="0" for /f %%h in ('calc !_v%%g!*!_v%%g!/!_p%%g!') do set _r%%g=%%h
		if not "!_p%%g!"=="0" if not "!_i%%g!"=="0" for /f %%h in ('calc !_p%%g!/^(!_i%%g!*!_i%%g!^)') do set _r%%g=%%h	
	)
)

rem //total
if "!_rt!"=="0" (
	if not "!_vt!"=="0" if not "!_it!"=="0" for /f %%h in ('calc !_vt!/!_it!') do set _rt=%%h
	if not "!_vt!"=="0" if not "!_pt!"=="0" for /f %%h in ('calc !_vt!*!_vt!/!_pt!') do set _rt=%%h
	if not "!_pt!"=="0" if not "!_it!"=="0" for /f %%h in ('calc !_pt!/^(!_it!*!_it!^)') do set _rt=%%h	
)



rem //test for unkonws
set _x=0&set _index=0
for /l %%g in (1,1,%_n%) do (
	if "!_r%%g!"=="0" (
		set /a _x+=1
		set _index=%%g
	)
)


rem //******** WIP find one missing resistance in parallel

rem // find one missing resistance in series if rt its known
set _sum=0
if %_opt%==serie if %_x% equ 1 if not "%_rt%"=="0" (
	for /l %%g in (1,1,%_n%) do for /f %%h in ('calc !_r%%g!+!_sum!') do set _sum=%%h
	for /f %%g in ('calc !_rt!-!_sum!') do set _r!_index!=%%g
	set _x=0
)

rem //total resistance already known
if not "!_rt!"=="0" exit /b
if %_x% neq 0 exit /b

rem //total resistance when all values are known

rem //series
if %_opt%==serie (
	for /l %%g in (1,1,%_n%) do (		
			for /f %%h in ('calc !_r%%g!+!_rt!') do set _rt=%%h
	)
)


rem //parallel
set _sum=0
if %_opt%==parallel (
	for /l %%g in (1,1,%_n%) do (		
			for /f %%h in ('calc 1/!_r%%g!+!_sum!') do set _sum=%%h
	)
	for /f %%h in ('calc 1/!_sum!') do set _rt=%%h
)

exit /b

:get_v

rem //all voltages should be the same in parallel, wont check for missmatch

for /l %%g in (1,1,%_n%) do (
	if "!_v%%g!"=="0" (
		if not "!_r%%g!"=="0" if not "!_i%%g!"=="0" for /f %%h in ('calc !_r%%g!*!_i%%g!') do set _v%%g=%%h
		if not "!_p%%g!"=="0" if not "!_i%%g!"=="0" for /f %%h in ('calc !_p%%g!/!_i%%g!') do set _v%%g=%%h
		if not "!_p%%g!"=="0" if not "!_r%%g!"=="0" for /f %%h in ('calc sqrt^(!_p%%g!*!_r%%g!^)') do set _v%%g=%%h
	)
)

if "%_vt%"=="0" (
	if not "%_rt%"=="0" if not "%_it%"=="0" for /f %%h in ('calc %_rt%*%_it%') do set _vt=%%h
	if not "%_pt%"=="0" if not "%_it%"=="0" for /f %%h in ('calc %_pt%/%_it%') do set _vt=%%h
	if not "%_pt%"=="0" if not "%_rt%"=="0" for /f %%h in ('calc sqrt^(!_pt!*!_rt!^)') do set _vt=%%h
)

rem //get total voltage from any known voltage, in parallel
if %_opt%==parallel if "%_vt%"=="0" for /l %%g in (1,1,%_n%) do if not "!_v%%g!"=="0" set _vt=!_v%%g!

rem //fill in table for parallel for a known total voltage
if %_opt%==parallel if not "%_vt%"=="0" for /l %%g in (1,1,%_n%) do set _v%%g=%_vt%

rem //test for unkonws, use voltage divider for series
set _x=0&set _index=0
for /l %%g in (1,1,%_n%) do if "!_v%%g!"=="0" (
	set /a _x+=1
	set _index=%%g
)

rem // for vt not known in series, add all voltages
if %_opt%==serie if "!_vt!"=="0" if %_x% equ 0 (
	for /l %%g in (1,1,%_n%) do for /f %%h in ('calc !_v%%g!+!_vt!') do set _vt=%%h

)

rem //fine one missing voltage value in series
set _sum=0
if %_opt%==serie if not "%_vt%"=="0" if not "%_rt%"=="0" if %_x% equ 1 if !_r%_index%! neq 0 (
	for /l %%g in (1,1,%_n%) do for /f %%h in ('calc !_vt!*!_r%_index%!/!_rt!') do set _v!_index!=%%h
	set _x=0
)

rem //fine one missing voltage value in series
set _sum=0
if %_opt%==serie if not "%_vt%"=="0" if %_x% equ 1 (
	for /l %%g in (1,1,%_n%) do for /f %%h in ('calc !_v%%g!+!_sum!') do set _sum=%%h
	for /f %%g in ('calc !_vt!-!_sum!') do set _v!_index!=%%g
	set _x=0
)


exit /b




@ECHO OFF
REM Configuration des variable
REM Dossier où se trouve le script
SET SOURCESCRIPT=F:\Script copy
REM Dosser de téléchargement Android
SET DLANDROID=F:\AndroidDL\downloads
REM Dosier de téléchargement HDDownloader
SET DLHDDOWNLOADER=F:\1. Manga
REM Lettre de lecteur Colva
SET COLVA=Z:\
REM Lettre de lecteur Anjuna
SET ANJUNA=U:\
REM Dossier Telecharge
SET DL=Telecharge
REM Dossier Fini
SET FINI=Series_Finis
REM BD trié
SET BDTRIE=BD_Trie
REM Dossier A_preparer
SET APREP=A_preparer
REM Dossier Adulte Long
SET FINIADULTLONG=Adulte Long
REM Dossier Adulte Short
SET FINIADULTSHORT=Adulte Short
REM Dossier BD fini
SET FINIBD=BD
REM Dossier Manga fini
SET FINIMANGA=Manga
REM Dossier Manhua fini
SET FINIMANHUA=Manhua
REM Dossier Manwha fini
SET FINIMANWHA=Manwha
REM Dossier Webtoon fini
SET FINIWEBTOON=Webtoon
REM Dossier Webtoon H fini
SET FINIWEBTOONH=Webtoon H
REM Paramétre de robocopy pour déplacement
SET PARAMETREMV=/E /MOVE /V /R:10 /W:10 /NFL /COMPRESS
REM Paramétre de robocopy pour copie
SET PARAMETRECP=/E /MIR /V /R:10 /W:10 /NFL /COMPRESS

REM Menu pour selectionner le type de copie
TITLE Outil de copie Scan
COLOR 07
SET ERRORLEVEL=
CLS
ECHO.
ECHO -------------------------------------------------------------------------------
ECHO. Outil de copie des Scans
ECHO -------------------------------------------------------------------------------
ECHO.
ECHO 1 - Copie des nouveaux Scans
ECHO 2 - Copie de Colva vers Anjuna
ECHO 3 - Copie Selective
ECHO.
ECHO Q - Quitter
ECHO.
CHOICE /C 123Q /T 10 /D 1

SET CHXMENU=%ERRORLEVEL%
IF %CHXMENU% EQU 1 SET CHX=NOUVEAU
IF %CHXMENU% EQU 2 SET CHX=GENERAL
IF %CHXMENU% EQU 3 SET CHX=SELECT
IF %CHXMENU% EQU 4 SET CHX=FINFIN
CLS
GOTO %CHX%

)

:NOUVEAU
REM Gestion des particularités
REM exception.txt existe t'il
IF EXIST "exception.txt" ( 
	REM Extraction des variables
	FOR /f "skip=2 tokens=1-2 delims=;"  %%I IN (exception.txt) DO (
		REM le dossier à renommer existe ? Si oui, renommage
		CD "%DLANDROID%\Webtoons.com (FR)\"
		IF EXIST %%I (
			ECHO.
			ECHO Renomage de %%J
			REN "%%I" "%%J"
			ECHO.
			ECHO %%J renomé
		) ELSE (
			REM Sinon, on affiche qu'il n'y a rien à renommer
			ECHO Pas de dossier %%I a copier

		)
	)
)
REM Centralisation des DL
REM source.txt existe t'il
ECHO %SOURCESCRIPT%\source.txt
ECHO.
IF EXIST "%SOURCESCRIPT%\source.txt" ( 
	REM Extraction des variables
	FOR /F "usebackq tokens=*" %%A IN (source.txt) DO (
		REM le dossier à copier existe ? Si oui, copie
		IF EXIST "%DLANDROID%\%%A" (
			ECHO -------------------------------------------------------------------------------
			ECHO.
			ECHO Copie du dossier %%A
			robocopy "%DLANDROID%\%%A" "%DLHDDOWNLOADER%" %PARAMETREMV%
			ECHO -------------------------------------------------------------------------------
		) ELSE (
			REM Sinon, on affiche qu'il n'y a rien à copier
			ECHO Pas de dossier %%A a copier
		)
	)
)
PAUSE
REM Copie du dossier final vers Colva
ECHO -------------------------------------------------------------------------------
ECHO.
ECHO Copie du dossier %DLHDDOWNLOADER%
robocopy "%DLHDDOWNLOADER%" "%COLVA%%DL%" %PARAMETREMV%
mkdir "%DLHDDOWNLOADER%"

:GENERAL
REM Menu pour copier le reste ou non
TITLE Copie vers Anjuna
COLOR 07
SET ERRORLEVEL=
CLS
ECHO.
ECHO -------------------------------------------------------------------------------
ECHO. Copier vers Anjuna
ECHO -------------------------------------------------------------------------------
ECHO.
ECHO 1 - Dossier Telecharge
ECHO 2 - Tout copier
ECHO 3 - Copie Selective
ECHO.
ECHO Q - Quitter
ECHO.
CHOICE /C 123Q /T 10 /D 1

SET CHXMENU=%ERRORLEVEL%
IF %CHXMENU% EQU 1 SET CHX=CPTELECHARGE
IF %CHXMENU% EQU 2 SET CHX=CPTOUT
IF %CHXMENU% EQU 3 SET CHX=SELECT
IF %CHXMENU% EQU 4 SET CHX=FIN
GOTO %CHX%

:SELECT
REM Menu pour selectionner un copie en particulier
TITLE Copie a la carte
COLOR 07
SET ERRORLEVEL=
CLS
ECHO.
ECHO -------------------------------------------------------------------------------
ECHO. Copier a la carte Colva vers Anjuna
ECHO -------------------------------------------------------------------------------
ECHO.
ECHO 1 - Telecharger
ECHO 2 - A_Preparer
ECHO 3 - BD_Trie
ECHO 4 - Series_Finis
ECHO 5 -  +long
ECHO 6 -  +court
ECHO 7 -  +BD
ECHO.
ECHO Q - Quitter
ECHO.
CHOICE /C 1234567Q

SET CHXMENU=%ERRORLEVEL%
IF %CHXMENU% EQU 1 SET CHX=CPTELECHARGE
IF %CHXMENU% EQU 2 SET CHX=CPAPREPARER
IF %CHXMENU% EQU 3 SET CHX=CPBDTRIE
IF %CHXMENU% EQU 4 SET CHX=CPSERIESFINI
IF %CHXMENU% EQU 5 SET CHX=CPLONGFINI
IF %CHXMENU% EQU 6 SET CHX=CPCOURTFINI
IF %CHXMENU% EQU 7 SET CHX=CPBDFINI
IF %CHXMENU% EQU 8 SET CHX=FIN
CLS
GOTO %CHX%


:CPLONGFINI
TITLE Copie de "Adulte Long" de Colva vers Anjuna
CLS
ECHO Copie de "Adulte Long" de Colva vers Anjuna
robocopy "%COLVA%%FINI%\%FINIADULTLONG%" "%ANJUNA%%FINI%\%FINIADULTLONG%" %PARAMETRECP%
GOTO SELECT

:CPCOURTFINI
TITLE Copie de "Adulte Court" de Colva vers Anjuna
CLS
ECHO Copie de "Adulte Court" de Colva vers Anjuna
robocopy "%COLVA%%FINI%\%FINIADULTSHORT%" "%ANJUNA%%FINI%\%FINIADULTSHORT%" %PARAMETRECP%
PAUSE
GOTO SELECT

:CPBDFINI
TITLE Copie de "BD Fini" de Colva vers Anjuna
CLS
ECHO Copie de "BD Fini" de Colva vers Anjuna
robocopy "%COLVA%%FINI%\%FINIBD%" "%ANJUNA%%FINI%\%FINIBD%" %PARAMETRECP%
GOTO SELECT

:CPTOUT
:CPTELECHARGE
TITLE Copie de "Telecharge" de Colva vers Anjuna
CLS
ECHO Copie de "Telecharge" de Colva vers Anjuna
robocopy "%COLVA%%DL%" "%ANJUNA%%DL%" %PARAMETRECP%
IF %CHX% EQU CPTELECHARGE GOTO SELECT

:CPAPREPARER
TITLE Copie de "A_Preparer" de Colva vers Anjuna
CLS
ECHO Copie de "A_Preparer" de Colva vers Anjuna
robocopy "%COLVA%%APREP%" "%ANJUNA%%APREP%" %PARAMETRECP%
IF %CHX% EQU CPAPREPARER GOTO SELECT

:CPBDTRIE
TITLE Copie de "BD_Trie" de Colva vers Anjuna
CLS
ECHO Copie de "BD_Trie" de Colva vers Anjuna
robocopy "%COLVA%%BDTRIE%" "%ANJUNA%%BDTRIE%" %PARAMETRECP%
IF %CHX% EQU CPBDTRIE GOTO SELECT

:CPSERIESFINI
TITLE Copie de "Series_Finis" de Colva vers Anjuna
CLS
ECHO Copie de "Series_Finis" de Colva vers Anjuna
robocopy "%COLVA%%FINI%" "%ANJUNA%%FINI%" %PARAMETRECP%
GOTO SELECT


:FIN
EXIT

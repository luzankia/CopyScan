@ECHO OFF
REM MODE DEVELOPEMENT 1=Oui 0=Non
SET DEV=0

:INIT
REM Configuration des variable
REM Determiner la lettre de lecteur
SET DRIVE=%CD:~0,3%
REM Lettre de lecteur Colva
SET COLVA=Z:\
REM Lettre de lecteur Anjuna
SET ANJUNA=U:\
REM Dossier où se trouve le script
SET SOURCESCRIPT=%CD%
REM récuperation de la lettre de lecteur attendu depuis le fichier lecteur.txt
SET /p DRIVEORI=<"%SOURCESCRIPT%\lecteur.txt"
REM Dosser de téléchargement Android
SET DLANDROID=%DRIVE%AndroidDL\downloads
REM Dosier de téléchargement HDDownloader
SET DLHDDOWNLOADER=%DRIVE%1. Manga
REM Dossier Telecharge
SET DL=Telecharge
REM Dossier Fini
SET FINI=Series_Finis
REM BD Telecharge
SET BDTELECHARGE=BD_Telecharge
REM BD Vrac
SET BDVRAC=BD_Vrac
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
SET PARAMETREMV=/E /MOVE /V /R:10 /W:10 /NFL /COMPRESS /NDL /NJH /NJS /nc /ns /np
REM Paramétre de robocopy pour copie
SET PARAMETRECP=/E /MIR /V /R:10 /W:10 /NFL /COMPRESS /NDL /NJH /NJS /nc /ns

IF %DEV% EQU 0 GOTO INITFILES
ECHO ZONE DE DEV
REM Zone d'affichage
REM --------------------------------------------------
GOTO NOUVEAU

ECHO PAUSE Zone de test
PAUSE
REM --------------------------------------------------

:INITFILES
:EXCEPTION
REM Verification du fichier exception.txt et creation au besoin
CD %SOURCESCRIPT%
IF NOT EXIST "exception.txt" (GOTO CREAEXCEPTION) ELSE (GOTO BATCHEXCEPTION)

:BATCHEXCEPTION
REM Verification du fichier batchexception.txt et creation au besoin
CD %SOURCESCRIPT%
IF NOT EXIST "batchexception.txt" (GOTO CREABATCHEXCEPTION) ELSE (GOTO SOURCE)

:SOURCE
REM Verification du fichier source.txt et creation au besoin
CD %SOURCESCRIPT%
IF NOT EXIST "source.txt" (GOTO CREASOURCE) ELSE (GOTO LECTEUR)

:LECTEUR
REM Le fichier lecteur.txt existe t'il ?
IF NOT EXIST "lecteur.txt" (GOTO RESET)

:VERIFDRIVE
REM Vérification de la lettre de lecteur courant par rapport au fichier de réf
IF "%DRIVE:~0,1%"=="%DRIVEORI%" (GOTO DEBUT) ELSE (GOTO ERREURDRIVE)

:DEBUT
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
ECHO.
ECHO G - Menu General
ECHO S - Copie Selective
ECHO.
ECHO Q - Quitter
ECHO.
CHOICE /C 1SQ /T 10 /D 1
SET CHXMENU=%ERRORLEVEL%
IF %CHXMENU% EQU 1 SET CHX=NOUVEAU
IF %CHXMENU% EQU 2 SET CHX=GENERAL
IF %CHXMENU% EQU 3 SET CHX=SELECT
IF %CHXMENU% EQU 4 SET CHX=FIN
CLS
GOTO %CHX%

:NOUVEAU
REM Gestion des particularités
REM Extraction des variables
FOR /f "skip=1 tokens=1-3 delims=;" %%I IN (exception.txt) DO (
	REM le dossier à renommer existe ? Si oui, renommage
	CD "%DLANDROID%\%%I\" 2>NUL
	IF EXIST %%J (
		REN "%%J" "%%K"
		ECHO %%K renomé
		MOVE "%DLANDROID%\%%I\%%K" "%DLHDDOWNLOADER%"
	) ELSE (
		REM Sinon, on affiche qu'il n'y a rien à renommer
		ECHO Nope !
	)
)
ECHO.

REM Gestion des dossiers spéciaux
CD %SOURCESCRIPT%
FOR /f "skip=1 tokens=1,2 delims=;" %%M IN (batchexception.txt) DO (
	FOR /d %%Q IN ("%DLANDROID%\%%M\"*) DO (
		ECHO Traitement de %%Q
		REN "%DLANDROID%\%%M\%%~nxQ" "%%~nxQ%%N"
	)
)
ECHO.
ECHO Fin de renomage des dossiers spéciaux
ECHO.
PING -n 6 127.0.0.1>NUL

ECHO Fin de renomage des exceptions
ECHO.
PING -n 6 127.0.0.1>NUL

REM Centralisation des DL
CD %SOURCESCRIPT%
REM Extraction des variables
FOR /F "skip=1 usebackq tokens=*" %%A IN (source.txt) DO (
	REM le dossier à copier existe ? Si oui, copie
	IF EXIST "%DLANDROID%\%%A" (
		ECHO.
		ECHO Copie du dossier %%A
		robocopy "%DLANDROID%\%%A" "%DLHDDOWNLOADER%" %PARAMETREMV% 
	) ELSE (
		REM Sinon, on affiche qu'il n'y a rien à copier
		REM ECHO Pas de dossier %%A a copier
		REM ECHO Nope !
	)
)
ECHO.
ECHO Fin de la copie des dossiers Android
PING -n 6 127.0.0.1>NUL

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
SET CHXMENU=
CLS
ECHO.
ECHO -------------------------------------------------------------------------------
ECHO. Copier vers Anjuna
ECHO -------------------------------------------------------------------------------
ECHO.
ECHO 1 - Tout copier
ECHO 2 - Telecharge
ECHO 3 - A Preparer
ECHO 4 - BD Vrac
ECHO 5 - BD Telecharge
ECHO 6 - Series Fini
ECHO 7    - Copie Series Fini Selective
ECHO.
ECHO Q - Quitter
ECHO.
REM CHOICE /C 1234567Q /T 10 /D 1
CHOICE /C 1234567Q
SET CHXMENU=%ERRORLEVEL%
IF %CHXMENU% EQU 1 SET CHX=CPTOUT
IF %CHXMENU% EQU 2 SET CHX=CPTELECHARGE
IF %CHXMENU% EQU 3 SET CHX=CPAPREPARER
IF %CHXMENU% EQU 4 SET CHX=CPBDVRAC
IF %CHXMENU% EQU 5 SET CHX=CPBDTELECHARGE
IF %CHXMENU% EQU 6 SET CHX=CPSERIESFINI
IF %CHXMENU% EQU 7 SET CHX=SELECT
IF %CHXMENU% EQU 8 SET CHX=FIN
CLS
GOTO %CHX%

:SELECT
REM Menu pour selectionner un copie en particulier
TITLE Copie a la carte
COLOR 07
SET ERRORLEVEL=
SET CHXMENU=
CLS
ECHO.
ECHO -------------------------------------------------------------------------------
ECHO. Copie selective de Colva vers Anjuna
ECHO -------------------------------------------------------------------------------
ECHO.
ECHO 1 - Adulte Long
ECHO 2 - Adulte Short
ECHO 3 - BD
ECHO 4 - Manga
ECHO 5 - Manhua
ECHO 6 - Manwha
ECHO 7 - Webtoon
ECHO 8 - Webtoon H
ECHO.
ECHO G - Generale
ECHO.
CHOICE /C 12345678G

SET CHXMENU=%ERRORLEVEL%
IF %CHXMENU% EQU 1 SET CHX=CPALONG
IF %CHXMENU% EQU 2 SET CHX=CPASHORT
IF %CHXMENU% EQU 3 SET CHX=CPBD
IF %CHXMENU% EQU 4 SET CHX=CPMANGA
IF %CHXMENU% EQU 5 SET CHX=CPMANHUA
IF %CHXMENU% EQU 6 SET CHX=CPMANWHA
IF %CHXMENU% EQU 7 SET CHX=CPWEBT
IF %CHXMENU% EQU 8 SET CHX=CPWEBTH
IF %CHXMENU% EQU 9 SET CHX=GENERAL
CLS
GOTO %CHX%


:CPALONG
TITLE Copie du dossier "Adulte Long" de Colva vers Anjuna
CLS
ECHO Copie du dossier "Adulte Long" de Colva vers Anjuna
robocopy "%COLVA%%FINI%\%FINIADULTLONG%" "%ANJUNA%%FINI%\%FINIADULTLONG%" %PARAMETRECP%
GOTO SELECT

:CPASHORT
TITLE Copie du dossier "Adulte Court" de Colva vers Anjuna
CLS
ECHO Copie du dossier "Adulte Court" de Colva vers Anjuna
robocopy "%COLVA%%FINI%\%FINIADULTSHORT%" "%ANJUNA%%FINI%\%FINIADULTSHORT%" %PARAMETRECP%
GOTO SELECT

:CPBD
TITLE Copie du dossier "BD Fini" de Colva vers Anjuna
CLS
ECHO Copie du dossier "BD Fini" de Colva vers Anjuna
robocopy "%COLVA%%FINI%\%FINIBD%" "%ANJUNA%%FINI%\%FINIBD%" %PARAMETRECP%
GOTO SELECT

:CPMANGA
TITLE Copie du dossier "Manga Fini" de Colva vers Anjuna
CLS
ECHO Copie du dossier "Manga Fini" de Colva vers Anjuna
robocopy "%COLVA%%FINI%\%FINIMANGA%" "%ANJUNA%%FINI%\%FINIMANGA%" %PARAMETRECP%
GOTO SELECT

:CPMANHUA
TITLE Copie du dossier "Manhua Fini" de Colva vers Anjuna
CLS
ECHO Copie du dossier "Manhua Fini" de Colva vers Anjuna
robocopy "%COLVA%%FINI%\%FINIMANHUA%" "%ANJUNA%%FINI%\%FINIMANHUA%" %PARAMETRECP%
GOTO SELECT

:CPMANWHA
TITLE Copie du dossier "Manwha Fini" de Colva vers Anjuna
CLS
ECHO Copie du dossier "Manwha Fini" de Colva vers Anjuna
robocopy "%COLVA%%FINI%\%FINIMANWHA%" "%ANJUNA%%FINI%\%FINIMANWHA%" %PARAMETRECP%
GOTO SELECT

:CPWEBT
TITLE Copie du dossier "Webtoon Fini" de Colva vers Anjuna
CLS
ECHO Copie du dossier "Webtoon Fini" de Colva vers Anjuna
robocopy "%COLVA%%FINI%\%FINIWEBTOON%" "%ANJUNA%%FINI%\%FINIWEBTOON%" %PARAMETRECP%
GOTO SELECT

:CPWEBTH
TITLE Copie du dossier "Webtoon H Fini" de Colva vers Anjuna
CLS
ECHO Copie du dossier "Webtoon H Fini" de Colva vers Anjuna
robocopy "%COLVA%%FINI%\%FINIWEBTOONH%" "%ANJUNA%%FINI%\%FINIWEBTOONH%" %PARAMETRECP%
GOTO SELECT

:CPTOUT
:CPTELECHARGE
TITLE Copie du dossier "Telecharge" de Colva vers Anjuna
IF %CHX% NEQ CPTOUT CLS
ECHO Copie du dossier "Telecharge" de Colva vers Anjuna
robocopy "%COLVA%%DL%" "%ANJUNA%%DL%" %PARAMETRECP%
IF %CHX% EQU CPTELECHARGE GOTO GENERAL

:CPAPREPARER
TITLE Copie du dossier "A_Preparer" de Colva vers Anjuna
IF %CHX% NEQ CPTOUT CLS
ECHO Copie du dossier "A_Preparer" de Colva vers Anjuna
robocopy "%COLVA%%APREP%" "%ANJUNA%%APREP%" %PARAMETRECP%
IF %CHX% EQU CPAPREPARER GOTO GENERAL

:CPBDTELECHARGE
TITLE Copie du dossier "BD_Telecharge" de Colva vers Anjuna
IF %CHX% NEQ CPTOUT CLS
ECHO Copie du dossier "BD_Telecharge" de Colva vers Anjuna
robocopy "%COLVA%%BDTELECHARGE%" "%ANJUNA%%BDTELECHARGE%" %PARAMETRECP%
IF %CHX% EQU CPBDTELECHARGE GOTO GENERAL

:CPBDVRAC
TITLE Copie du dossier "BD_Vrac" de Colva vers Anjuna
IF %CHX% NEQ CPTOUT CLS
ECHO Copie du dossier "BD_Vrac" de Colva vers Anjuna
robocopy "%COLVA%%BDVRAC%" "%ANJUNA%%BDVRAC%" %PARAMETRECP%
IF %CHX% EQU CPBDVRAC GOTO GENERAL

:CPSERIESFINI
TITLE Copie du dossier "Series_Finis" de Colva vers Anjuna
IF %CHX% NEQ CPTOUT CLS
ECHO Copie du dossier "Series_Finis" de Colva vers Anjuna
robocopy "%COLVA%%FINI%" "%ANJUNA%%FINI%" %PARAMETRECP%
GOTO GENERAL

:ERREURDRIVE
ECHO La lettre de lecteur a change, il est probable que ca va merder !
ECHO.
ECHO.
REM Menu pour copier le reste ou non
TITLE Reinitialisation de la lettre de lecteur
COLOR 07
SET ERRORLEVEL=
CLS
ECHO.
ECHO -------------------------------------------------------------------------------
ECHO La lettre de lecteur a change, il est probable que ca va merder !
ECHO Mettre à jour la lettre de lecteur ?
ECHO -------------------------------------------------------------------------------
ECHO.
ECHO O - Oui
ECHO N - Non
ECHO.
ECHO Q - Quitter
ECHO.
CHOICE /C ONQ

SET CHXMENU=%ERRORLEVEL%
IF %CHXMENU% EQU 1 SET CHX=RESET
IF %CHXMENU% EQU 2 SET CHX=LAISSER
IF %CHXMENU% EQU 3 SET CHX=FIN
GOTO %CHX%

:RESET
CLS
ECHO %DRIVE:~0,1%>"%SOURCESCRIPT%\lecteur.txt"
ECHO Lettre de lecteur reinitialise
PAUSE
GOTO INIT

:LAISSER
CLS
ECHO Lettre de lecteur non modifie, va faloir changer la la lettre du lecteur !
ECHO Et ca va pas fonctionner ici !
PAUSE
GOTO FIN

:CREAEXCEPTION
CD %SOURCESCRIPT%
ECHO le fichier exception.txt n'existe pas !
ECHO.
PAUSE
ECHO creation du fichier exception.txt
ECHO Dossier;nom original;nom original [FR];>exception.txt
ECHO Hiperdex (EN);My High School Bully;My High School Bully (Hiperdex)>>exception.txt
ECHO The Blank Scanlation (EN);My Lovely Illustrator;My Lovely Illustrator (Original)>>exception.txt
ECHO The Blank Scanlation (EN);For Sale. Ruined Lady. Not Used;For Sale. Ruined Lady. Not Used (Original)>>exception.txt
ECHO Manga District (EN);Resume;Resume (Official)>>exception.txt
CLS
ECHO Fichier exception.txt cree et pre-remplis
PAUSE
GOTO BATCHEXCEPTION

:CREABATCHEXCEPTION
CD %SOURCESCRIPT%
ECHO le fichier batchexception.txt n'existe pas !
ECHO.
PAUSE
ECHO Folder Name;Added Element>batchexception.txt
ECHO Lunar Scans (EN); (Lunar)>>batchexception.txt
ECHO Omega Scans (EN); (Omega)>>batchexception.txt
ECHO The Blank Scanlation (EN); (The Blank)>>batchexception.txt
ECHO Webtoons.com (FR); [FR]>>batchexception.txt
CLS
ECHO Fichier batchexception.txt cree et pre-remplis
PAUSE
GOTO SOURCE

:CREASOURCE
REM ficher source.txt par defaut, pour recreation au cas où
CD %SOURCESCRIPT%
ECHO le fichier source.txt n'existe pas !
ECHO.
PAUSE
ECHO creation du fichier source.txt
ECHO Nom du Dossier>source.txt
ECHO Asura Scans (EN)>>source.txt
ECHO Bato.to (ALL)>>source.txt
ECHO ExHentai (ALL)>>source.txt
ECHO FastManhwa (EN)>>source.txt
ECHO Hentai Manga (EN)>>source.txt
ECHO Hentai20 (EN)>>source.txt
ECHO HentaiHere (EN)>>source.txt
ECHO HentaiWebtoon (EN)>>source.txt
ECHO Hentaidexy (EN)>>source.txt
ECHO Hiperdex (EN)>>source.txt
ECHO InstaManhwa (EN)>>source.txt
ECHO Lunar Scans (EN)>>source.txt
ECHO Manga18fx (EN)>>source.txt
ECHO MangaBuddy (EN)>>source.txt
ECHO MangaDex (EN)>>source.txt
ECHO Manga District (EN)>>source.txt
ECHO Mangahere (EN)>>source.txt
ECHO Mangakakalot (EN)>>source.txt
ECHO Manhua Plus (EN)>>source.txt
ECHO Manhwa18 (EN)>>source.txt
ECHO Manhwa18.app (EN)>>source.txt
ECHO Manhwa18.cc (ALL)>>source.txt
ECHO Manhwa18.cc (EN)>>source.txt
ECHO Manhwa18.org (EN)>>source.txt
ECHO Manhwa68 (EN)>>source.txt
ECHO Manhwahentai.me (EN)>>source.txt
ECHO ManyToon (EN)>>source.txt
ECHO Omega Scans (EN)>>source.txt
ECHO Oppai Stream (EN)>>source.txt
ECHO Reaper Scans (EN)>>source.txt
ECHO Temple Scan (EN)>>source.txt
ECHO The Blank Scanlation (EN)>>source.txt
ECHO Toonily (EN)>>source.txt
ECHO Webtoons.com (EN)>>source.txt
ECHO Webtoons.com (FR)>>source.txt
CLS
ECHO Fichier source.txt cree et pre-remplis
PAUSE
GOTO LECTEUR

:FIN
EXIT

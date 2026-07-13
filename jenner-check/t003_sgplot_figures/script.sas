/***********************************************************************
Program : SGPLOT graphics from Figures.sas (author: Nithish M S)

The PROC SGPLOT statements below are the clean, runnable graphics from the
study's Figures.sas graphics-practice file, plotting sashelp.class as the
author wrote them: two SCATTER variants, a SERIES, a STEP, and VBOX/HBOX box
plots. Each produces a PNG/SVG via ODS.
***********************************************************************/

/* SGPLOT : SCATTER, SERIES, STEP, BOX PLOTS (sashelp.class) */

PROC SGPLOT DATA=SASHELP.CLASS;
SCATTER X=HEIGHT Y=WEIGHT/MARKERATTRS=(SYMBOL=STAR SIZE=10);
RUN;
QUIT;

/* IT CAN BE CHANGE TH ANY SHAPE LIKE STAR TRIANGLE */
PROC SGPLOT DATA=SASHELP.CLASS;
SCATTER X=HEIGHT Y=WEIGHT/MARKERATTRS=(SYMBOL=TRIANGLE SIZE=10);
RUN;
QUIT;

PROC SGPLOT DATA=SASHELP.CLASS;
SERIES X=NAME Y=AGE;
RUN;
QUIT;

/* STEP GRAPH */
PROC SGPLOT DATA=SASHELP.CLASS;
STEP X=NAME Y=AGE;
RUN;

/* VBOX */
PROC SGPLOT DATA=SASHELP.CLASS;
VBOX AGE/CATEGORY=SEX;
RUN;
QUIT;

/* HBOX */
PROC SGPLOT DATA=SASHELP.CLASS;
HBOX AGE/CATEGORY=SEX;
RUN;
QUIT;

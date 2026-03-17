*GRAPHA

1.CHARTS GCHART

2.PLOT GPLOT SPLOT

CHARTS:BAR (VBAR,HBAR),PIE,BLOCK,DONUT,STAR*/
;

DATA TEST;
SET SASHELP.CLASS;
RUN;

/* GROUP */
PROC GCHART DATA=TEST;
VBAR AGE/DISCRETE TYPE=MEAN SUMVAR=HEIGHT MEAN GROUP=SEX;
RUN;
QUIT;

/* SUBGROUP */
PROC GCHART DATA=TEST;
VBAR AGE/DISCRETE TYPE=MEAN SUMVAR=HEIGHT MEAN SUBGROUP=SEX;
RUN;
QUIT;

/* GET THE GRAPH IN SEPERATE CHART */
PROC SORT DATA=SASHELP.CLASS OUT=CLASS;
BY SEX;
RUN;
PROC GCHART DATA=CLASS;
VBAR AGE/DISCRETE TYPE=MEAN SUMVAR=HEIGHT MEAN;
where sex="F";
BY SEX;
RUN;
QUIT;

/* var3d */
PROC GCHART DATA=CLASS;
VBAR3d AGE/DISCRETE TYPE=MEAN SUMVAR=HEIGHT MEAN;
where sex="F";
BY SEX;
RUN;
QUIT;

PROC GCHART DATA=CLASS;
hBAR3d AGE/DISCRETE TYPE=MEAN SUMVAR=HEIGHT MEAN;
where sex="F";
BY SEX;
RUN;
QUIT;

/* To change the colour by(patternid=midpint) */
PROC GCHART DATA=CLASS;
VBAR3d AGE/DISCRETE TYPE=MEAN SUMVAR=HEIGHT MEAN patternid=midpoint;
where sex="F";
BY SEX;
RUN;
QUIT;

/* To change the shape and width  */
PROC GCHART DATA=CLASS;
VBAR3d AGE/DISCRETE TYPE=MEAN SUMVAR=HEIGHT MEAN patternid=midpoint width=10 shape=cylinder;
where sex="F";
BY SEX;
RUN;
QUIT;

PROC GCHART DATA=CLASS;
hBAR3d AGE/DISCRETE TYPE=MEAN SUMVAR=HEIGHT MEAN patternid=midpoint width=10 shape=cylinder;
where sex="F";
BY SEX;
RUN;
QUIT;


/* Similarly perform for pichart */
proc gchart data=sashelp.class;
pie age/discrete type=mean sumvar=height;
run;
quit;

/* to get the value of the means inside the pie chart  (value=inside)*/
proc gchart data=sashelp.class;
pie age/discrete type=mean value=inside ;
run;
quit;

/* if the height value should be outside of the pie chart(slice=outside) */
proc gchart data=sashelp.class;
pie age/discrete type=mean value=inside slice=outside ;
run;
quit;

/* simalarly for donut chart */
proc gchart data=sashelp.class;
donut age/discrete type=mean value=inside slice=outside ;
run;
quit;

/* for subgroup of the diffrent catagory of data use(subgroup=var) */
proc gchart data=sashelp.class;
donut age/discrete type=mean value=inside slice=outside subgroup=sex;
run;
quit;

/* Star chart */
proc gchart data=sashelp.class;
star age/discrete type=mean value=inside slice=outside group=sex;
run;
quit;

/* for getting only for female */
proc gchart data=sashelp.class;
star age/discrete type=mean value=inside slice=outside group=sex;
where sex="F";
run;
quit;

/* Block */
proc gchart data=sashelp.class;
block age/discrete type=mean sumvar=height subgroup=sex;
where sex="F";
run;
quit;

/*Value and slice option are only used in pie chare and ther are not used in 
bar chart*/
/* plot */
proc plot data=sashelp.class;
plot age*height="*";
run;
quit;

/* gplot */
proc gplot data=sashelp.class;
plot age*height="*";
run;
quit;

symbol1 color=green value=diamond height=2;
symbol2 color=vio value=triangle height=2;


proc gplot data=sashelp.class;
plot age*height=sex;
run;
quit;


/* SGPLOT :SCATTER,SERIES,STEP,BOX PLOTS */

PROC SGPLOT DATA=SASHELP.CLASS;
SCATTER X=HEIGHT Y=WEIGHT/MARKERATTRS=(SYMBOL=STAR SIZE=10);
RUN;
QUIT;

/* IT CAN BE CHANGE TH ANY SHAPE LIKE STAR TRIANGLE */
PROC SGPLOT DATA=SASHELP.CLASS;
SCATTER X=HEIGHT Y=WEIGHT/MARKERATTRS=(SYMBOL=TRIANGLE SIZE=10);
RUN;
QUIT;

/* SERIES (LINEATTRIBUT ) TO CHANG COLOUR AND WEIDTH*/
PROC SGPLOT DATA=SASHELP.CLASS;
SERIES X=NAME Y=AGE;
RUN;
QUIT;

PROC SGPLOT DATA=SASHELP.CLASS;
SERIES X=NAME Y=AGE/LINEATTRS=(COLOUR=RED THICKNESS=10);
RUN;
QUIT;

/* STEP GRAPH */
PROC SGPLOT DATA=SASHELP.CLASS;
STEP X=NAME Y=AGE;
RUN;

/* TO CHANGE THE COLOUR AND THICKNESS OF THE PLOT USE (LINEATTRE=(COLOUR=RED THICKNESS=4)) */
PROC SGPLOT DATA=SASHELP.CLASS;
STEP X=NAME Y=AGE/LINEATTRS=(COLOUR=PURLE THICKNESS=5);
RUN;
QUIT;

/* FOR THE CREATION OF MULTIPLE STEP */
PROC SGPLOT DATA=SASHELP.CLASS;
STEP X=NAME Y=HEIGHT/LINEATTRS=(COLOUR=GREEN THICKNESS=5);
STEP X=NAME Y=WEIGHT/LINEATTRS=(COLOUR=RED THICKNESS=5);
RUN;
QUIT;

*BOX:IT HAS 2 TYPE 
      1.VBOX PLOT
      2.HBOX PLOT;
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


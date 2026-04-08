/*SEX*
MALE=1 , FEMALE=2 

*TRTO1A*
BP3304 = 1
PLACEBO = 0

*RACE*
WHITE = 1
Black or African American =2
Asian = 3
American Indian or Alaska Native =4
Native Hawaiian or Other Pacific Islander = 5
Other = 6

*ETHNICITY*
Hispanic or Latino = 1
Not Hispanic or Latino = 2

*ALCOHOL_HISTORY*
Currently Consumes =1
Previously Consumed =2
Never Consumed =3

*TOBACCO_HISTORY*
Currently Consumes =1
Previously Consumed =2
Never Consumed =3

*/

libname Table "/home/u64252598/SAS/New Folder";
run;

PROC IMPORT DATAFILE="/home/u64252598/SAS/New Folder/ADSL.xlsx"
OUT=table.ADAM
DBMS=XLSX REPLACE;
GETNAMES=YES;
QUIT;

data k;
set table.adam;
run;

proc contents data=k;
quit;

proc means data=k maxdec=0;
quit;


proc sort data=k out=adam1;
by age;
quit;

data adam4;
set adam1;
if sex="Male" then sex=1;
else if sex="Female" then sex=2;
if TRT01A="BP3304" THEN TRT01A=1;
ELSE IF TRT01A="Placebo" THEN TRT01A=0;
IF RACE="Asian" THEN RACE=3;
IF RACE="White" THEN RACE=1;
IF RACE="American Indian or Alaska Native" THEN RACE=4;
IF RACE="Native Hawaiian or Other Pacific Islander" THEN RACE=5;
IF RACE="Black or African American" THEN RACE=2;
IF RACE="Other" THEN RACE=6;
IF ETHNICITY = "Hispanic or Latino" THEN ETHNICITY=1;
IF ETHNICITY = "Not Hispanic or Latino" THEN ETHNICITY=2;
IF ALCOHOL_HISTORY = "Currently Consumes" THEN ALCOHOL_HISTORY =1;
IF ALCOHOL_HISTORY = "Previously Consumed" THEN ALCOHOL_HISTORY =2;
IF ALCOHOL_HISTORY ="Never Consumed" THEN ALCOHOL_HISTORY =3;
IF TOBACCO_HISTORY ="Currently Consumes" THEN TOBACCO_HISTORY=1;
IF TOBACCO_HISTORY ="Previously Consumed" THEN TOBACCO_HISTORY=2;
IF TOBACCO_HISTORY = "Never Consumed" THEN TOBACCO_HISTORY=3;
run;

data adam5;
set adam4;output;
TRT01A=2;output;
run;

proc sort data=adam5 out=adam6;by TRT01A;
quit;

proc summary data=adam6 ;
by trt01a;
var age;
output out=age_1 n=_n_ mean=_mean_ std=_std_ median=_median_ min=_min_ max=_max_;
quit;

DATA age_2;
set age_1;
Meansd=put(_mean_,5.1)||"("||put(_std_,6.2)||")";
minmax=put(_min_,4.0)||","||put(_max_,4.0);
n=put(_N_,4.0);
Median=put(_median_,5.1);
drop _:;
run;

proc transpose data=age_2 out=age_3 prefix=tret;
var n Meansd median minmax;
id trt01a;
quit;

data age_4;
length newvar $ 40;
set age_3;
if _Name_="n" then newvar="        N";
else if _Name_="Meansd" then newvar="       Mean(SD)";
else if _Name_="Median" then newvar="       Median";
else if _Name_="minmax" then newvar="       Min,Max";
drop _Name_;
Suborder=1;
run;

data dummy;
length newvar $ 40;
newvar="Age(Years)";
Suborder=0;
run;

data age;
set dummy age_4 ;
order=1;
run;

/* Gender statistics */

proc freq data=adam6 noprint;
by trt01a;
table sex/out=gen_1;
run;

data gen_2;
set gen_1;
np=put(count,4.0)||"("||put(Percent,4.1)||")";
run;

proc sort data=gen_2;
by sex;
quit;

proc transpose data=gen_2 out=gen_3 (drop=_NAME_) prefix=tret;
var np;
id trt01a;
by sex;
run;

data gen_4;
length newvar $ 60;
set gen_3;
if sex=1 then newvar="          Male";
else if sex=2 then newvar="          Female";
Suborder=2;
run;

data dummy1;
length newvar $ 60;
newvar="Gender [n (%)]a";
Suborder=0;
run;


data gender;
set dummy1 gen_4;
order=2;
run;

/* Ethnicity */

proc freq data=adam6 noprint;
by trt01a;
table ETHNICITY/out=eth_1;
run;

data eth_2;
set eth_1;
np=put(count,4.0)||"("||put(Percent,4.1)||")";
run;

proc sort data=eth_2;
by ETHNICITY;
quit;

proc transpose data=eth_2 out=eth_3 (drop=_NAME_) prefix=tret;
var np;
id trt01a;
by ETHNICITY;
run;

data eth_4;
length newvar $ 60;
set eth_3;
if ETHNICITY=1 then newvar="          Hispanic or Latino";
else if ETHNICITY=2 then newvar="          Not Hispanic or Latino";
Suborder=3;
run;

data dummy2;
length newvar $ 60;
newvar="Ethnicity [n (%)]a";
Suborder=0;
run;


data Ethnicity;
set dummy2 eth_4;
order=3;
run;


/* Race */

proc freq data=adam6 noprint;
by trt01a;
table RACE/out=race_1;
run;

data race_2;
set race_1;
np=put(count,4.0)||"("||put(Percent,4.1)||")";
run;

proc sort data=race_2;
by RACE;
quit;

proc transpose data=race_2 out=race_3 (drop=_NAME_) prefix=tret;
var np;
id trt01a;
by RACE;
run;

data race_4;
length newvar $ 90;
set race_3;
if RACE=1 then newvar="          White";
else if RACE=2 then newvar="          Black or African American";
else if RACE=3 then newvar="          Asian";
else if RACE=4 then newvar="          American Indian or Alaskan Native";
else if RACE=5 then newvar="          Native Hawaiian or Other Pacific Islander";
else if RACE=6 then newvar="          Other";
Suborder=4;
run;

data dummy3;
length newvar $ 90;
newvar="Race [n (%)]a";
Suborder=0;
run;


data RACE;
set dummy3 race_4;
order=4;
run;

data final;
set age gender Ethnicity RACE;
keep newvar tret0 tret1 tret2 order Suborder;
run;

proc report data=final nowd headline headskip split="*"
style(report)=[width=100%]
style(header)=[just=center]
style(column)=[just=center];

column(order Suborder newvar tret1 tret0 tret2);

define order/group noprint;
define Suborder/group noprint ;

define newvar /display STYLE(COLUMN)=[CELLWIDTH=3IN JUST=LEFT];

define tret1/"BP3304*(N=45)" STYLE(COLUMN)=[CELLWIDTH=1.5IN];
define tret0/"Placebo*(N=35)" STYLE(COLUMN)=[CELLWIDTH=1.5IN];
define tret2/"Overall*(N=80)" STYLE(COLUMN)=[CELLWIDTH=1.5IN];

rbreak after/skip;

compute before _page_;
line "";
line @9 "14.1.2.1 Subject Demographics and Baseline Characteristics";
line @19 "Safety Population";
line " ";
endcomp;

compute after;
line @4 "Reference: Listing 16.2.4.1";
line @5 "Percentages are based on the number of subjects in the population.";
line @4 "Note: SD = standard deviation, Min = Minimum, Max = Maximum";
line "";
endcomp;
run;



/* 14.1.2.1 Subject Demographics and Baseline Characteristics */
/* Safety Population */


/* Height_cm */

PROC IMPORT DATAFILE="/home/u64252598/SAS/New Folder/ADSL.xlsx"
OUT=ADAM01
DBMS=XLSX REPLACE;
GETNAMES=YES;
QUIT;

data adam02;
set adam5 (keep=height_cm weight_kg bmi TRT01A);
run;


proc sort data=adam02 out=adam03;by TRT01A;
quit;

proc summary data=adam03;
var height_cm;
by TRT01A;
output out=hgt_1 n=_n_ mean=_mean_ stddev=_std_ median=_median_ min=_min_ max=_max_;
quit;


data hgt_2;
set hgt_1;
meansd=put(_mean_,4.1)||"("||put(_std_,5.2)||")";
median=put(_median_,4.1);
minmax=put(_min_,4.0)||","||put(_max_,4.0);
n=put(_n_,4.0);
drop _:;
run;

PRoc transpose data=hgt_2 out=hgt_3 prefix=tret;
var n meansd median minmax;
id TRT01A;
quit;


data hgt_4;
length newvar $ 60;
set hgt_3;
if _NAME_ = "n" then newvar="       N";
else if _NAME_="meansd" then newvar="       Mean(SD)";
else if _NAME_="median" then newvar="       Median";
else if _NAME_="minmax" then newvar="       Min,Max";
drop _:;
suborder=1;
run;

data dummy01;
length newvar $ 60;
newvar="Height (cm)";
suborder=0;
run;

data Height;
set dummy01 hgt_4;
order=1;
run;


/* Macro */

%macro proj(var=,dset1= ,dset2=,dset3=,dset4=,newvar=,dummy=,final=,order1=,subordern0=,subordern1=);

PROC IMPORT DATAFILE="/home/u64252598/SAS/New Folder/ADSL.xlsx"
OUT=ADAM01
DBMS=XLSX REPLACE;
GETNAMES=YES;
QUIT;

data adam4;
set ADAM01;
if sex="Male" then sex=1;
else if sex="Female" then sex=2;
if TRT01A="BP3304" THEN TRT01A=1;
ELSE IF TRT01A="Placebo" THEN TRT01A=0;
IF RACE="Asian" THEN RACE=3;
IF RACE="White" THEN RACE=1;
IF RACE="American Indian or Alaska Native" THEN RACE=4;
IF RACE="Native Hawaiian or Other Pacific Islander" THEN RACE=5;
IF RACE="Black or African American" THEN RACE=2;
IF RACE="Other" THEN RACE=6;
IF ETHNICITY = "Hispanic or Latino" THEN ETHNICITY=1;
IF ETHNICITY = "Not Hispanic or Latino" THEN ETHNICITY=2;
IF ALCOHOL_HISTORY = "Currently Consumes" THEN ALCOHOL_HISTORY =1;
IF ALCOHOL_HISTORY = "Previously Consumed" THEN ALCOHOL_HISTORY =2;
IF ALCOHOL_HISTORY ="Never Consumed" THEN ALCOHOL_HISTORY =3;
IF TOBACCO_HISTORY ="Currently Consumes" THEN TOBACCO_HISTORY=1;
IF TOBACCO_HISTORY ="Previously Consumed" THEN TOBACCO_HISTORY=2;
IF TOBACCO_HISTORY = "Never Consumed" THEN TOBACCO_HISTORY=3;
run;

data adam5;
set adam4;output;
TRT01A=2;output;
run;

data adam02;
set adam5 (keep=height_cm weight_kg bmi TRT01A);
run;


proc sort data=adam02 out=adam03;
by TRT01A;
quit;

proc summary data=adam03;
var &var;
by TRT01A;
output out=&dset1 n=_n_ mean=_mean_ stddev=_std_ median=_median_ min=_min_ max=_max_;
quit;


data &dset2;
set &dset1;
meansd=put(_mean_,4.1)||"("||put(_std_,5.2)||")";
median=put(_median_,4.1);
minmax=put(_min_,4.0)||","||put(_max_,4.0);
n=put(_n_,4.0);
drop _:;
run;

PRoc transpose data=&dset2 out=&dset3 prefix=tret;
var n meansd median minmax;
id TRT01A;
quit;


data &dset4;
length newvar $ 60;
set &dset3;
if _NAME_ = "n" then newvar="       N";
else if _NAME_="meansd" then newvar="       Mean(SD)";
else if _NAME_="median" then newvar="       Median";
else if _NAME_="minmax" then newvar="       Min,Max";
drop _:;
suborder=&subordern1;
run;

data &dummy;
length newvar $ 60;
newvar=&newvar;
suborder=&subordern0;
run;

data &final;
set &dummy &dset4;
order=&order1;
run;

%mend;

/* height_cm weight_kg bmi TRT01A */

/* Weight */
%proj(var=weight_kg,dset1=wtg_1 ,dset2=wtg_2,dset3=wtg_3,dset4=wtg_4,newvar="Weight (kg)",dummy=dummy02,final=weight,order1=2,subordern0=0,subordern1=2);

/* Body mass index */
%proj(var=BMI,dset1=bmi_1 ,dset2=bmi_2,dset3=bmi_3,dset4=bmi_4,newvar="Body Mass Index (kg/m2)",dummy=dummy03,final=BMI,order1=3,subordern0=0,subordern1=3);

data final2;
set Height weight BMI;
run;

/* Report  */

title1 j=l "BIGG PHARMACEUTICAL COMPANY" j=r "DATE: &sysdate9.";
      
TITLE2 J=L "BP3304-002" J=R  "PROGRAM: XXXXXX.SAS";
      
TITLE3 J=R "1";      


proc report data=final2 nowd headline headskip split="*" 
style(report)=[width=100%]
style(header)=[just=center]
style(column)=[just=center];

column(order suborder newvar tret1 tret0 tret2);

define order / group noprint;
define suborder / group noprint;
define newvar / display STYLE(COLUMN)=[CELLWIDTH=3IN JUST=LEFT];

define tret1/"BP3304*(N=45)" STYLE(COLUMN)=[CELLWIDTH=1.5IN];
define tret0/"Placebo*(N=35)" STYLE(COLUMN)=[CELLWIDTH=1.5IN];
define tret2/"Overall*(N=80)" STYLE(COLUMN)=[CELLWIDTH=1.5IN];

Rbreak after/skip;

compute before _page_;
line "";
line @9 "14.1.2.1 Subject Demographics and Baseline Characteristics";
line @19 "Safety Population";
line " ";
endcomp;

compute after;
LINE "";
line @4 "Reference: Listing 16.2.4.1";
line @4 "Note: SD = standard deviation, Min = Minimum, Max = Maximum";
line "";
endcomp;

run;


/* 14.1.2.1 Subject Demographics and Baseline Characteristics */
/* Safety Population */

data AH;
SET adam5;
RUN;

PROC SORT DATA=AH OUT=AH1;
BY TRT01A;
QUIT;

PROC FREQ DATA=AH1 NOPRINT;
TABLE ALCOHOL_HISTORY/OUT=AH2;
BY TRT01A;
QUIT;

DATA AH3;
SET AH2;
COUNTPER=STRIP(PUT(COUNT,BEST.)||"("||PUT(PERCENT,5.2)||")");
DROP COUNT PERCENT;
RUN;


PROC SORT DATA=AH3 OUT=AH4;BY ALCOHOL_HISTORY TRT01A;QUIT;

PROC TRANSPOSE DATA=AH4 PREFIX=TRET OUT=AH5;
VAR COUNTPER;
BY ALCOHOL_HISTORY;
ID TRT01A;
QUIT;

DATA AH6;
LENGTH NEWVAR $ 80;
SET AH5;
IF ALCOHOL_HISTORY=3 THEN NEWVAR="Never Consumed";
ELSE IF ALCOHOL_HISTORY=2 THEN NEWVAR="Previously Consumed";
ELSE IF ALCOHOL_HISTORY=1 THEN NEWVAR="Currently Consumes";
DROP ALCOHOL_HISTORY _NAME_;
RUN;

DATA DUMMEY;
NEWVAR="Alcohol History [n (%)]a";
RUN;

DATA AH_FINAL;
SET DUMMEY AH6;
ORDER=1;
RUN;


/* Tobacco History */

data TH;
SET adam5;
RUN;

PROC SORT DATA=TH OUT=TH1;
BY TRT01A;
QUIT;

PROC FREQ DATA=TH1 NOPRINT;
TABLE TOBACCO_HISTORY/OUT=TH2;
BY TRT01A;
QUIT;

DATA TH3;
SET TH2;
COUNTPER=STRIP(PUT(COUNT,BEST.)||"("||PUT(PERCENT,5.2)||")");
DROP COUNT PERCENT;
RUN;


PROC SORT DATA=TH3 OUT=TH4;BY TOBACCO_HISTORY TRT01A;QUIT;

PROC TRANSPOSE DATA=TH4 PREFIX=TRET OUT=TH5;
VAR COUNTPER;
BY TOBACCO_HISTORY;
ID TRT01A;
QUIT;

DATA TH6;
LENGTH NEWVAR $ 80;
SET TH5;
IF TOBACCO_HISTORY=3 THEN NEWVAR="Never Consumed";
ELSE IF TOBACCO_HISTORY=2 THEN NEWVAR="Previously Consumed";
ELSE IF TOBACCO_HISTORY=1 THEN NEWVAR="Currently Consumes";
DROP TOBACCO_HISTORY _NAME_;
RUN;

DATA DUMMEY;
NEWVAR="Tobacco History [n (%)]a";
RUN;

DATA TH_FINAL;
SET DUMMEY TH6;
ORDER=2;
RUN;

/* Duration of Hypertension (years) */

DATA DU_YR;
SET adam5;
RUN;


PROC SORT DATA=DU_HY OUT=DU_YR1;BY TRT01A;QUIT;

PROC SUMMARY DATA=DU_YR1;
VAR HTN_DURATION_YRS;
BY TRT01A;
OUTPUT OUT=DU_YR2 N=_N_ MEAN=_MEAN_ STDDEV=_STD_ MEDIAN=_MED_ MIN=_MIN_ MAX=_MAX_;
QUIT;

DATA DU_YR3;
SET DU_YR2;
N=STRIP(PUT(_N_,5.));
MEANSD=STRIP(PUT(_MEAN_,5.1)||"("||PUT(_STD_,5.2)||")");
MEDIAN=STRIP(PUT(_MED_,5.));
MINMAX=COMPRESS(PUT(_MIN_,5.0)||","||PUT(_MAX_,5.0));
RUN;

DATA DU_YR4;
SET DU_YR3;
DROP _:;
RUN;

PROC TRANSPOSE DATA=DU_YR4 OUT=DU_YR5 PREFIX=TRET NAME=NEWVAR;
VAR N MEANSD MEDIAN MINMAX;
ID TRT01A;
RUN;

DATA DU_YR6;
SET DU_YR5;
IF NEWVAR=N THEN NEWVAR="N";
ELSE IF NEWVAR="MEANSD" THEN NEWVAR="Mean(SD)";
else IF NEWVAR="MEDIAN" THEN NEWVAR="Medina";
else if NEWVAR="MINMAX" THEN NEWVAR="Min,Max";
drop N;
run;

DATA DUMMEY;
NEWVAR="Duration of Hypertension (years)";
RUN;

DATA DU_FINAL;
SET DUMMEY DU_YR6;
ORDER=3;
RUN;


DATA FINAL_OUT;
SET AH_FINAL TH_FINAL DU_FINAL;
RUN;


/* REPORT */
title1 j=l "BIGG PHARMACEUTICAL COMPANY" j=r "DATE: &sysdate9.";
      
TITLE2 J=L "BP3304-002" J=R  "PROGRAM: XXXXXX.SAS";
      
TITLE3 J=R "1";      

proc report data=FINAL_OUT HEADLINE HEADSKIP SPLIT="*";
COLUMN ORDER NEWVAR TRET0 TRET1 TRET2;

DEFINE ORDER/ORDER NOPRINT;
DEFINE NEWVAR/DISPLAY STYLE(COLUMN)=[CELLWIDTH=3IN JUST=LEFT];

define tret1/"BP3304*(N=45)" STYLE(COLUMN)=[CELLWIDTH=1.5IN];
define tret0/"Placebo*(N=35)" STYLE(COLUMN)=[CELLWIDTH=1.5IN];
define tret2/"Overall*(N=80)" STYLE(COLUMN)=[CELLWIDTH=1.5IN];

Rbreak after/skip;

compute before _page_;
line "";
line @9 "14.1.2.1 Subject Demographics and Baseline Characteristics";
line @19 "Safety Population";
line " ";
endcomp;

compute after;
LINE "";
line @4 "Reference: Listing 16.2.4.1";
line @4 "Note: SD = standard deviation, Min = Minimum, Max = Maximum";
line "";
endcomp;
RUN;


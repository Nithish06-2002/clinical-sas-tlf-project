/***********************************************************************
Program : %proj continuous-variable summary macro
Source  : table_comblete code.sas (author: Nithish M S)

The %proj macro below is copied verbatim from the study program, with one
substitution: its internal PROC IMPORT of ADSL.xlsx is replaced by a SET of a
mock ADSL dataset built here (same columns and character coding the macro's
IF-THEN recodes key off), so the macro runs self-contained. The macro's
summary/transpose/report logic is the author's, unchanged. The caller at the
bottom is the author's own %proj(var=weight_kg,...) invocation.
***********************************************************************/

/* Mock ADSL: columns %proj reads (sex, TRT01A, RACE, ETHNICITY,
   ALCOHOL_HISTORY, TOBACCO_HISTORY, height_cm, weight_kg, bmi). */
DATA ADSL01;
LENGTH sex $6 TRT01A $8 RACE $40 ETHNICITY $30 ALCOHOL_HISTORY $30 TOBACCO_HISTORY $30;
INFILE DATALINES DLM='|';
INPUT sex $ TRT01A $ RACE $ ETHNICITY $ ALCOHOL_HISTORY $ TOBACCO_HISTORY $ height_cm weight_kg bmi;
DATALINES;
Male|BP3304|Asian|Hispanic or Latino|Currently Consumes|Currently Consumes|179.5|80.5|25.0
Male|Placebo|White|Hispanic or Latino|Currently Consumes|Currently Consumes|159.3|77.1|30.4
Male|Placebo|Black or African American|Not Hispanic or Latino|Never Consumed|Previously Consumed|182.4|50.3|15.1
Male|Placebo|Asian|Not Hispanic or Latino|Currently Consumes|Currently Consumes|188.3|65.1|18.4
Male|Placebo|White|Not Hispanic or Latino|Previously Consumed|Never Consumed|160.6|52.0|20.2
Female|BP3304|American Indian or Alaska Native|Hispanic or Latino|Never Consumed|Previously Consumed|183.2|77.8|23.2
Female|BP3304|White|Hispanic or Latino|Never Consumed|Currently Consumes|180.9|94.3|28.8
Male|BP3304|American Indian or Alaska Native|Not Hispanic or Latino|Previously Consumed|Never Consumed|183.4|57.3|17.0
Female|BP3304|Asian|Hispanic or Latino|Never Consumed|Never Consumed|156.8|82.8|33.7
Male|Placebo|American Indian or Alaska Native|Not Hispanic or Latino|Never Consumed|Never Consumed|172.3|80.8|27.2
Male|BP3304|White|Not Hispanic or Latino|Previously Consumed|Previously Consumed|152.6|91.1|39.1
Female|BP3304|American Indian or Alaska Native|Not Hispanic or Latino|Never Consumed|Previously Consumed|155.7|56.3|23.2
Female|Placebo|American Indian or Alaska Native|Not Hispanic or Latino|Currently Consumes|Currently Consumes|170.4|54.1|18.6
Male|BP3304|Black or African American|Hispanic or Latino|Never Consumed|Previously Consumed|173.9|67.3|22.3
Female|Placebo|White|Hispanic or Latino|Never Consumed|Never Consumed|180.0|84.6|26.1
Female|BP3304|Asian|Not Hispanic or Latino|Currently Consumes|Previously Consumed|150.1|82.5|36.6
Female|BP3304|White|Not Hispanic or Latino|Never Consumed|Never Consumed|174.4|56.9|18.7
Male|BP3304|Asian|Not Hispanic or Latino|Currently Consumes|Currently Consumes|187.2|89.5|25.5
Female|BP3304|White|Hispanic or Latino|Never Consumed|Currently Consumes|153.4|71.9|30.6
Male|BP3304|Black or African American|Not Hispanic or Latino|Never Consumed|Currently Consumes|160.6|89.3|34.6
Female|BP3304|Black or African American|Not Hispanic or Latino|Previously Consumed|Never Consumed|176.0|69.7|22.5
Female|BP3304|Black or African American|Hispanic or Latino|Currently Consumes|Previously Consumed|150.8|74.9|32.9
Male|BP3304|White|Hispanic or Latino|Currently Consumes|Currently Consumes|186.2|88.7|25.6
Male|BP3304|Asian|Not Hispanic or Latino|Currently Consumes|Never Consumed|155.3|92.1|38.2
Female|BP3304|American Indian or Alaska Native|Not Hispanic or Latino|Currently Consumes|Currently Consumes|153.9|69.4|29.3
Female|Placebo|American Indian or Alaska Native|Hispanic or Latino|Never Consumed|Never Consumed|189.4|54.4|15.2
Female|Placebo|White|Hispanic or Latino|Currently Consumes|Currently Consumes|171.5|56.3|19.1
Male|Placebo|American Indian or Alaska Native|Hispanic or Latino|Currently Consumes|Previously Consumed|182.3|88.5|26.6
Male|BP3304|White|Hispanic or Latino|Currently Consumes|Currently Consumes|166.3|71.7|25.9
Female|BP3304|Black or African American|Not Hispanic or Latino|Currently Consumes|Previously Consumed|160.6|85.3|33.1
;
RUN;

/* Macro */

%macro proj(var=,dset1= ,dset2=,dset3=,dset4=,newvar=,dummy=,final=,order1=,subordern0=,subordern1=);

data adam4;
set ADSL01;
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
output out=&dset1 n=_n_ mean=_mean_ std=_std_ median=_median_ min=_min_ max=_max_;
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
set weight BMI;
run;

/* Report  */
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

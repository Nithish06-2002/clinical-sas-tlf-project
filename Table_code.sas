/* TLF'S PROJECT */

/***********************************************************************
Program Name : t_14_1_2_1_demographic_summary.sas

Purpose      : Generate Table 14.1.2.1 – Subject Demographics
               for the Safety Population.

Study        : BP3304 Clinical Study
Sponsor      : ABC Pharma

Author       : Nithish M S
Date Created : 17MAR2026

Input Data   : my_data.demog
Output Data  : final_demog_table

Description  :
This program generates summary statistics for subject demographic
characteristics by treatment group.

The table includes the following variables:

1. Age (years)
   - N
   - Mean (Standard Deviation)
   - Median
   - Minimum and Maximum

2. Gender
   - Male
   - Female
   Results displayed as n (%)

3. Ethnicity
   - Hispanic or Latino
   - Not Hispanic or Latino
   Results displayed as n (%)

4. Race
   - White
   - Black or African American
   - Asian
   - American Indian / Other
   Results displayed as n (%)

Treatment Groups:
0 = Placebo
1 = BP3304

Population:
Safety Population

Output Table:
CSR Table 14.1.2.1 – Subject Demographic Characteristics

***********************************************************************/

PROC IMPORT DATAFILE="/home/u64252598/SAS/clinical_demographics_tlf_practice.csv"
OUT=DM
DBMS=CSV REPLACE;
GETNAMES=YES;
QUIT;

PROC SORT DATA=DM OUT=DM1;
BY TRT;
QUIT;

DATA DM2;
SET DM1;OUTPUT;
TRT=2;OUTPUT;
RUN;

PROC SORT DATA=DM2;BY TRT;RUN;

/* SUMMARY STATISTICS */
PROC SUMMARY DATA=DM2 MAXDEC=0;
BY TRT;
VAR AGE;
OUTPUT OUT=AGE_1 N=_N MEAN=_MEAN STD=_STD MEDIAN=_MEDIAN MIN=_MIN MAX=_MAX;
RUN;

/* FROMATING VALUES */
DATA AGE_2;
SET AGE_1;
MEANSD=put(_MEAN,5.1)||"("||put(_STD,6.2)||")";
MINMAX=PUT(_MIN,4.0)||","||PUT(_MAX,4.0);
N=PUT(_N,4.0);
MEDIAN=PUT(_MEDIAN,5.1);
DROP _:;
RUN;

/* TRANSPOSING THE VALUE */
PROC TRANSPOSE DATA=AGE_2 OUT=AGE_3 PREFIX=TREAT;
ID TRT;
VAR N MEANSD MEDIAN MINMAX;
QUIT; 

DATA AGE_4;
LENGTH desc$ 80.;
SET AGE_3;
IF _NAME_="N" THEN desc="     N";
ELSE IF _NAME_="MEANSD" THEN desc="    MEAN(SD)";
ELSE IF _NAME_="MEDIAN" THEN desc="    MEDIAN";                  
ELSE IF _NAME_="MINMAX" THEN desc="    MIN,MAX";
DROP _NAME_;
RUN;

DATA MOCKDATA;
LENGTH desc$ 80.;
desc="Age(years)";
run;

DATA AGE;
LENGTH desc$ 80.;
SET MOCKDATA AGE_4;
order=1;
RUN;

/* GENDER STATISTICS */

PROC FREQ DATA=DM2;
BY TRT;
TABLES gender/OUT=GEN_1;
QUIT;
    
DATA GEN_2;
SET GEN_1;
NP=PUT(COUNT,4.0)||"("||PUT(PERCENT,4.1)||")";
RUN;

PROC SORT DATA=GEN_2;BY GENDER;QUIT;

PROC TRANSPOSE DATA=GEN_2 OUT=GEN_3 (DROP=_NAME_) PREFIX=TREAT;
ID TRT;
VAR NP;
BY GENDER;
QUIT;

DATA GEN_4;
length desc$ 40.;
SET GEN_3;
IF GENDER=1 THEN DESC="     Male";
else if GENDER=2 THEN DESC="    Female";
drop GENDER;
run;

data dummy1;
desc="Gender[n(%)]^a";
run;

data gen;
set dummy1 gen_4;
order=2 ;
run;

/* ETHNIC STATAS */

PROC FREQ DATA=DM2;
BY TRT;
TABLES ETHNIC/OUT=ETH_1;
QUIT;
    
DATA ETH_2;
SET ETH_1;
NP=PUT(COUNT,4.0)||"("||PUT(PERCENT,4.1)||")";
RUN;

PROC SORT DATA=ETH_2;BY ETHNIC;QUIT;

PROC TRANSPOSE DATA=ETH_2 OUT=ETH_3 (DROP=_NAME_) PREFIX=TREAT;
ID TRT;
VAR NP;
BY ETHNIC;
QUIT;

DATA ETH_4;
length desc$ 40.;
SET ETH_3;
IF ETHNIC=1 THEN DESC="     Hispanic or Latino";
else if ETHNIC=2 THEN DESC="    Not Hispanic or Latino";
drop ETHNIC;
run;

data dummy2;
desc="Ethnicity[n(%)]^a";
run;

data eth;
set dummy2 ETH_4;
order=3 ;
run;

/* Race status */

PROC FREQ DATA=DM2;
BY TRT;
TABLES race/OUT=race_1;
QUIT;
    
DATA race_2;
SET race_1;
NP=PUT(COUNT,4.0)||"("||PUT(PERCENT,4.1)||")";
RUN;

PROC SORT DATA=race_2;BY race;QUIT;

PROC TRANSPOSE DATA=race_2 OUT=race_3 (DROP=_NAME_) PREFIX=TREAT;
ID TRT;
VAR NP;
BY race;
QUIT;

DATA race_4;
length desc$ 40.;
SET race_3;
IF race=1 THEN DESC="     White";
else if race=2 THEN DESC="     Black";
else if race=3 THEN DESC="     Asian";
else if race=4 THEN DESC="     American Indian";
drop race;
run;

data dummy3;
desc="Race[n(%)]^a";
run;

data race;
set dummy3 race_4;
order=4 ;
run;

/* Generating the report as per the mockshell */

data final;
set age gen eth race;
run;

PROC REPORT DATA=FINAL nowd headline headskip SPLIT="*";
column(order desc treat1 treat0 treat2);
define order/group noprint;
define desc/"" width=40;
define treat1/"BP3304*(N=31)" ;
DEFINE treat0/"Placebo*(N=29)";
define treat2/"overall*(N=60)";

break after order/skip;
compute before _page_;
line "";
line @10 "14.1.2.1 Subject Demographics and Baseline Characteristics";
line @20 "Safety Population";
line  "";
endcomp;

compute after;
line @4 "Reference: Listing 16.2.4.1";
line @4 "Percentages are based on the number of subjects in the population.";
line @4 "Note: SD = standard deviation, Min = Minimum, Max = Maximum.";
endcomp;
run;


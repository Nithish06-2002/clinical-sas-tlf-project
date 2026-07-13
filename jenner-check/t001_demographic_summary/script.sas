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

/* Demographics loaded inline from the study's own
   clinical_demographics_tlf_practice.csv (first 100 subjects) so the table
   runs self-contained. Columns and coding match the CSV exactly:
   trt 0=Placebo 1=BP3304 | gender 1=Male 2=Female
   race 1=White 2=Black 3=Asian 4=American Indian | ethnic 1=Hispanic 2=Not Hispanic */
DATA DM;
INFILE DATALINES DLM=' ';
INPUT subjid trt gender race age ethnic;
DATALINES;
1001 0 1 2 68 2
1002 1 1 3 23 1
1003 0 1 1 23 2
1004 0 2 1 20 1
1005 0 1 1 24 2
1006 1 1 1 68 1
1007 0 2 4 25 1
1008 0 1 1 59 2
1009 0 2 4 69 1
1010 1 2 4 32 1
1011 0 1 1 64 2
1012 0 2 1 46 1
1013 0 1 2 50 2
1014 0 2 3 69 2
1015 1 2 1 47 2
1016 0 1 2 56 1
1017 1 2 2 44 1
1018 1 2 3 53 1
1019 1 2 4 46 2
1020 0 2 1 55 1
1021 1 2 3 74 2
1022 0 1 1 50 2
1023 1 2 2 78 1
1024 1 1 2 54 2
1025 1 2 4 44 1
1026 1 1 2 72 1
1027 1 1 2 50 1
1028 1 2 3 79 1
1029 1 2 1 21 1
1030 1 2 1 39 2
1031 0 1 3 19 2
1032 0 2 4 27 2
1033 1 1 1 22 1
1034 1 1 2 76 1
1035 1 1 1 27 1
1036 0 2 2 50 2
1037 1 2 4 71 1
1038 0 1 3 55 2
1039 0 1 1 30 2
1040 0 2 3 48 1
1041 0 1 1 64 1
1042 0 2 2 53 2
1043 1 1 3 62 1
1044 1 2 1 41 2
1045 1 1 2 69 1
1046 1 2 3 73 1
1047 1 1 3 32 2
1048 0 2 1 46 1
1049 1 2 1 25 2
1050 1 1 1 22 1
1051 0 1 2 46 2
1052 1 2 1 64 2
1053 0 1 3 21 1
1054 1 2 3 29 2
1055 0 1 1 62 1
1056 1 2 1 19 1
1057 1 2 4 44 1
1058 0 2 3 48 2
1059 0 2 2 68 2
1060 0 2 4 68 1
1061 0 2 1 53 1
1062 0 1 1 53 2
1063 0 1 3 43 1
1064 0 1 1 60 1
1065 0 2 2 44 2
1066 1 2 3 22 1
1067 1 2 1 37 2
1068 0 2 3 28 1
1069 1 1 1 79 2
1070 1 1 1 27 1
1071 1 2 1 57 1
1072 1 1 2 55 2
1073 0 1 2 23 1
1074 1 2 3 25 2
1075 0 1 1 40 1
1076 1 2 1 64 2
1077 1 1 2 43 2
1078 1 2 1 63 2
1079 0 2 2 60 2
1080 1 2 1 29 1
1081 0 2 3 43 1
1082 1 1 1 30 2
1083 0 2 1 57 2
1084 1 2 4 79 2
1085 0 2 2 35 1
1086 0 1 1 42 1
1087 1 2 1 50 1
1088 0 1 4 64 1
1089 1 2 4 57 2
1090 1 1 2 77 2
1091 1 1 4 60 2
1092 1 2 3 29 1
1093 1 1 4 61 1
1094 1 2 3 53 1
1095 1 2 2 65 2
1096 1 2 2 21 2
1097 1 1 2 22 1
1098 1 1 2 73 2
1099 1 2 2 54 1
1100 0 2 3 25 1
;
RUN;

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


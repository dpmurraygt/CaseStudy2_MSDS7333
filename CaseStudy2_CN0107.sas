data carmpg;
infile '\\client\c$\Users\patrickcorynichols\MSDS_QTW\CaseStudy2_MSDS7333\carmpgdata_2_2_2.txt'
DSD delimiter='09'x firstobs = 2;
length auto $25;
input auto mpg cylinders size hp weight accel eng_type;
run;

PROC PRINT data = carmpg;
RUN;

PROC MEANS STD CLM Q1 MEDIAN Q3;
VAR MPG CYLINDERS SIZE HP WEIGHT ACCEL; /*weight here should be renamed to avoid confusion */
CLASS ENG_TYPE;
RUN;
ods graphics on /width=12in;
ods graphics on/ height=12in;

proc sgscatter data=carmpg;
title 'SP Matrix for Cars';
matrix mpg cylinders size hp weight accel / group=eng_type diagonal=(histogram);
run;

/* non-normality in multiple continuous variables, assumptions for LR questionable */
/* strong pos corr in hp - size, neg corr in mpg - size: expected, lots of great linear rels in general*/ 

/* baseline analysis with listwise deletion */
Title 'Predicting MPG Without Imputation';
PROC REG data = carmpg;
MODEL MPG = CYLINDERS SIZE HP WEIGHT;
RUN;

/* 16 missing obs deleted and MLR performed */
/* model overall significant w/large F & p < .0001 and high expl of variance adj Rsq .875*/
/* hp, cylinders not significant predictors via t test */
/* residuals show random pattern */




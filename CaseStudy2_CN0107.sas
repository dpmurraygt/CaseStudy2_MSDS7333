data carmpg;
infile '\\client\c$\Users\patrickcorynichols\MSDS_QTW\CaseStudy2_MSDS7333\carmpgdata_2_2_2.txt'
DSD delimiter='09'x DSD missover firstobs = 2;
length auto $25;
input auto mpg cylinders size hp weight accel eng_type;
run;

PROC PRINT data = carmpg;
RUN;

PROC MEANS STD CLM Q1 MEDIAN Q3;
VAR MPG CYLINDERS SIZE HP WEIGHT ACCEL;
CLASS ENG_TYPE;
RUN;

proc sgscatter data=carmpg;
title 'SP Matrix for Cars';
matrix mpg cylinders size hp weight accel / group=eng_type diagonal=(histogram);
RUN;

/* non-normality in multiple continuous variables, assumptions for LR questionable */
/* strong pos corr in hp - size, neg corr in mpg - size: expected, lots of great linear rels in general*/ 

/* baseline analysis with listwise deletion */

/* correlation matrix for car */
PROC CORR data = carmpg;
RUN;


Title 'Predicting MPG Without Imputation';
PROC REG data = carmpg;
MODEL MPG = CYLINDERS SIZE HP WEIGHT ACCEL ENG_TYPE;
OUTPUT out = modeldiags
RSTUDENT = rstudent
COOKD = cookd;
RUN;
QUIT;

/* 16 missing obs deleted and MLR performed */
/* model overall significant w/large F & p < .0001 and high expl of variance adj Rsq .875*/
/* hp, cylinders not significant predictors via t test */
/* residuals show random pattern */
/* Fiat strada has high influence */
/* no need for transforms per instructions*/

ODS SELECT MISSPATTERN;
PROC MI data = carmpg seed = 100 nimpute = 0;
VAR CYLINDERS SIZE HP WEIGHT ACCEL ENG_TYPE;
MCMC;
RUN;
QUIT;

/* arbitrary pattern */
/* proc MI default is MCMC but explicitly calling */
/* MCMC uses EM to prime estimates with more accurate covariance and mean estimates*/
/* MCMC uses random walks via Markov chain(s) to build a fair sample distribution that is sampled from to estimate imputed values
values typically based on likelihood estimates of the dataset with selected imputes */

PROC MI data = carmpg OUT = MIOUT seed = 100 nimpute = 5;
VAR CYLINDERS SIZE HP WEIGHT ACCEL ENG_TYPE;
MCMC;
RUN;
QUIT;


PROC PRINT data = miout;
RUN;

PROC REG data = miout outest = outreg covout;
MODEL MPG = CYLINDERS SIZE HP WEIGHT ACCEL ENG_TYPE;
BY _IMPUTATION_;
RUN;
QUIT;

/* analyze outputs vs listwise */

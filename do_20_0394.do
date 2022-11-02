use "~/data_20_0394.dta", clear

xtset nid year

*** DESCRIPTIVE STATS ***
* set working directory
desctable suiWun suiWMun suiWFun perc_empl_white perc_empl_white_men perc_empl_white_women citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic, stats(n mean sd min max) title(Descriptive Statistics) filename("descriptive_stats") 

/*** HYBRID MODELS:	YEAR RANDOM INTERCEPT 
					MINIMUM WITHIN-CLUSTER VARIANCE FOR PREDICTORS: 5% 
					***/
					
*** BOTH SEXES ***
* SIMPLE MODEL
xthybrid suiWun perc_empl_white year, clusterid(nid) vce(robust) randomslope(year) percentage(5) test full
/*
Tests of the random effects assumption:
  _b[B__perc_empl_white] = _b[W__perc_empl_white]; p-value: 0.5759
  _b[B__year] = _b[W__year]; p-value: 0.0000
*/
xthybrid suiWun perc_empl_white year, clusterid(nid) vce(robust) randomslope(year) percentage(5) test full use(year)
est sto simple

* MULTIPLE MODEL
xthybrid suiWun perc_empl_white citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) randomslope(year) percentage(5) test full
/*
Tests of the random effects assumption:
  _b[B__perc_empl_white] = _b[W__perc_empl_white]; p-value: 0.1284
  _b[B__citi6016] = _b[W__citi6016]; p-value: 0.2680
  _b[B__gini] = _b[W__gini]; p-value: 0.6118
  _b[B__povertyrate] = _b[W__povertyrate]; p-value: 0.8059
  _b[B__gdp] = _b[W__gdp]; p-value: 0.2826
  _b[B__perc_snap] = _b[W__perc_snap]; p-value: 0.7306
  _b[B__perc_college] = _b[W__perc_college]; p-value: 0.5338
  _b[B__single_person_hh] = _b[W__single_person_hh]; p-value: 0.0772
  _b[B__sexratio_mf] = _b[W__sexratio_mf]; p-value: 0.5126
  _b[B__binge_drinking] = _b[W__binge_drinking]; p-value: 0.7577
  _b[B__age_under_18] = _b[W__age_under_18]; p-value: 0.0043
  _b[B__age_18_34] = _b[W__age_18_34]; p-value: 0.7875
  _b[B__age_above_64] = _b[W__age_above_64]; p-value: 0.0835
  _b[B__year] = _b[W__year]; p-value: 0.0000
*/
xthybrid suiWun perc_empl_white citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) randomslope(year) percentage(5) test full use(age_under_18 year)
/*
Tests of the random effects assumption:
  _b[B__age_under_18] = _b[W__age_under_18]; p-value: 0.2978
  _b[B__year] = _b[W__year]; p-value: 0.0000
*/
xthybrid suiWun perc_empl_white citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) randomslope(year) percentage(5) test full use(year)
est sto multiple

/*
WALD TEST FOR MODEL IMPROVEMENT 
ESTIMATE THE FULL MODEL
THEN TYPE test FOLLOWED BY THE VARIABLES
WHICH ARE MISSING IN THE SIMPLE MODEL 
*/

quietly: xthybrid suiWun perc_empl_white citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) randomslope(year) percentage(5) test use(year)

test R__citi6016 R__gini R__povertyrate R__gdp R__perc_snap R__perc_college R__avg_hh_size R__hfr R__sexratio_mf R__binge_drinking R__logpop R__lpopdens R__age_under_18 R__age_18_34 R__age_above_64 R__perc_white R__perc_hispanic 

/*
           chi2( 17) =  228.63
         Prob > chi2 =    0.0000

Based on the p-value, we are able to reject the null hypothesis, ... 
meaning that including these variables create a statistically significant 
improvement in the fit of the model.

https://stats.idre.ucla.edu/stata/faq/how-can-i-perform-the-likelihood-ratio-wald-and-lagrange-multiplier-score-test-in-stata/

*/

* CREATE TABLE (http://repec.sowi.unibe.ch/stata/estout/esttab.html)
* set working directory
esttab simple multiple using table_20_0394_both_sexes.rtf, replace b(2) stats(N ll chi2 p aic, fmt(0 2 2 3 2)) wide nogaps addnotes("Level 1: 850 state-years. Level 2: 50 states." "Robust SE clustered by state." "Unless otherwise noted, the coefficients represent random effects.")

*** ONLY MEN ***
* SIMPLE MODEL
xthybrid suiWMun perc_empl_white_men year, clusterid(nid) vce(robust) randomslope(year) percentage(5) test full
/*
Tests of the random effects assumption:
  _b[B__perc_empl_white_men] = _b[W__perc_empl_white_men]; p-value: 0.4413
  _b[B__year] = _b[W__year]; p-value: 0.0000
*/
xthybrid suiWMun perc_empl_white_men year, clusterid(nid) vce(robust) randomslope(year) percentage(5) test full use(year)
est sto simplemen

* MULTIPLE MODEL
xthybrid suiWMun perc_empl_white_men citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) randomslope(year) percentage(5) test full
/*
Tests of the random effects assumption:
  _b[B__perc_empl_white_men] = _b[W__perc_empl_white_men]; p-value: 0.4434
  _b[B__citi6016] = _b[W__citi6016]; p-value: 0.2900
  _b[B__gini] = _b[W__gini]; p-value: 0.7566
  _b[B__povertyrate] = _b[W__povertyrate]; p-value: 0.6205
  _b[B__gdp] = _b[W__gdp]; p-value: 0.2150
  _b[B__perc_snap] = _b[W__perc_snap]; p-value: 0.6502
  _b[B__perc_college] = _b[W__perc_college]; p-value: 0.8509
  _b[B__single_person_hh] = _b[W__single_person_hh]; p-value: 0.0356
  _b[B__sexratio_mf] = _b[W__sexratio_mf]; p-value: 0.2852
  _b[B__binge_drinking] = _b[W__binge_drinking]; p-value: 0.5099
  _b[B__age_under_18] = _b[W__age_under_18]; p-value: 0.0031
  _b[B__age_18_34] = _b[W__age_18_34]; p-value: 0.8338
  _b[B__age_above_64] = _b[W__age_above_64]; p-value: 0.0808
  _b[B__year] = _b[W__year]; p-value: 0.0000
*/
xthybrid suiWMun perc_empl_white_men citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) randomslope(year) percentage(5) test full use(single_person_hh age_under_18 year)
est sto multiplemen

/*
WALD TEST FOR MODEL IMPROVEMENT 
ESTIMATE THE FULL MODEL
THEN TYPE test FOLLOWED BY THE VARIABLES
WHICH ARE MISSING IN THE SIMPLE MODEL 
*/
quietly: xthybrid suiWMun perc_empl_white_men citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) randomslope(year) percentage(5) test use(single_person_hh age_under_18 year)

test R__citi6016 R__gini R__povertyrate R__gdp R__perc_snap R__perc_college R__avg_hh_size R__hfr R__sexratio_mf R__binge_drinking R__logpop R__lpopdens R__age_18_34 R__age_above_64 R__perc_white R__perc_hispanic W__single_person_hh W__age_under_18 B__single_person_hh B__age_under_18
/*

           chi2( 20) =  420.41
         Prob > chi2 =    0.0000

P sig = statistically significant improvement in the fit of the model

*/

* CREATE TABLE (http://repec.sowi.unibe.ch/stata/estout/esttab.html)
* set working directory
esttab simplemen multiplemen using table_20_0394_only_men.rtf, replace b(2) stats(N ll chi2 p aic, fmt(0 2 2 3 2)) wide nogaps addnotes("Level 1: 850 state-years. Level 2: 50 states." "Robust SE clustered by state." "Unless otherwise noted, the coefficients represent random effects.")

*** ONLY WOMEN ***
* SIMPLE MODEL
xthybrid suiWFun perc_empl_white_women year, clusterid(nid) vce(robust) randomslope(year) percentage(5) test full
/*
Tests of the random effects assumption:
  _b[B__perc_empl_white_women] = _b[W__perc_empl_white_women]; p-value: 0.0457
  _b[B__year] = _b[W__year]; p-value: 0.0945
*/
xthybrid suiWFun perc_empl_white_women year, clusterid(nid) vce(robust) percentage(5) test full use(perc_empl_white_women)
/*
Tests of the random effects assumption:
  _b[B__perc_empl_white_women] = _b[W__perc_empl_white_women]; p-value: 0.3454
*/

* BOTH PREDICTORS SHOULD BE R.E., THUS I FIT THE MODEL WITH MEGLM 
* (multilevel mixed-effects generalized linear models)

meglm suiWFun perc_empl_white_women year || nid:, vce(cluster nid)
est sto simplewomen
/*
Mixed-effects GLM                               Number of obs     =        771
Family:                Gaussian
Link:                  identity
Group variable:          nid                 Number of groups  =         50

                                                Obs per group:
                                                              min =          2
                                                              avg =       15.4
                                                              max =         17

Integration method: mvaghermite                 Integration pts.  =          7

                                                Wald chi2(2)      =     422.01
Log pseudolikelihood = -987.98289               Prob > chi2       =     0.0000
                                         (Std. Err. adjusted for 50 clusters in nid)
---------------------------------------------------------------------------------------
                      |               Robust
              suiWFun |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
----------------------+----------------------------------------------------------------
perc_empl_white_women |  -.0396377   .0241519    -1.64   0.101    -.0869746    .0076992
                 year |   .1822186    .012296    14.82   0.000     .1581188    .2063184
                _cons |   -357.306   25.52358   -14.00   0.000    -407.3313   -307.2807
----------------------+----------------------------------------------------------------
nid                   |
            var(_cons)|   2.481169   .4848174                      1.691736    3.638984
----------------------+----------------------------------------------------------------
        var(e.suiWFun)|   .5808184   .0785442                      .4455866    .7570918
---------------------------------------------------------------------------------------
*/

* GET AIC
estat ic
/*
Akaike's information criterion and Bayesian information criterion

-----------------------------------------------------------------------------
       Model |          N   ll(null)  ll(model)      df        AIC        BIC
-------------+---------------------------------------------------------------
           . |        771          .  -987.9829       5   1985.966   2009.204
-----------------------------------------------------------------------------
*/

* DOUBLE-CHECKING: I FIT THE MODEL WITH XTREG, RE ROBUST - VERY SIMILAR RESULTS 
xtset nid year
xtreg suiWFun perc_empl_white_women year, re robust
/*
Random-effects GLS regression                   Number of obs     =        771
Group variable: nid                          Number of groups  =         50

R-sq:                                           Obs per group:
     within  = 0.6189                                         min =          2
     between = 0.1951                                         avg =       15.4
     overall = 0.2752                                         max =         17

                                                Wald chi2(2)      =     425.94
corr(u_i, X)   = 0 (assumed)                    Prob > chi2       =     0.0000

                                         (Std. Err. adjusted for 50 clusters in nid)
---------------------------------------------------------------------------------------
                      |               Robust
              suiWFun |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
----------------------+----------------------------------------------------------------
perc_empl_white_women |  -.0397596   .0243031    -1.64   0.102    -.0873929    .0078736
                 year |   .1821924   .0123884    14.71   0.000     .1579115    .2064733
                _cons |  -357.2466   25.72769   -13.89   0.000     -407.672   -306.8213
----------------------+----------------------------------------------------------------
              sigma_u |  1.5546317
              sigma_e |  .76293465
                  rho |   .8059089   (fraction of variance due to u_i)
---------------------------------------------------------------------------------------
*/

* MULTIPLE MODEL
xthybrid suiWFun perc_empl_white_women citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) randomslope(year) percentage(5) test full
/*
Tests of the random effects assumption:
  _b[B__perc_empl_white_women] = _b[W__perc_empl_white_women]; p-value: 0.0222
  _b[B__citi6016] = _b[W__citi6016]; p-value: 0.2877
  _b[B__gini] = _b[W__gini]; p-value: 0.1921
  _b[B__povertyrate] = _b[W__povertyrate]; p-value: 0.4389
  _b[B__gdp] = _b[W__gdp]; p-value: 0.4098
  _b[B__perc_snap] = _b[W__perc_snap]; p-value: 0.3169
  _b[B__perc_college] = _b[W__perc_college]; p-value: 0.2252
  _b[B__single_person_hh] = _b[W__single_person_hh]; p-value: 0.6036
  _b[B__sexratio_mf] = _b[W__sexratio_mf]; p-value: 0.7392
  _b[B__binge_drinking] = _b[W__binge_drinking]; p-value: 0.6143
  _b[B__age_under_18] = _b[W__age_under_18]; p-value: 0.0218
  _b[B__age_18_34] = _b[W__age_18_34]; p-value: 0.0340
  _b[B__age_above_64] = _b[W__age_above_64]; p-value: 0.0160
  _b[B__year] = _b[W__year]; p-value: 0.6347
*/
xthybrid suiWFun perc_empl_white_women citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) percentage(5) test full use(perc_empl_white_women age_under_18 age_18_34 age_above_64)
/*
Tests of the random effects assumption:
  _b[B__perc_empl_white_women] = _b[W__perc_empl_white_women]; p-value: 0.0030
  _b[B__age_under_18] = _b[W__age_under_18]; p-value: 0.0217
  _b[B__age_18_34] = _b[W__age_18_34]; p-value: 0.2484
  _b[B__age_above_64] = _b[W__age_above_64]; p-value: 0.0030
*/
xthybrid suiWFun perc_empl_white_women citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) percentage(5) test full use(perc_empl_white_women age_under_18 age_above_64)
/*
Tests of the random effects assumption:
  _b[B__perc_empl_white_women] = _b[W__perc_empl_white_women]; p-value: 0.0031
  _b[B__age_under_18] = _b[W__age_under_18]; p-value: 0.0378
  _b[B__age_above_64] = _b[W__age_above_64]; p-value: 0.0005
*/
est sto multiplewomen

/*
WALD TEST FOR MODEL IMPROVEMENT 
ESTIMATE THE FULL MODEL
THEN TYPE test FOLLOWED BY THE VARIABLES
WHICH ARE MISSING IN THE SIMPLE MODEL 
*/
xthybrid suiWFun perc_empl_white_women citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) percentage(5) star test use(perc_empl_white_women age_under_18 age_above_64)
/*
NOTICE: THIS IS NOT ENTIRELY ACCURATE, BUT ALMOST. 
I'M REMOVING ALL THE VARIABLES BUT: R__YEAR AND B_%B_PERC_EMPL_WHITE_WOMEN
THE SIMPLE MODEL HAS R_PERC_EMPL_WHITE_WOMEN, NOT B_PERC_EMPL_WHITE_WOMEN
IF I TRY THIS KEEPING R_PERC_EMPL_WHITE_WOMEN IN THE MULTIPLE MODEL TOO, 
THE RESULT IS SLIGHTLY DIFFERENT BUT CONSISTENT:
chi2( 20) =  281.12
Prob > chi2 =    0.0000
THE TAKEAWAY IS: THE MULTIPLE MODEL IS A SIGNIFICANT IMPROVEMENT. 
*/
test R__citi6016 R__gini R__povertyrate R__gdp R__perc_snap R__perc_college R__single_person_hh R__avg_hh_size R__hfr R__sexratio_mf R__binge_drinking R__logpop R__lpopdens R__age_18_34 R__perc_white R__perc_hispanic W__perc_empl_white_women W__age_under_18 W__age_above_64 B__age_under_18 B__age_above_64
/*
           chi2( 21) =  326.56
         Prob > chi2 =    0.0000

P sig = statistically significant improvement in the fit of the model

*/

* CREATE TABLE (http://repec.sowi.unibe.ch/stata/estout/esttab.html)
* set working directory
esttab simplewomen multiplewomen using table_20_0394_only_women.rtf, replace b(2) stats(N ll chi2 p aic, fmt(0 2 2 3 2)) wide nogaps addnotes("Level 1: 771 state-years. Level 2: 50 states." "Robust SE clustered by state." "Unless otherwise noted, the coefficients represent random effects.")



*** FIGURE 3 ***
set scheme plotplainblind
twoway (scatter suiWun perc_empl_white) (lfit suiWun perc_empl_white, lwidth(thick))
*** more figures ***
twoway (lfit suiWun perc_empl_white if nid<26, by(stateid) lwidth(medthick) ytitle(White Suicide))
twoway (lfit suiWun perc_empl_white if nid>25, by(stateid) lwidth(medthick) ytitle(White Suicide))


*** SENSITIVITY ANALYSES *** 

* male + female

xtreg suiWun perc_empl_white citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, fe robust

est sto state_fixed_effects

xtreg suiWun perc_empl_white citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic i.year, fe robust

est sto state_year_fixed_effects

xtreg suiWun perc_empl_white citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, re robust

est sto random_effects

xthybrid suiWun perc_empl_white citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) randomslope(year) percentage(10) test full use(year)

est sto hybrid_perc_10

coefplot state_fixed_effects state_year_fixed_effects random_effects hybrid_perc_10, keep(perc_empl_white R__perc_empl_white) rename(R__perc_empl_white=perc_empl_white) xline(0) title("Effects on White Suicide Rate") scale(.95)

* male 

estimates clear

xtreg suiWMun perc_empl_white_men citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, fe robust

est sto state_fixed_effects

xtreg suiWMun perc_empl_white_men citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic i.year, fe robust

est sto state_year_fixed_effects

xtreg suiWMun perc_empl_white_men citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, re robust

est sto random_effects

xthybrid suiWMun perc_empl_white_men citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) randomslope(year) percentage(10) test full use(single_person_hh age_under_18 year)

est sto hybrid_perc_10

coefplot state_fixed_effects state_year_fixed_effects random_effects hybrid_perc_10, keep(perc_empl_white_men R__perc_empl_white_men) rename(R__perc_empl_white_men=perc_empl_white_men) xline(0) title("Effects on White Male Suicide Rate") scale(.95) 

* female 

estimates clear

xtreg suiWFun perc_empl_white_women citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, fe robust

est sto state_fixed_effects

xtreg suiWFun perc_empl_white_women citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic i.year, fe robust

est sto state_year_fixed_effects

xtreg suiWFun perc_empl_white_women citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, re robust

est sto random_effects

xthybrid suiWFun perc_empl_white_women citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) percentage(10) test full use(perc_empl_white_women age_above_64)

est sto hybrid_perc_10_WE

xthybrid suiWFun perc_empl_white_women citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year, clusterid(nid) vce(robust) percentage(10) test full use(perc_empl_white_women age_above_64)

est sto hybrid_perc_10_BE

coefplot state_fixed_effects state_year_fixed_effects random_effects (hybrid_perc_10_WE, keep(W__perc_empl_white_women)) (hybrid_perc_10_BE, keep(B__perc_empl_white_women)), keep(perc_empl_white_women) rename(W__perc_empl_white_women=perc_empl_white_women B__perc_empl_white_women=perc_empl_white_women)  xline(0) title("Effects on White Female Male Suicide Rate") scale(.95) 


*** BETA COEF PLOTS ***

use "~/data_20_0394.dta", clear

xtset nid year 

foreach x in suiWun perc_empl_white suiWMun perc_empl_white_men citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year {
	egen z`x' = std(`x')
}

xthybrid zsuiWun zperc_empl_white zciti6016 zgini zpovertyrate zgdp zperc_snap zperc_college zsingle_person_hh zavg_hh_size zhfr zsexratio_mf zbinge_drinking zlogpop zlpopdens zage_under_18 zage_18_34 zage_above_64 zperc_white zperc_hispanic zyear, clusterid(nid) vce(robust) randomslope(zyear) percentage(5) test full use(zyear)

coefplot, keep(R__zperc_empl_white R__zperc_snap R__zlpopdens W__zyear) xline(0) coeflabels(R__zperc_empl_white = "White Employment-to-Pop, RE" R__zperc_snap = "SNAP, RE" R__zlpopdens = "Pop Density, RE" W__zyear = "Year, WE") title("Hybrid Model for White Suicide Rate 2000-16, Beta Coefs") scale(.95) 

xthybrid zsuiWMun zperc_empl_white_men zciti6016 zgini zpovertyrate zgdp zperc_snap zperc_college zsingle_person_hh zavg_hh_size zhfr zsexratio_mf zbinge_drinking zlogpop zlpopdens zage_under_18 zage_18_34 zage_above_64 zperc_white zperc_hispanic zyear, clusterid(nid) vce(robust) randomslope(zyear) percentage(5) test full use(zsingle_person_hh zage_under_18 zyear)

coefplot, keep(R__zperc_empl_white_men R__zhfr R__zlpopdens B__zsingle_person_hh B__zage_under_18 W__zyear) xline(0) coeflabels(R__zperc_empl_white_men= "White Male Employment-to-Pop, RE" R__zhfr="Household Firearm Rate, RE" R__zlpopdens="Pop Density, RE" B__zsingle_person_hh="Single-person Household, BE" B__zage_under_18="Age < 18, BE" W__zyear="Year, WE") order(R__zperc_empl_white_men R__zhfr R__zlpopdens B__zsingle_person_hh B__zage_under_18 W__zyear) title("Hybrid Model for White Male Suicide Rate 2000-16, Beta Coefs") scale(.95) 

use "~/data_20_0394.dta", clear

xtset nid year 

drop if suiWFun == .

foreach x in suiWFun perc_empl_white_women citi6016 gini povertyrate gdp perc_snap perc_college single_person_hh avg_hh_size hfr sexratio_mf binge_drinking logpop lpopdens age_under_18 age_18_34 age_above_64 perc_white perc_hispanic year {
	egen z`x' = std(`x')
}

xthybrid zsuiWFun zperc_empl_white_women zciti6016 zgini zpovertyrate zgdp zperc_snap zperc_college zsingle_person_hh zavg_hh_size zhfr zsexratio_mf zbinge_drinking zlogpop zlpopdens zage_under_18 zage_18_34 zage_above_64 zperc_white zperc_hispanic zyear, clusterid(nid) vce(robust) percentage(5) test full use(zperc_empl_white_women zage_under_18 zage_above_64)

coefplot, xline(0) keep(B__zperc_empl_white_women W__zperc_empl_white_women R__zgdp R__zperc_snap R__zlogpop R__zlpopdens B__zage_under_18 B__zage_above_64 W__zage_above_64 R__zyear) order(B__zperc_empl_white_women W__zperc_empl_white_women R__zgdp R__zperc_snap R__zlogpop R__zlpopdens B__zage_under_18 B__zage_above_64 W__zage_above_64 R__zyear) coeflabels(B__zperc_empl_white_women="White Female Employment-to-Pop, BE" W__zperc_empl_white_women="White Female Employment-to-Pop, WE" R__zgdp="GDP, RE" R__zperc_snap="SNAP, RE" R__zlogpop="Population, RE" R__zlpopdens="Pop Density, RE" B__zage_under_18="Age < 18, BE" B__zage_above_64="Age > 64, BE" W__zage_above_64="Age > 64, WE" R__zyear="Year, RE") title("Hybrid Model for White Female Suicide Rate 2000-16, Beta Coefs") scale(.95) 





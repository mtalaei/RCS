*===============================================================================
*						Shape (RCS: linearity testing - multiple)
*===============================================================================

*========Working directory.
/*hmy431*/ 	cd "C:\Users\"

*========Dataset
use "data\XXX.dta", clear

*========Model
do codes\Models_XXX.do				/*Adjustment models*/
global model_CS "$model_5"			/*Final model*/

**#===RCS: P for any association
*----->Defining
global iff "indicatorXXX==1"		/*if clause*/
local expoli "E1 E2 E3"				/*Exposure list*/
local exrow "B C D"
local outli "O1 O2 O3 O4 O5"		/*Outcome list*/
local knots3="10 50 90"				/*Knots position in percentile (standard: 10 50 90)*/
local knots4="5 35 65 95"			/*Knots position in percentile (standard: 5 35 65 95)*/
local knots5="5 27.5 50 72.5 95"	/*Knots position in percentile (standard: 5 27.5 50 72.5 95)*/
putexcel set outputs\Tables_RCS.xlsx, sheet(RCS_XXX) modify		/*Output file*/
*==Run
putexcel A1="RCS", bold fpattern(solid,gold)
putexcel B1="P for association", bold fpattern(solid,lemonchiffon)
putexcel C1:D1, bold fpattern(solid,lemonchiffon)
putexcel A2="Outcomes", bold 
local n : word count `exrow'
forvalues j = 1/`n' {
local jj : word `j' of `exrow'
local expo_s : word `j' of `expoli'
global expo `expo_s'
local expolbl: variable label ${expo}
putexcel `jj'2="`expolbl'", bold fpattern(solid,lavender)
sleep 1000
local rn = 2
foreach oo in `outli'  {  
local rn = `rn' + 1
local outlbl: variable label `oo'
putexcel A`rn'="`outlbl'", bold 
set more off
display "==============>" `"`oo'"'
local rn = `rn' + 1
putexcel A`rn'="3 knots", txtindent(1) 
_pctile ${expo} if $iff, p(`knots3') 
local knot1 = r(r1)
local knot2 = r(r2)
local knot3 = r(r3)
local knots3ptile="`knot1' `knot2' `knot3'"
mkspline ${expo}_spl=${expo} if $iff, knots(`knot1' `knot2' `knot3') cubic displayknots
mat knots = r(knots)
quietly regress `oo' ${expo}_spl* $model_CS if $iff, cformat(%9.2f) 
testparm ${expo}_spl*  
putexcel `jj'`rn'=`r(p)', nformat(number_d2)
drop ${expo}_spl*
sleep 1000
local rn = `rn' + 1
putexcel A`rn'="4 knots", txtindent(1) 
_pctile ${expo} if $iff, p(`knots4') 
local knot1 = r(r1)
local knot2 = r(r2)
local knot3 = r(r3)
local knot4 = r(r4)
local knots4ptile="`knot1' `knot2' `knot3' `knot4'"
mkspline ${expo}_spl=${expo} if $iff, knots(`knot1' `knot2' `knot3' `knot4') cubic displayknots
mat knots = r(knots)
quietly regress `oo' ${expo}_spl* $model_CS if $iff, cformat(%9.2f) 
testparm ${expo}_spl* 
putexcel `jj'`rn'=`r(p)', nformat(number_d2)
drop ${expo}_spl*
sleep 1000
local rn = `rn' + 1
putexcel A`rn'="5 knots", txtindent(1) 
_pctile ${expo} if $iff, p(`knots5') 
local knot1 = r(r1)
local knot2 = r(r2)
local knot3 = r(r3)
local knot4 = r(r4)
local knot5 = r(r5)
local knots5ptile="`knot1' `knot2' `knot3' `knot4' `knot5'"
mkspline ${expo}_spl=${expo} if $iff, knots(`knot1' `knot2' `knot3' `knot4' `knot5') cubic displayknots
mat knots = r(knots)
quietly regress `oo' ${expo}_spl* $model_CS if $iff, cformat(%9.2f) 
testparm ${expo}_spl*
putexcel `jj'`rn'=`r(p)', nformat(number_d2)
drop ${expo}_spl*
sleep 1000
}
local rn = `rn' + 2
putexcel `jj'`rn'="`knots3'", nformat(number_d2)
local rn = `rn' + 1
putexcel `jj'`rn'="`knots3ptile'", nformat(number_d2)
sleep 1000 
local rn = `rn' + 2
putexcel `jj'`rn'="`knots4'", nformat(number_d2)
local rn = `rn' + 1
putexcel `jj'`rn'="`knots4ptile'", nformat(number_d2)
sleep 1000
local rn = `rn' + 2
putexcel `jj'`rn'="`knots5'", nformat(number_d2)
local rn = `rn' + 1
putexcel `jj'`rn'="`knots5ptile'", nformat(number_d2)
sleep 1000 
}
/*END*/


**#===RCS: AIC
*----->Defining
global iff "indicatorXXX==1"		/*if clause*/
local expoli "E1 E2 E3"				/*Exposure list*/
local exrow "H I J"
local outli "O1 O2 O3 O4 O5"		/*Outcome list*/
local knots3="10 50 90"				/*Knots position in percentile (standard: 10 50 90)*/
local knots4="5 35 65 95"			/*Knots position in percentile (standard: 5 35 65 95)*/
local knots5="5 27.5 50 72.5 95"	/*Knots position in percentile (standard: 5 27.5 50 72.5 95)*/
putexcel set outputs\Tables_RCS.xlsx, sheet(RCS_Chi) modify		/*Output file*/
*==Run
putexcel G1="RCS", bold fpattern(solid,gold)
putexcel H1="AIC", bold fpattern(solid,turquoise)
putexcel I1:J1, bold fpattern(solid,turquoise)
putexcel G2="Outcomes", bold 
local n : word count `exrow'
forvalues j = 1/`n' {
local jj : word `j' of `exrow'
local expo_s : word `j' of `expoli'
global expo `expo_s'
local expolbl: variable label ${expo}
putexcel `jj'2="`expolbl'", bold fpattern(solid,lavender)
sleep 1000
local rn = 2
foreach oo in `outli'  {  
local rn = `rn' + 1
local outlbl: variable label `oo'
putexcel G`rn'="`outlbl'", bold 
set more off
display "==============>" `"`oo'"'
local rn = `rn' + 1
putexcel G`rn'="3 knots", txtindent(1) 
_pctile ${expo} if $iff, p(`knots3') 
local knot1 = r(r1)
local knot2 = r(r2)
local knot3 = r(r3)
local knots3ptile="`knot1' `knot2' `knot3'"
mkspline ${expo}_spl=${expo} if $iff, knots(`knot1' `knot2' `knot3') cubic displayknots
mat knots = r(knots)
quietly regress `oo' ${expo}_spl* $model_CS if $iff, cformat(%9.2f) 
estat ic
matrix mtx= r(S)
putexcel `jj'`rn'=mtx[1,5], nformat(number_d2)
drop ${expo}_spl*
sleep 1000
local rn = `rn' + 1
putexcel G`rn'="4 knots", txtindent(1) 
_pctile ${expo} if $iff, p(`knots4') 
local knot1 = r(r1)
local knot2 = r(r2)
local knot3 = r(r3)
local knot4 = r(r4)
local knots4ptile="`knot1' `knot2' `knot3' `knot4'"
mkspline ${expo}_spl=${expo} if $iff, knots(`knot1' `knot2' `knot3' `knot4') cubic displayknots
mat knots = r(knots)
quietly regress `oo' ${expo}_spl* $model_CS if $iff, cformat(%9.2f) 
estat ic
matrix mtx= r(S)
putexcel `jj'`rn'=mtx[1,5], nformat(number_d2)
drop ${expo}_spl*
sleep 1000
local rn = `rn' + 1
putexcel G`rn'="5 knots", txtindent(1) 
_pctile ${expo} if $iff, p(`knots5') 
local knot1 = r(r1)
local knot2 = r(r2)
local knot3 = r(r3)
local knot4 = r(r4)
local knot5 = r(r5)
local knots5ptile="`knot1' `knot2' `knot3' `knot4' `knot5'"
mkspline ${expo}_spl=${expo} if $iff, knots(`knot1' `knot2' `knot3' `knot4' `knot5') cubic displayknots
mat knots = r(knots)
quietly regress `oo' ${expo}_spl* $model_CS if $iff, cformat(%9.2f) 
estat ic
matrix mtx= r(S)
putexcel `jj'`rn'=mtx[1,5], nformat(number_d2)
drop ${expo}_spl*
sleep 1000
}
local rn = `rn' + 2
putexcel `jj'`rn'="`knots3'", nformat(number_d2)
local rn = `rn' + 1
putexcel `jj'`rn'="`knots3ptile'", nformat(number_d2)
sleep 1000 
local rn = `rn' + 2
putexcel `jj'`rn'="`knots4'", nformat(number_d2)
local rn = `rn' + 1
putexcel `jj'`rn'="`knots4ptile'", nformat(number_d2)
sleep 1000
local rn = `rn' + 2
putexcel `jj'`rn'="`knots5'", nformat(number_d2)
local rn = `rn' + 1
putexcel `jj'`rn'="`knots5ptile'", nformat(number_d2)
sleep 1000 
}
/*END*/


**#===RCS: P for non-linearity
*----->Defining
global iff "indicatorXXX==1"		/*if clause*/
local expoli "E1 E2 E3"				/*Exposure list*/
local exrow "N O P"
local outli "O1 O2 O3 O4 O5"		/*Outcome list*/
local knots3="10 50 90"				/*Knots position in percentile (standard: 10 50 90)*/
local knots4="5 35 65 95"			/*Knots position in percentile (standard: 5 35 65 95)*/
local knots5="5 27.5 50 72.5 95"	/*Knots position in percentile (standard: 5 27.5 50 72.5 95)*/
putexcel set outputs\Tables_RCS.xlsx, sheet(RCS_Chi) modify		/*Output file*/
*==Run
putexcel M1="RCS", bold fpattern(solid,gold)
putexcel N1="P for non-linearity", bold fpattern(solid,thistle)
putexcel O1:P1, bold fpattern(solid,thistle)
putexcel M2="Outcomes", bold 
local n : word count `exrow'
forvalues j = 1/`n' {
local jj : word `j' of `exrow'
local expo_s : word `j' of `expoli'
global expo `expo_s'
local expolbl: variable label ${expo}
putexcel `jj'2="`expolbl'", bold fpattern(solid,lavender)
sleep 1000
local rn = 2
foreach oo in `outli'  {  
local rn = `rn' + 1
local outlbl: variable label `oo'
putexcel M`rn'="`outlbl'", bold 
set more off
display "==============>" `"`oo'"'
local rn = `rn' + 1
putexcel M`rn'="3 knots", txtindent(1) 
_pctile ${expo} if $iff, p(`knots3') 
local knot1 = r(r1)
local knot2 = r(r2)
local knot3 = r(r3)
local knots3ptile="`knot1' `knot2' `knot3'"
mkspline ${expo}_spl=${expo} if $iff, knots(`knot1' `knot2' `knot3') cubic displayknots
mat knots = r(knots)
quietly regress `oo' ${expo}_spl* $model_CS if $iff, cformat(%9.2f) 
testparm ${expo}_spl2  
putexcel `jj'`rn'=`r(p)', nformat(number_d2)
drop ${expo}_spl*
sleep 1000
local rn = `rn' + 1
putexcel M`rn'="4 knots", txtindent(1) 
_pctile ${expo} if $iff, p(`knots4') 
local knot1 = r(r1)
local knot2 = r(r2)
local knot3 = r(r3)
local knot4 = r(r4)
local knots4ptile="`knot1' `knot2' `knot3' `knot4'"
mkspline ${expo}_spl=${expo} if $iff, knots(`knot1' `knot2' `knot3' `knot4') cubic displayknots
mat knots = r(knots)
quietly regress `oo' ${expo}_spl* $model_CS if $iff, cformat(%9.2f) 
testparm ${expo}_spl2 ${expo}_spl3 
putexcel `jj'`rn'=`r(p)', nformat(number_d2)
drop ${expo}_spl*
sleep 1000
local rn = `rn' + 1
putexcel M`rn'="5 knots", txtindent(1) 
_pctile ${expo} if $iff, p(`knots5') 
local knot1 = r(r1)
local knot2 = r(r2)
local knot3 = r(r3)
local knot4 = r(r4)
local knot5 = r(r5)
local knots5ptile="`knot1' `knot2' `knot3' `knot4' `knot5'"
mkspline ${expo}_spl=${expo} if $iff, knots(`knot1' `knot2' `knot3' `knot4' `knot5') cubic displayknots
mat knots = r(knots)
quietly regress `oo' ${expo}_spl* $model_CS if $iff, cformat(%9.2f) 
testparm ${expo}_spl2 ${expo}_spl3 ${expo}_spl4
putexcel `jj'`rn'=`r(p)', nformat(number_d2)
drop ${expo}_spl*
sleep 1000
}
local rn = `rn' + 2
putexcel `jj'`rn'="`knots3'", nformat(number_d2)
local rn = `rn' + 1
putexcel `jj'`rn'="`knots3ptile'", nformat(number_d2)
sleep 1000 
local rn = `rn' + 2
putexcel `jj'`rn'="`knots4'", nformat(number_d2)
local rn = `rn' + 1
putexcel `jj'`rn'="`knots4ptile'", nformat(number_d2)
sleep 1000
local rn = `rn' + 2
putexcel `jj'`rn'="`knots5'", nformat(number_d2)
local rn = `rn' + 1
putexcel `jj'`rn'="`knots5ptile'", nformat(number_d2)
sleep 1000 
}
/*END*/

*===============================================================================
**#					RCS: linearity testing - linear regression - multiple
*===============================================================================
*Notes:
*	Linear regressions with a flexible number and positions of knots for multiple associations
*	standard knot positions: 3K-> 10 50 90, 4K-> 5 35 65 95, 5K-> 5 27.5 50 72.5 95
*	'if' must be included in the 'if clause', otherwise you get an error, but it can be empty. 
*	Columns should match number of exposures: B C & H I & N O for two exposures; see ReadMe

*========Working directory.
/*Work*/ 	cd "C:\Users\"

*========Dataset
use "data\XXX.dta", clear

*========Model
macro drop _all
do codes\Models_XXX.do						//Adjustment models
global model_CS "$model_5"					//Final model

**#===P for any association
*----->Defining
global iff //if indicatorXXX==1				//if clause
local expoli //E1 E2 E3						//Exposures list
local exrow B C D							//Columns
local outli //O1 O2 O3 O4 O5				//Outcomes list
local knots3 10 50 90						//Positions of Knots: 3
local knots4 5 35 65 95						//Positions of Knots: 4
local knots5 5 27.5 50 72.5 95				//Positions of Knots: 5
putexcel set outputs\Tables_RCS.xlsx, sheet(RCS_XXX) open modify	//Output file & sheet
*----->Run
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
	local rn = 2
	foreach oo in `outli'  {  
		local rn = `rn' + 1
		local outlbl: variable label `oo'
		putexcel A`rn'="`outlbl'", bold 
		set more off
		display _n "==============>" "`expolbl'" " —— " "`outlbl'"
		forv nk=3/5 {
			local rn = `rn' + 1
			putexcel A`rn'="`nk' knots", txtindent(1) 
			_pctile ${expo} $iff, p(`knots`nk'') 
			local knotn ""
			quietly forv i=1/`nk' {
				local knot`i' : display %6.3g r(r`i')
				local knotn `knotn' `knot`i''
			}
		local knots`nk'ptile="`knotn'"
		mkspline ${expo}_spl=${expo} $iff, knots(`knotn') cubic displayknots
		mat knots = r(knots)
		quietly regress `oo' ${expo}_spl* $model_CS $iff, cformat(%9.2f)
		di _n " N included in the analysis:	 " `e(N)'
		testparm ${expo}_spl*  
		putexcel `jj'`rn'=`r(p)', nformat(number_d2)
		drop ${expo}_spl*
	}
	}
	local rn = `rn' + 2
	putexcel `jj'`rn'="`knots3'", nformat(number_d2)
	local rn = `rn' + 1
	putexcel `jj'`rn'="`knots3ptile'", nformat(number_d2)
	local rn = `rn' + 2
	putexcel `jj'`rn'="`knots4'", nformat(number_d2)
	local rn = `rn' + 1
	putexcel `jj'`rn'="`knots4ptile'", nformat(number_d2)
	local rn = `rn' + 2
	putexcel `jj'`rn'="`knots5'", nformat(number_d2)
	local rn = `rn' + 1
	putexcel `jj'`rn'="`knots5ptile'", nformat(number_d2)
	sleep 1000 
}
putexcel save
di _n "Adjustment Model:" _n "${model_CS}"
/*END*/


**#===AIC
*----->Defining
global iff //if indicatorXXX==1				//if clause
local expoli //E1 E2 E3						//Exposures list
local exrow H I J							//Columns
local outli //O1 O2 O3 O4 O5				//Outcomes list
local knots3 10 50 90						//Positions of Knots: 3
local knots4 5 35 65 95						//Positions of Knots: 4
local knots5 5 27.5 50 72.5 95				//Positions of Knots: 5
putexcel set outputs\Tables_RCS.xlsx, sheet(RCS_XXX) open modify	//Output file & sheet
*----->Run
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
	local rn = 2
	foreach oo in `outli'  {  
		local rn = `rn' + 1
		local outlbl: variable label `oo'
		putexcel G`rn'="`outlbl'", bold 
		set more off
		display _n "==============>" "`expolbl'" " —— " "`outlbl'"
		forv nk=3/5 {
			local rn = `rn' + 1
			putexcel G`rn'="`nk' knots", txtindent(1) 
			_pctile ${expo} $iff, p(`knots`nk'') 
			local knotn ""
			quietly forv i=1/`nk' {
				local knot`i' : display %6.3g r(r`i')
				local knotn `knotn' `knot`i''
			}
		local knots`nk'ptile="`knotn'"
		mkspline ${expo}_spl=${expo} $iff, knots(`knotn') cubic displayknots
		mat knots = r(knots)
		quietly regress `oo' ${expo}_spl* $model_CS $iff, cformat(%9.2f)
		di _n " N included in the analysis:	 " `e(N)'
		estat ic
		matrix mtx= r(S)
		local aic = round(mtx[1,5],0.01)
		putexcel `jj'`rn'=`aic', nformat(number_d2)
		drop ${expo}_spl*
	}
	}
	local rn = `rn' + 2
	putexcel `jj'`rn'="`knots3'", nformat(number_d2)
	local rn = `rn' + 1
	putexcel `jj'`rn'="`knots3ptile'", nformat(number_d2)
	local rn = `rn' + 2
	putexcel `jj'`rn'="`knots4'", nformat(number_d2)
	local rn = `rn' + 1
	putexcel `jj'`rn'="`knots4ptile'", nformat(number_d2)
	local rn = `rn' + 2
	putexcel `jj'`rn'="`knots5'", nformat(number_d2)
	local rn = `rn' + 1
	putexcel `jj'`rn'="`knots5ptile'", nformat(number_d2)
	sleep 1000 
}
putexcel save
di _n "Adjustment Model:" _n "${model_CS}"
/*END*/


**#===P for non-linearity
*----->Defining
global iff //if indicatorXXX==1				//if clause
local expoli //E1 E2 E3						//Exposures list
local exrow N O P							//Columns
local outli //O1 O2 O3 O4 O5				//Outcomes list
local knots3 10 50 90						//Positions of Knots: 3
local knots4 5 35 65 95						//Positions of Knots: 4
local knots5 5 27.5 50 72.5 95				//Positions of Knots: 5
putexcel set outputs\Tables_RCS.xlsx, sheet(RCS_XXX) open modify	//Output file & sheet
*----->Run
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
	local rn = 2
	foreach oo in `outli'  {  
		local rn = `rn' + 1
		local outlbl: variable label `oo'
		putexcel M`rn'="`outlbl'", bold 
		set more off
		display _n "==============>" "`expolbl'" " —— " "`outlbl'"
		forv nk=3/5 {
			local rn = `rn' + 1
			putexcel M`rn'="`nk' knots", txtindent(1) 
			_pctile ${expo} $iff, p(`knots`nk'') 
			local knotn ""
			quietly forv i=1/`nk' {
				local knot`i' : display %6.3g r(r`i')
				local knotn `knotn' `knot`i''
			}
		local knots`nk'ptile="`knotn'"
		mkspline ${expo}_spl=${expo} $iff, knots(`knotn') cubic displayknots
		mat knots = r(knots)
		quietly regress `oo' ${expo}_spl* $model_CS $iff, cformat(%9.2f)
		di _n " N included in the analysis:	 " `e(N)'
		local nkm1 = `nk' - 1
		local splist ""
		quietly forv i=2/`nkm1' {
			local splist `splist' ${expo}_spl`i'
		}
		testparm `splist'				
		putexcel `jj'`rn'=`r(p)', nformat(number_d2)
		drop ${expo}_spl*
	}
	}
	local rn = `rn' + 2
	putexcel `jj'`rn'="`knots3'", nformat(number_d2)
	local rn = `rn' + 1
	putexcel `jj'`rn'="`knots3ptile'", nformat(number_d2)
	local rn = `rn' + 2
	putexcel `jj'`rn'="`knots4'", nformat(number_d2)
	local rn = `rn' + 1
	putexcel `jj'`rn'="`knots4ptile'", nformat(number_d2)
	local rn = `rn' + 2
	putexcel `jj'`rn'="`knots5'", nformat(number_d2)
	local rn = `rn' + 1
	putexcel `jj'`rn'="`knots5ptile'", nformat(number_d2)
	sleep 1000 
}
putexcel save
di _n "Adjustment Model:" _n "${model_CS}"
/*END*/

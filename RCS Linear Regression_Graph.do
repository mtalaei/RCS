*=============================================================================== 
**#					RCS Graph: Linear Regression 
*===============================================================================
*Notes:
*	Linear regressions with a flexible number and positions of knots 
*	Standard knot positions: 3K-> 10 50 90, 4K-> 5 35 65 95, 5K-> 5 27.5 50 72.5 95
*	No. & positions of knots must be consistent 
*	Please read the accompanying README for guidance before running this script.

*========Working directory.
/*Work*/ 	cd "C:\Users\"

*========Dataset
use "data\XXX.dta", clear

*========Model
graph drop _all
macro drop _all
do codes\Models_XXX.do						//Adjustment models
global model_CS "$model_5"					//Final model

*----->Defining
global expo //EE							//Exposure
local ref_ptile //15						//Reference level in %ile
local nk //4								//No. of Knots
local knots 5 35 65 95						//Position of knots in %ile
global out //OO								//Outcome: OO
global iff //if indicatorXXX==1				//if clause
*----->Run
replace ${expo} = float(${expo})
global expolbl: variable label ${expo}		
global outlbl: variable label ${out}	
_pctile ${expo} $iff, p(`knots') 
quietly forv i=1/`nk' {
	local knot`i' : display %6.3g r(r`i')
	local knotn `knotn' `knot`i''
}
mkspline ${expo}_spl=${expo} $iff, knots(`knotn') cubic displayknots
mat knots = r(knots)
regress ${out} ${expo}_spl* $model $iff, cformat(%9.2f) 
local nn=e(N)
testparm ${expo}_spl* 				
local poa=round(r(p), 0.001)
local nkm1 = `nk' - 1
quietly forv i=2/`nkm1' {
	local splist `splist' ${expo}_spl`i'
}
testparm `splist' 				
local pnl=round(r(p), 0.001) 
_pctile ${expo}, p(`ref_ptile')
local p_temp = r(r1)
gen diff=abs(${expo}-`p_temp')
gsort diff
local ref = ${expo}[_n==1]
quietly levelsof ${expo}
quietly xbrcspline ${expo}_spl, values(`r(levels)') ref(`ref') matknots(knots) gen(con hr lb ub)
_pctile ${expo}, p(0.1 99.9)				//To drop extremes//
local cut_lo = r(r1)
local cut_hi = r(r2)
sum ${expo} $iff, d
local med=r(p50)
*----->Graph
twoway  ///
|| (line lb ub hr con if inrange(con,`cut_lo',`cut_hi'), ///
	lp(- - l) lc(cranberry*0.6 cranberry*0.6 maroon) yaxis(1)), ///
	scheme(s1mono) ylabel(-8(2)10, angle(horiz) format(%2.1fc) ) ///			//Y1 scale
	xlabel(-3(0.5)2, format(%9.1fc)) ytitle("${outlbl} mean difference") ///	//X scale
	xtitle("${expolbl}", margin(medsmall)) ///
	xline(`med', lc(blue*0.4) lw(thin) lp(shortdash))  ///
	yline(0, lc(gs12) lw(thin)) plotregion(lcolor(none)) ///
	legend(cols(1) region(fcolor(white) lcolor(none)) position(1) ring(0) ///
	order( 2 "Upper and lower band 95% CI" 3 "Regression coefficient (β)") size(small)) ///
	text(11 `med' "Median", place(c) size(vsmall) color(gs3) ///				//Median
	box bcolor(white) margin(t+5 b+1)) ///										//Median
|| (hist ${expo} if inrange(${expo},`cut_lo',`cut_hi'), ///
	percent bin(21) lwidth(vthin) yaxis(2) fcolor(none) /// 
	lcolor(gs12) ytitle("Proportion of Population (%)", ///
	axis(2)) ylabel(0(5)40, axis(2) angle(horiz) format(%2.0fc))) 				//Y2 scale
drop ${expo}_spl* diff con hr lb ub
di ""	////
	_newline "${expolbl} —— ${outlbl} "      				///
	_newline " Knots position:        	 " "`knotn'"  	///
	_newline " Reference value: 		" " Percentile " `ref_ptile' " (" %4.2f `ref' ")" ///
	_newline " P for overall association: 	" `poa'   	///
	_newline " P for non-linearity: 	" `pnl'			///
	_newline " N included in the analysis:	 " `nn'

graph save Graph "outputs\graphs\RCS_EE-OO.gph", replace 						//Graph name
graph export "outputs\graphs\RCS_EE-OO.tif", replace width(1500)

/*		*/ 

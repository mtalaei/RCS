*===============================================================================
**#					RCS Estimation: Specific values
*===============================================================================
/*Notes: 	To translate the estimated curve into a set of values corresponding 
			to two specific values of exposure: Value of interest vs a reference */
*====Working directory.
/*hmy431*/ 	cd "C:\Users\hmy431\Queen Mary, University of London\MRC_ToxicMetals - Documents\DASH"

*========Dataset
use "data\DASH_W3_metals_health_survey_M.dta", clear
macro drop _all

do codes\Models_DASH_FER.do
global model "$model_4" 

/*Finding the actual values
global expo PbμgL								//Exposure: EE
replace ${expo}=round(${expo},0.01)				//Refining exposure if needed
list ${expo} if ${expo}>5 & ${expo}<6 */
 
*Mrgin  										-5 from Median  
*----->Defining
global expo //EE								//Exposure: EE
local nk //3									//No. of Knots
local knots 10 50 90							//Position of knots in %ile
global out //OO									//Outcome: OO
local ref //10.75								//Reference value, must exist
local val //5.78								//Value of interest, must exist
global iff //if indicatorXXX==1					//if clause
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
set more off									
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
xblc ${expo}_spl*, covname(${expo}) at(`val') reference(`ref')
di ""	////
	_newline "${expolbl} —— ${outlbl} "      				///
	_newline " Knots position:        	 " "`knotn'"  	///
	_newline " P for overall association: 	 " %4.3f `poa'   	///
	_newline " P for non-linearity: 	 " %4.3f `pnl'			///
	_newline " N included in the analysis:	 " `nn'		///
	_newline " Reference value: 		 "   `ref'  ///
	_newline " Comparison value: 		 "   `val'  /// 
	_newline " Estimate (95% CI): 		 "  %4.2f `r(estimate)' " ("  %4.2f `r(lb)' ", "  %4.2f `r(ub)' ")" ///
	_newline " 	  P-value: 		 " %4.3f `r(p)'
drop lAsμgL_spl? diff cdiff
	

*===============================================================================
**#					RCS Estimation: Percentiles
*===============================================================================
/*Notes: 	To translate the estimated curve into a set of values corresponding 
			to a change in exposure vs a percentile value as a reference */

*========Working directory.
/*Work*/ 	cd "C:\Users\"

*========Dataset
use "data\XXX.dta", clear

*========Model
graph drop _all
macro drop _all
do codes\Models_XXX.do					
global model "$model_5"	

/*Check percentile of a value
local expo //EE									//Exposure: EE
local tval //VV  								//Target value: VV
local iff //if indicatorXXX==1					//if clause
sum `expo' `iff'
local total = r(N)
count if `expo' <= `tval'
local ptile = 100 * (`r(N)' / `total')
local noabv= `total' - `r(N)'
display _n "Percentile for `tval': " %4.1f `ptile' "%" _n "No. ≤: " `r(N)' _n "No. >: " `noabv' _n "Total: " `total'		*/
 
*=Mrgin  										-5 from Median
*----->Defining
global expo //EE								//Exposure: EE
local nk //3									//No. of Knots
local knots 10 50 90							//Position of knots in %ile
global out //OO									//Outcome: OO
local ref_ptile //50							//Reference level, percentile
local change //-5								//Change of interest, actual scale
global iff //if indicatorXXX==1					//if clause
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
set more off									
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
tempvar cdiff
local p_temp2= `ref'+`change' 
gen cdiff=abs(${expo}-`p_temp2')
gsort cdiff
local val = ${expo}[_n==1]
xblc ${expo}_spl*, covname(${expo}) at(`val') reference(`ref')
di ""	////
	_newline "${expolbl} —— ${outlbl} "      				///
	_newline " Knots position:        	 " "`knotn'"  	///
	_newline " P for overall association: 	 " %4.3f `poa'   	///
	_newline " P for non-linearity: 	 " %4.3f `pnl'			///
	_newline " N included in the analysis:	 " `nn'		///
	_newline " Reference value: 		 " `ref'  ///
	_newline " Comparison value: 	  	 " `val'  /// 
	_newline " Estimate (95% CI): 		 " %4.2f `r(estimate)' " ("  %4.2f `r(lb)' ", "  %4.2f `r(ub)' ")" ///
	_newline " 	  P-value: 		 " %4.3f `r(p)'
drop lAsμgL_spl? diff cdiff

	
*===============================================================================
**#					RCS Estimation: Percentiles-Excel
*===============================================================================
/*Notes: 	To translate the estimated curve into a set of values corresponding 
			to a change in exposure vs a percentile value as a reference, and
			exporting the output to an Excel file.*/

*========Working directory.
/*Work*/ 	cd "C:\Users\"

*========Dataset
use "data\XXX.dta", clear

*========Model
graph drop _all
macro drop _all
do codes\Models_XXX.do					
global model "$model_5"				
			
*========Excel
putexcel set outputs\Tables_RCS_temp.xlsx, sheet(Margin_5) modify
 
*=Mrgin  										-5 from Median  		
*----->Defining
global expo //EE								//Exposure: EE
local nk //3									//No. of Knots
local knots 10 50 90							//Position of knots in %ile
global out //OO									//Outcome: OO
local ref_ptile //50							//Reference level, percentile
local change //-5								//Change of interest, actual scale
global iff //if indicatorXXX==1					//if clause
local rw //2									//Row in Excel (+1)
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
set more off									
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
tempvar cdiff
local p_temp2= `ref'+`change' 
gen cdiff=abs(${expo}-`p_temp2')
gsort cdiff
local val = ${expo}[_n==1]
xblc ${expo}_spl*, covname(${expo}) at(`val') reference(`ref')
local BetaCI : display %4.2f `r(estimate)' " ("  %4.2f `r(lb)' ","  %4.2f `r(ub)' ")"
putexcel A1="Exposure" B1="Reference value" C1="Comparison vlaue"  ///
	D1="Outcome" E1="β (95% CI)" F1="P-value" G1="N" H1="P for overall association" ///
	I1="P for non-linearity", bold fpattern(solid,gold)
putexcel A`rw' = "${expolbl}" B`rw' = `ref' C`rw' = `val' D`rw' ="${outlbl}" ///
	E`rw' = "`BetaCI'" F`rw' = `r(p)' G`rw' = `nn' H`rw' = `poa' I`rw' = `pnl', names nformat(number_d2) 
drop lAsμgL_spl? diff cdiff

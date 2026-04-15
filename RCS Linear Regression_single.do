*===============================================================================
**#					RCS: linearity testing - linear regression - single
*===============================================================================
*Notes:
*	Linear regression with a flexible number and positions of knots for a single association
*	Standard positions of knots: 3K-> 10 50 90, 4K-> 5 35 65 95, 5K-> 5 27.5 50 72.5 95
*	If clause should not be empty, if nothing: !missing(`oo')

*========Working directory.
/*Work*/ 	cd "C:\Users\"

*========Dataset
use "data\XXX.dta", clear

*========Model
do codes\Models_XXX.do				//Adjustment models//
global model_CS "$model_3"			//Final model//

**#===EE-OO association
global model_CS "$model_3"
*----->Defining
gen EEm = round(EE, 0.01)			//Exposure: EE//
local oo "OO"						//Outcome: OO//
global iff "indicatorXXX==1"		//if clause//
local nk "4"						//Number of Knots//
local knots="5 35 65 95"			//Positions of Knots//
*----->Run
local outlbl: variable label `oo'
_pctile EEm if $iff, p(`knots') 
quietly forv i=1/`nk' {
	local knot`i' : display %9.3g r(r`i')
	local knotn `knotn' `knot`i''
}
mkspline EEm_spl=EEm if $iff, knots(`knotn') cubic displayknots
mat knots = r(knots)
regress `oo' EEm_spl* $model_CS if $iff, cformat(%9.2f) 
local nn=e(N)
estat ic
matrix mtx= r(S)
local aic = round(mtx[1,5],0.01)
testparm EEm_spl* 				
local poa=round(r(p), 0.001)
local nkm1 = `nk' - 1
quietly forv i=2/`nkm1' {
	local EEm_spl `EEm_spl' EEm_spl`i'
}
testparm `EEm_spl' 				
local pnl=round(r(p), 0.001) 
drop EEm_spl* EEm
di " "    	///
 _newline "========================================RCS report: `oo'"  ///
 _newline "Knots position:	          " "`knotn'"   ///
 _newline "N included in the analysis: 	  " `nn'    ///
 _newline "AIC: 	                  " `aic'   	///
 _newline "P for overall association:	 " `poa'    ///
 _newline "P for non-linearity:	 	 " `pnl'	

# RCS
Restricted Cubic Spline (RCS) in Stata

Files
RCS Linear Regression		Testing non-linearity for continuous outcome variables

Explanations
These codes test non-linearity between multiple continuous exposure variables and multiple outcomes in multivariable models in Stata. For each exposure-outcome set, three blocks of codes should be run separately, which produce three items per association: 
1)	P for any association
Only suitable when there is no evidence of a non-linear association (item 3).
2)	AIC for the model 
To compare model fit with different numbers of knots (3, 4, and 5 knots). The model with the lowest AIC value has the best fit and should be used. 
3)	P for a non-linear association 
It is the ultimate product of these codes, in which the evidence of a non-linear association is explored. 
The output Excel file is organised with exposure variables in columns and outcome variables in rows, in three blocks (column sets) corresponding to the three items explained above, all in a single sheet. For example, it currently has three hypothetical exposure variables (E1-E3) and 5 hypothetical outcome variables (O1-O5); therefore, the three blocks explained above will each have three columns, separated by an empty column. 
The section above titled “*==Run” needs to be adjusted to your needs. These changes should be identical across the three blocks of code, except for the column letters for exposures. It means that the ‘if clauses’, exposure and outcome variable lists, etc., must be the same, but columns corresponding to exposures need to move forward (B C D, H I J, and N O P for three exposure variables).
The ‘if clause’ must be defined even if none is necessary. In that case, you can use a covariate without missing as an indicator [e.g. !missing(age)]. 
If you aim to use standard knot positions (3, 4, and 5 default knots), you don’t need to change anything. If you want to explore alternative knots (modified), they should be produced in a separate sheet (by adding _m to the sheet name). If all results are needed in a single sheet (e.g., to compare AICs), you can merge the two sheets by manually adding the products of the alternative knots to the Excel sheet for default knots (in the S1 cell if there are three exposure variables).
Finally, modify the last line before “*==Run” (putexcle command) by defining the Excel file name and sheet. Don’t forget that this must be identical in the three blocks. 
The “*==Run” line is a flag; you should run the codes from “*----->Defining” to “/*END*/” for each block (it will not work correctly if you run the section after “*==Run” separately). 

Errors
1.	Can happen when saving outputs takes longer than the cycle time. You can save your output on a local drive (not synchronised by OneDrive, etc.), disconnect your computer from the internet, or increase the sleep command. 
2.	Convergence issue: You need to explore the problem manually. Usually, you need to amend the multivariable model, such as using a simpler one. 


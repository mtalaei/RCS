# RCS automated 
Restricted Cubic Spline (RCS) in Stata

**RCS Linear Regression_single**	-	
Testing non-linearity in the association between a continuous exposure and a continuous outcome in a linear regression model 

*Explanations*:
It is totally flexible in the number of knots and their positions (in percentile terms). 
After defining the adjustment model, the following items need to be defined: Exposure (EE), Outcome (OO), if clause, number of Knots, and Knot positions. 
 
1. The working directory path refers to a folder containing ‘codes’ and ‘outputs’ folders. The outputs folder may include a ‘graphs’ folder.
2. Model: The adjustment models may be organised in another do file in an accumulative, stepwise manner (e.g., from model 1 to model 5). It calls all models first, then you choose the model of your choice, which is labelled here as the final model (the main adjusting model). Instead, you can define your model by replacing ‘$model_5’ with a covariate list.
3. Most changes are needed from ‘----->Defining’ to the ‘----->Run’, where the following items need to be defined: Exposure variable (EE), outcome variable (OO), if-clause, number of Knots (usually 3, 4, or 5) and their position in percentiles (standard positions are provided within the do file).
4. If there is no indicator to be used as an if clause, it should be !missing(`oo')
5. The number of Knots and positions should be consistent; if 4 knots are defined, there should be four positions defined in the line below.
   standard knot positions:<br>
     (3): 10 50 90<br>
     (4): 5 35 65 95<br>
     (5): 5 27.5 50 72.5 95<br>
6. The “----->Run” line is a flag indicating that there is usually no need to change code from that point onwards. <br>
<br>

**RCS Graph Linear Regression** -
RCS Graph Linear Regression – To draw an RCS curve association between a continuous exposure and a continuous outcome in a linear regression model.

*Explanations:* 
The number of knots and their positions (in percentiles) are flexibly defined at the beginning of the code, and there is no need to change most of the other lines, except for graph particulars and file names. It produces a report on analysis choices and outputs (P-values) in addition to the graph. 
1.	The working directory path refers to a folder containing ‘codes’ and ‘outputs’ folders. The outputs folder may include a ‘graphs’ folder.
2.	Model: The adjustment models may be organised in another do file in an accumulative, stepwise manner (e.g., from model 1 to model 5). It calls all models first, then you choose the model of your choice, which is labelled here as the final model (the main adjusting model). Instead, you can define your model by replacing ‘$model_5’ with a covariate list. 
3.	Most changes are needed from ‘----->Defining’ to the ‘----->Run’, where the following items need to be defined: Exposure variable (EE), reference level in percentile (like 50), number of Knots (usually 3, 4, or 5) and their position in percentile (standard positions are provided within the do file), outcome variable (OO), and if-clause.
4.	If-clause: The ‘if clause’ must be defined even if none is necessary. In that case, you can use outcome as an indicator [by replacing ‘indicatorXXX==1’ with ‘!missing(${out})’]. The best practice is to define an indicator variable that reflects the inclusion and exclusion criteria. 
5.	The ‘----->Run’ line is a flag indicating that there is usually no need to change code from that point onwards. You should run all the code from ‘----->Defining’ to where you save the graph files at the end. You can leave the two final lines for saving graph files until you are fully satisfied with the graph.  
6.	The labels of the exposure and outcome variables are automatically used as the Y and X axis labels for the RCS graph produced. You need to set those labels the way you want them to appear on the graph; otherwise, you need to manually insert what you want in the ytitle and xtitle commands. 
7.	To drop extremes: It excludes outliers of exposure for visualisation purposes; by default, it drops the top and bottom 1 percentiles (indicated by 1 and 99). You can change it to 0.01 and 99.99 if you need to include all values. 
8.	The lines marked by ‘Y1 scale’ and ‘X scale’ are where you need to adjust the scales to fit the range of exposure and outcome variables for the RCS curve.
9.	The lines marked by ‘Y2 scale’ and ‘X scale’ are where you need to adjust the scales to fit the distribution of the exposure variable for the histogram. Unlike the Y1 scale, this one usually does not need to change. To keep the histogram and RCS curves apart, the Y2 scale is deliberately larger than what the height of bars requires.
10.	Median: The 2 lines marked by ‘Median’ are optional and may be dropped to keep the graph less cluttered. It adds the median of the exposure and helps to understand the distribution relative to the estimated curve. The calculated median is for the population defined by the indicator in the if-clause, without excluding any outliers. If you keep it, adjust the height to match the scale of the outcome variable and the Y axis (change 11 to a value that suits your graph). <br>
<br>

**RCS Linear Regression_multiple** - 
Testing non-linearity in associations between multiple continuous exposures and multiple continuous outcome variables in linear regression models 

*Explanations*:
These codes test non-linearity between multiple continuous exposure variables and multiple outcomes in multivariable models in Stata. For each exposure-outcome set, three blocks of codes should be run separately, which produce three items per association: 
1)	P for any association  
Only suitable when there is no evidence of a non-linear association (item 3).
2)	AIC for the model  
To compare model fit with different numbers of knots (3, 4, and 5 knots). The model with the lowest AIC value has the best fit and should be used. 
3)	P for a non-linear association  
It is the ultimate product of these codes, in which the evidence of a non-linear association is explored. 
The output Excel file is organised with exposure variables in columns and outcome variables in rows, in three blocks (column sets) corresponding to the three items explained above, all in a single sheet. For example, it currently has three hypothetical exposure variables (E1-E3) and 5 hypothetical outcome variables (O1-O5); therefore, the three blocks explained above will each have three columns, separated by an empty column. 
The section above titled “----->Run” needs to be adjusted to your needs. These changes should be identical across the three code blocks, except for the column letters for exposures. It means that the ‘if clauses’, exposure and outcome variable lists, etc., must be the same, but columns corresponding to exposures need to move forward (B C D, H I J, and N O P for three exposure variables).  
The ‘if clause’ must be defined even if none is necessary. In that case, you can use a covariate without missing as an indicator [e.g. !missing(age)].  
If you aim to use standard knot positions (3, 4, and 5 default knots), you don’t need to change anything. If you want to explore alternative knots (modified), they should be produced in a separate sheet (by adding _m to the sheet name). If all results are needed in a single sheet (e.g., to compare AICs), you can merge the two sheets by manually adding the products of the alternative knots to the Excel sheet for default knots (in the S1 cell if there are three exposure variables).  
Finally, modify the last line before “----->Run” (putexcle command) by defining the Excel file name and sheet. Don’t forget that this must be identical in the three blocks.  
The “----->Run” line is a flag indicating that there is usually no need to change code from that point onwards. You should run all the code from “----->Defining” to “/*END*/” for each block (it will not work correctly if you run the section after “----->Run” separately).  
The working directory path refers to a folder containing ‘codes’ and ‘outputs’ folders. The outputs folder may include a ‘graphs’ folder. <br>
Errors <br>
1.	Can happen when saving outputs takes longer than the cycle time. You can save your output on a local drive (not synchronised by OneDrive, etc.), disconnect your computer from the internet, or increase the sleep command.
2.	Convergence issue: You need to explore the problem manually. Usually, you need to amend the multivariable model, such as using a simpler one. 



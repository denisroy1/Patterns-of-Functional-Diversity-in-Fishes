# Patterns-of-Functional-Diversity-in-Fishes

This repository composes all of the relevant scripts and files for the manuscript titled: Patterns of functional diversity along latitudinal gradients of species richness in eleven fish families by Jonathan Diamond & Denis Roy submitted to Global Ecology and Biogeography.

Scripts

To see the main scripts used for this research, first, go to 'scripts' folder. 
Script definitons:

* Actualdisp-bylat.R: calculates the functional diversity (using morphometrics of fully body shape) along the latitudes based on the species occuring there.

* iterdisp2.R: calculates the functional diversity (using morphometrics of fully body shape) along the latitudes based on (1000 X) randomly selected species within a family to generate the null model.

* brokenstick_v4.R: generates the broken stick models of functional diversity along the latitudes within a given family.

* Occurence data.R: Generates dataframes/files describing the number of species within a given family occur at a specific latitude. 

* sumbp (1).R: generates a forest plot that summarizes the breakpoints found for each family.

Data 

To see raw data used for this research, go to 'data' folder

* Null folder: Contains the txt files with the family specific estimates from the null model with 95% conf. intervals at each latitude
* Actual morphological diversity folder: contains the the txt files with the family-level functional diversity estimate based on morphometric variance calculated using geometric morphometrics. 
* 

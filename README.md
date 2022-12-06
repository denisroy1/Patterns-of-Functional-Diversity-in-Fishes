# Patterns-of-Functional-Diversity-in-Fishes

This repository comprises all of the relevant scripts and files for the manuscript titled: 
Patterns of functional diversity along latitudinal gradients of species richness in eleven fish families
Authored by: Jonathan Diamond & Denis Roy in press with Global Ecology and Biogeography https://onlinelibrary.wiley.com/journal/14668238.

Scripts

To see the main scripts used for this research, go to 'scripts' folder. 
Script definitons:

* Actualdisp-bylat.R: This calculates functional diversity (using geometric morphometrics of fully body shape) along the latitudes based on the species occuring at those latitudes.
* iterdisp2.R: Calculates the functional diversity (using geometric morphometrics of fully body shape) along the latitudes based on randomly selected species within a family to generate the null model (iterated 1000X).
* brokenstick_v4.R: Generates the broken stick models of functional diversity along the latitudes within a given family.
* Occurence data.R: Generates dataframes/files describing the number of species within a given family occur at a specific latitude. 
* sumbp (1).R: Generates forest plots summarizing the breakpoints found for each family.

Data 

To see raw data used for this research, go to 'data' folder

* Null folder: Contains the '.txt' files with the family specific estimates from the null model with 95% conf. intervals at each latitude.
* Actual morphological diversity folder: Contains the '.txt' files with the family-level functional diversity estimate based on geometric morphometric variance. 
* 

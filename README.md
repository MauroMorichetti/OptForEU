10/09/2024

Mauro Morichetti
CNR - ISAFOM - Forest Model Lab

The folder contains the codes to prepare all the files needed to run the 3D-CMCC-FEM for all Case Study Area selected in the OptForEu project.
The main codes are writtin in NCL (NCAR Command Language - https://www.ncl.ucar.edu)

------------------ begin ---------------

**--> 01_stand_initilization_files <--**
Create the "sitename_stand.txt" files that provide information about the stand conditions.

To run the code: 
./EX_STANDS.sh

**--> 02_soil_initializaion_files <--**
Create the "sitename_soil.txt" files that contains information about soil and fertility of the test site.

Th data used is the SoilGrids — global gridded soil information database --> https://www.isric.org/explore/soilgrids
!!! Please note that due to space constraints, the raw data is not uploaded. !!!

To run the code: 
./EX_SOIL.sh

**--> 03_topography_initialization_files <--**
Create the s sitename_topo.txt files that contains about topography of the test
site.

Th data used is  the USGS - Digital Elevation - Global 30 Arc-Second Elevation (GTOPO30) - https://doi.org/10.5066/F7DF6PQS

!!! Please note that due to space constraints, the raw data is not uploaded. !!!

To run the code: 
./EX_TOPO.sh

**--> 04_meteorological_data_files_CC <--**

Create the sitename_meteo.txt, containing the daily meteorological data for different CC scenario (i.e., RCP2.6, RCP4.5, RCP8.5).

Climate input data to initialize forest model considered so far are HADGEM2ES/RACMO22. The NCL code reads the path as ./RACMO22/RCP26/CSA_Italy

!!! Please note that due to space constraints, the raw data is not uploaded. !!!

To run the code: 
./EX_SCENARIO.sh


**--> 05_CO2_atmospheric_concentrations_files <--**

Create the scenario_CO2.txt, the carbon dipxide average annual data to be provided for the expected simulation years.

To run the code: 
./EX_CO2.sh

**--> 06_settings_files <--**

Create the sitename_settings.txt. The file containing the setting parameters for simulations. See the setting_values.log to see all the parameters.

To run the code: 
./EX_SETTINGS.sh

**--> 07_ex_run <--**
Create the INPUT and OUTPUT of 3D-CMCC-FEM simulations.

./IMPORT/EX_IMPORT.sh collctes all the input data files from the previous folders dividing by scneario and sitename. --> create INPUT folder.

./PARAM include all the parameterization file, the species eco-physiological constants file, named with specie to simulate.

**To run the code: 
./3D-CMCC-FEM.sh --> CREATE THE OUTPUT FILES DIVIDED BY SITENAME AND CC SCENARIO.**

------------------ end ---------------





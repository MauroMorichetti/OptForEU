10/09/2024

Mauro Morichetti
CNR - ISAFOM - Forest Model Lab

The folder contains the codes to prepare all the files needed to run the 3D-CMCC-FEM for all Case Study Area selected in the OptForEu project.
The main codes are writtin in NCL (NCAR Command Language - https://www.ncl.ucar.edu)

**--> 01_stand_initilization_files <--**
Create the "sitename_stand.txt" files that provide information about the stand conditions.

To run the code: 
./EX_STANDS.sh

**--> 02_soil_initializaion_files <--**
Create the "sitename_soil.txt" files that contains information about soil and fertility of the test site.

Th data used is the SoilGrids — global gridded soil information database --> https://www.isric.org/explore/soilgrids![image](https://github.com/user-attachments/assets/85b0f309-4a3b-4d35-ab14-0b578c6ea27a)

!!! Please note that due to space constraints, the raw data is not uploaded. !!!

To run the code: 
./EX_SOIL.sh

**--> 03_topography_initialization_files <--**
Create the s sitename_topo.txt files that contains about topography of the test
site.

Th data used is  the USGS - Digital Elevation - Global 30 Arc-Second Elevation (GTOPO30) - https://doi.org/10.5066/F7DF6PQS![image](https://github.com/user-attachments/assets/117fa55c-7a9c-4fe8-94d2-e918842992b1)

!!! Please note that due to space constraints, the raw data is not uploaded. !!!

To run the code: 
./EX_TOPO.sh

**--> 04_meteorological_data_files_CC <--**

Create the sitename_meteo.txt, containing the daily meteorological data for different CC scenario (i.e., RCP2.6, RCP4.5, RCP8.5).

Climate input data to initialize forest model considered so far are HADGEM2ES/RACMO22. The NCL code reads the path as ./RACMO22/RCP26/CSA_Italy

!!! Please note that due to space constraints, the raw data is not uploaded. !!!

To run the code: 
./EX_SCENARIO.sh









load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

; Script Time
begTime = get_cpu_time()

;1)--------------------------------------------------------
; SET Version MODEL FOLDER useful for comparison of different versions 

;models  = (/"3D-CMCC-FEM-v.5.6.06","3D-CMCC-FEM-v.5.6"/)
;models  = (/"3D-CMCC-FEM-v.5.5-ISIMIP"/)
;models  = (/"3D-CMCC-FEM-v.5.6"/)
models  = (/"3D-CMCC-FEM-v.5.6.06"/)
nmodels = dimsizes(models)

;DEBUG
;print(models)
;exit

;2)--------------------------------------------------------
; SET MAIN INPUT and CSA 

files  = systemfunc("ls ./INPUT/")
nfiles = dimsizes(files)

;DEBUG
;print(files)
;exit

;3)--------------------------------------------------------
; SET ESM  

esm    = (/"RACMO22"/)
nesm   = dimsizes(esm)

;DEBUG
;print(esm)
;exit

;4)--------------------------------------------------------
; SET RCP CC scenario  

rcp   = (/"RCP26","RCP45","RCP85"/)
nrcp   = dimsizes(rcp)

;DEBUG
;print(rcp)
;exit

;--------------------------------------------------------

;--------------------------------------------------------
;A) LOOP over MODELS 
do mt=0,nmodels-1

;DEBUG
;do mt=0,0

; Clean the enviroment
if (models(mt) .eq. "3D-CMCC-FEM-v.5.5-ISIMIP") then

    version = "5.5"

else if (models(mt) .eq. "3D-CMCC-FEM-v.5.6") then 

    version = "5.6"

else if (models(mt) .eq. "3D-CMCC-FEM-v.5.6.06") then

    version = "5.6.06"

end if
end if
end if

rm_output = systemfunc("rm -rf OUTPUT_v"+version)
mkdir_output = systemfunc("mkdir OUTPUT_v"+version)

;DEBUG
;print(version)
;exit

;--------------------------------------------------------
;B) LOOP over CSA 
    do ft=0,nfiles-1

;DEBUG
;     do ft=0,0

       files_plots    = systemfunc("ls ./INPUT/"+files(ft))
       nfiles_plots   = dimsizes(files_plots)

;--------------------------------------------------------
;Clean and create the enviroment      
       rm_CSA         = systemfunc("rm -rf OUTPUT_v"+version+"/"+files(ft)) 
       mkdir_CSA      = systemfunc("mkdir  OUTPUT_v"+version+"/"+files(ft))

;DEBUG
;print(files_plots)
;exit

;--------------------------------------------------------
;C) LOOP over PLOTS 
        do pt=0,nfiles_plots-1

;DEBUG
;        do pt=0,0

;Create the enviroment      
           mkdir_plots = systemfunc("mkdir OUTPUT_v"+version+"/"+files(ft)+"/"+files_plots(pt))
            
;--------------------------------------------------------
;Print Check

print("-------------------------------------------------------------------------------------------------------")     
print("              Working on CSA "+files(ft)+" for "+files_plots(pt)+" with "+models(mt)+"                 ")     
print("-------------------------------------------------------------------------------------------------------")     

;DEBUG
;exit

;--------------------------------------------------------
;D) LOOP over ESM 
            do et=0,nesm-1

;DEBUG
;            do et=0,0

;--------------------------------------------------------
;E) LOOP over RCP
                do rt=0,nrcp-1

;DEBUG
;                do rt=0,0

;Create the enviroment      
                   mkdir_scenario = systemfunc("mkdir OUTPUT_v"+version+"/"+files(ft)+"/"+files_plots(pt)+"/"+esm(et)+"_"+rcp(rt))

;--------------------------------------------------------
; SET INPUT DATA 

; path to the 3D_CMCC_Forest_Model executable
                  dir_code  = "/home/wksfml/"+models(mt)+"/software/3D-CMCC-Forest-Model/Debug/"

; path to save input data
                  dir_input = "./INPUT/"+files(ft)+"/"+files_plots(pt)+"/"

; path to species parametrization data
                  dir_param = "./PARAM/"                                                                             

; path to save output data
                  dir_output = "./OUTPUT_v"+version+"/"+files(ft)+"/"+files_plots(pt)+"/"+esm(et)+"_"+rcp(rt)     

                  stand       = systemfunc("ls "+dir_input+"*stand*")
                  stand_file  = str_get_field(stand, 5, "/")
                  stand_name  = str_get_field(stand_file, 1, ".")

                  meteo       = systemfunc("ls "+dir_input+esm(et)+"_"+rcp(rt)+"*")
                  meteo_file  = str_get_field(meteo, 5, "/")
                  meteo_name  = str_get_field(meteo_file, 1, ".")

                  soil       = systemfunc("ls "+dir_input+"*soil*")
                  soil_file  = str_get_field(soil, 5, "/")

                  topo       = systemfunc("ls "+dir_input+"*topo*")
                  topo_file  = str_get_field(topo, 5, "/")

                  setting       = systemfunc("ls "+dir_input+"*setting*")
                  setting_file  = str_get_field(setting, 5, "/")
                  setting_name  = str_get_field(setting_file, 1, ".")

                  co2        = systemfunc("ls "+dir_input+"CO2_"+rcp(ft)+"*")           
                  co2_file   = str_get_field(co2, 5, "/")
                  co2_name   = str_get_field(co2_file, 1, ".")

;DEBUG
;print(dir_code)
;print(dir_input)
;print(dir_output)
;print(dir_param)
;print("---------------")
;print("----FOLDERS----")
;print(stand)
;print(meteo)
;print(soil)
;print(topo)
;print(co2)
;print(setting)
;print("---------------")
;print("----FILES----")
;print(stand_file)
;print(stand_file2)
;print(meteo_file)
;print(soil_file)
;print(topo_file)
;print(setting_file)
;print(co2_file)
;print("---------------")
;print("----NAMES----")
;print(stand_name)
;print(meteo_name)
;print(setting_name)
;print(co2_name)
;exit

;--------------------------------------------------------
; RUN EXECUTABLE 

print("                           driven by ESM "+esm(et)+" and "+rcp(rt)+" CC scenario                       ")     
print("-------------------------------------------------------------------------------------------------------")     
print( dir_code+"3D_CMCC_Forest_Model       ") 
print( " -i "+dir_input+"                   ") 
print( " -o "+dir_output+"                  ") 
print( " -p "+dir_param+"                   ") 
print( " -d "+stand_file+"                  ") 
print( " -m "+meteo_file+"                  ") 
print( " -s "+soil_file+"                   ") 
print( " -t "+topo_file+"                   ") 
print( " -c "+setting_file+"                ") 
print( " -k "+co2_file+"                    ") 
print( " > "+dir_output+"/"+models(mt)+"-"+meteo_name+".log")
print("-------------------------------------------------------------------------------------------------------")     

;--------------------> RUN the 3D-CMCC-FEM <----------------
                system(dir_code+"3D_CMCC_Forest_Model " +\+
                       " -i "+dir_input+"             " +\+
                       " -o "+dir_output+"            " +\+
                       " -p "+dir_param+"             " +\+
                       " -d "+stand_file+"            " +\+
                       " -m "+meteo_file+"            " +\+
                       " -s "+soil_file+"             " +\+
                       " -t "+topo_file+"             " +\+
                       " -c "+setting_file+"          " +\+
                       " -k "+co2_file+"              " +\+
                       " > "+dir_output+"/"+models(mt)+"-"+meteo_name+".log")
;--------------------> RUN the 3D-CMCC-FEM <----------------

                end do
;E) LOOP over RCP
;--------------------------------------------------------

            end do
;D) LOOP over ESM 
;--------------------------------------------------------

        end do
;--------------------------------------------------------
;C) LOOP over PLOTS 

delete(files_plots)
    end do
;B) LOOP over CSA 
;--------------------------------------------------------

;CHECK FOR ERRORS
check_errors    = systemfunc("grep error OUTPUT_v"+version+"/*/*/*/*log")
check_attention = systemfunc("grep ATTENTION OUTPUT_v"+version+"/*/*/*/*log")
print(check_errors)
print(check_attention)

delete(version)
end do
;A) LOOP over MODELS
;--------------------------------------------------------

;--------------------------------------------------------
; Script Time
print("Calculated PI in " + (get_cpu_time() - begTime) + " seconds")
print("--------------------------------------------------------------")
print("THE END")

end

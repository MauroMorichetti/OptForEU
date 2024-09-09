load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;--------------------------------------------------------
; Script Time
begTime = get_cpu_time()

;----> CSA 
case_studies = systemfunc("ls ./COORDS/CSA*.csv")
ncstudies    = dimsizes(case_studies)

;DEBUG
;print("---------------")
;print(" CASE STUDIES  ")
;print("---------------")
;print(case_studies)
;print(ncstudies)
;exit

;--------------------------------------------------------
;A) LOOP over CSA 
   do ct=0,ncstudies-1

;-------> OPEN the STAND FILE with COORDINATES            
      split_names1  = str_split(case_studies(ct),"_")
      split_names2  = str_split(split_names1(2),".")
      CSA          = split_names1(1) 
      coord_file   = asciiread(case_studies(ct),-1,"string")
      str          = str_split_csv(coord_file, ",",-1)
      stand_id     = tostring(str(1::,0))
      nstand       = dimsizes(stand_id) 

;DEBUG
;print(split_names1)
;print(split_names2)
;print(CSA)
;print(case_studies(ct))
;print(coord_file)
;print(str)
;print(stand_id)
;print(nstand)
;exit

;------------> Information for LOOP
print("-------------------------------------------------------------------------------")
print("-------------------------------------------------------------------------------")
print("--------------------------- Working for CSA "+CSA+" ---------------------------")

;--------------------------------------------------------
;B) LOOP over COORDINATES
             do nt=0,nstand-1
                
                mv1 = systemfunc("cp ./CO2_scenario/CO2_rcp8p5.txt CO2_RCP85_"+stand_id(nt)+".txt")
                mv2 = systemfunc("cp ./CO2_scenario/CO2_rcp4p5.txt CO2_RCP45_"+stand_id(nt)+".txt")
                mv3 = systemfunc("cp ./CO2_scenario/CO2_rcp2p6.txt CO2_RCP26_"+stand_id(nt)+".txt")
                mv4 = systemfunc("cp ./CO2_scenario/CO2_hist.txt   CO2_hist_"+stand_id(nt)+".txt")
         
             end do
;B) LOOP over COORDINATES
;--------------------------------------------------------

delete(split_names1)          
delete(split_names2)          
delete(CSA)
delete(coord_file)
delete(str)
delete(stand_id)
delete(nstand)
    end do
;A) LOOP over CSA
;--------------------------------------------------------

;--------------------------------------------------------
; Script Time
print("Calculated PI in " + (get_cpu_time() - begTime) + " seconds")
print("--------------------------------------------------------------")
print("THE END")

end


load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;--------------------------------------------------------
; Script Time
begTime = get_cpu_time()

;--------------------------------------------------------
; copy txt from folder 01-07 
      mv     = systemfunc("mv ../../0*files*/*.txt .")

;DEBUG
      ;cp     = systemfunc("cp ../../0*files*/*.txt .")
;exit

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
      split_names1  = str_split(case_studies(ct),"/")
      split_names2  = str_split(split_names1(2),"_")
      CSA          = split_names2(0)+"_"+split_names2(1) 
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
;exit

;------------> Information for LOOP
print("-------------------------------------------------------------------------------")
print("-------------------------------------------------------------------------------")
print("--------------------------- Working for CSA "+CSA+" ---------------------------")
      
      rm     = systemfunc("rm -rf ../INPUT/"+CSA) 
      folder = systemfunc("mkdir ../INPUT/"+CSA) 

;--------------------------------------------------------
;B) LOOP over COORDINATES
              do nt=0,nstand-1
                 
                 rm2     = systemfunc("rm -rf ../INPUT/"+CSA+"/"+stand_id(nt)) 
                 folder2 = systemfunc("mkdir ../INPUT/"+CSA+"/"+stand_id(nt)) 
                 print("mv *"+stand_id(nt)+"* ../INPUT/"+CSA+"/"+stand_id(nt)) 
                 mv = systemfunc("mv *"+stand_id(nt)+"* ../INPUT/"+CSA+"/"+stand_id(nt)) 

              end do
;D) LOOP over COORDINATES
;--------------------------------------------------------

delete(split_names1)          
delete(split_names2)          
delete(CSA)
delete(coord_file)
delete(str)
delete(nstand)
delete(stand_id)

    end do
;A) LOOP over CSA
;--------------------------------------------------------

;--------------------------------------------------------
; Script Time
print("Calculated PI in " + (get_cpu_time() - begTime) + " seconds")
print("--------------------------------------------------------------")
print("THE END")

end


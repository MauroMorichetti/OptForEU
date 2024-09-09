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
      lon_csa      = tofloat(str(1::,2))
      lat_csa      = tofloat(str(1::,1))
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
;print(lat_csa)
;print(lon_csa)
;exit

;------------> Information for LOOP
print("-------------------------------------------------------------------------------")
print("-------------------------------------------------------------------------------")
print("--------------------------- Working for CSA "+CSA+" ---------------------------")

;-----------> Open Soil file to use and coordinates 

              if (CSA .eq. "Romania") then
              a = addfile("Q2.nc", "r")
              else 
              a = addfile("Q1.nc", "r")
              end if
              
              lon_esm = tofloat(a->lon) 
              lat_esm = tofloat(a->lat) 
 
;DEBUG
;print(a)
;print(lat_esm)
;print(lon_esm)
;exit


;--------------------------------------------------------
;D) LOOP over COORDINATES
              do nt=0,nstand-1

                 jlat    = ind_nearest_coord (lat_csa(nt), lat_esm,0)
                 ilon    = ind_nearest_coord (lon_csa(nt), lon_esm,0)

                 lat_ex = lat_esm(jlat) 
                 lon_ex = lon_esm(ilon) 

;------------> Information for LOOP
print("-------------------------------------------------------------------------------")
print("Plot "+stand_id(nt)+" with lat "+lat_csa(nt)+" and lon "+lon_csa(nt)            ) 
print(" --> nearest ESM lat("+jlat+") "+lat_ex+" and lon("+ilon+") "+lon_ex            )
print("-------------------------------------------------------------------------------")

;DEBUG
;print(lat_csa(nt))
;print(lon_csa(nt))
;print(jlat)
;print(ilon)
;print(lat_esm)
;print(lon_esm)
;print(lat_ex)
;print(lon_ex)
;exit

;------------> GTOPO30 elevetion
                elev = a->Band1(jlat,ilon) ; 0-5    cm (g/Kg)  

;DEBUG
;print(elev) 
;exit

;-------------> Variables to print on the soil file 
                X = 0
                Y = 0
                ELEV = elev

;---------------> Soil Table Information 
                csv_filename = stand_id(nt)+"_topo.txt"
                system("rm -rf " + csv_filename)               ; Remove file in case it exists.
                header = (/"X,Y,ELEV"/)
                hlist = [/header/]
                write_table(csv_filename, "w", hlist, "%s")

;---------> Create the file to write
                format = "%d,%d,%d" ; Format to use for each variable.
                alist  = [/X,Y,ELEV/]
                write_table(csv_filename, "a", alist, format)

             end do
;D) LOOP over COORDINATES
;--------------------------------------------------------

delete(split_names1)          
delete(split_names2)          
delete(CSA)
delete(coord_file)
delete(str)
delete(stand_id)
delete(nstand)
delete(lon_csa)
delete(lat_csa)
    end do
;A) LOOP over CSA
;--------------------------------------------------------

;--------------------------------------------------------
; Script Time
print("Calculated PI in " + (get_cpu_time() - begTime) + " seconds")
print("--------------------------------------------------------------")
print("THE END")

end


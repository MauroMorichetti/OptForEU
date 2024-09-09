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
              a = addfile("ISRIC.nc", "r")

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

;------------> Clay
                clay_1 = a->Band1(jlat,ilon) ; 0-5    cm (g/Kg)  
                clay_2 = a->Band2(jlat,ilon) ; 5-15   cm (g/Kg) 
                clay_3 = a->Band3(jlat,ilon) ; 15-30  cm (g/Kg) 
                clay_4 = a->Band4(jlat,ilon) ; 30-60  cm (g/Kg) 
                clay_5 = a->Band5(jlat,ilon) ; 60-100 cm (g/Kg) 
                clay_tot = tofloat(clay_1+clay_2+clay_3+clay_4+clay_5) ; 0-100 cm (g/Kg) 

;DEBUG
;print(clay_1) 
;print(clay_2) 
;print(clay_3) 
;print(clay_4) 
;print(clay_5) 
;print(clay_tot) 
;printVarSummary(clay_1) 
;exit

;------------> Sand
                sand_1 = a->Band6(jlat,ilon) ; 0-5    cm (g/Kg)  
                sand_2 = a->Band7(jlat,ilon) ; 5-15   cm (g/Kg) 
                sand_3 = a->Band8(jlat,ilon) ; 15-30  cm (g/Kg) 
                sand_4 = a->Band9(jlat,ilon) ; 30-60  cm (g/Kg) 
                sand_5 = a->Band10(jlat,ilon) ; 60-100 cm (g/Kg) 
                sand_tot = tofloat(sand_1+sand_2+sand_3+sand_4+sand_5) ; 0-100 cm (g/Kg) 

;DEBUG
;print(sand_1) 
;print(sand_2) 
;print(sand_3) 
;print(sand_4) 
;print(sand_5) 
;print(sand_tot) 
;printVarSummary(sand_1) 
;exit

;------------> Silt
                silt_1 = a->Band11(jlat,ilon) ; 0-5    cm (g/Kg)  
                silt_2 = a->Band12(jlat,ilon) ; 5-15   cm (g/Kg) 
                silt_3 = a->Band13(jlat,ilon) ; 15-30  cm (g/Kg) 
                silt_4 = a->Band14(jlat,ilon) ; 30-60  cm (g/Kg) 
                silt_5 = a->Band15(jlat,ilon) ; 60-100 cm (g/Kg) 
                silt_tot = tofloat(silt_1+silt_2+silt_3+silt_4+silt_5) ; 0-100 cm (g/Kg) 

;DEBUG
;print(silt_1) 
;print(silt_2) 
;print(silt_3) 
;print(silt_4) 
;print(silt_5) 
;print(silt_tot) 
;printVarSummary(silt_1) 
;exit

;-------------> Total Soil Volume 
                tot = tofloat(sand_tot + clay_tot + silt_tot) ; 0-100 cm (g/Kg)

;-------------> Weighted average 
                clay_fraction_n = tofloat((clay_tot/tot)*100)
                sand_fraction_n = tofloat((sand_tot/tot)*100)
                silt_fraction_n = tofloat((silt_tot/tot)*100)

                clay_fraction = decimalPlaces(clay_fraction_n,2,True) 
                sand_fraction = decimalPlaces(sand_fraction_n,2,True) 
                silt_fraction = decimalPlaces(silt_fraction_n,2,True) 
;DEBUG
;print(tot) 
;print(clay_fraction)
;print(sand_fraction)
;print(silt_fraction)
;print("CHECK SUM")
;print(clay_fraction+sand_fraction+silt_fraction)
;exit

;-------------> Variables to print on the soil file 
                X = 0
                Y = 0
                LANDUSE = "F"
                LAT = lat_csa(nt) 
                LON = lon_csa(nt)
                CLAY_PERC = clay_fraction
                SILT_PERC = silt_fraction
                SAND_PERC = sand_fraction
                SOIL_DEPTH = 100
                FR=1
                FN0=0.5
                FNN=0.5
                M0=0.2
                LITTERC=-9999
                LITTERN=-9999
                SOILC=-9999
                SOILN=-9999
                DEADWOODC=-9999

;---------------> Soil Table Information 
csv_filename = stand_id(nt)+"_soil.txt"
system("rm -rf " + csv_filename)               ; Remove file in case it exists.
header = (/"X,Y,LANDUSE,LAT,LON,CLAY_PERC,SILT_PERC,SAND_PERC,SOIL_DEPTH,FR,FN0,FNN,M0,LITTERC,LITTERN,SOILC,SOILN,DEADWOODC"/)
hlist = [/header/]
write_table(csv_filename, "w", hlist, "%s")
;exit 

;---------> Create the file to write
format = "%d,%d,%s,%f,%f,%f,%f,%f,%d,%d,%f,%f,%f,%d,%d,%d,%d,%d"; Format to use for each variable.
alist  = [/X,Y,LANDUSE,LAT,LON,CLAY_PERC,SILT_PERC,SAND_PERC,SOIL_DEPTH,FR,FN0,FNN,M0,LITTERC,LITTERN,SOILC,SOILN,DEADWOODC/]
write_table(csv_filename, "a", alist, format)

delete(X)
delete(Y)
delete(LANDUSE)
delete(LAT) 
delete(LON)
delete(CLAY_PERC)
delete(SILT_PERC)
delete(SAND_PERC)
delete(SOIL_DEPTH)
delete(FR)
delete(FN0)
delete(FNN)
delete(M0)
delete(LITTERC)
delete(LITTERN)
delete(SOILC)
delete(SOILN)
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


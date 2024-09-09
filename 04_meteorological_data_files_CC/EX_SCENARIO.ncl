load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;--------------------------------------------------------
; Script Time
begTime = get_cpu_time()

;--------------------------------------------------------
; SET OptForEu Variables Declaration

;---->ESM
ESM_names   = (/"RACMO22"/)
nesm        = dimsizes(ESM_names)

;DEBUG
;print("---------------")
;print("       ESM     ")
;print("---------------")
;print(ESM_names)
;print(nesm)
;exit

;---->RCP
rcp_names        = (/"RCP26", "RCP45", "RCP85"/)
nrcps            = dimsizes(rcp_names)

;DEBUG
;print("---------------")
;print("       RCP     ")
;print("---------------")
;print(rcp_names)
;print(nrcps)
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

;--------------------------------------------------------
;B) LOOP over ESM 
       do et=0,nesm-1

          ESM = ESM_names(et)

;DEBUG
;print(ESM)
;exit

;--------------------------------------------------------
;C) LOOP over RCP 
            do rt=0,nrcps-1

;------------> Information for LOOP
print("-------------------------------------------------------------------------------")
print("-------------------------------------------------------------------------------")
print("Working on "+ESM_names(et)+" for scenario "+rcp_names(rt)+" and CSA "+CSA)

               RCP           = rcp_names(rt)
               meteo_files   = systemfunc("ls ./"+ESM+"/"+RCP+"/"+CSA+"/RACMO*")
               nmeteo        = dimsizes(meteo_files)

;DEBUG
;print(RCP)
;print(meteo_files)
;print(nmeteo)
;exit

;-----------> Open First File to use Time and coordinates 
              a = addfile(meteo_files(0), "r")

;-----------> Time convert
              time = a->time
              utc_date = cd_calendar(time, 0)
              year   = tointeger(utc_date(:,0))   
              month  = tointeger(utc_date(:,1)) 
              day    = tointeger(utc_date(:,2))
              hour   = tointeger(utc_date(:,3))
              minute = tointeger(utc_date(:,4))
              second = tointeger(utc_date(:,5))


;DEBUG
;print(a)
;print(NA_value)
;print(utc_date)
;print(year)
;print(month)
;print(day)
;print(hour)
;print(minute)
;print(second)
;exit

;-----------> Create a 365 days calendar to use as reference
              time_file    = asciiread("example_meteofile.csv",-1,"string")
              str1         = str_split_csv(time_file, ",",-1)
              year_csv     = tointeger(str1(1::,0))
              month_csv    = tointeger(str1(1::,1))
              day_csv      = tointeger(str1(1::,2))
              hour_csv     = new(dimsizes(year_csv),double, -999)
              hour_csv     = 0
              minute_csv   = new(dimsizes(year_csv),double, -999)
              minute_csv   = 0
              second_csv   = new(dimsizes(year_csv),double, -999)
              second_csv   = 0

              time_steps               =  dimsizes(year_csv)
              time_365                 =  fspan(min(time),max(time),time_steps)
              time_365!0               = "time" 
              time_365&time            =  time_365
              time_365@standard_name   = "time" 
              time_365@units           = "days since 1949-12-01"
              time_365@calendar        = "365_day" 
              time_365@long_name       = "time" 
              time_365@axis            = "T" 

              NA_value = new(dimsizes(year_csv),string)     ; NA values
              NA_value = -9999

;DEBUG
;print(time_365)
;printVarSummary(time_365)
;print(month_csv)
;print(day_csv)
;print(hour_csv)
;print(minute_csv)
;print(second_csv)
;print(csv_time)
;print(axis_date)
;exit

;-----------> Coordinate convert
              lon_esm = tofloat(a->longitude) 
              lat_esm = tofloat(a->latitude) 

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
delete(a)

;---------------> Meteo Table Information 
csv_filename = ESM+"_"+RCP+"_"+stand_id(nt)+".txt"
system("rm -rf " + csv_filename)               ; Remove file in case it exists.

header = (/"Year	Month	n_days	Rg_f	Ta_f	Tmax	Tmin	RH_f	Ts_f	Precip	SWC	LAI	ET	WS_f"/)
hlist = [/header/]
write_table(csv_filename, "w", hlist, "%s")
  
;--------------------------------------------------------
;E) LOOP over METEO FILES 
                do mt=0,nmeteo-1
                   a = addfile(meteo_files(mt), "r")
                   name_file     = str_split(meteo_files(mt),"_")               
                   name_variable = name_file(3)               

                   if (name_variable .eq. "PREC") then
                      pr           = a->pr(:,jlat,ilon)
                      pr_new       = linint1_n(time,pr,False,time_365,0,0)
                      Precip       = pr_new * 86400 ; to convert from kg/m2/s to mm/day
                      Precip@units = "mm day^-1"
                      Precip@_FillValue = -9999
delete(pr)    
;DEBUG
;print(Precip)
;printVarSummary(Precip)
;exit
                   else if (name_variable .eq. "REL") then
                      hurs         = a->hurs(:,jlat,ilon)
                      hurs_new     = linint1_n(time,hurs,False,time_365,0,0)
                      RH_f         = hurs_new 
                      RH_f@units   = "%"
                      RH_f@_FillValue = -9999
delete(hurs)
;DEBUG
;printVarSummary(RH_f)
;exit
                   else if (name_variable .eq. "SHR") .or. (name_variable .eq. "SWR") then
                      rsds         = a->rsds(:,jlat,ilon)
                      rsds_new     = linint1_n(time,rsds,False,time_365,0,0)
                      Rg_f         = (rsds_new*3600*24)/1000000 ; to convert from W/m2 to MJ/m2 day 
                      Rg_f@units   = "MJ m^-2 day^-1"
                      Rg_f@_FillValue = -9999
delete(rsds)
;DEBUG
;printVarSummary(Rg_f)
;exit
                   else if (name_variable .eq. "TAS") then
                      tas          = a->tas(:,jlat,ilon)
                      tas_new      = linint1_n(time,tas,False,time_365,0,0)
                      Ta_f         = tas_new-273.15 ;  to convert from Kelvin to °C
                      Ta_f@units   = "degC"
                      Ta_f@_FillValue = -9999
delete(tas)
;DEBUG
;printVarSummary(Ta_f)
;exit
                   else if (name_variable .eq. "TASMAX") then
                      tasmax       = a->tasmax(:,jlat,ilon)
                      tasmax_new   = linint1_n(time,tasmax,False,time_365,0,0)
                      Tmax         = tasmax_new-273.15 ;  to convert from Kelvin to °C
                      Tmax@units   = "degC"
                      Tmax@_FillValue = -9999
delete(tasmax)
;DEBUG
;printVarSummary(Tmax)
;exit
                   else if (name_variable .eq. "TASMIN") then
                      tasmin       = a->tasmin(:,jlat,ilon)
                      tasmin_new   = linint1_n(time,tasmin,False,time_365,0,0)
                      Tmin         = tasmin_new-273.15 ;  to convert from Kelvin to °C
                      Tmin@units   = "degC"
                      Tmin@_FillValue = -9999
delete(tasmin)
;DEBUG
;printVarSummary(Tmin)
;exit
                   else if (name_variable .eq. "SO") .or. (name_variable .eq. "SM") then
                      mrso        = a->mrso(:,jlat,ilon)
                      mrso_new    = linint1_n(time,mrso,False,time_365,0,0)
                      SWC         = mrso_new/1000 ;  to convert from Kg m-2 to % 
                      SWC@units   = "%"
                      SWC@_FillValue = -9999
delete(mrso)
;DEBUG
;printVarSummary(SWC)
;exit
                   end if
                   end if
                   end if
                   end if
                   end if
                   end if
                   end if

delete(name_file)
delete(name_variable)
                end do
;E) LOOP over METEO FILES
;--------------------------------------------------------

format = "%d	%d	%d	%f	%f	%f	%f	%f	%s	%f	%f	%s	%s	%s"; Format to use for each variable.
                           
;---------> Create the file to write
alist  = [/year_csv,month_csv,day_csv,Rg_f,Ta_f,Tmax,Tmin,RH_f,NA_value,Precip,SWC,NA_value, NA_value, NA_value/]
write_table(csv_filename, "a", alist, format)

delete(SWC)
delete(Tmin)
delete(Tmax)
delete(Ta_f)
delete(Rg_f)
delete(Precip)
delete(RH_f)
             end do
;D) LOOP over COORDINATES
;--------------------------------------------------------

delete(NA_value)
delete(RCP)  
delete(utc_date)
delete(time)
delete(year)
delete(month)
delete(day)
delete(hour)
delete(minute)
delete(second)
delete(meteo_files)
delete(nmeteo)
delete(lon_esm)
delete(lat_esm)
            end do
;C) LOOP over RCP
;--------------------------------------------------------

delete(ESM)  
         end do
;B) LOOP over ESM
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


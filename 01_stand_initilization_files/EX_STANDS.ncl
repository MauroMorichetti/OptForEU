load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;--------------------------------------------------------
; Script Time
begTime = get_cpu_time()

;--------------------------------------------------------
; SET OptForEu Variables Declaration

;----> CSA coordinates 
case_studies    = systemfunc("ls ./COORDS/CSA*_coordinates.csv")
ncstudies       = dimsizes(case_studies)

;----> CSA species 
case_studies_sp   = systemfunc("ls ./SPECIES/CSA*_species.csv")

;DEBUG
;print("---------------")
;print(" CASE STUDIES  ")
;print("---------------")
;print(case_studies)
;print(case_studies_sp)
;print(ncstudies)
;exit

;--------------------------------------------------------
;A) LOOP over CSA 
   do ct=0,ncstudies-1

;-------> OPEN the STAND FILE with SPECIES            
      species_file      = asciiread(case_studies_sp(ct),-1,"string")
      spe               = str_split_csv(species_file, ",",-1)
      species_id        = tostring(spe(1::,0))
      species_3d        = tostring(spe(1::,2))

;-------> OPEN the STAND FILE with COORDINATES            
      split_names1  = str_split(case_studies(ct),"_")
      split_names2  = str_split(split_names1(1),".")
      CSA           = split_names2(0) 
      coord_file    = asciiread(case_studies(ct),-1,"string")
      str           = str_split_csv(coord_file, ",",-1)
      stand_id      = tostring(str(1::,0))
      lon_csa       = tofloat(str(1::,1))
      lat_csa       = tofloat(str(1::,2))
      nstand        = dimsizes(stand_id) 

;DEBUG
;print(species_file)
;print(species_id)
;print(species_3d)
;print(split_names1)
;print(split_names2)
print("---------------")
print("    "+CSA+"    ")
print("---------------")
;print(case_studies(ct))
;print(coord_file)
;print(str)
;print(stand_id)
;print(nstand)
;print(lat_csa)
;print(lon_csa)
;exit

;--------------------------------------------------------
; SET number of column for variables on case study 

      if (CSA .eq. "Austria") then
         n_age  =  1
         n_dbh  =  2 
         n_ht   =  3 
         n_nha  =  4
         n_ba   =  5 
         n_year = 12
      else if (CSA .eq. "Romania") then
         n_age  =  2
         n_dbh  =  3 
         n_ht   =  4 
         n_nha  =  5
         n_ba   =  6 
         n_year = 13
      else if (CSA .eq. "Italy") then
         n_age  =  2
         n_dbh  =  3 
         n_ht   =  4 
         n_nha  =  5
         n_ba   =  6 
         n_year = 13
      end if
      end if
      end if

;--------------------------------------------------------
;B) LOOP over STAND 
       do nt=0,nstand-1

;------------> Open by tree species
          plot1        = str_split(stand_id(nt),"_")
          plot2        = systemfunc("ls ./CSA*"+CSA+"/*"+plot1(1)+"*csv")
  
          age_interval = str_split(plot1(2),"-")
          age_min      = tofloat(age_interval(0))
          age_max      = tofloat(age_interval(1))

;------------> Information for LOOP
print("-------------------------------------------------------------------------------")
print("-------------------------------------------------------------------------------")
print("Working on CSA "+CSA+" for specie "+plot1(1)+" and age interval "+age_min+"-"+age_max)

;DEBUG
;print(plot1)
;print(plot2)
;print(age_interval)
;exit

;------------> Open by age classes
          plot_setting = asciiread(plot2,-1,"string")
          str1         = str_split_csv(plot_setting, ",",-1)

          stand_age    = tofloat(str1(1::,n_age))  ;Tree age
          stand_dbh    = tofloat(str1(1::,n_dbh))  ;DBH in cm 
          stand_ht     = tofloat(str1(1::,n_ht ))  ;Tree height in m  
          stand_nha    = tofloat(str1(1::,n_nha))  ;Number of trees per ha
          stand_ba     = tofloat(str1(1::,n_ba ))  ;Basal area m2/ha
          stand_year   = tofloat(str1(1::,n_year)) ;Year of sampling
          ii           = str_match_ind(species_id,plot1(1)) ;File for 3D species

          nstand_age   = dimsizes(stand_age)
          

;DEBUG
;print(ii)
;print(plot1(1)+" = "+species_3d(ii))
;print(str1)
;print(stand_age)
;print(nstand_age)
;print(stand_dbh ) 
;print(stand_ht  )
;print(stand_nha )
;print(stand_ba  )
;print(stand_year)
;exit

;------------> Define new plots
           numx     = num((stand_age .gt. age_min) .and. (stand_age .le. age_max))
           ba_age   = new(toint(numx),float) 
           ba_nha   = new(toint(numx),float) 
           ba_dbh   = new(toint(numx),float) 
           ba_ht    = new(toint(numx),float) 
           ba_year  = new(toint(numx),float) 
           ba_ba    = new(toint(numx),float) 
           new_plot = new(toint(numx),float) 
           icount   = -1
;DEBUG
;print(numx)
;print(dnumx)
;exit

;--------------------------------------------------------
;C.1) LOOP over AGE classes
            do at=0,nstand_age-1

;------------> Age interval values
               if (stand_age(at) .gt. age_min) .and. (stand_age(at) .le. age_max) then
                  icount = icount+1
                  new_plot(icount) = at
               end if

           end do
;C.1) LOOP over AGE classes
;--------------------------------------------------------

;DEBUG
;print(new_plot)
;exit

;--------------------------------------------------------
;C.2) LOOP over AGE classes
            do dt=0,numx-1

;------------> Define weighted average
               age    = stand_age (toint(new_plot(dt)))     ;Tree age 
               dbh    = stand_dbh (toint(new_plot(dt)))     ;DBH in cm 
               ht     = stand_ht  (toint(new_plot(dt)))     ;Tree height in m  
               nha    = stand_nha (toint(new_plot(dt)))     ;Number of trees per ha
               ba     = stand_ba  (toint(new_plot(dt)))     ;Basal area m2/ha
               year   = stand_year(toint(new_plot(dt)))     ;Year of sampling

               ba_ba(dt)  = ba
               ba_age(dt) = age *ba
               ba_dbh(dt) = dbh *ba
               ba_ht(dt)  = ht  *ba
               ba_nha(dt) = nha *ba
               ba_year(dt)= year*ba

;DEBUG
;print(ba) 
;print(age  +" age "+ ba_age(dt))  
;print(dbh  +" dbh "+ ba_dbh(dt))  
;print(ht   +" ht  "+ ba_ht(dt) )   
;print(nha  +" nha "+ ba_nha(dt)) 
;print(year +" year "+ ba_year(dt)) 
;print(ba_age(dt))
;print(ba_dbh(dt))
;print(ba_ht(dt) ) 
;print(ba_nha(dt)) 
;print(ba_year(dt))
;exit

            end do
;C.2) LOOP over AGE classes
;--------------------------------------------------------

;------------> Define variables new plots
           YEAR   = toint(sum(ba_year)/sum(ba_ba))
           AGE    = toint(sum(ba_age)/sum(ba_ba))
           NHA    = toint(sum(ba_nha)/sum(ba_ba)) 
           AVDBH  = sum(ba_dbh)/sum(ba_ba) 
           HEIGHT = sum(ba_ht)/sum(ba_ba) 
           SPECIE = species_3d(ii)
           NA_value = tostring(-9999)

;DEBUG
;print(ba_age ) 
;print(ba_dbh) 
;print(ba_ht ) 
;print(ba_nha) 
;print(ba_year)
;print(sum(ba_age)) 
;print(sum(ba_dbh)) 
;print(sum(ba_ht )) 
;print(sum(ba_nha)) 
;print(sum(ba_year))
;print(sum(ba_ba)) 
;print("YEAR "+toint(sum(ba_year)/sum(ba_ba)))
;print("AGE "+toint(sum(ba_age)/sum(ba_ba)))
;print("NHA "+sum(ba_nha)/sum(ba_ba)) 
;print("AVDBH "+sum(ba_dbh )/sum(ba_ba)) 
;print("HEIGHT "+sum(ba_ht )/sum(ba_ba)) 
;exit

;---------------> Meteo Table Information
          csv_filename = plot1(0)+"_"+plot1(1)+"_"+age_min+"-"+age_max+"_stand.txt"
          system("rm -rf " + csv_filename)               ; Remove file in case it exists.
          header = (/"Year,x,y,Age,Species,Management,N,Stool,AvDBH,Height,Wf,Wrc,Wrf,Ws,Wbb,Wres,Lai"/)
          hlist = [/header/]
          write_table(csv_filename, "w", hlist, "%s")
  
;---------------> Create the file to write
          format = "%d,%d,%d,%d,%s,%s,%d,%d,%f,%f,%d,%d,%d,%d,%d,%d,%s"
          alist  = [/YEAR,0,0,AGE,SPECIE,"T",NHA,0,AVDBH,HEIGHT,0,0,0,0,0,0,NA_value/]
          write_table(csv_filename, "a", alist, format)

;---------> Create the file to write
delete(plot1)  
delete(plot2)  
delete(plot_setting )
delete(age_interval )
delete(age_min      )
delete(age_max      )
delete(str1      )
delete(stand_age )
delete(nstand_age)
delete(stand_dbh ) 
delete(stand_ht  )
delete(stand_nha )
delete(stand_ba  )
delete(stand_year)
delete(numx    )
delete(new_plot)
delete(ba_dbh ) 
delete(ba_ht   ) 
delete(ba_nha  ) 
delete(ba_age  ) 
delete(ba_year ) 
delete(ba_ba ) 

         end do
;B) LOOP over STAND
;--------------------------------------------------------

delete(split_names1)          
delete(split_names2)          
delete(CSA)
delete(coord_file)
delete(str)
delete(stand_id)
delete(nstand)
delete(species_file)
delete(spe         )
delete(species_id  )
delete(species_3d  )
delete(lat_csa)
delete(lon_csa)
delete(n_age ) 
delete(n_dbh ) 
delete(n_ht  ) 
delete(n_nha ) 
delete(n_ba  ) 
delete(n_year) 

    end do
;A) LOOP over CSA
;--------------------------------------------------------

;--------------------------------------------------------
; Script Time
print("Calculated PI in " + (get_cpu_time() - begTime) + " seconds")
print("--------------------------------------------------------------")
print("THE END")

end


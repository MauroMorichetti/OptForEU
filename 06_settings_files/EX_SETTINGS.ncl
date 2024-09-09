load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

;--------------------------------------------------------
; Script Time
begTime = get_cpu_time()

;----> CSA 
stands     = systemfunc("ls ../01_stand_initilization_files/*txt")
nstands    = dimsizes(stands)

;DEBUG
;print("---------------")
;print("     STANDS    ")
;print("---------------")
;print(stands)
;print(nstands)
;exit

example_file   = asciiread("examples_settings_file.csv",-1,"string")
str_ex         = str_split_csv(example_file, " ",-1)

;DEBUG
;print(example_file)
;print(str_ex)
;exit

;--------------------------------------------------------
;A) LOOP over STANDS
    do nt=0,nstands-1

       split_names1  = str_split(stands(nt),"/")
       split_names2  = str_split(split_names1(2),"_")
       sitename = split_names2(0)+"_"+split_names2(1)+"_"+split_names2(2)

;DEBUG
;print(split_names1)
;print(split_names2)
;print(sitename)
;exit

;------------> Information for LOOP
print("-------------------------------------------------------------------------------")
print("-------------------------------------------------------------------------------")
print("------------------------ Working for PLOT "+sitename+" ------------------------")

       stand_file   = asciiread(stands(nt),-1,"string")
       str          = str_split_csv(stand_file, ",",-1)
       year_start   = str(1,0)
       year_end     = 2099     ; CC scenario

;DEBUG
;print(str)
;print(stand_file)
;print(year_start)
;print(year_end)
;exit

;----------------> Change SITENAME      
       line = str_split(example_file(0), " ")
       line(1) = sitename
       example_file(0) = str_join(line, " ")
       delete(line)

;----------------> Change YEAR_START      
       line = str_split(example_file(13), " ")
       line(1) = year_start
       example_file(13) = str_join(line, " ")
       delete(line)

;----------------> Change YEAR_END      
       line = str_split(example_file(14), " ")
       line(1) = year_end
       example_file(14) = str_join(line, " ")
       delete(line)

       asciiwrite(sitename+"_settings.txt", example_file)

    end do
;A) LOOP over STANDS
;--------------------------------------------------------

;--------------------------------------------------------
; Script Time
print("Calculated PI in " + (get_cpu_time() - begTime) + " seconds")
print("--------------------------------------------------------------")
print("THE END")

end


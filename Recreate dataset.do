clear 

cd "C:\Users\H\Desktop\CS classes\SS154\Assignment\Final Assignment\Synthetic control 2"

use "C:\Users\H\Desktop\CS classes\SS154\Assignment\Final Assignment\replication_files_ddcg\DDCGdata_final.dta" 

keep country_name wbcode year gdppercapitaconstant2000us lp_bl ls_bl lh_bl taxratio region unrestreg wbcode2 yeardem secenr prienr tradewb mortnew ginv rtfpna y unrest loginvpc ltfp ltrade2 lprienr lsecenr lgov lmort unrestn demevent tradewbreg yreg country areakm2 elev tropicar distcr
drop country tropicar unrest unrestn demevent wbcode region 
drop if year > 2000
*drop lp_bl ls_bl lh_bl secenr prienr 

encode country_name, gen(countries_name)

*Country of interest: Korea (101)
*Choose those countries to be within the donor pool: Japan (94), Singapore (161), 
*China (35), Thailand (177), Phillipines (144), Greece (72),
*Italy (91), Spain (55), U.S (189), U.K (63), Ecuador(52), Turkey(183), Tunisia(182), 
*Brazil(26), Portugal (149), Mexico(118), Panama(142), Costa Rica(42), 
*Trinidad and Tobaco(181), Venezuela(192), Argentina(6)
*Albania(4), Romania(154)

egen countries = anymatch(wbcode2), values(101 94 161 35 91 177 144 72 55 189 63 52 183 182 26 19 118 142 42 181 192 6 4 154)
keep if countries

gsort wbcode2 year

gen country_code = 1 + floor((_n-1)/41)
tsset country_code year

save synth_korea.dta, replace

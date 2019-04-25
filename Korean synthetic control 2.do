clear 

cd "C:\Users\H\Desktop\CS classes\SS154\Assignment\Final Assignment\Synthetic control 2"
use "C:\Users\H\Desktop\CS classes\SS154\Assignment\Final Assignment\Synthetic control 2\synth_korea_2.dta" 

#delimit;
synth y taxratio ltrade2 ltfp lmort ginv lgov unrestreg(1986) tradewbreg(1986) lp_bl(1980) ls_bl(1975) lh_bl(1975), trunit(10) trperiod(1987) unitnames(country_name) mspeperiod (1970(1)1986) resultsperiod(1970(1)2000) keep(synth_korea.dta) replace fig;
mat list e(V_matrix);
#delimit cr

*Parallel: synth y taxratio(1980(1)1986) ltrade2(1980(1)1986) ltfp lmort ginv lgov unrestreg(1986) tradewbreg(1970&1980&1986) lp_bl(1985) ls_bl(1985) lh_bl(1985), trunit(7) trperiod(1987) mspeperiod (1970(1)1986) resultsperiod(1970(1)2000) keep(synth_korea.dta) replace fig;
*Parallel: synth y taxratio ltrade2 ltfp lmort ginv lgov unrestreg(1986) tradewbreg(1975&1980&1986) lp_bl(1985) ls_bl(1985) lh_bl(1985), trunit(7) trperiod(1987) mspeperiod (1970(1)1986) resultsperiod(1970(1)2000) keep(synth_korea.dta) replace fig;
*Parallel 2: synth y taxratio(1980(1)1986) ltrade2(1980(1)1986) ltfp lmort ginv lgov unrestreg(1986) tradewbreg(1970&1980&1986) lp_bl(1985) ls_bl(1985) lh_bl(1985), trunit(7) trperiod(1987) mspeperiod (1970(1)1986) resultsperiod(1970(1)2000) keep(synth_korea.dta) replace fig;
*synth y taxratio ltrade2 ltfp lmort ginv lgov unrestreg(1986) tradewbreg(1986) lp_bl(1970&1985) ls_bl(1970&1985) lh_bl(1970&1985), trunit(10) trperiod(1987) unitnames(country_name) mspeperiod (1970(1)1986) resultsperiod(1970(1)2000) keep(synth_korea.dta) replace fig;
*synth y taxratio(1970&1980&1986) ltrade2(1970&1980&1986) ltfp(1970&1980&1986) lmort ginv lgov(1970&1980&1986) unrestreg(1980&1986) tradewbreg(1986) lp_bl(1980&1985) ls_bl(1980&1985) lh_bl(1980&1985), trunit(7) trperiod(1987) mspeperiod (1970(1)1986) resultsperiod(1970(1)2000) keep(synth_korea.dta) replace fig;
*synth gdppercapitaconstant2000us taxratio ltrade2 ltfp lmort ginv lgov unrestreg(1986) tradewbreg lp_bl ls_bl lh_bl, trunit(7) trperiod(1987) mspeperiod (1970(1)1986) resultsperiod(1970(1)2000) keep(synth_korea.dta) replace fig;

* Plot the gap in predicted error
use synth_korea.dta, clear
keep _Y_treated _Y_synthetic _time
drop if _time==.
rename _time year
rename _Y_treated  treat
rename _Y_synthetic counterfact
gen gap=treat-counterfact
sort year 
twoway (line gap year,lp(solid)lw(vthin)lcolor(black)), yline(0, lpattern(shortdash) lcolor(black)) xline(1987, lpattern(shortdash) lcolor(black)) xtitle("",si(medsmall)) xlabel(#10) ytitle("Gap in GDP per capita prediction error", size(medsmall)) legend(off)
save synth_gap_korea.dta, replace

* Placebo test
clear 
cd "C:\Users\H\Desktop\CS classes\SS154\Assignment\Final Assignment\Synthetic control 2"
use "C:\Users\H\Desktop\CS classes\SS154\Assignment\Final Assignment\Synthetic control 2\synth_korea_2.dta" 

#delimit;
set more off;
local countrylist  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19;
foreach i of local countrylist {;
	synth y taxratio ltrade2 ltfp lmort ginv lgov unrestreg(1986) tradewbreg(1986) lp_bl(1980) ls_bl(1975) lh_bl(1975), trunit(`i') trperiod(1987) unitnames(country_name) mspeperiod (1970(1)1986) resultsperiod(1970(1)2000) keep(synth_`i'.dta) replace; matrix country_name`i' = e(RMSPE);
}; 

/* check the V matrix*/
			
 foreach i of local countrylist {;
 matrix rownames country_name`i'=`i';
 matlist country_name`i', names(rows);
 };

#delimit cr
 
 
local countrylist  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19

 foreach i of local countrylist {
 	use synth_`i' ,clear
 	keep _Y_treated _Y_synthetic _time
 	drop if _time==.
	rename _time year
 	rename _Y_treated  treat`i'
 	rename _Y_synthetic counterfact`i'
 	gen gap`i'=treat`i'-counterfact`i'
 	sort year 
 	save synth_gap_`i'.dta, replace
}

use synth_gap_korea.dta, clear
sort year
save placebo_korea.dta, replace

foreach i of local countrylist {
		
		merge year using synth_gap_`i'
		drop _merge
		sort year
		
	save placebo_korea.dta, replace
}

* All the placeboes on the same picture
use placebo_korea.dta, replace

* Picture of the full sample, including outlier RSMPE
#delimit;	

twoway 
(line gap1 year ,lp(solid)lw(vthin)) 
(line gap2 year ,lp(solid)lw(vthin)) 
(line gap3 year ,lp(solid)lw(vthin)) 
(line gap4 year ,lp(solid)lw(vthin)) 
(line gap5 year ,lp(solid)lw(vthin))
(line gap6 year ,lp(solid)lw(vthin)) 
(line gap7 year ,lp(solid)lw(vthin)) 
(line gap8 year ,lp(solid)lw(vthin)) 
(line gap9 year ,lp(solid)lw(vthin)) 
(line gap11 year ,lp(solid)lw(vthin)) 
(line gap12 year ,lp(solid)lw(vthin)) 
(line gap13 year ,lp(solid)lw(vthin)) 
(line gap14 year ,lp(solid)lw(vthin)) 
(line gap15 year ,lp(solid)lw(vthin)) 
(line gap16 year ,lp(solid)lw(vthin)) 
(line gap17 year ,lp(solid)lw(vthin)) 
(line gap18 year ,lp(solid)lw(vthin)) 
(line gap19 year ,lp(solid)lw(vthin)) 
(line gap10 year ,lp(solid)lw(thick)lcolor(black)), /*treatment unit, South Korea*/
yline(0, lpattern(shortdash) lcolor(black)) xline(1987, lpattern(shortdash) lcolor(black))
xtitle("",si(small)) xlabel(#10) ytitle("Gap in GDP per capita", size(small))
	legend(off);

#delimit cr

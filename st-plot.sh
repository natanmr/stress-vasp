#/bin/bash

# Colect the results of stress tensor calculation
step_st=0; > stress.dat
dirs_st=($(ls -d */ | grep -E '^[0-9]'))

echo "#step    E_tot            Volume        Pressure" >> stress.dat
for run in $(seq 1 ${#dirs_st[*]}); do
        energy=($(grep 'energy  w' ./$run/OUTCAR | awk '{print $7}'))
        vol=($(grep 'volume of cell' ./$run/OUTCAR | awk '{print $5}' | awk 'NR>1'))
        press=($(grep 'external pressure' ./$run/OUTCAR | awk '{print $4}'))
        for n in $( seq 0 $(echo "${#energy[@]}-1"| bc ) ) ; do
                echo $step_st "    " ${energy[$n]} "    " ${vol[$n]} "    " ${press[$n]}  >> stress.dat
                step_st=$((step_st+1))
        done
        echo "" >> stress.dat
done


# Configure the plot
cat << EOF > st_plot.gps
set encoding iso_8859_1
set terminal postscript eps enhanced  color font "Times-New-Roman,16"# Configurations of plot
set output 'stress.eps' #Outuput file

# global options:
ntics=5
set style line 1 lc rgb 'black' pt 7   # circle
stats "stress.dat" u 1 nooutput
set xrange [STATS_min-1:STATS_max+1]

# Set title and Labels
set multiplot layout 4,1  title "Stress Tensor Calculation\n" font ",20"   

unset xlabel
set tmargin 2; set bmargin 0; set lmargin 15; set rmargin 7
unset xtics 

set ylabel "E_{tot} (eV)"
stats "stress.dat" u 2 nooutput
set ytics STATS_min, abs(STATS_max-STATS_min)/4, STATS_max nomirror
plot 'stress.dat' u 1:2 w lp ls 1 t "" 

set ylabel "V ({\305}^3)" 
stats "stress.dat" u 3 nooutput
set ytics STATS_min, abs(STATS_max-STATS_min)/4, STATS_max nomirror
plot 'stress.dat' u 1:3 w lp ls 1 t ""

set ylabel "Pressure (kB)" 
set xlabel "Step"
set xtics nomirror
stats "stress.dat" u 4 nooutput
set ytics STATS_min, abs(STATS_max-STATS_min)/4, STATS_max nomirror
plot 'stress.dat' u 1:4 w lp ls 1 t ""

unset multiplot
EOF
gnuplot st_plot.gps
rm st_plot.gps



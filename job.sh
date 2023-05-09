#!/bin/bash

#PBS -q workq
#PBS -l nodes=1:ppn=16
#PBS -l walltime=48:00:00
#PBS -m bae  
#PBS -N teste
#PBS -j oe
#PBS -V

### cd to directory where the job was submitted:
cd $PBS_O_WORKDIR

source /opt/intel/oneapi/setvars.sh
ulimit -s unlimited
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1

# Vasp executable to use:
v_exec=/home/nmregis/fontes/vasp/vasp.5.4.4/bin/vasp_std

# Check if we're rerunning the calculation:
dirs=($(ls -d */ | grep -E '^[0-9]'))
if [[ "${#dirs[*]}" == "0" ]]; then
	echo "Runing from the scratch"
	nstart=0		
else
	echo 'runing in the (re)start mode'
	nstart="${#dirs[*]}"
fi

#Create OSZICAR if file not exists
if [[ ! -e OSZICAR ]]; then
       	touch OSZICAR
fi 

# loop for reexecute until convergence (max 10) 
n_max=10


for counter in $(seq $(($nstart+1)) $(($nstart+$n_max)) ); do
	if [[ $(tail -1 OSZICAR) =~ [[:blank:]]+"1 F="  ]]; then
		echo "Converged! "
		break
	else
		./or.x < POSCAR > KPOINTS		
		mpiexec  $v_exec > saida.out
		mkdir ./$counter
		cp POSCAR OUTCAR KPOINTS CONTCAR ./$counter
		mv CONTCAR POSCAR
	fi
done

# stress-vasp
Project with automatic job for stress tensor calculations and automatic plot of some parameters

- The job.sh run the calculation util if is converged. The max number os reexecutions could be changed
- the file stress.sh colect the data (total energy, volume and external pressure) and plot it
- the file kp-gen.f90 is used to generate kpoint mesh based on the Rk parameter (more informations in https://www.vasp.at/wiki/index.php/KPOINTS)

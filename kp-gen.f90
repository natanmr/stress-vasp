!gfortran rkmesh-POSCAR.f90 -o rkmesh.x
!rkmesh.x < POSCAR > out.dat
!reads POSCAR and generates k-mesh size as a function of kpoints density
program main

implicit none
double precision,dimension(3,3) :: rlat
integer,dimension(3) :: ngrid
double precision :: rk
integer :: i
character(len=30) :: cflag
double precision :: ifactor

read(*,*) cflag
read(*,*) ifactor

read(*,*) rlat(1,1),rlat(1,2),rlat(1,3)
read(*,*) rlat(2,1),rlat(2,2),rlat(2,3)
read(*,*) rlat(3,1),rlat(3,2),rlat(3,3)

rlat=ifactor*rlat


! write(*,*) "         ","rk","          ","Nk1","          ","Nk2","          ","Nk3"

! do i=1,20

i=35 ! Este é Rk. Ajustar para cada sistema.
rk= dble(i)
!call rkmesh2D(rk,rlat,ngrid)
call rkmesh(rk,rlat,ngrid)

                ngrid(3) = 1  ! Para sistemas 2D, fazemos o grid = 1 na terceira direção. 

                write(*,'(a14)') "Automatic mesh"
                write(*,'(a69)') "0              ! number of k-points = 0 ->automatic generation scheme"
                write(*,'(a32)') "Monkhorst-Pack ! fully automatic"
write(*,'(3i6)') ngrid(1),ngrid(2),ngrid(3)

! end do



end program main



subroutine rkmesh(rk,rlat,ngrid)

implicit none

integer,dimension(3) :: ngrid
double precision :: rk
double precision,dimension(3,3) :: rlat,blat
double precision,dimension(3) :: vsize
double precision,parameter :: pi=acos(-1.0)

call recvec(rlat(1,:),rlat(2,:),rlat(3,:),blat(1,:),blat(2,:),blat(3,:))

call vecsize(blat(1,:),vsize(1))
call vecsize(blat(2,:),vsize(2))
call vecsize(blat(3,:),vsize(3))

vsize = vsize/(2*pi)

ngrid(1) = int(max(1.0,(rk*vsize(1))+0.5))
ngrid(2) = int(max(1.0,(rk*vsize(2))+0.5))
ngrid(3) = int(max(1.0,(rk*vsize(3))+0.5))



end subroutine rkmesh

subroutine rkmesh2D(rk,rlat,ngrid)

implicit none

integer,dimension(3) :: ngrid
double precision :: rk
double precision,dimension(3,3) :: rlat,blat
double precision,dimension(3) :: vsize
double precision,parameter :: pi=acos(-1.0)

call recvec(rlat(1,:),rlat(2,:),rlat(3,:),blat(1,:),blat(2,:),blat(3,:))

call vecsize(blat(1,:),vsize(1))
call vecsize(blat(2,:),vsize(2))
call vecsize(blat(3,:),vsize(3))

vsize = vsize/(2*pi)

ngrid(1) = int(max(1.0,(rk*vsize(1))+0.5))
ngrid(2) = int(max(1.0,(rk*vsize(2))+0.5))
ngrid(3) = 1



end subroutine rkmesh2D

subroutine recvec(rlat1,rlat2,rlat3,blat1,blat2,blat3) !calcula os vetores da rede recíproca, a partir dos vetores da rede real

implicit none

double precision,parameter :: pi=acos(-1.)

double precision,dimension(3) :: rlat1,rlat2,rlat3
double precision,dimension(3) :: blat1,blat2,blat3

double precision,dimension(3) :: v23,v31,v12
double precision :: vol

call prodvec(rlat2,rlat3,v23)
call prodvec(rlat3,rlat1,v31)
call prodvec(rlat1,rlat2,v12)

vol= abs((rlat1(1)*v23(1))+(rlat1(2)*v23(2))+(rlat1(3)*v23(3)))

blat1 = ((2.0*pi)/vol)*v23
blat2 = ((2.0*pi)/vol)*v31
blat3 = ((2.0*pi)/vol)*v12


end subroutine recvec

subroutine vecsize(vec,vsize)

double precision,dimension(3) :: vec
double precision :: vsize

vsize= sqrt((vec(1)**2)+(vec(2)**2)+(vec(3)**2))


end subroutine vecsize

subroutine prodvec(v1,v2,vx) !calcula o vetor oriundo do produto vetorial entre dois vetores v1 X v2

implicit none

double precision,dimension(3) :: v1,v2,vx

vx(1) = (v1(2)*v2(3))-(v1(3)*v2(2))
vx(2) = (v1(3)*v2(1))-(v1(1)*v2(3))
vx(3) = (v1(1)*v2(2))-(v1(2)*v2(1))


end subroutine prodvec

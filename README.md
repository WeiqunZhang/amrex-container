To pull the latest amrex container, run
```
$ docker pull weiqunzhang/amrex:latest
```

Start the container with:
```
$ docker run -it weiqunzhang/amrex:latest
```

This will put you in `/home/amrexuser`. Inside this directory, you will find
two subdirectories,
  * `amrex`: the AMReX source code (with a CMake build directory inside),
  * `amrex-101`: an example code.

A precompiled AMReX library is located at `~/amrex/installdir`. To run some
tests using CTest,
```
$ cd ~/amrex/
$ ctest --test-dir build
```

If you are a GNU Make user, you can do the following to compile and run the
example code amrex-101.
```
$ cd ~/amrex-101/Amr/Exec
$ make -j
$ mpiexec -n 4 ./main3d.gnu.MPI.ex inputs
```

If you are a CMake user, you can do the following to compile and run the
example code amrex-101.
```
$ cd ~/amrex-101/Amr
$ cmake -S . -B build -DAMReX_ROOT=${HOME}/amrex/installdir
$ cmake --build build -j
$ cd Exec
$ mpiexec -n 4 ../build/amr101 inputs
```

You can also make a movie using the pre-installed ParaView in the container,
if your machine is x86_64.
```
$ cd ~/amrex-101/Amr/Exec
$ pvpython paraview_amr101.py
```

To get the movie files to the host, run this from a terminal on the *host*
while the container is still running.
```
$ docker cp $(docker ps -q | head -n1)://home/amrexuser/amrex-101/Amr/Exec/amr101_3D.avi .
$ docker cp $(docker ps -q | head -n1)://home/amrexuser/amrex-101/Amr/Exec/amr101_3D.gif .
```

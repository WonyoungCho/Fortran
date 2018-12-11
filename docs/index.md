# Programming with Fortran.

**Fortran** 언어를 기본으로 하여 병렬처리 방법인 **OpenMP**와 **MPI** 사용법에 대하여 예제와 함께 공부할 수 있는 공간입니다.

<a href="https://fortran.readthedocs.io" target="_blank"> https://fortran.readthedocs.io </a>

예제는 KISTI 교육자료를 참고 하였습니다. (<a href="http://webedu.ksc.re.kr" target="_blank">http://webedu.ksc.re.kr/ </a>)

---

**Wonyoung Cho**.

<bourbaki10@gmail.com>

---
## Install
- **gFortran**
```sh
$ sudo pacman -S gcc-fortran
```

- **OpenMP**
```sh
$ sudo pacman -S gcc
```

- **MPI**
```sh
$ sudo pacman -S openmpi
```

## alias
```sh
alias f='gfortran -o a'
alias fp='gfortran -fopenmp -o d'
alias m='mpif90 -o a'
alias mp='mpif90 -fopenmp -o a'
```

## etc

<a href="http://lsi.ugr.es/jmantas/pdp/ayuda/datos/instalaciones/Install_OpenMPI_en.pdf" target="_blank"> OpenMPI Installation </a>

<a href="https://gcc.gnu.org/wiki/GFortranBinaries" target="_blank"> https://gcc.gnu.org/wiki/GFortranBinaries </a>

<a href="http://www.lapk.org/gfortran/gfortran.php?OS=7" target="_blank">   http://www.lapk.org/gfortran/gfortran.php?OS=7 </a>

<a href="https://github.com/fxcoudert/gfortran-for-macOS/releases" target="_blank">  https://github.com/fxcoudert/gfortran-for-macOS/releases </a>

```bash
$ brew install gcc --without -multilib
```

---



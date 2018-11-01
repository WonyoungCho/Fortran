# Parallel loop
```bash
!$omp parallel
!$omp do
do =1,N
...
!$omp end do
!$omp end parallel
```
it can be written as
```bash
!$omp do
do =1,N
...
!$omp end parallel do
```
***Caution** 

**Fortran**에서 변수를 초기화 해주는 `!$omp workshare` 가 있지만 `!$omp do` 를 이용하여 초기화 하는 방법이 더 빠르다.
```bash
integer::a(1000)
!$omp do
do i=1,1000
  a(i)=100
enddo
!$omp end do

!! or !!

!$omp workshare
a(N)=100
!$omp end workshare
```
## Example 1
``` bash
program parallel_for
  integer, parameter :: N=20
  integer :: tid, i, omp_get_thread_num

  call omp_set_num_threads(4)
  !$omp parallel private(tid)
  tid = omp_get_thread_num()

  !$omp do
  do i=0, N-1
     print *, 'Hello World', tid, i
  end do
  !$omp end do !!! optional
  !$omp end parallel
end program parallel_for
```
i는 지정해 주지 않았는데 shared 인가 private 인가?

Ans) **Fortran**에서는 loop 변수가 몇 개가 되든 `private` 로 취급한다. **C**의 multi-loop는 2번째 변수부터 `shared` 로 설정된다.
```
 Hello World           0           0
 Hello World           0           1
 Hello World           0           2
 Hello World           0           3
 Hello World           0           4
 Hello World           2          10
 Hello World           2          11
 Hello World           2          12
 Hello World           3          15
 Hello World           3          16
 Hello World           3          17
 Hello World           3          18
 Hello World           3          19
 Hello World           1           5
 Hello World           1           6
 Hello World           1           7
 Hello World           1           8
 Hello World           1           9
 Hello World           2          13
 Hello World           2          14
```

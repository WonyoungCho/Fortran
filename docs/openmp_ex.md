# Hello World!


**[Exmaple 1](#)**
``` bash
program hello
  implicit none
  integer::omp_get_thread_num

  !$omp parallel
  print*,'hello',omp_get_thread_num()
  !$omp end parallel
end program hello
```
`Terminal`에서 정한 `thread` 숫자만큼 병렬화 작업이 된다.
```
$ export OMP_NUM_THREADS=8
$ ./a.out
 hello           0
 hello           7
 hello           3
 hello           4
 hello           1
 hello           2
 hello           6
 hello           5
```
코드 내부에서 `thread` 수를 정해주는 방법도 있다.

**`Exmaple 2`**
``` bash
program hello
  implicit none
  integer::omp_get_thread_num

  call omp_set_num_threads(4)
  !$omp parallel
  print*,'hello',omp_get_thread_num()
  !$omp end parallel
end program hello
```
```bash
$ ./a.out
 hello           3
 hello           0
 hello           2
 hello           1

```
또는

**`Exmaple 3`**
``` bash
program hello
  implicit none
  integer::omp_get_thread_num

  !$omp parallel num_threads(2)
  print*,'hello',omp_get_thread_num()
  !$omp end parallel
end program hello
```
```bash
$ ./a.out
 hello           0
 hello           1
```
**Tip!** `get`이 들어가는 구문(`omp_get_thread_num`)은 `function`에 해당하고, `set`이 들어가는 구문(`omp_set_num_threads(4)`)은 `subroutine`에 해당하며 `call`을 동반한다(**`Example 2`**).

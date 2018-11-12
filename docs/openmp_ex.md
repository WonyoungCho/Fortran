# Hello World!

- **Example 1**
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
다음과 같이 코드 내부에서 `thread` 수를 정해주는 방법도 있다.

- **Exmaple 2{:name="hello_ex2"}**
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

- **Exmaple 3**
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

- **Exmaple 4**
```bash
program hello
  use omp_lib
  implicit none

  !$omp parallel num_threads(2)
  print*,'hello',omp_get_thread_num()
  !$omp end parallel
end program hello
```
`use omp_lib`를 사용하면 `omp_get_thread_num`을 따로 *integer*로 지정해 줄 필요가 없고, **OpenMP** `subroutine`을 사용할 수 있다.
```bash
$ ./a.out
 hello           0
 hello           1
```

**Tip!** `get`이 들어가는 구문(`omp_get_thread_num`)은 `function`에 해당하고, `set`이 들어가는 구문(`omp_set_num_threads(4)`)은 `subroutine`에 해당하며 `call`을 동반한다([**Example 2**](#hello_ex2)).

# thread_num & num_threads

`thread_num`은 전체 `thread id`를 나타내며, `num_threads'는 사용된 `thread` 수를 나타낸다.

- **Example 1**
``` bash
program thread
  integer::omp_get_thread_num, omp_get_num_threads

  print *, 'threads = ', omp_get_num_threads()

  !$omp parallel num_threads(3)
  print *, 'tid = ', omp_get_thread_num(), ' threads = ', omp_get_num_threads()
  !$omp end parallel

  print *, 'threads = ', omp_get_num_threads()

  !$omp parallel
  print *, 'tid = ', omp_get_thread_num(), ' threads = ', omp_get_num_threads()
  !$omp end parallel

  print *, 'threads = ', omp_get_num_threads()
end program hello_world
```
``` bash
$ ./a.out
 threads =            1
 tid =            0  threads =            3
 tid =            1  threads =            3
 tid =            2  threads =            3
 threads =            1
 tid =            1  threads =            8
 tid =            7  threads =            8
 tid =            5  threads =            8
 tid =            6  threads =            8
 tid =            3  threads =            8
 tid =            0  threads =            8
 tid =            4  threads =            8
 tid =            2  threads =            8
 threads =            1
```

# Private
**private** : shared memory에서 thread 별로 변수 memory를 각각 할당.

**firstprivate** : `!$omp_parallel` 이전에 선언된 변수에 할당된 memory 계속 사용.

- **Example 1**
```bash
program data_scope_firstprivate
  integer i, tid, omp_get_thread_num

  i = 10
  call omp_set_num_threads(4)
  !$omp parallel private(tid) firstprivate(i)
  tid = omp_get_thread_num()
  print *, ' tid = ', tid, ' i = ', i
  i = 20
  !$omp end parallel
  print *, ' tid = ', tid, ' i = ', i
end program data_scope_firstprivate
```
```bash
$ ./a.out
  tid =            2  i =           10
  tid =            0  i =           10
  tid =            1  i =           10
  tid =            3  i =           10
  tid =    674566864  i =           10
```

- **Exmaple 2**
```bash
program data_scope_firstprivate
  integer a(0:9), i, tid, omp_get_thread_num

  call omp_set_num_threads(4)
  !$omp parallel shared(a) private(tid)
  tid = omp_get_thread_num()
  a(tid) = tid + 1
  print *, a(tid),tid
  !$omp end parallel

  do i=0, 3
     print *, 'a(', i, ') = ', a(i)
  end do
end program data_scope_firstprivate
```
```bash
$ ./a.out
           1           0
           3           2
           4           3
           2           1
 a(           0 ) =            1
 a(           1 ) =            2
 a(           2 ) =            3
 a(           3 ) =            4
```

- **Example 3**
```bash
program data_scope_solution
  integer :: a(0:11), i=10, tid, omp_get_thread_num

  call omp_set_num_threads(4)
  !$omp parallel shared(a) private(tid) firstprivate(i)
  tid = omp_get_thread_num()
  i = i + tid
  a(tid+0) = i + 0
  a(tid+4) = i + 4
  a(tid+8) = i + 8
  !$omp end parallel

  !! or

  !$omp parallel shared(a) private(tid) firstprivate(i)
  tid = omp_get_thread_num() * 3
  i = i + tid
  a(tid+0) = i + 0
  a(tid+1) = i + 1
  a(tid+2) = i + 2
  !$omp end parallel

  do i=0, 11
     print *, 'a(', i, ') = ', a(i)
  end do
end program data_scope_solution
```
```
$ ./a.out
 a(           0 ) =           10
 a(           1 ) =           11
 a(           2 ) =           12
 a(           3 ) =           13
 a(           4 ) =           14
 a(           5 ) =           15
 a(           6 ) =           16
 a(           7 ) =           17
 a(           8 ) =           18
 a(           9 ) =           19
 a(          10 ) =           20
 a(          11 ) =           21
```

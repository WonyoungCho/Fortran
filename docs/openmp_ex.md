# Hello World!

- **Example 1**
```bash
program hello
  implicit none
  integer :: omp_get_thread_num

  !$omp parallel
  print*,'hello',omp_get_thread_num()
  !$omp end parallel
end program hello
```
`Terminal`에서 정한 `thread` 숫자만큼 병렬화 작업이 된다.
```sh
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

- <a name="hello_ex2"></a>**Exmaple 2**
```bash
program hello
  implicit none
  integer :: omp_get_thread_num

  call omp_set_num_threads(4)
  !$omp parallel
  print*,'hello',omp_get_thread_num()
  !$omp end parallel
end program hello
```
```sh
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
  integer :: omp_get_thread_num

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

`thread_num`은 각각의 잡이 할당된 `thread id`를 나타내며, `num_threads`는 사용된 전체 `thread` 수를 나타낸다.

- **Example 1**
``` bash
program thread
  integer :: omp_get_thread_num, omp_get_num_threads

  print *, 'threads = ', omp_get_num_threads()

  !$omp parallel num_threads(3)
  print *, 'tid = ', omp_get_thread_num(), ' threads = ', omp_get_num_threads()
  !$omp end parallel

  print *, 'threads = ', omp_get_num_threads()

  !$omp parallel
  print *, 'tid = ', omp_get_thread_num(), ' threads = ', omp_get_num_threads()
  !$omp end parallel

  print *, 'threads = ', omp_get_num_threads()
end program thread
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
program firstprivate
  integer :: i, tid, omp_get_thread_num

  i = 10
  call omp_set_num_threads(4)
  !$omp parallel private(tid) firstprivate(i)
  tid = omp_get_thread_num()
  print *, ' tid = ', tid, ' i = ', i
  i = 20
  !$omp end parallel
  print *, ' tid = ', tid, ' i = ', i
end program firstprivate
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
program firstprivate
  integer :: a(0:9), i, tid, omp_get_thread_num

  call omp_set_num_threads(4)
  !$omp parallel shared(a) private(tid)
  tid = omp_get_thread_num()
  a(tid) = tid + 1
  print *, a(tid),tid
  !$omp end parallel

  do i=0, 3
     print *, 'a(', i, ') = ', a(i)
  end do
end program firstprivate
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
program private
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
end program private
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

# Parallel loop
```bash
!$omp parallel
!$omp do
do =1,N
...
!$omp end do
!$omp end parallel
```
`!$omp parallel`과 `!$omp do` 사이에 다른 구문이 없을 때, 다음과 같이 작성할 수 있다.
```bash
!$omp parallel do
do =1,N
...
!$omp end parallel do
```
**주의**해야 할 사항으로는 `!$omp parallel do` 바로 밑에는 do 문이 와야 한다.

Multi-loop 경우에 가장 바깥 do 문만 병렬작업을 하게 된다.

- **Example 1**
``` bash
program parallel_loop
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
end program parallel_loop
```
질문) 변수 `i`는 지정해 주지 않았는데 shared 인가 private 인가?

정답) **Fortran**에서는 loop 변수가 몇 개가 되든 `private`로 취급한다. **C**의 multi-loop는 2번째 변수부터 `shared`로 설정된다.
```
& ./a.out
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
**Tip!** 코드를 짜다보면 변수들을 초기화 해주어야 하는 경우가 있다. **Fortran**에서는 변수를 초기화 해주는 `!$omp workshare`가 있지만 `!$omp do`를 이용하여 변수를 초기화 하는 방법이 더 빠르다.
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

# Reduction
병렬처리 계산한 값을 합쳐서 최종 결과를 도출해야 하는 작업이 있을 경우 `reduction`은 유용하게 사용된다.

- **Example 1**
```bash
program atomic
  implicit none
  integer, parameter :: N=100

  integer :: i, sum=0, local_sum

  !$omp parallel private(local_sum)
  local_sum = 0
  !$omp do
  do i=1, N
     local_sum = local_sum + i
  end do

  !$omp atomic
  sum = sum + local_sum
  !$omp end parallel

  print *, 'sum =', sum
end program atomic
```
```
& ./a.out
 sum =        5050
```
`!$omp atomic`을 이용하여 각 `thread`에서 계산한 값을 더하여 최종 값을 도출하였다. 이것을 `!$omp parallel do reduction(+:sum)`을 써서 코드를 간단히 하면서 동일한 결과를 얻는다.
```bash
program reduction
  implicit none
  integer, parameter :: N=100

  integer :: i, sum=0

  !$omp parallel do reduction(+:sum)
  do i=1, N
     sum = sum + i
  end do
  !$omp end parallel do

  print *, 'sum =', sum
end program reduction
```
```
& ./a.out
 sum =        5050
```

**Tip!**

`!$omp critical` : 한 쓰레드가 계산하고 있으면 다른 쓰레드가 같은 메모리로의 접근을 못 하게 한다. 명령어가 여러 개 있을 때 사용.

`!$omp atomic` : `!$omp critical`과 같은 원리이지만 단순한 계산에서 쓰인다.

# Section
`Section`은 주로 독립적인 작업을 병렬로 처리할 경우 사용된다. Thread별로 `!$omp section` 구문 안의 일을 각각 동시에 처리한다. 장점은 `section`을 지정하여 **I/O** 시간을 줄일 수 있다.

Section 하나에 thread 한개가 할당된다. `!$omp parallel num_threads(2)`과 같이 section의 수를 고려하여 thread 수를 지정해 주어야 쓰지 않는 thread 생성에 걸리는 시간을 줄일 수 있다.
```bash
program sections
  integer i, a(0:9), b(0:19)

  call omp_set_num_threads(8)

  !$omp parallel num_threads(2)
  !$omp sections
  !$omp section
  do i=0, 9
     a(i) = i * 10 + 5
  end do
  !$omp section
  do i=0, 19
     b(i) = i * 5 + 10
  end do
  !$omp end sections
  !$omp end parallel

  write(*,10) a
  write(*,20) b

10 format(10i4)
20 format(20i4)
end program sections
```
```
& ./a.out
   5  15  25  35  45  55  65  75  85  95
  10  15  20  25  30  35  40  45  50  55  60  65  70  75  80  85  90  95 100 105
```

# Single & Master

`!$omp single`을 사용하면 임의의 한개의 thread에서만 작업을 한다. 나머지 `thread`들은 `single`로 할당된 `thread`의 작업이 끝날 때까지 기다렸다가 join 된다. 즉 barrier 기능이 있다.

`!$omp master`의 경우에는 다른 `thread`들이 barrier되지 않고 계산된다.

`!$omp single`의 barrier 기능을 해제하는 방법은 nowait 를 사용하는 방법이 있지만, 메모리 접근을 고려하여 조심하게 사용해야 한다 (`!$omp end single nowait`). 잘 사용하지는 않는다. 

- **Example - Single**
```bash
program single
  integer omp_get_thread_num

  call omp_set_num_threads(4)
  !$omp parallel
  !$omp single
  call sleep(1)
  print *, 'Hello World'
  !$omp end single
  print *, 'tid=',omp_get_thread_num()
  !$omp end parallel
end program single
```
```
& ./a.out
 Hello World
 tid=           0
 tid=           1
 tid=           2
 tid=           3
```

- **Example - Master**
```bash
program master
  integer omp_get_thread_num

  call omp_set_num_threads(4)
  !$omp parallel
  !$omp master
  call sleep(1)
  print *, 'Hello World'
  !$omp end master
  print *, 'tid=',omp_get_thread_num()
  !$omp end parallel
end program master
```
```
& ./a.out
 tid=           2
 tid=           3
 tid=           1
 Hello World
 tid=           0
```

# Nowait

`nowait`은 작업이 먼저 끝난 `thread`를 다른 작업에 투입되도록 한다.

-  **Example - end do nowait**
```bash
program do_nowait
  integer, parameter :: N = 20
  integer :: i, tid, a(N), omp_get_thread_num

  call omp_set_num_threads(4)
  !$omp parallel private(tid)
  tid = omp_get_thread_num()
  if( tid /= 2 ) then
     call sleep(5)
  end if
  !$omp do
  do i=0, N-1
     a(i) = i
     print *, 'a(',i,')=',a(i),' tid=',tid
  end do
  !$omp end do nowait
  print *, 'end ',tid,' thread'
  !$omp end parallel
end program do_nowait
```
```bash
& ./a.out
 a(          10 )=          10  tid=           2
 a(          11 )=          11  tid=           2
 a(          12 )=          12  tid=           2
 a(          13 )=          13  tid=           2
 a(          14 )=          14  tid=           2
 end            2  thread
 a(           5 )=           5  tid=           1
 a(           6 )=           6  tid=           1
 a(           7 )=           7  tid=           1
 a(           8 )=           8  tid=           1
 a(           9 )=           9  tid=           1
 end            1  thread
 a(           0 )=           0  tid=           0
 a(           1 )=           1  tid=           0
 a(           2 )=           2  tid=           0
 a(           3 )=           3  tid=           0
 a(           4 )=           4  tid=           0
 end            0  thread
 a(          15 )=          15  tid=           3
 a(          16 )=          16  tid=           3
 a(          17 )=          17  tid=           3
 a(          18 )=          18  tid=           3
 a(          19 )=          19  tid=           3
 end            3  thread
```

- **Example - end sections nowait**
```bash
program section_nowait
  integer, parameter :: N = 4
  integer :: i, tid, omp_get_thread_num

  call omp_set_num_threads(4)
  !$omp parallel private(i, tid)
  tid = omp_get_thread_num()
  !$omp sections
  !$omp section
  do i=0, N-1
     print *, 'L1 tid=',tid
  end do
  !$omp section
  do i=0, N-1
     print *, 'L2 tid=',tid
  end do
  call sleep(2);
  !$omp end sections nowait
  print *, 'end tid=', tid
  !$omp end parallel
end program section_nowait
```
```bash
& ./a.out
 L1 tid=           0
 L1 tid=           0
 L1 tid=           0
 L1 tid=           0
 end tid=          0
 end tid=          1
 end tid=          3
 L2 tid=           2
 L2 tid=           2
 L2 tid=           2
 L2 tid=           2
 end tid=          2
```

# Ordered

아래 예제와 같이 `do` 문은 임의의 thread가 작업하지만 결과는 순차적으로 출력하도록 한다.

- **Example 1**
```bash
program ordered
  integer i, a(0:9)

  call omp_set_num_threads(4)
  !$omp parallel private(i)
  !$omp do ordered
  do i=0, 9
     a(i) = i * 2
     !$omp ordered
     print *, 'a(',i,')=',a(i)
     !$omp end ordered
  end do
  !$omp end parallel
end program ordered
```
```
$ ./a.out
 a(           0 )=           0
 a(           1 )=           2
 a(           2 )=           4
 a(           3 )=           6
 a(           4 )=           8
 a(           5 )=          10
 a(           6 )=          12
 a(           7 )=          14
 a(           8 )=          16
 a(           9 )=          18
```

# Task

**Queue** 로 작업을 던지고 `thread`가 queue에서 작업을 가져오는 방식.

- **Example 1**
```bash
program task
  use omp_lib

  integer::a,b,c,d,e
  !$omp parallel private(b,d,e)
  !$omp task private(e)
    a : shared
    b : firstprivate
    c : shared
    d : firstprivate
    e : private
  !$omp end task
  !$omp end parallel
  
end program task
```

# Nested

`Thread` 내에서 또 다시 `thread` 병렬화를 할 때 사용한다.
- **Example 1**
```bash
program nested_parallel
  use omp_lib
  integer tid

  call omp_set_nested(.true.)
  call omp_set_num_threads(4)
  
  !$omp parallel private(tid)
  tid = omp_get_thread_num()
  print 10, 'thread id =', tid
  if( tid == 1 ) then
    !$omp parallel private(tid) num_threads(2)
    tid = omp_get_thread_num()
    print 20, 'thread id =', tid
    !$omp end parallel
  end if
  !$omp end parallel

10 format(A,I4)
20 format(T8,A,I4)
end program nested_parallel
```
`use omp_lib` 에는 nested 관련 수를 포함하고 있다.
```
$ ./a.out
thread id =   0
thread id =   2
thread id =   1
thread id =   3
       thread id =   0
       thread id =   2
       thread id =   3
       thread id =   1
       thread id =   4
```

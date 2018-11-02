# Nowait

nowait는 작업이 먼저 끝난 thread를 다음 작업에 투입되도록 한다.

## Example - end do nowait
```bash
program simple_test1
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
end program simple_test1
```
```
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

## Example - end sections nowait
```bash
program simple_test5
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
end program simple_test5
```
 L1 tid=           0
 L1 tid=           0
 L1 tid=           0
 L1 tid=           0
 end tid=           0
 end tid=           1
 end tid=           3
 L2 tid=           2
 L2 tid=           2
 L2 tid=           2
 L2 tid=           2
 end tid=           2

```

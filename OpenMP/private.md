# Private & Shared memory
**private** : shared memory에서 변수를 각각 선언.

**firstprivate** : `!$omp_parallel` 이전에 할당된 변수 계속 사용.
## Example 1
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
  tid =            2  i =           10
  tid =            0  i =           10
  tid =            1  i =           10
  tid =            3  i =           10
  tid =    674566864  i =           10
```

## Exmaple 2
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
```
           1           0
           3           2
           4           3
           2           1
 a(           0 ) =            1
 a(           1 ) =            2
 a(           2 ) =            3
 a(           3 ) =            4
```

## Example 3
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

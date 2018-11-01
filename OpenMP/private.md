# Private
private : shared memmory에서 변수를 각각 선언.
firstprivate : omp_parallel 이전에 할당된 변 계속 사용.
```
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
```
  tid =            2  i =           10
  tid =            0  i =           10
  tid =            1  i =           10
  tid =            3  i =           10
  tid =    674566864  i =           10
```

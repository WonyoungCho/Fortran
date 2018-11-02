# Nested

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
`use omp_lib` 에는 nested 관련 함수와 변수를 포함하고 있다 (`integer::omp_get_thread_num`).
```
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

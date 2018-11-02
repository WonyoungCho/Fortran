# Single & Master

`!$omp single`을 사용하면 임의의 한개의 thread에서만 작업을 한다. 나머지 thread들은 single 작업이 끝날 때까지 기다렸다가 join된다. 즉 barrier 기능이 있다.

`!$omp master`의 경우에는 barrier 기능이 없이 계산한다.
## Single
```bash
program master
  integer omp_get_thread_num

  call omp_set_num_threads(4)
  !$omp parallel
  !$omp single
  call sleep(1)
  print *, 'Hello World'
  !$omp end single
  print *, 'tid=',omp_get_thread_num()
  !$omp end parallel
end program master
```
```
 Hello World
 tid=           0
 tid=           1
 tid=           2
 tid=           3
```

## Master
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
 tid=           2
 tid=           3
 tid=           1
 Hello World
 tid=           0
```

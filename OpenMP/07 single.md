# Single & Master

`!$omp single`을 사용하면 임의의 한개의 thread에서만 작업을 한다. 나머지 thread들은 single 작업이 끝날 때까지 기다렸다가 join된다. 즉 barrier 기능이 있다.

`!$omp master`의 경우에는 다른 thread들의 barrier되지 않고 계산한다.

`!$omp single`의 barrier 기능을 해제하는 방법은 nowait 를 사용하는 방법이 있지만, 메모리 접근을 고려하여 조심하게 사용해야 한다 (`!$omp end single nowait`). 잘 사용하지는 않는다. 


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

# thread_num & num_threads
``` bash
program hello_world
  integer omp_get_thread_num, omp_get_num_threads

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

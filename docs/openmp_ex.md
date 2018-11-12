# Hello World!

``` bash
program hello
  implicit none
  integer::omp_get_thread_num

  !$omp parallel
  print*,'hello',omp_get_thread_num()
  !$omp end parallel
end program hello
```

```
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

``` bash
program hello
  implicit none
  integer::omp_get_thread_num

  call omp_set_num_threads(4)
  !$omp parallel
  print*,'hello',omp_get_thread_num()
  !$omp end parallel
  print*,''
  !$omp parallel num_threads(2)
  print*,'hello',omp_get_thread_num()
  !$omp end parallel

end program hello
```
get : function, set : subroutine
```
 hello           0
 hello           7
 hello           3
 hello           4
 hello           1
 hello           2
 hello           6
 hello           5

 hello           3
 hello           0
 hello           2
 hello           1

 hello           0
 hello           1
```


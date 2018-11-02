# Task
**Queue** 로 작업을 던지고 thread이 queue에서 작업을 가져오는 방식.
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

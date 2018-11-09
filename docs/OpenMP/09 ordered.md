# Ordered

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
`do` 문은 임의의 thread가 작업하지만 결과는 순차적으로 출력하도록 한다.
```
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

# Sections - section
```bash
program sections
  integer i, a(0:9), b(0:19)

  call omp_set_num_threads(2)

  !$omp parallel
  !$omp sections
  !$omp section
  do i=0, 9
     a(i) = i * 10 + 5
  end do
  !$omp section
  do i=0, 19
     b(i) = i * 5 + 10
  end do
  !$omp end sections
  !$omp end parallel

  write(*,10) a
  write(*,20) b

10 format(10i4)
20 format(20i4)
end program sections
```
```
   5  15  25  35  45  55  65  75  85  95
  10  15  20  25  30  35  40  45  50  55  60  65  70  75  80  85  90  95 100 105
```

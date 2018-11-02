# Sections - section
Thread별로 `!$omp section` 구문 안의 일을 각각 동시에 처리한다.

Section을 지정하여 **I/O** 시간을 줄일 수 있다.

Section 하나에 thread 한개가 할당된다. `!$omp parallel num_threads(2)`과 같이 section의 수를 고려하여 thread 수를 지정해 주어야 쓰지 않는 thread 생성에 걸리는 시간을 줄일 수 있다.
```bash
program sections
  integer i, a(0:9), b(0:19)

  call omp_set_num_threads(8)

  !$omp parallel num_threads(2)
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

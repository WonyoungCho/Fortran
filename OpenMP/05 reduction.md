`!$omp critical` : 한 쓰레드가 계산하고 있으면 다른 쓰레드가 같은 메모리로의 접근을 못 하게 한다. 명령어가 여러 개 있을 때 사용.

`!$omp atomic` : `!$omp critical`과 같은 원리이지만 한 개의 계산에서 쓰인다.
## Example 1
```bash
program sync_exercise
  implicit none
  integer, parameter :: N=100

  integer :: i, sum=0, local_sum

  !$omp parallel private(local_sum)
  local_sum = 0
  !$omp do
  do i=1, N
     local_sum = local_sum + i
  end do

  !$omp atomic
  sum = sum + local_sum
  !$omp end parallel

  print *, 'sum =', sum
end program sync_exercise
```
```
 sum =        5050
```
Each thread local sums can be summed with `!$omp parallel do reduction(+: sum)`.
```bash
program sync_exercise
  implicit none
  integer, parameter :: N=100

  integer :: i, sum=0

  !$omp parallel do reduction(+:sum)
  do i=1, N
     sum = sum + i
  end do
  !$omp end parallel do

  print *, 'sum =', sum
end program sync_exercise
```
```
 sum =        5050
```

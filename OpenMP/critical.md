`!$omp critical` : 한 쓰레드가 계산하고 있으면 다른 쓰레드가 같은 메모리로의 접근을 못 하게한다.

`!$omp atomic` : `critical`과 같지만, 간단한 계산에서 쓰인다. Like mini-critical section.

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

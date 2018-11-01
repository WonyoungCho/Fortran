program hello
  implicit none
  integer::omp_get_thread_num

  !$omp parallel
  print*,'hello',omp_get_thread_num()
  !$omp end parallel
  print*,''
  call omp_set_num_threads(4)
  !$omp parallel
  print*,'hello',omp_get_thread_num()
  !$omp end parallel
  print*,''
  !$omp parallel num_threads(2)
  print*,'hello',omp_get_thread_num()
  !$omp end parallel

end program hello

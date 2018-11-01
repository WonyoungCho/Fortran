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

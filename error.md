# MPI_REDUCE with over 200 cores.
```fortran
program reduce_test
  use mpi_f08
  implicit none
  integer :: nproc, rank
  integer(8) :: istat, iend, n
  integer(8) :: i,j, k=0
  integer(8) :: tsum=0

  call mpi_init
  call mpi_comm_size(mpi_comm_world, nproc)
  call mpi_comm_rank(mpi_comm_world, rank)

  n=10000

  istat = rank*n/nproc + 1 ; iend=(rank+1)*n/nproc

  do i= istat,iend
     k = 1
  enddo

  call mpi_reduce(k, tsum, 1, mpi_integer8, mpi_sum, 0, mpi_comm_world)
  call mpi_finalize

  print *, 'Result :', rank, k, tsum

end program reduce_test
```
```sh
[compute-0-18:184026] *** An error occurred in MPI_Reduce
[compute-0-18:184026] *** reported by process [2538104278,200]
[compute-0-18:184026] *** on communicator MPI_COMM_WORLD
[compute-0-18:184026] *** MPI_ERR_OTHER: known error not in list
[compute-0-18:184026] *** MPI_ERRORS_ARE_FATAL (processes in this communicator will now abort,
[compute-0-18:184026] ***    and potentially your MPI job)
[compute-0-1][[38728,26070],64][connect/btl_openib_connect_udcm.c:2034:udcm_process_messages] could not initialize cpc data for endpoint
srun: Job step aborted: Waiting up to 32 seconds for job step to finish.
slurmstepd: error: *** STEP 49022.0 ON compute-0-0 CANCELLED AT 2018-11-28T23:15:38 ***
[compute-0-18:184034] *** An error occurred in MPI_Reduce
[compute-0-18:184034] *** reported by process [2538104278,208]
[compute-0-18:184034] *** on communicator MPI_COMM_WORLD
[compute-0-18:184034] *** MPI_ERR_OTHER: known error not in list
[compute-0-18:184034] *** MPI_ERRORS_ARE_FATAL (processes in this communicator will now abort,
[compute-0-18:184034] ***    and potentially your MPI job)
[warn] Epoll ADD(4) on fd 30 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 28 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 36 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 31 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 43 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 37 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 40 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 34 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[compute-0-19:175381] pmix_usock_msg_send_bytes: write failed: Bad file descriptor (9) [sd = -1]
[warn] Epoll ADD(4) on fd 56 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 74 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 44 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 72 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 73 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 52 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 79 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 60 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 48 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 43 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 25 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 54 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 50 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 34 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 73 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 72 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 38 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 48 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 32 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 37 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 79 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 54 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 68 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 78 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 30 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 26 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 82 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 64 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 80 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 46 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 66 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 58 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 84 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 31 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 70 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 40 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 55 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 76 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 60 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 28 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 49 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 52 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 42 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 36 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 67 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
[warn] Epoll ADD(4) on fd 62 failed.  Old events were 0; read change was 0 (none); write change was 1 (add): Bad file descriptor
srun: error: compute-0-3: tasks 120-159: Killed
srun: error: Timed out waiting for job step to complete
```

# MPI + OpenMP

- **Example 1**
```bash
program hybrid
  use mpi_f08
  implicit none
  integer :: nproc, rank
  integer(8) :: istat, iend, n, sum=0
  integer(8) :: i,j,k

  call mpi_init
  call mpi_comm_size(mpi_comm_world, nproc)
  call mpi_comm_rank(mpi_comm_world, rank)

  n=10000000

  istat = rank*n/nproc + 1 ; iend=(rank+1)*n/nproc
  k=0
  do i= istat,iend
  !$omp parallel
  !$omp do reduction(+:k)
  do j = 1,10000
        k = k + i + j
     enddo
  !$omp end parallel
  enddo

  call mpi_reduce(k, sum, 1, mpi_integer8, mpi_sum, 0, mpi_comm_world)
  call mpi_finalize
  
  print *, 'Result :', rank, k, sum

end program hybrid
```
---

### Batch file
작업을 **Queue**에 넘겨주기 위해서는 배치파일을 만들면 편하다.

배치 파일 이름을 `hybrid.sh` 로 만들었다고 하자.
```sh
#! /bin/bash -l
#
#SBATCH --job-name=hybrid
#SBATCH --output=output.txt
#SBATCH --partition=microcentury
#SBATCH --ntasks=50          # number of tasks
#SBATCH --cpus-per-task=2    # number of threads
##SBATCH --nodes=2           # number of nodes

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
srun --mpi=pmix ./a
```

`#SBATCH --ntasks=50`는 **MPI**의 프로세서의 수 이며, `#SBATCH --cpus-per-task=2`는 **OpenMP**의 thread 수 이다.

`#SBATCH --nodes=2`를 설정하고 작업을 실행했을 때, 작업의 코어 갯수가 노드의 총 코어수를 넘는다면 에러 메시지를 보낸다. 넣지 않는게 좋다.

에러 메시지는 다음과 같다.
```sh
sbatch: error: Batch job submission failed: Requested node configuration is not available
```

배치파일을 실행하여 **Queue**에 작업을 올린다.
```sh
$ sbatch hybrid.sh
Fri Nov 23 03:41:00 2018
             JOBID PARTITION     NAME     USER    STATE       TIME TIME_LIMI  NODES NODELIST(REASON)
             48811 microcent   hybrid     ycho  RUNNING       0:01   1:00:00      3 compute-0-[21-23]
```

작업이 끝나고 log 파일을 확인하면 다음과 같이 3개의 Node를 사용하고, 100개의 core를 사용했다고 나온다.
```sh
        ycho 2018-11-23T03:40:59 2018-11-23T03:41:04   00:00:05          3        100  COMPLETED 
```

작업 결과로 생성된 `output.txt` 파일을 확인해 보자. 50개의 프로세서가 사용되었으며, 각 프로세서에서 계산되는 동안 2개씩의 thread 병렬 작업이 있었다.
```sh
$ cat output.txt
 Result :           41    16610002000000000                    0
 Result :           45    18210002000000000                    0
 Result :           43    17410002000000000                    0
 Result :           44    17810002000000000                    0
 Result :           42    17010002000000000                    0
 Result :           46    18610002000000000                    0
 Result :           49    19810002000000000                    0
 Result :           48    19410002000000000                    0
 Result :           47    19010002000000000                    0
 Result :           40    16210002000000000                    0
 Result :           25    10210002000000000                    0
 Result :           22     9010002000000000                    0
 Result :           23     9410002000000000                    0
 Result :           37    15010002000000000                    0
 Result :           27    11010002000000000                    0
 Result :           13     5410002000000000                    0
 Result :           24     9810002000000000                    0
 Result :           21     8610002000000000                    0
 Result :           26    10610002000000000                    0
 Result :           36    14610002000000000                    0
 Result :           30    12210002000000000                    0
 Result :           29    11810002000000000                    0
 Result :           31    12610002000000000                    0
 Result :           20     8210002000000000                    0
 Result :           38    15410002000000000                    0
 Result :           33    13410002000000000                    0
 Result :           34    13810002000000000                    0
 Result :           28    11410002000000000                    0
 Result :           35    14210002000000000                    0
 Result :           39    15810002000000000                    0
 Result :           32    13010002000000000                    0
 Result :           11     4610002000000000                    0
 Result :           17     7010002000000000                    0
 Result :            6     2610002000000000                    0
 Result :            7     3010002000000000                    0
 Result :            9     3810002000000000                    0
 Result :            3     1410002000000000                    0
 Result :            5     2210002000000000                    0
 Result :            4     1810002000000000                    0
 Result :            1      610002000000000                    0
 Result :            2     1010002000000000                    0
 Result :           12     5010002000000000                    0
 Result :            8     3410002000000000                    0
 Result :           18     7410002000000000                    0
 Result :           19     7810002000000000                    0
 Result :            0      210002000000000   500500100000000000
 Result :           10     4210002000000000                    0
 Result :           15     6210002000000000                    0
 Result :           14     5810002000000000                    0
 Result :           16     6610002000000000                    0
```

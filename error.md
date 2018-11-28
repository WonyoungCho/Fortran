# MPI_REDUCE with over 200 cores.
```sh
[compute-0-18:183218] *** An error occurred in MPI_Reduce
[compute-0-18:183218] *** reported by process [1013006671,200]
[compute-0-18:183218] *** on communicator MPI_COMM_WORLD
[compute-0-18:183218] *** MPI_ERR_OTHER: known error not in list
[compute-0-18:183218] *** MPI_ERRORS_ARE_FATAL (processes in this communicator will now abort,
[compute-0-18:183218] ***    and potentially your MPI job)
srun: Job step aborted: Waiting up to 32 seconds for job step to finish.
slurmstepd: error: *** STEP 49018.0 ON compute-0-0 CANCELLED AT 2018-11-28T22:53:52 ***
srun: error: compute-0-18: task 200: Exited with exit code 16
srun: error: compute-0-1: tasks 40-79: Killed
srun: error: compute-0-3: tasks 120-159: Killed
srun: error: compute-0-4: tasks 160-199: Killed
srun: error: compute-0-0: tasks 0-39: Killed
srun: error: compute-0-2: tasks 80-119: Killed
```

# Hello World

```c
#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
  int        nRank, nProcs;
  char     procName[MPI_MAX_PROCESSOR_NAME];
  int        nNameLen;

  MPI_Init(&argc, &argv);                       // MPI Start
  MPI_Comm_rank(MPI_COMM_WORLD, &nRank);        // Get current processor rank id
  MPI_Comm_size(MPI_COMM_WORLD, &nProcs);       // Get number of processors

  MPI_Get_processor_name(procName, &nNameLen);

  printf("Hello World. (Process name = %s, nRank = %d, nProcs = %d)\n", procName, nRank, nProcs);

  printf("Address : %x \n",nRank);
  MPI_Finalize();                               // MPI End
  return 0;
}
```
```bash
Hello World. (Process name = ibs0001, nRank = 1, nProcs = 4)
Address : 1
Hello World. (Process name = ibs0001, nRank = 2, nProcs = 4)
Address : 2
Hello World. (Process name = ibs0001, nRank = 0, nProcs = 4)
Address : 0
Hello World. (Process name = ibs0001, nRank = 3, nProcs = 4)
Address : 3
```

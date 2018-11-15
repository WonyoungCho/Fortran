# Reduce

```c
#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
  int i, nrank, start, end, ROOT = 0;
  double a[9], sum, tsum;

  MPI_Init(&argc, &argv);
  MPI_Comm_rank(MPI_COMM_WORLD, &nrank);

  start = nrank * 3;
  end = start + 2;

  for (i=start; i<end+1; i++) {
    a[i] = i + 1;
    if (i == start) printf("rank (%d) ", nrank);
    printf("a[%d] = %.2f   ", i, a[i]);
  }

  sum = 0.0;
  for (i=start; i<end+1; i++) sum = sum + a[i];

  MPI_Reduce(&sum, &tsum, 1, MPI_DOUBLE, MPI_SUM,ROOT, MPI_COMM_WORLD);

  if (nrank == ROOT) printf("\nrank(%d):sum= %.2f.\n", nrank, tsum);
  printf("\n");

  MPI_Finalize();
  return 0;
}
```
```bash
$ mpicc -np 3 ./a.out
rank (1) a[3] = 4.00   a[4] = 5.00   a[5] = 6.00
rank (2) a[6] = 7.00   a[7] = 8.00   a[8] = 9.00
rank (0) a[0] = 1.00   a[1] = 2.00   a[2] = 3.00
rank(0):sum= 45.00.
```


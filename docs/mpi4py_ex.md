# Hello World!

```python
from mpi4py import MPI

print 'Hello World!'
```

```sh
$ mpiexec -n 4 python hello.py
 Hello World!
 Hello World!
 Hello World!
 Hello World!
```

# Send & Recv

```
from mpi4py import MPI

comm = MPI.COMM_WORLD
rank = comm.Get_rank()

if rank == 0:
    data = 3.0
    comm.send(data, dest=1)
elif rank == 1:
    data = comm.recv(source=0)
    print rank, data
```

```sh
$ mpiexec -n 4 python sendrecv.py
 1 3.0
```

Array에서는 명령어가 다르다. (`comm.Send`, `comm.Recv`)

```python
from mpi4py import MPI
import numpy as np

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

if rank == 0:
    data = np.linspace(0,12,size)
    comm.Send(data, dest=1)
elif rank == 1:
    data = np.empty(size, dtype='d')
    comm.Recv(data, source=0)
    print data
```

```sh
$ mpiexec -n 4 python sendrecv.py
 [  0.   4.   8.  12.]
```

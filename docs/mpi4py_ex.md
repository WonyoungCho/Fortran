# Installation

```
$ sudo apt-get install openmpi-bin openmpi-doc libopenmpi-dev
$ sudo pip install mpi4py
```

# Hello World!

```
from mpi4py import MPI

comm = MPI.COMM_WORLD
rank = comm.Get_rank()

print rank, 'Hello World!'
```

```sh
$ mpiexec -n 4 python hello.py
0 Hello World!
1 Hello World!
2 Hello World!
3 Hello World!
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

```
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
# blocking

각 rank에서 계산이 끝나길 기다리려야 할 경우 Barrier를 사용하면 된다.

```
... computation region for each rank ...

comm.Barrier()

```

# Broadcast

```
from mpi4py import MPI
import numpy as np

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

data = None

if rank == 0:
    data = np.array([5,6,7,8])
else:
    data = np.array([0,0,0,0])
    
print 'rank = ', rank, ' before :', data

comm.Bcast(data, root=0)

print 'rank = ', rank, ' after :', data
```

```sh
$ mpiexec -n 4 python bcast.py
rank =  2  before : [0 0 0 0]
rank =  1  before : [0 0 0 0]
rank =  3  before : [0 0 0 0]
rank =  0  before : [5 6 7 8]
rank =  0  after : [5 6 7 8]
rank =  1  after : [5 6 7 8]
rank =  2  after : [5 6 7 8]
rank =  3  after : [5 6 7 8]
```

# Scatter

```
from mpi4py import MPI
import numpy as np

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

data = None

if rank == 0:
    data = np.array([5,6,7,8])
    
print 'rank = ', rank, ' before :', data

rdata = np.array([0])

comm.Scatter(data, rdata, root=0)

print 'rank = ', rank, ' after :', rdata
```

```sh
$ mpiexec -n 4 python scatter.py
rank =  3  before : None
rank =  2  before : None
rank =  1  before : None
rank =  0  before : [5 6 7 8]
rank =  0  after : [5]
rank =  2  after : [7]
rank =  1  after : [6]
rank =  3  after : [8]
```

# Gather

```
from mpi4py import MPI
import numpy as np

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

data = None

if rank == 0:
    data = np.array([5,6,7,8])
    
print 'rank = ', rank, ' before :', data

rdata = np.array([0])

comm.Scatter(data, rdata, root=0)

print 'rank = ', rank, ' after :', rdata

gdata = np.array([0,0,0,0])

comm.Gather(rdata, gdata, root=0)

if rank == 0:
    print 'rank = ', rank, ' gathered :', gdata
```

```sh
$ mpiexec -n 4 python gather.py
rank =  3  before : None
rank =  2  before : None
rank =  1  before : None
rank =  0  before : [5 6 7 8]
rank =  0  after : [5]
rank =  1  after : [6]
rank =  3  after : [8]
rank =  2  after : [7]
rank =  0  gathered : [5 6 7 8]
```

# Reduce

```
from mpi4py import MPI
import numpy as np

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

ista = rank * size
iend = (rank + 1) * size

rsum = np.zeros(1)

for i in range(ista,iend):
    rsum = rsum + i

print rank, 'sum =', rsum[0]

tsum = np.zeros(1)

comm.Reduce(rsum, tsum, op=MPI.SUM, root=0)

if rank == 0:
    print 'sum =', tsum[0]
```

```sh
$ mpiexec -n 4 python reduce.py
1 sum = 22.0
3 sum = 54.0
2 sum = 38.0
0 sum = 6.0
Total sum = 120.0
```

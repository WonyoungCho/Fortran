# Hello World!

```{.python}
from mpi4py import MPI

print 'Hello World!'
```

```
$ mpiexec -n 4 python hello.py
Hello World!
Hello World!
Hello World!
Hello World!
```

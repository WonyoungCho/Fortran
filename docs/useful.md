## File transfer
```
scp -P 포트 아이디@아이피:/home/디렉토리/ ./
```

## CPU TIME
``` bash
real :: start, finish
call cpu_time(start)

   ! code here !

call cpu_time(finish)
print '("Time = ",f6.3," seconds.")',finish-start
```
or

```bash
$ time ./a.out
```

## Memory size 확인
```
ulimit -a
```
- **Stack memory size 변경**
```
ulimit -s 512000
```

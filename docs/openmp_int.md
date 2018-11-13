# Introduction
`OpenMP`는 병렬처리하고자 하는 작업을 `thread`에 할당해 주는 계산 방법이며, 공유 메모리를 통해 작업을 처리한다. 공유 메모리를 어떻게 사용할 것인가가 중요하다. `Master thread`외에는 계산하고자 하는 `Thread`를 임의로 정할 수 없다.

## Useful site

- <a href="http://webedu.ksc.re.kr" target="_blank"> http://webedu.ksc.re.kr </a>

- <a href="http://www.openmp.org" target="_blank"> http://www.openmp.org </a>

- <a href="http://www.compunity.org" target="_blank"> http://www.compunity.org </a>

- <a href="http://openmpcon.org" target="_blank"> http://openmpcon.org </a>

- <a href="https://computing.llnl.gov/tutorials/openMP" target="_blank"> https://computing.llnl.gov/tutorials/openMP </a>

- <a href="http://www.citutor.org" target="_blank"> http://www.citutor.org </a>


## OpenMP Compile Option
GCC `-fopenmp`, Intel `-qopenmp`, PGI `-mp`


## Memory size 확인
```
ulimit -a
```
### Stack memory size 변경
```
ulimit -s 512000
```

|  |
| :--: |
|  |

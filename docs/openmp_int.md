# Introduction
**OpenMP**는 하고자 하는 작업을 `thread` 별로 할당하여 병렬로 계산하는 방법이며, 공유 메모리를 통해 작업을 처리한다. 공유 메모리를 어떻게 사용할 것인가가 중요하다. `Master thread`외에는 계산하고자 하는 `Thread`를 임의로 정할 수 없다.

병렬작업을 이야기할 때 **fork**와 **join**을 이야기한다. 작업이 병렬화될 때를 **fork**라고 하며, 병렬작업이 끝날때를 **join**이라고 한다. 코드에서 `!$omp parallel` 명령어가 작업을 병렬화해 주는 시점(**fork**)이 된다. `!$omp end parallel`은 병렬화의 종료되는 지점(**join**)이다.

## Compile
**Compile**시에는 옵션을 넣어주어야 하며, 제조사별로 옵션명 다르다.

- GCC `-fopenmp`

- Intel `-qopenmp`

- PGI `-mp`

```bash
$ gfortran -fopenmp -o a.out test.f90
```
그리고 몇개의 `thread`로 작업을 할 것인지 실행파일을 실행 전에 정해주어야 한다. 코드내에서도 정할 수 있다.
```bash
$ export OMP_NUM_THREADS=4
$ ./a.out
```
`export OMP_NUM_THREADS=4`에서 `OMP_NUM_THREADS`는 대문자로 써야하며 `=4`는 붙여써야 한다.

## Useful site

- <a href="http://webedu.ksc.re.kr" target="_blank"> http://webedu.ksc.re.kr </a>

- <a href="http://www.openmp.org" target="_blank"> http://www.openmp.org </a>

- <a href="http://www.compunity.org" target="_blank"> http://www.compunity.org </a>

- <a href="http://openmpcon.org" target="_blank"> http://openmpcon.org </a>

- <a href="https://computing.llnl.gov/tutorials/openMP" target="_blank"> https://computing.llnl.gov/tutorials/openMP </a>

- <a href="http://www.citutor.org" target="_blank"> http://www.citutor.org </a>



|  |
| :--: |
|  |

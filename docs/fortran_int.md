# Programming with Fortran.

소개는 **Fortran90** 을 기준으로 하며, 파일의 확장자는 `.f90`이다. **compile**은 소문자와 대문자를 가리지 않는다.

참고로, 높은 버전의 **Fortran**은 하위 버전의 기능과 문법을 포함하고 있다. 즉, **Fortran90**은 **Fortran77** 문법으로 쓰여진 코드를 인식한다.

# Fortran77 vs Fortran90

- **Fortran77**

```
123456789012345678901234567890
      program hello
      implicit none
c       code here
      end program hello
```
> - 앞 6간을 항상 비워놔야 한다.
> - 72열 까지만 허용된다.
> - Label은 제 2열부터 시작된다.
> - 제 6열은 줄 연결 표시(**&**)이다.
> - 주석은 첫 열의 **c** 표시로 시작하며, 코드와 같은 줄에 올 수 없다.
```bash
c this is a comment.
      do i=1,10
      ...
```
> - 변수의 길이가 6자로 제한된다.
> - 메모리의 동적 저장 기능이 없다.
- - -

- **Fortran90**

```fortran
program hello
implicit none
! code here
end program
```
> - 첫 칸부터 사용가능하며 시작 위치의 제한이 없다.
> - 132열까지 사용 가능하다.
> - 한 줄에 분리기호인 ; 을 사용하여 여러 문장이 가능하다.
```bash
i=12; j=13
```
> - 주석은 ! 를 시작기호로 사용하며 문장과 같은 라인에 적을 수 있다.
> - 줄바꿈은 & 표시와 함께 문장 마지막에 넣으며, 40 라인까지 가능하다. (**Fortran2003**은 256라인까지 가능하다.)
> - 변수의 길이가 31자까지 가능하다. (**Fortran2003**은 최대 63자이다.)
```
- 변수는 반드시 영문자로 시작해야 된다.
- 변수로 사용 가능한 문자는 다음과 같다. a-z , 0-9, _
```
> - 관계연산자의 표현을 다음과 같이 쓸 수 있다.
```
Fortran77 : .lt., .le., .eq., .ne., .ge., .gt. 
Fortran90 :   < ,  <= ,  == ,  /= ,  >= ,  > 
```

# Compile

```
$ gfortran -o a file_name.f90
```
`-o` 옵션을 사용하여 실행파일의 이름을 정해줄 수가 있다. 위 **compile** 명령어에서는 `a`라는 이름으로 실행파일을 만들었다.

```
$ gfortran file_name.f90
```
다음과 같이 **compile**을 할 경우 default 값인 `a.out`이 실행파일로 생성된다.

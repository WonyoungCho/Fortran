# Programming with Fortran.

**Fortran 90** 을 기준으로 하며, 파일의 확장자는 `.f90`이다. 코드는 소문자 대문자를 가리지 않는다.

- **Fortran 77** : 앞 6간을 항상 비워놔야 했다.
```
123456program hello
      implicit none
      !!   code   !!
      end program hello
```

- **Fortran 90**
```
program hello
implicit none
!!   code   !!!
end program
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

Program deg
  implicit none

  integer(8)::sum_k(500000000)
  integer(8)::a ,i ,j ,d ,d_max
  character(10)::c
  character::tab
  tab = char(9)
  d_max=0
  write(*,*)'a = ?'
  read(*,*) a
  write(c,'(i0)')a

  open(21,file='./degen/m'//trim(c)//'.dat')

  do i =1 ,a**2
     sum_k(i)=0
  enddo
  do i = 1 ,a
     do j = 1 ,a
        d = i*i + j*j
        if(d.gt.a**2)then
           goto 20
        endif
        sum_k(d) = sum_k(d) +1
        d_max = max(d_max ,d)
     enddo
20 enddo
  do i = 1 ,d_max
     if(sum_k(i).eq.0)then
        goto 11
     else
        write(21 ,'(i0,a,i0)')i ,tab ,sum_k(i)
     endif
11 enddo
  close(21)
  stop
end Program deg


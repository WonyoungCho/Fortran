program degeneracy
  implicit none
  integer(8) :: n2 , nx , ny
  integer(8) :: dg , a1 , a2 , b1 , b2
  real(8) :: e1 , nyr
  character(12) :: c
  character:: tab
  tab = char (9)
  write(*,*) 'Initial and final cut-off (ini,fin)'
  read(*,*) b1 ,b2
  a1 =(b1)**2
  a2 =(b2)**2
  write(c,'( i0 )') b2
  open(21,file ='./degen/d'//trim(c)//'.dat')
  open(22,file ='./degen/d'//trim(c)//'_trash.dat')
  do n2 = a1 +1 , a2
     dg = 0
     do nx = 1 ,int((n2 -1)**(0.5d0))
        ny = (n2 - nx**2)**(0.5d0)
        nyr = (n2 - nx**2)**(0.5d0)
        e1 = nyr - dble(ny)*1d0
        if(e1.eq.0d0.and.ny.ne.0)then
           dg = dg +1
           write(22,*) n2, dg
        endif
     enddo
     if(dg.ne.0d0)then
        write(21 ,'(i0,a,i0)')n2, tab, dg
     endif
  enddo
  close (21)
  close (22,status ='delete')
  stop
end program degeneracy

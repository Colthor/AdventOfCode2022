program day25
    implicit none
    character (len = 10) :: str
    integer:: o
    
    str = '1=11-2'
    o = snafu_to_int(str)
    print *, 'Hello World! ', o
    
    
contains

function snafu_to_int(s) result (o)
    implicit none
    character (*), intent(in) :: s
    integer:: o, n, p, i
    
    o = 0
    p = 1
    
    do i = len(s), 1, -1
    
        if (s(i:i) /= ' ') then
            if (s(i:i) >= '0' .and. s(i:i) <= '2') then
                n = ichar(s(i:i)) - ichar('0')
            else if (s(i:i) == '-') then
                n = -1
            else if (s(i:i) == '=') then
                n = -2
            else
                n = 0
            endif
            
        
            o = o + n * p
            print *, 's(i:i)=', ichar(s(i:i)), 'i=', i, 'n=', n, 'p=', p, 'o=', o, '\n'
            p = p * 5
        endif
    
    end do
    
end function snafu_to_int

end program day25

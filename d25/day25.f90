program day25
    implicit none
    integer, parameter :: Int18 = selected_int_kind (18) !some of these SNAFUs are really big
    character (len = 25) :: str, res
    integer (kind=Int18):: o
    
    str = '1=1-2210-21-=120102'
    o = snafu_to_int(str)
    res = int_to_snafu(o)
    print *, 'snafu in: ', str
    print *, 'to int:   ', o
    print *, 'to snafu: ', res
    
contains

function int_to_snafu(n) result (s)
    implicit none
    integer (kind=Int18), intent(in) :: n
    character(len = 25) :: s
    character :: c
    integer (kind=Int18) :: i, remain, d
    
    remain = n
    i = 25
    do while (remain > 0 .and. i > 0)
        d = mod(remain, 5_Int18)
        remain = remain / 5_Int18
        c = ' '
        
        if(d < 3_Int18) then
            c = char(ichar('0') + d)
        else if (d == 3_Int18) then
            c = '='
            remain = remain + 1_Int18
        else !d==4
            c = '-'
            remain = remain + 1_Int18        
        endif
        
        s(i:i) = c
        i = i - 1
    end do
    
end function int_to_snafu

function snafu_to_int(s) result (o)
    implicit none
    character (*), intent(in) :: s
    integer (kind=Int18):: o, n, p, i
    
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
            !print *, 's(i:i)=', ichar(s(i:i)), 'i=', i, 'n=', n, 'p=', p, 'o=', o, '\n'
            p = p * 5
        endif
    
    end do
    
end function snafu_to_int

end program day25

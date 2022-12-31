type Rock :
    record
        width: int
        height: int
        shape: array 0..3, 0..3 of boolean
    end record

var rocks: array 0..4 of Rock
var pit : array 0..8, 0..5272 of boolean
var wind : char(11000)

function collides(ri : int, x : int, y : int) : boolean
    var res : boolean := false
    /*if x < 1 or x + rocks(ri).width - 1 > 7 or y < 0 then
        result true
    end if*/
    
    for rx : 0..(rocks(ri).width - 1)
        for ry : 0..(rocks(ri).height - 1)
            var px : int := x + rx
            var py : int := y + ry
            %put "(", px, ", ", py, "): ", pit(px, py), ", ", ri, ", (", rx, ", ", ry, "): ", rocks(ri).shape(rx,ry)
            res := res or (pit(px, py) and rocks(ri).shape(rx,ry))
        end for
    end for
    result res
end collides

procedure copy_to_pit(ri : int, x : int, y : int)
    
    for rx : 0..(rocks(ri).width - 1)
        for ry : 0..(rocks(ri).height - 1)
            var px : int := x + rx
            var py : int := y + ry
            pit(px, py) := pit(px, py) or rocks(ri).shape(rx,ry)
        end for
    end for
    
end copy_to_pit

%init rocks
for i : 0..4
    for x : 0..3
        for y : 0..3
            rocks(i).shape(x,y) := false
        end for
    end for
end for

%Set up rocks
rocks(0).width := 4
rocks(0).height := 1
for i : 0..3
    rocks(0).shape(i,0) := true
end for

rocks(1).width := 3
rocks(1).height := 3
for i : 0..2
    rocks(1).shape(i,1) := true
    rocks(1).shape(1,i) := true
end for

rocks(2).width := 3
rocks(2).height := 3
for i : 0..2
    rocks(2).shape(i,0) := true
    rocks(2).shape(2,i) := true
end for

rocks(3).width := 1
rocks(3).height := 4
for i : 0..3
    rocks(3).shape(0,i) := true
end for

rocks(4).width := 2
rocks(4).height := 2
for i : 0..1
    rocks(4).shape(0,i) := true
    rocks(4).shape(1,i) := true
end for

%load wind
var windLen : int
var fileNumber : int

open : fileNumber, "day17test.txt", get
loop
    exit when eof (fileNumber)
    get : fileNumber, wind
end loop

var n : int := 1
var done : boolean := false
loop
    if 0 = ord(wind(n)) then
        windLen := n - 1 % one-based arrays...
        done := true
    end if
    exit when done
    n := n + 1
end loop

%make pit
for i : 0..8
    pit(i, 0) := true
end for
for i : 1..5266
    pit(0, i) := true
    pit(8, i) := true
    for x : 1..7
        pit(x, i) := false
    end for
end for

var rockCount : int := 1
var ri : int := 0 % rock index
var turn : int := 0
var wi : int := 1 % wind index
var h : int := 0  % max height
var x : int := 3  % current rock pos
var y : int := 4

% simulate rocks
loop
    exit when rockCount > 2022
    wi := (turn mod windLen) + 1
    var nx : int := x
    var ny : int := y
    %put wi, ", ", wind(wi), "; " ..
    
    %blow rock
    if wind(wi) = '<' then
        nx := x - 1
    else
        nx := x + 1
    end if
    if collides(ri, nx, ny) then
        %blown into something, can't move
        %put 'c' ..
        nx := x
    end if
    
    %rock falls
    ny := ny - 1
    
    if collides(ri, nx, ny) then
        %landed on something, can't fall - fill pit and set up next rock
        ny := y
        copy_to_pit(ri, nx, ny)
        if h < ny + rocks(ri).height - 1 then
            h := ny + rocks(ri).height - 1
        end if
        
        put "Rock ", rockCount, " landed. (", nx, ", ", ny, ") wi: ", wi, "; Height: ", h
        
        ri := (ri + 1) mod 5
        x := 3
        y := h + 4
        %delay(1000)
        rockCount := rockCount + 1
    else
        x := nx
        y := ny
    end if 

    turn := turn + 1
end loop

put "Height: ", h
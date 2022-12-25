#!/usr/bin/ruby

map = Array.new(1001) { Array.new(501) {0}}

def draw_line(map, startp, endp)
    dir = [0,0]
    if endp[0] == startp[0] then
        dir[1] = (endp[1] - startp[1]) / (endp[1] - startp[1]).abs()
    else
        dir[0] = (endp[0] - startp[0]) / (endp[0] - startp[0]).abs()
    end
    p = startp
    print "Start: ", startp, " End: ", endp, " Dir: ", dir, "\n"
    #print (endp[1] - startp[1]).abs()
    #print (endp[0] - startp[0]).abs()

    while p != endp do
        #print p
        map[p[0]][p[1]] = 1 #1 = rock
        p[0] += dir[0]
        p[1] += dir[1]
    end
    map[p[0]][p[1]] = 1 
end

def draw_lines(map, coords)

    start = coords[0]
    i = 1
    while i < coords.size do

        draw_line(map, start, coords[i])
        start = coords[i]
        i += 1
    end
end

def simulate_sand(map)
    start_pos = [500,0]

    if 0 != map[start_pos[0]][start_pos[1]] then
        return false
    end

    pos = [500,0]
    settled = false

    while !settled do

        if pos[1] >= 500 then
            return false
        end

        if 0 == map[pos[0]][pos[1]+1] then
            pos[1] += 1
        elsif 0 == map[pos[0]-1][pos[1]+1] then
            pos[1] += 1
            pos[0] -= 1
        elsif 0 == map[pos[0]+1][pos[1]+1] then
            pos[1] += 1
            pos[0] += 1
        else
            settled = true
            print "Settled ( ", pos[0], ", ", pos[1], ") (startpos: ", start_pos, ")\n"
        end

    end

    map[pos[0]][pos[1]] = 2 # 2 = sand
    

    return true
end

max_y = 0
IO.foreach("day14.txt"){|line|
    coords_str = line.split(" -> ")
    coords = Array.new(coords_str.size) {[0,0]}
    
    i = 0
    coords_str.each do |cstr|
        c = cstr.split(',')
        coords[i] = [Integer(c[0]), Integer(c[1])]
        if coords[i][1] > max_y then
            max_y = coords[i][1]
        end
        i += 1
    end
    draw_lines(map, coords)
}

draw_line(map, [0,max_y+2],[1000, max_y+2])

sand_count = 0
while simulate_sand(map) do
    sand_count += 1
end

print "Sand count: ", sand_count, "\n"
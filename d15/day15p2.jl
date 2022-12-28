mutable struct Scanner
    x::Int64
    y::Int64
    range::Int64
end
const MAX_X = 4000000
const MAX_Y = 4000000

function pos_covered(scanners, x, y)
    if x < 0 || x > MAX_X || y < 0 || y > MAX_Y
        return true
    end

    covered = false
    for s in scanners
        covered |= (abs(x - s.x) + abs(y - s.y)) <= s.range
        if covered
            break
        end
    end
    return covered
end

function main()
    scanners = Scanner[]

    open("day15.txt", "r") do f
        for ln in eachline(f)
            s = Scanner(0, 0, 0)
            sarr = split(ln, " ")
            if lastindex(sarr) >= 9
                s.x = parse(Int64, SubString(sarr[3], 3, lastindex(sarr[3]) - 1))
                s.y = parse(Int64, SubString(sarr[4], 3, lastindex(sarr[4]) - 1))

                bx = parse(Int64, SubString(sarr[9], 3, lastindex(sarr[9]) - 1))
                by = parse(Int64, SubString(sarr[10], 3, lastindex(sarr[10])))

                s.range = abs(s.x - bx) + abs(s.y - by)
                push!(scanners, s)
            end
        end
    end

    println("Go!")
    o_x = -1
    o_y = -1

    for s1 in scanners
        r = s1.range + 1
        for i in 0:r
            #br - trace around the outside of each scanner
            x = s1.x + r - i
            y = s1.y + i
            if !pos_covered(scanners, x, y)
                o_x = x
                o_y = y
                break
            end
            #bl
            x = s1.x - i
            y = s1.y + r - i
            if !pos_covered(scanners, x, y)
                o_x = x
                o_y = y
                break
            end
            #tl
            x = s1.x - r + i
            y = s1.y + i
            if !pos_covered(scanners, x, y)
                o_x = x
                o_y = y
                break
            end
            #tr
            x = s1.x + i
            y = s1.y + r - i
            if !pos_covered(scanners, x, y)
                o_x = x
                o_y = y
                break
            end
        end
        if o_x > -1
            break
        end
    end

    println("Position: (", o_x, ", ", o_y, ") Freq: ", o_x * 4000000 + o_y)

end #main

main()
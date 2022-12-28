mutable struct Scanner
    x::Int64
    y::Int64
    range::Int64
end

function main()
    scanners = Scanner[]
    Y = 2000000
    boy = Set()

    open("day15.txt", "r") do f
        for ln in eachline(f)
            s = Scanner(0, 0, 0)
            sarr = split(ln, " ")
            if lastindex(sarr) >= 9
                s.x = parse(Int64, SubString(sarr[3], 3, lastindex(sarr[3]) - 1))
                s.y = parse(Int64, SubString(sarr[4], 3, lastindex(sarr[4]) - 1))

                bx = parse(Int64, SubString(sarr[9], 3, lastindex(sarr[9]) - 1))
                by = parse(Int64, SubString(sarr[10], 3, lastindex(sarr[10])))

                if by == Y
                    push!(boy, bx)
                    # If there's a beacon present it's not an empty slot
                end

                s.range = abs(s.x - bx) + abs(s.y - by)
                push!(scanners, s)
            end
        end
    end

    println("Go!")

    covered = Set()

    for s in scanners
        dy = abs(s.y - Y)
        if dy <= s.range
            dx = s.range - dy
            min_x = s.x - dx
            max_x = s.x + dx
            #println(min_x, ", ", max_x, "; ", dx, ", ", dy)
            for i = min_x:max_x
                #println(i)
                push!(covered, i)
            end
        end
    end

    #println(covered)
    println(length(setdiff(covered, boy)))

end #main

main()
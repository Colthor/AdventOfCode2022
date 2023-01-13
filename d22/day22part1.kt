import java.io.File
import java.lang.Math.max

fun load_map(fileName: String) : Pair<Array<IntArray>, String> {
    var done: Boolean = false
    var maxWidth: Int = 0
    var height: Int = 0
    File(fileName).forEachLine {
        //println(it)
        if(!done) {
            if (it.length < 4) {
                done = true
            } else {
                maxWidth = max(maxWidth, it.length)
                ++height
            }
        }
    }
    println("Height: $height, Max width: $maxWidth")

    // this could easily be a ByteArray but I'd wind up with casts everywhere
    // and who can be bothered. So 4 or 8* the memory it is!
    val map = Array(maxWidth) { IntArray(height) }
    var instructions = ""
    var y = 0
    done = false
    File(fileName).forEachLine {
        //println(it)
        if(!done) {
            if (it.length < 4) {
                done = true
            } else {
                for (x in it.indices) {
                    map[x][y] = when (it[x]) {
                        '.' -> 1
                        '#' -> 2
                        else -> 0
                    }
                }
                ++y
            }
        } else {
            instructions += it
        }
    }

    return Pair(map, instructions)
}

data class Position(var x: Int, var y: Int, var facing: Int) {
    fun turnLeft() {facing = (facing - 1).mod(4)}
    fun turnRight() {facing = (facing + 1).mod(4)}
    fun direction() = when (facing) {
        0 -> Pair(1, 0) //right
        1 -> Pair(0, 1) //down
        2 -> Pair(-1, 0) //left
        else -> Pair(0, -1) //up
    }
    fun password() = (y+1)*1000 + (x+1)*4 + facing
}

fun read_instruction(ip_in: Int, instructions: String) : Pair<Int, String> {
    var ip = ip_in
    if(!instructions[ip].isDigit()) {
        return Pair(ip+1, instructions[ip].toString())
    }
    var out = ""
    while(ip < instructions.length && instructions[ip].isDigit() ) {
        out += instructions[ip]
        ++ip
    }
    return Pair(ip, out)
}

fun do_move(map: Array<IntArray>, pos: Position) : Position {
    val (dx, dy) = pos.direction()
    var x = pos.x
    var y = pos.y
    var wall = false
    do {
        x = (x + dx).mod(map.size)
        y = (y + dy).mod(map[0].size)
        if(2 == map[x][y]) {
            //print ("wall at ($x, $y)! ")
            x = pos.x
            y = pos.y
            wall = true
            break
        }
    } while(1 != map[x][y])

    if( !wall && (pos.x + dx != x || pos.y + dy != y)) {
        println("Wrapped from $pos to ($x, $y)")
    }

    return Position(x, y, pos.facing)
}

fun do_instruction(map: Array<IntArray>, pos_in: Position, instr: String) : Position {
    var pos = pos_in
    //println("Instruction '$instr' at $pos_in")
    if("R" == instr) {
        pos.turnRight()
    } else if("L" == instr) {
        pos.turnLeft()
    } else {
        val ct = instr.toInt()

        for(i in 0 until ct) {
            pos = do_move(map, pos)
        }
    }
    return pos
}

fun main(args: Array<String>) {
    val fileName = "day22.txt"

    val (map, instructions) = load_map(fileName)
    var x = 0
    //start at first empty space on line 0
    while (1 != map[x][0]) {
        ++x
    }

    var pos = Position(x, 0, 0)
    println("Start: $pos")

    var ip = 0
    while(ip < instructions.length) {
        val (newip, instruction) = read_instruction(ip, instructions)
        pos = do_instruction(map, pos, instruction)
        ip = newip
    }

    println("pos: $pos")
    println ("Password: ${pos.password()}")
}
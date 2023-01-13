import java.io.File
import java.lang.Exception
import java.lang.Math.max
import kotlin.math.acos

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
    fun turn(n: Int) {facing = (facing + n).mod(4)}
    fun direction() = when (facing) {
        0 -> Pair(1, 0) //right
        1 -> Pair(0, 1) //down
        2 -> Pair(-1, 0) //left
        else -> Pair(0, -1) //up
    }
    fun password() = (y+1)*1000 + (x+1)*4 + facing

    fun getFace() = when {
        x in 50..99 && y <= 49   -> 1
        x <= 49 && y in 150..199 -> 2
        x >= 100 && y <= 49            -> 3
        x <= 49 && y in 100..149 -> 4
        x in 50..99 && y in 50..99 ->5
        x in 50..99 && y in 100..149 ->6
        else -> throw Exception("Invalid position to get face: ($x, $y) (facing: $facing)")
    }
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

fun move_to_new_face(pos: Position) : Position {
    println("move_to_new_face from $pos")
    val face = pos.getFace()
    val np = Position(pos.x, pos.y, pos.facing) //I'm not certain if np = pos would just copy the reference

    when {
        1 == face && 2 == pos.facing -> {
            np.turn(2)
            np.x = 0
            np.y = 149 - pos.y
        }
        1 == face && 3 == pos.facing -> {
            np.facing = 0
            np.x = 0
            np.y = pos.x + 100
        }
        2 == face && 0 == pos.facing -> {
            np.facing = 3
            np.x = pos.y - 100
            np.y = 149
        }
        2 == face && 1 == pos.facing -> {
            np.turn(0)
            np.x = pos.x + 100
            np.y = 0
        }
        2 == face && 2 == pos.facing -> {
            np.facing = 1
            np.x = pos.y - 100
            np.y = 0
        }
        3 == face && 0 == pos.facing -> {
            np.turn(2)
            np.x = 99
            np.y = 149 - pos.y
        }
        3 == face && 1 == pos.facing -> {
            np.facing = 2
            np.x = 99
            np.y =pos.x - 50
        }
        3 == face && 3 == pos.facing -> {
            np.turn(0)
            np.x = pos.x - 100
            np.y = 199
        }
        4 == face && 2 == pos.facing -> {
            np.turn(2)
            np.x = 50
            np.y = 49 - (pos.y - 100)
        }
        4 == face && 3 == pos.facing -> {
            np.facing = 0
            np.x = 50
            np.y = pos.x + 50
        }
        5 == face && 0 == pos.facing -> {
            np.facing = 3
            np.x = pos.y + 50
            np.y = 49
        }
        5 == face && 2 == pos.facing -> {
            np.facing = 1
            np.x = pos.y - 50
            np.y = 100
        }
        6 == face && 0 == pos.facing -> {
            np.turn(2)
            np.x = 149
            np.y = 49 - (pos.y - 100)
        }
        6 == face && 1 == pos.facing -> {
            np.facing = 2
            np.x = 49
            np.y = pos.x + 100
        }
        else -> throw Exception("Error, move_to_new_face from $face direction ${pos.facing}")
    }
    return np
}

fun do_move(map: Array<IntArray>, pos: Position) : Position {
    val (dx, dy) = pos.direction()
    var x = pos.x
    var y = pos.y

    x = (x + dx).mod(map.size)
    y = (y + dy).mod(map[0].size)

    if(0 == map[x][y]) { //stepped into the void - move to adjacent face of cube
        val np = move_to_new_face(pos)
        println("to $np")
        return if(2 == map[np.x][np.y]) pos
        else np
    }

    if(2 == map[x][y]) { //hit a wall
        //print ("wall at ($x, $y)! ")
        return pos
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
            map[pos.x][pos.y] = 10 + pos.facing
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

    File("mapout.txt").printWriter().use { out ->

        for (y in 0..199){
            for (x in 0..149) {
                when (map[x][y]) {
                    0 -> out.print(" ")
                    1 -> out.print(".")
                    2 -> out.print("#")
                    10 -> out.print(">")
                    11 -> out.print("v")
                    12 -> out.print("<")
                    13 -> out.print("^")
                    else -> out.print("?")
                }
            }
            out.println("")
        }

    }
}
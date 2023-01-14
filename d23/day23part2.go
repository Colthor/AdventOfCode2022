package main

import (
	"bufio"
	"fmt"
	"os"
)

type Position struct {
	x, y int
}

type Elf struct {
	pos     Position
	sel_dir int
}

type DestCheck struct {
	name   string
	dir    rune
	dest   Position
	check1 Position
	check2 Position
}

func error_handle(err error) {
	if err != nil {
		panic(err)
	}
}

//Seriously?
func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func pa(a, b Position) Position {
	return Position{a.x + b.x, a.y + b.y}
}

func ps(a, b Position) Position {
	return Position{a.x - b.x, a.y - b.y}
}

func pmin(a, b Position) Position {
	return Position{min(a.x, b.x), min(a.y, b.y)}
}

func pmax(a, b Position) Position {
	return Position{max(a.x, b.x), max(a.y, b.y)}
}

//returns (top left (min), bottom right (max)) of elf positions
func get_bounds(elves []Elf) (Position, Position) {
	var tl = elves[0].pos
	var br = elves[0].pos

	for _, e := range elves {
		tl = pmin(tl, e.pos)
		br = pmax(br, e.pos)
	}
	return tl, br
}

func check_destination(dc DestCheck, positions map[Position]int, pos Position) bool {
	var d = pa(pos, dc.dest)
	var c1 = pa(pos, dc.check1)
	var c2 = pa(pos, dc.check2)

	if _, c := positions[d]; c {
		return false
	}
	if _, c := positions[c1]; c {
		return false
	}
	if _, c := positions[c2]; c {
		return false
	}
	return true
}

func surrounding_empty(positions map[Position]int, pos Position) bool {
	for x := -1; x <= 1; x++ {
		for y := -1; y <= 1; y++ {

			if !(0 == x && 0 == y) {

				if _, c := positions[pa(pos, Position{x, y})]; c {
					//fmt.Println("Elf ", n, " is at ", pos, " + ", Position{x, y})
					return false
				}
			}
		}
	}
	return true
}

func output_to_file(f *os.File, dcs []DestCheck, round int, elves []Elf) {
	var tl, br = get_bounds(elves)
	tl = pa(tl, Position{-1, -1})
	br = pa(br, Position{1, 1}) //To give room for direction marks in the map.
	var size = pa(ps(br, tl), Position{1, 1})
	fmt.Fprintln(f, "Round ", round, " rect: ", tl, " -> ", br, "; (", size.x, ", ", size.y, ")")

	var mp = make([][]rune, size.x)
	for i := 0; i < size.x; i++ {
		mp[i] = make([]rune, size.y)
	}
	for x := 0; x < size.x; x++ {
		//fmt.Fprintln(f, "x: ", x)
		for y := 0; y < size.y; y++ {
			//fmt.Fprintln(f, "y: ", y)
			mp[x][y] = '.'
		}
	}

	for _, e := range elves {
		var ep = ps(e.pos, tl)
		//fmt.Fprintln(f, "ep: ", ep)
		mp[ep.x][ep.y] = '#'
		if e.sel_dir > -1 {
			var p = pa(ep, dcs[e.sel_dir].dest)
			//fmt.Fprintln(f, "p: ", p)
			mp[p.x][p.y] = dcs[e.sel_dir].dir
		}
	}

	for y := 0; y < size.y; y++ {
		var outstr = ""
		for x := 0; x < size.x; x++ {
			outstr += string(mp[x][y])
		}
		f.WriteString(outstr + "\n")
	}
	f.WriteString("\n")

}

func main() {
	fmt.Println("Go!")
	f, err := os.Open("day23.txt")
	error_handle(err)
	//outfile, err := os.OpenFile("out.txt", os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0755)
	//error_handle(err)

	defer f.Close()
	scanner := bufio.NewScanner(f)

	var y = 0
	var elves []Elf = make([]Elf, 0, 100) // our permanent store of elves
	var positions = make(map[Position]int)
	var North = DestCheck{"North", '^', Position{0, -1}, Position{-1, -1}, Position{1, -1}}
	var South = DestCheck{"South", 'v', Position{0, 1}, Position{-1, 1}, Position{1, 1}}
	var West = DestCheck{"West", '<', Position{-1, 0}, Position{-1, -1}, Position{-1, 1}}
	var East = DestCheck{"East", '>', Position{1, 0}, Position{1, -1}, Position{1, 1}}
	var destinationChecks = []DestCheck{North, South, West, East}

	for scanner.Scan() {

		//fmt.Println(scanner.Text())
		for x, c := range scanner.Text() {
			if '#' == c {
				var e = Elf{Position{x, y}, -1}
				elves = append(elves, e)
				positions[e.pos] = len(elves) - 1 //index of appended elf, in case it's useful?
				//fmt.Println(e.pos)
			}
		}
		y += 1
	}
	fmt.Println("We have ", len(elves), " elves and ", len(positions), " positions")

	var stationary = 0
	var moved = 1
	var round = 0
	for moved > 0 {
		//fmt.Println("Round ", round)
		stationary = 0
		moved = 0

		var chosen = make(map[Position]int)

		//choose locations
		for n, e := range elves {
			elves[n].sel_dir = -1
			if !surrounding_empty(positions, e.pos) {
				//fmt.Print("Elf ", n, " looks ")
				for j := 0; j < 4; j++ {
					var d = (round + j) % 4
					//fmt.Print(destinationChecks[d].name, " ")
					if check_destination(destinationChecks[d], positions, e.pos) {
						elves[n].sel_dir = d
						var p = pa(e.pos, destinationChecks[d].dest)
						var v, _ = chosen[p]
						chosen[p] = v + 1
						//fmt.Println("\nElf ", n, " picks ", d, "from", e.pos, " to: ", p)
						break
					}
				}
			} else {
				//fmt.Println("Nothing surrounding Elf ", n, " at ", e.pos)
				stationary++
			}

		}

		//output_to_file(outfile, destinationChecks, round, elves)
		positions = make(map[Position]int)

		//move if free
		for n, e := range elves {
			if e.sel_dir >= 0 {
				var p = pa(e.pos, destinationChecks[e.sel_dir].dest)
				if chosen[p] == 1 {
					//fmt.Println("Elf ", n, " moves from", e.pos, " to: ", p)
					elves[n].pos = p
					moved++

				} else {
					//fmt.Println("Elf ", n, " chosen location picked ", chosen[p], " times")
				}
			}
			positions[elves[n].pos] = n
		}
		//fmt.Println(stationary, " elves in empty space; ", moved, " moved.")
		round++ // I buggered part 2 for ages because I put this at the top of the loop not the bottom ><
	}

	var tl, br = get_bounds(elves)
	var size = pa(ps(br, tl), Position{1, 1})
	var area = size.x * size.y
	var empty = area - len(elves)

	fmt.Println("Elves have spread to a ", size.x, " * ", size.y, " rectangle with ", empty, " empty spaces after ", round, " rounds")

}

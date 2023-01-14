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

func ap(a, b Position) Position {
	return Position{a.x + b.x, a.y + b.y}
}

func check_destination(dc DestCheck, positions map[Position]int, pos Position) bool {
	var d = ap(pos, dc.dest)
	var c1 = ap(pos, dc.check1)
	var c2 = ap(pos, dc.check2)

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

				if n, c := positions[ap(pos, Position{x, y})]; c {
					fmt.Println("Elf ", n, " is at ", pos, " + ", Position{x, y})
					return false
				}
			}
		}
	}
	return true
}

func main() {

	f, err := os.Open("day23.txt")

	error_handle(err)

	defer f.Close()
	scanner := bufio.NewScanner(f)

	var y = 0
	var elves []Elf = make([]Elf, 0, 100) // our permanent store of elves
	var positions = make(map[Position]int)
	var North = DestCheck{"North", Position{0, -1}, Position{-1, -1}, Position{1, -1}}
	var South = DestCheck{"South", Position{0, 1}, Position{-1, 1}, Position{1, 1}}
	var West = DestCheck{"West", Position{-1, 0}, Position{-1, -1}, Position{-1, 1}}
	var East = DestCheck{"East", Position{1, 0}, Position{1, -1}, Position{1, 1}}
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

	for round := 0; round < 10; round++ {
		var chosen = make(map[Position]int)

		//choose locations
		for n, e := range elves {
			elves[n].sel_dir = -1
			if !surrounding_empty(positions, e.pos) {
				fmt.Print("Elf ", n, " looks ")
				for j := 0; j < 4; j++ {
					var d = (round + j) % 4
					fmt.Print(destinationChecks[d].name, " ")
					if check_destination(destinationChecks[d], positions, e.pos) {
						elves[n].sel_dir = d
						var p = ap(e.pos, destinationChecks[d].dest)
						var v, _ = chosen[p]
						chosen[p] = v + 1
						fmt.Println("\nElf ", n, " picks ", d, "from", e.pos, " to: ", p)
						break
					}
				}
			} else {
				fmt.Println("Nothing surrounding Elf ", n, " at ", e.pos)
			}

		}

		positions = make(map[Position]int)

		//move if free
		for n, e := range elves {
			if e.sel_dir >= 0 {
				var p = ap(e.pos, destinationChecks[e.sel_dir].dest)
				if chosen[p] == 1 {
					fmt.Println("Elf ", n, " moves from", e.pos, " to: ", p)
					elves[n].pos = p

				} else {
					fmt.Println("Elf ", n, " chosen location picked ", chosen[p], " times")
				}
			}
			positions[elves[n].pos] = n
		}
		fmt.Println("Positions: ", positions)
		fmt.Println(" ")
	}

	var min_x = elves[0].pos.x
	var min_y = elves[0].pos.y
	var max_x = elves[0].pos.x
	var max_y = elves[0].pos.y
	for _, e := range elves {
		min_x = min(min_x, e.pos.x)
		min_y = min(min_y, e.pos.y)
		max_x = max(max_x, e.pos.x)
		max_y = max(max_y, e.pos.y)
	}
	var size_x = max_x - min_x + 1
	var size_y = max_y - min_y + 1
	var area = size_x * size_y
	var empty = area - len(elves)

	fmt.Println("Elves have spread to a ", size_x, " * ", size_y, " rectangle with ", empty, " empty spaces")

}

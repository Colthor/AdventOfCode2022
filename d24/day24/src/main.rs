use std::cmp;
use std::fs;
use std::fs::File;
use std::io::Write;

#[derive(Debug, Clone, Copy)]
struct Blizzard {
    x: usize,
    y: usize,
    dx: i32,
    dy: i32,
    map_width: usize,
    map_height: usize,
    symbol: char,
}

impl Blizzard {
    fn pos_after(&self, t: i32) -> Pos {
        (
            1 + ((self.x - 1) as i32 + t * self.dx).rem_euclid(self.map_width as i32 - 2) as usize,
            1 + ((self.y - 1) as i32 + t * self.dy).rem_euclid(self.map_height as i32 - 2) as usize,
        )
    }
}

#[derive(Debug, Clone, Copy)]
struct Tile {
    blocked: bool,
    dist: usize,
    symbol: char,
}

type MapLayer = Vec<Vec<Tile>>;
type Pos = (usize, usize);

fn new_map_layer(map_width: usize, map_height: usize) -> MapLayer {
    vec![
        vec![
            Tile {
                blocked: false,
                dist: UNREACHED,
                symbol: '.',
            };
            map_height as usize
        ];
        map_width as usize
    ]
}

struct Map {
    map: Vec<MapLayer>,
    map_width: usize,
    map_height: usize,
    blizzards: Vec<Blizzard>,
    start_pos: Pos,
    end_pos: Pos,
    max_search_pos: Pos,
    min_search_pos: Pos,
}

impl Map {
    fn new(filename: &str) -> Map {
        let rawdata = fs::read_to_string(filename).expect("Unable to read file");
        let data = rawdata.trim();
        let line_iterator = data.split("\n");
        let mut map_width: usize = 0;
        let mut map_height: usize = 0;
        let mut blizzards = Vec::<Blizzard>::with_capacity(50);

        for l in line_iterator.clone() {
            map_height += 1;
            map_width = cmp::max(map_width, l.chars().count() as usize);
        }

        let mut map_layer_0: MapLayer = new_map_layer(map_width, map_height);

        println!("map is: {map_width} * {map_height}");

        let mut start_pos = (0, 0);
        let mut end_pos = (0, map_height - 1);

        let mut y: usize = 0;
        for l in line_iterator {
            let mut x: usize = 0;

            for c in l.chars() {
                match c {
                    '#' => {
                        map_layer_0[x as usize][y as usize] = Tile {
                            symbol: '#',
                            blocked: true,
                            dist: UNREACHED,
                        }
                    }
                    '<' | '>' | '^' | 'v' => {
                        let b = Blizzard {
                            x: x,
                            y: y,
                            dx: match c {
                                '<' => -1,
                                '>' => 1,
                                _ => 0,
                            },
                            dy: match c {
                                '^' => -1,
                                'v' => 1,
                                _ => 0,
                            },
                            map_width: map_width,
                            map_height: map_height,
                            symbol: c,
                        };
                        blizzards.push(b);
                        map_layer_0[x as usize][y as usize] = Tile {
                            symbol: c,
                            blocked: true,
                            dist: UNREACHED,
                        };
                    }
                    '.' => {
                        if 0 == y {
                            start_pos.0 = x;
                        } else if (map_height - 1) == y {
                            end_pos.0 = x;
                        }
                    }
                    _ => (),
                }
                x += 1;
            }
            y += 1;
        }

        map_layer_0[start_pos.0][start_pos.1].dist = 0;

        println!("Start: {start_pos:?}, end: {end_pos:?}");
        println!("Blizzards: {}", blizzards.len());

        Map {
            map: vec![map_layer_0],
            map_width: map_width,
            map_height: map_height,
            blizzards: blizzards,
            start_pos: start_pos,
            end_pos: end_pos,
            max_search_pos: start_pos,
            min_search_pos: start_pos,
        }
    }

    fn create_next_layer(&mut self) {
        let mut layer = new_map_layer(self.map_width, self.map_height);

        for x in 0..self.map_width {
            layer[x][0].blocked = true;
            layer[x][0].symbol = '#';
            layer[x][self.map_height - 1].blocked = true;
            layer[x][self.map_height - 1].symbol = '#';
        }
        for y in 0..self.map_height {
            layer[0][y].blocked = true;
            layer[0][y].symbol = '#';
            layer[self.map_width - 1][y].blocked = true;
            layer[self.map_width - 1][y].symbol = '#';
        }
        layer[self.start_pos.0][self.start_pos.1].blocked = false;
        layer[self.start_pos.0][self.start_pos.1].symbol = 'S';
        layer[self.end_pos.0][self.end_pos.1].blocked = false;
        layer[self.end_pos.0][self.end_pos.1].symbol = 'E';

        for b in &self.blizzards {
            let p = b.pos_after(self.map.len() as i32);
            layer[p.0][p.1].blocked = true;
            layer[p.0][p.1].symbol = b.symbol;
        }

        self.map.push(layer);
    }

    fn find_route(&mut self, end_positions: &[Pos]) -> usize {
        let end_pos = end_positions[0];
        let n = self.map.len() as usize;
        //println!("Iteration {n}");
        self.create_next_layer();
        let mut new_max = self.max_search_pos;
        let mut new_min = self.min_search_pos;

        for x in self.min_search_pos.0..=self.max_search_pos.0 {
            for y in self.min_search_pos.1..=self.max_search_pos.1 {
                if self.map[n - 1][x][y].dist != UNREACHED {
                    let adj: Vec<(i32, i32)> = vec![(1, 0), (0, 0), (-1, 0), (0, -1), (0, 1)];

                    for d in adj {
                        if !(0 == y && -1 == d.1) && !(y + 1 == self.map_height && 1 == d.1) {
                            let vx = (x as i32 + d.0) as usize;
                            let vy = (y as i32 + d.1) as usize;
                            if !self.map[n][vx][vy].blocked {
                                //println!("p:({x}, {y}) -> visit:({vx}, {vy})");
                                self.map[n][vx][vy].dist = n; //this really only needs to be a bool
                                self.map[n][vx][vy].symbol = '*';
                                new_max = (cmp::max(new_max.0, vx), cmp::max(new_max.1, vy));
                                new_min = (cmp::min(new_min.0, vx), cmp::min(new_min.1, vy));
                            }
                        }
                    }
                } //if not unreached
            } //y
        } //x
          //println!("max: {new_max:?}");

        self.max_search_pos = new_max;
        self.min_search_pos = new_min;

        if UNREACHED == self.map[n][end_pos.0][end_pos.1].dist {
            self.find_route(end_positions)
        } else {
            if end_positions.len() == 1 {
                self.map[n][end_pos.0][end_pos.1].dist
            } else {
                println!("Reached {end_pos:?} after {n} iterations.");
                //reset map reached and search for the next end position.
                for x in 0..self.map_width {
                    for y in 0..self.map_height {
                        self.map[n][x][y].dist = UNREACHED;
                    }
                }
                self.map[n][end_pos.0][end_pos.1].dist = n;
                self.min_search_pos = end_pos;
                self.max_search_pos = end_pos;
                self.find_route(&end_positions[1..])
            }
        }
    }

    fn layer_to_string(&self, layer: &MapLayer) -> String {
        let mut out = String::new();

        for y in 0..self.map_height {
            for x in 0..self.map_width {
                out.push(layer[x][y].symbol);
            }
            out += "\n";
        }
        out += "\n";
        out
    }

    fn output_map(&self, filename: &str) {
        let mut f = File::create(filename).expect("Error opening output file");

        let mut n = 0;
        for layer in &self.map {
            let str = "Iteration ".to_string() + &n.to_string() + "\n";
            f.write_all(str.as_bytes())
                .expect("Error writing to output file");

            f.write_all(self.layer_to_string(layer).as_bytes())
                .expect("Error writing to output file");
            n += 1;
        }
        f.sync_data().expect("Error syncing output file");
    }
}

const UNREACHED: usize = 1024 * 1024;

fn main() {
    println!("Hello, world!");

    let mut map = Map::new("day24.txt");
    //let end_positions = vec![map.end_pos]; // part 1
    let end_positions = vec![map.end_pos, map.start_pos, map.end_pos]; // part 2
    println!(
        "Steps taken to reach exit: {}",
        map.find_route(&end_positions[..])
    );
    map.output_map("out.txt");
    println!("Done.");
}

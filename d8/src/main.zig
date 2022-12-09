const std = @import("std");
const tree = struct {
    height:u8, visible:bool, scenic:usize,
};

fn set_scenic(map: *std.ArrayList(std.ArrayList(tree))) !void {
    var size_x:usize = 0;
    var size_y:usize = 0;
    size_x = map.*.items.len;
    size_y = map.*.items[0].items.len;
    
    std.debug.print("{}, {}\n", .{size_x, size_y});
    var x:usize = 1;
    while(x < size_x-1) : (x += 1) {
        var y:usize = 1;
        while(y < size_y-1) : (y += 1) {
            var s:usize = 1;
            var height:u8 = map.*.items[x].items[y].height;

            s *= get_view_dist(map, x, y, 1, 0, height);
            s *= get_view_dist(map, x, y, -1, 0, height);
            s *= get_view_dist(map, x, y, 0, 1, height);
            s *= get_view_dist(map, x, y, 0, -1, height);
            map.*.items[x].items[y].scenic = s;
            std.debug.print("{}, {}: {}\n", .{x,y,s});
        }
        std.debug.print("{}\n", .{x});
    }
}
fn get_view_dist(map: *std.ArrayList(std.ArrayList(tree)), x_in:usize, y_in:usize, dx:i32, dy:i32, height:u8) usize {
    var dist:usize = 0;
    var x = x_in;
    var y = y_in;
    while (x < map.items.len and y < map.items[x].items.len) {
        if(x != x_in or y != y_in){
            var t:tree = map.*.items[x].items[y];
            dist += 1;

            if(height <= t.height) {
                break;
            }
        }
    
        
        if(dx < 0) {
            if (0 == x) break;
            x -= 1;
        }
        if(dx > 0) x += 1; //sigh, zig...
        if(dy < 0) {
            if (0 == y) break;
            y -= 1;
        }
        if(dy > 0) y += 1;
    }
    return dist; // we count ourself, which we don't want.
}


fn set_visible(map: *std.ArrayList(std.ArrayList(tree)), x_in:usize, y_in:usize, dx:i32, dy:i32) !void {
    var tallest:u8 = 255;
    var x = x_in;
    var y = y_in;
    while (x < map.items.len and y < map.items[x].items.len) {
        var t:tree = map.*.items[x].items[y];
        if(255 == tallest or t.height > tallest) {
            tallest = t.height;
            t.visible = true;
            map.*.items[x].items[y] = t;
        }
        if(dx < 0) {
            if (0 == x) break;
            x -= 1;
        }
        if(dx > 0) x += 1; //sigh, zig...
        if(dy < 0) {
            if (0 == y) break;
            y -= 1;
        }
        if(dy > 0) y += 1;
    }
}

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    //std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    //try stdout.print("Run `zig build test` to run the tests.\n", .{});

    var file = try std.fs.cwd().openFile("day8.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;
    
    
    var map = std.ArrayList(std.ArrayList(tree)).init(allocator);

    var size_x:usize = 0;
    var size_y:usize = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var row = std.ArrayList(tree).init(allocator);

        for (line) |c| {

            var t = tree{.height = c-'0', .visible = false, .scenic=0};
            try row.append(t);
        }
        size_y = row.items.len;
        try map.append(row);
    }
    size_x = map.items.len;

    var x:usize = 0;
    var y:usize = 0;

    while(x < size_x) : (x += 1) {
        try set_visible(&map, x, 0, 0, 1);
        try set_visible(&map, x, size_y-1, 0, -1);
    }
    while(y < size_y) : (y += 1) {
        try set_visible(&map, 0, y, 1, 0);
        try set_visible(&map, size_x-1, y, -1, 0);
    }

    try set_scenic(&map);

    var viscount:u32 = 0;
    var maxscenic:usize = 0;

    for(map.items) |row| {
        for(row.items) |t| {
            if(t.visible) viscount += 1;
            if(t.scenic > maxscenic) maxscenic = t.scenic;
        }
    }
    
    try stdout.print("Count: {}\nMax Scenic: {}\n", .{viscount, maxscenic});

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
   // var list = std.ArrayList(i32).init(std.testing.allocator);
    //defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    //try list.append(42);
    //try std.testing.expectEqual(@as(i32, 42), list.pop());
}

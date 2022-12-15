var day11p2;
(function (day11p2) {
    function newMonkey() {
        return { items: [], operation_mul: false, value: 0, test: (0), true_dest: 0, false_dest: 0, inspected: 0 };
    }
    function parseMonkeys(inStr, lcm) {
        var monkeys = [];
        var m;
        var created = false;
        lcm.lcm = 1;
        for (var _i = 0, _a = inStr.split(/[\r\n]+/); _i < _a.length; _i++) {
            var line = _a[_i];
            console.log(line);
            var trimmed = line.trim();
            if ("" == trimmed) {
            }
            else {
                var tokens = trimmed.split(" ");
                switch (tokens[0]) {
                    case "Monkey":
                        if (created) {
                            created = false;
                            console.log(m);
                            monkeys.push(m);
                        }
                        m = newMonkey();
                        created = true;
                        break;
                    case "Starting":
                        for (var i = 2; i < tokens.length; ++i) {
                            m.items.push((parseInt(tokens[i])));
                        }
                        break;
                    case "Operation:":
                        m.operation_mul = "*" == tokens[4];
                        if ("old" == tokens[5]) {
                            m.value = -1;
                        }
                        else {
                            m.value = parseInt(tokens[5]);
                        }
                        break;
                    case "Test:":
                        var test = parseInt(tokens[3]);
                        lcm.lcm *= test;
                        m.test = (test);
                        break;
                    case "If":
                        if ("true:" == tokens[1]) {
                            m.true_dest = parseInt(tokens[5]);
                        }
                        else {
                            m.false_dest = parseInt(tokens[5]);
                        }
                        break;
                    default:
                        //err?
                        break;
                }
            }
        }
        if (created) {
            created = false;
            console.log(m);
            monkeys.push(m);
        }
        return monkeys;
    }
    function doMonkeyBusiness(monkeys, lcm) {
        for (var _i = 0, monkeys_1 = monkeys; _i < monkeys_1.length; _i++) {
            var m = monkeys_1[_i];
            for (var _a = 0, _b = m.items; _a < _b.length; _a++) {
                var item = _b[_a];
                var val;
                ++m.inspected;
                if (m.value < 0) {
                    val = item;
                }
                else {
                    val = (m.value);
                }
                if (m.operation_mul)
                    item = item * val;
                else
                    item = item + val;
                //item = Math.floor(item / 3);
                item %= lcm;
                if (item % m.test == (0))
                    monkeys[m.true_dest].items.push(item);
                else
                    monkeys[m.false_dest].items.push(item);
            }
            m.items = [];
        }
    }
    function runp2() {
        var inputTxt = document.getElementById("inputTxt");
        var outputTxt = document.getElementById("outputTxt");
        var inStr = inputTxt.value;
        var lcm = { lcm: 0 };
        var monkeys = parseMonkeys(inStr, lcm);
        console.log(monkeys);
        for (var i = 0; i < 10000; ++i) {
            doMonkeyBusiness(monkeys, lcm.lcm);
        }
        console.log(monkeys);
        var inspected = [];
        for (var _i = 0, monkeys_2 = monkeys; _i < monkeys_2.length; _i++) {
            var m = monkeys_2[_i];
            inspected.push(m.inspected);
        }
        inspected.sort(function (a, b) { return b - a; });
        var mb = inspected[0] * inspected[1];
        outputTxt.value = mb.toString();
    }
    day11p2.runp2 = runp2;
})(day11p2 || (day11p2 = {})); //namespace

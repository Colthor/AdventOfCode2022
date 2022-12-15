namespace day11p1 {

interface Monkey {
    items: number[];
    operation_mul: boolean;
    value: number;
    test: number;
    true_dest: number;
    false_dest: number;
    inspected: number;
}

function newMonkey() : Monkey
{
    return { items: [], operation_mul: false, value: 0, test: 0, true_dest: 0, false_dest: 0, inspected: 0};
}

function parseMonkeys(inStr: string) : Monkey[]
{
    let monkeys: Monkey[] = [];
    let m:Monkey;
    let created = false;

    for (const line of inStr.split(/[\r\n]+/))
    {
        console.log(line);
        let trimmed = line.trim();
        if("" == trimmed)
        {
        }
        else
        {
            let tokens = trimmed.split(" ");
            
            switch(tokens[0])
            {
                case "Monkey":
                    if(created)
                    {
                        created = false;
                        console.log(m);
                        monkeys.push(m);
                    }
                    m = newMonkey();
                    created = true;
                    break;
                case "Starting":
                    for(var i = 2; i < tokens.length; ++i)
                    {
                        m.items.push( parseInt(tokens[i]));
                    }
                    break;

                case "Operation:":
                    m.operation_mul = "*" == tokens[4];
                    if( "old" == tokens[5])
                    {
                        m.value = -1;
                    }
                    else
                    {
                        m.value = parseInt(tokens[5]);
                    }
                    break;

                case "Test:":
                    
                    m.test = parseInt(tokens[3]);
                    break;

                case "If":
                    if("true:" == tokens[1])
                    {
                        m.true_dest = parseInt(tokens[5]);
                    }
                    else
                    {
                        m.false_dest = parseInt(tokens[5]);
                    }
                    break;

                default:
                    //err?
                    break;
            }

        }
    }
    
    if(created)
    {
        created = false;
        console.log(m);
        monkeys.push(m);
    }

    return monkeys;
}

function doMonkeyBusiness(monkeys: Monkey[])
{
    for(var m of monkeys)
    {
        for(var item of m.items)
        {
            var val: number;

            ++m.inspected;

            if(m.value < 0)
            {
                val = item;
            }
            else
            {
                val = m.value;
            }
            if(m.operation_mul) item = item * val;
            else item = item + val;

            item = Math.floor(item / 3);
            if (item % m.test == 0)
                monkeys[m.true_dest].items.push(item);
            else monkeys[m.false_dest].items.push(item);

        }
        m.items = [];
    }
}

export function runp1()
{
    let inputTxt = (document.getElementById("inputTxt") as HTMLInputElement);
    let outputTxt = (document.getElementById("outputTxt") as HTMLInputElement);
    let inStr = inputTxt.value;

    let monkeys = parseMonkeys(inStr);

    console.log(monkeys);

    for(var i = 0; i < 20; ++i)
    {
        doMonkeyBusiness(monkeys);
    }
    console.log(monkeys);

    let inspected : number[] = [];

    for( var m of monkeys)
    {
        inspected.push(m.inspected);
    }
    inspected.sort((a, b) => b-a);

    let mb = inspected[0] * inspected[1];

    outputTxt.value = mb.toString();
}

} //namespace
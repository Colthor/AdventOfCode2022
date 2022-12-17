// See https://aka.ms/new-console-template for more information
using gt = System.Collections.Generic.Dictionary<string, Node>;

int readFile(string filename, ref gt graph, ref HashSet<string> workingValves)
{
    int turnableValves = 0;
    foreach (string line in System.IO.File.ReadLines(filename))
    {
        string[] tokens = line.Split();
        if(tokens.Length < 8) continue;
        string name = tokens[1];
        Node n = new Node();
        string flowstr = tokens[4].Substring(5, tokens[4].Length-6);
        n.flow = Int32.Parse(flowstr);
        if(n.flow > 0) 
        {
            turnableValves +=1;
            workingValves.Add(name);
        }
        for(int i = 9; i < tokens.Length; ++i)
        {
            n.links.Add(tokens[i].Substring(0,2));
        }
        graph.Add(name, n);
    }
    return turnableValves;
}
int routecount = 0;

int routeLength(ref gt graph, string from, string dest, HashSet<string> visited)
{
    ++routecount;
    if(from == dest) return 0;
    if(graph[from].links.Contains(dest)) return 1;

    int mind = 1024;
    HashSet<string> nv = new HashSet<string>(visited);
    nv.Add(from);

    foreach(string loc in graph[from].links)
    {
        if(visited.Contains(loc)) continue;
        int d = routeLength(ref graph, loc, dest, nv);
        if(d < mind) mind = d;
    }
    return mind + 1;
}

void calculateDistances(ref gt graph, ref HashSet<string> workingValves)
{
    if(!workingValves.Contains("AA"))
    {
        foreach(string dest in workingValves)
        {
            routecount = 0;
            graph["AA"].distances[dest] = routeLength(ref graph, "AA", dest, new HashSet<string>());
            
        }
    }

    foreach(string loc in workingValves)
    {
        foreach(string dest in workingValves)
        {
            if(loc != dest)
            {
                routecount = 0;
                graph[loc].distances[dest] = routeLength(ref graph, loc, dest, new HashSet<string>());
            }
        }
    }   
}

int recurseValves(ref gt graph, ref HashSet<string> unvisited, string location, int timeRemaining)
{
    const int MAX_TRY = 11;

    Dictionary<string, int> dests = new Dictionary<string, int>();
    foreach(string dest in unvisited)
    {
        int timeReq = 1+graph[location].distances[dest];
        if(timeRemaining > timeReq)
        {
            dests.Add(dest, graph[dest].flow * (timeRemaining - timeReq));
        }
    }

    int tried = 0;
    int maxPressure = 0;

    foreach(KeyValuePair<string, int> dest in dests.OrderByDescending(key => key.Value))
    {
        ++tried;
        if( tried > MAX_TRY) break;
        HashSet<string> newUnvisited = new HashSet<string>(unvisited);
        newUnvisited.Remove(dest.Key);
        int p = dest.Value;
        if(newUnvisited.Count() > 0)
        {
            p += recurseValves(ref graph, ref newUnvisited, dest.Key, timeRemaining - (1+graph[location].distances[dest.Key]));
        }
        if(p > maxPressure) maxPressure = p;
    }

    return maxPressure;
}

int SetCombos(ref gt graph, ref HashSet<string> from_in, ref HashSet<string> to_in, int depth)
{
    if (0 == depth) return 0;

    HashSet<string> from = new HashSet<string>(from_in);
    HashSet<string> to = new HashSet<string>(to_in);
    int maxPressure = 0;

    foreach(string loc in from_in)
    {
        if(depth > 3) Console.WriteLine(loc + "; max so far: " + maxPressure);
        from.Remove(loc);
        to.Add(loc);
        int p = 0;
        if(depth < 2)
        {
            p = recurseValves(ref graph, ref from, "AA", 26) +  recurseValves(ref graph, ref to, "AA", 26);
        }

        if (p > maxPressure) maxPressure = p;

        p = SetCombos(ref graph, ref from, ref to, depth -1);
        if (p > maxPressure) maxPressure = p;

        to.Remove(loc);
        from.Add(loc);
    }

    return maxPressure;
}

void doDay16(string filename)
{
    gt graph = new gt();
    HashSet<String> workingValves = new HashSet<string>();
    int turnableValves = readFile(filename, ref graph, ref workingValves);
    calculateDistances(ref graph, ref workingValves);
    int maxPressureReleased = recurseValves(ref graph, ref workingValves, "AA", 30);//recurseGraph(ref graph, 30, "AA", new HashSet<string>(), new HashSet<string>(), turnableValves, 0);
    Console.WriteLine("Max pressure released: " + maxPressureReleased);

    HashSet<String> tmp = new HashSet<string>();
    
    Console.WriteLine("Part 2, with elephant's help: " + SetCombos(ref graph, ref workingValves, ref tmp, 5));
}

if( args.Length == 0)
{
    Console.WriteLine("Error: filename required.");
    return;
}
Console.WriteLine("Filename: " + args[0]);

doDay16(args[0]);


class Node
{
    public int flow = 0;
    public List<String> links = new List<string>();
    public Dictionary<string, int> distances = new Dictionary<string, int>();
};
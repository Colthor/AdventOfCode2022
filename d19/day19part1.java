
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.EnumMap;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Optional;
import java.util.Random;

enum MATERIALS {
    ORE,
    CLAY,
    OBSIDIAN,
    GEODE;

    public static MATERIALS[] REVERSE_MATERIALS = {GEODE, OBSIDIAN, CLAY, ORE};
};
class Robot {
    public EnumMap<MATERIALS, java.lang.Integer> cost;// = new EnumMap<MATERIALS, java.lang.integer>();
    public int quantity = 0;
    public MATERIALS mines;

    Robot(MATERIALS mat, EnumMap<MATERIALS, java.lang.Integer> cost_in) {
        mines = mat;
        cost = cost_in;
    }

    public boolean can_afford(EnumMap<MATERIALS, java.lang.Integer> inventory) {
        //System.out.println("Checking cost of robot: " + mines);
        for(var m : cost.entrySet()) {
            //System.out.println("Checking " + m.getKey() + "; have " + inventory.get(m.getKey()) + ", costs: " + m.getValue());
            if(m.getValue() > inventory.get(m.getKey())) return false;
        }
        return true;
    }
    public boolean buy_from(EnumMap<MATERIALS, java.lang.Integer> inventory) {

        for(var m : cost.entrySet()) {
            inventory.put(m.getKey(), inventory.get(m.getKey()) - m.getValue());
        }
        return true;
    }

}

class BlueprintSim {
    int index;
    EnumMap<MATERIALS, java.lang.Integer> inventory = new EnumMap<MATERIALS, java.lang.Integer>(MATERIALS.class);
    EnumMap<MATERIALS, java.lang.Integer> maxCosts = new EnumMap<MATERIALS, java.lang.Integer>(MATERIALS.class);
    EnumMap<MATERIALS, Robot> robots = new EnumMap<>(MATERIALS.class);

    Random rng = new Random();

    int bestGeodes = 0;
    BlueprintSim(String input) {
        parse_blueprint(input);
        reset_blueprint();
    }

    void reset_blueprint() {
        for(var mat : MATERIALS.values()) {
            inventory.put(mat, 0);
            robots.get(mat).quantity = 0;
        }
        robots.get(MATERIALS.ORE).quantity = 1;
    }
    void parse_blueprint(String input) {
        var sArr = input.split(" ");

        index = Integer.parseInt(sArr[1].substring(0, sArr[1].length() - 1));
        var cost = new EnumMap<MATERIALS, java.lang.Integer>(MATERIALS.class);

        var ore1 =  Integer.parseInt(sArr[6]);
        cost.put(MATERIALS.ORE, ore1);
        robots.put(MATERIALS.ORE, new Robot(MATERIALS.ORE, cost));

        cost = new EnumMap<MATERIALS, java.lang.Integer>(MATERIALS.class);
        var ore2 =  Integer.parseInt(sArr[12]);
        cost.put(MATERIALS.ORE, ore2);
        robots.put(MATERIALS.CLAY, new Robot(MATERIALS.CLAY, cost));

        cost = new EnumMap<MATERIALS, java.lang.Integer>(MATERIALS.class);
        var ore3 =  Integer.parseInt(sArr[18]);
        cost.put(MATERIALS.ORE, ore3);
        cost.put(MATERIALS.CLAY, Integer.parseInt(sArr[21]));
        robots.put(MATERIALS.OBSIDIAN, new Robot(MATERIALS.OBSIDIAN, cost));

        cost = new EnumMap<MATERIALS, java.lang.Integer>(MATERIALS.class);
        var ore4 =  Integer.parseInt(sArr[27]);
        cost.put(MATERIALS.ORE, ore4);
        cost.put(MATERIALS.OBSIDIAN, Integer.parseInt(sArr[30]));
        robots.put(MATERIALS.GEODE, new Robot(MATERIALS.GEODE, cost));

        maxCosts.put(MATERIALS.ORE, Math.max(Math.max(ore1, ore2), Math.max(ore3, ore4)));
        maxCosts.put(MATERIALS.CLAY, Integer.parseInt(sArr[21]));
        maxCosts.put(MATERIALS.OBSIDIAN, Integer.parseInt(sArr[30]));
    }

    ArrayList<Optional<MATERIALS>> robot_to_build(ArrayList<Optional<MATERIALS>> prev) {
        var poss = new ArrayList<Optional<MATERIALS>>();
        if(robots.get(MATERIALS.GEODE).can_afford(inventory)) {
            poss.add( Optional.of(MATERIALS.GEODE));
            return poss;
        }
        poss.add(Optional.empty());
        for(var m : MATERIALS.REVERSE_MATERIALS) {
            if(robots.get(m).can_afford(inventory)
                    && !prev.contains(Optional.of(m))
                    && robots.get(m).quantity < maxCosts.get(m)
                ) {
                poss.add( Optional.of(m));
            }
        }
        return poss;
    }

    void mine_resources() {
        for(var mat : MATERIALS.values()) {
            var had = inventory.get(mat);
            var mine = robots.get(mat).quantity;
            inventory.put(mat, had + mine);
            //System.out.println("Mining " + mine + " " + mat + ", now have: " + inventory.get(mat));
        }
    }

    void simulate() {
        //System.out.println("Simulating Blueprint " + index);
        var choices = new ArrayList<Optional<MATERIALS>>();
        for(int i = 1; i <= 24; ++i) {
            //System.out.println("Minute " + i);
            var turnsLeft = 25 - i;
            var maxGeodes = inventory.get(MATERIALS.GEODE) + turnsLeft * ( robots.get(MATERIALS.GEODE).quantity ) + (turnsLeft * (turnsLeft - 1))/2;
            if (maxGeodes < bestGeodes) break; // if we can't possibly beat our best, abandon the run.

            choices = robot_to_build(choices); //technically resources should be spent here but it makes no odds atm
            var toBuild = choices.get(rng.nextInt(choices.size()));
            mine_resources();

            if(!toBuild.isEmpty()) {
                choices.clear();
                robots.get(toBuild.get()).buy_from(inventory);
                robots.get(toBuild.get()).quantity += 1;
                //System.out.println("Building " + toBuild.get() + " robot, now have: " + robots.get(toBuild.get()).quantity);
            }
        }
        var g = inventory.get(MATERIALS.GEODE);
        if(g > bestGeodes)
        {
            bestGeodes = g;
            System.out.println(index + " best: " + g);
        }
    }
    public int get_quality_level() {
        simulate();
        return index * bestGeodes;
    }
}

public class Main {

    static ArrayList<BlueprintSim> read_file(String filename) {
        ArrayList<BlueprintSim> bpList = new ArrayList<>();

        try(BufferedReader br = new BufferedReader(new FileReader(filename))) {
            for(String line; (line = br.readLine()) != null; ) {
                bpList.add(new BlueprintSim(line));
            }
        }
        catch(FileNotFoundException e) {
            System.out.println("FileNotFoundException in read_file(): " + e.getMessage());
        } catch (IOException e) {
            System.out.println("IOException in read_file(): " + e.getMessage());
        }

        return bpList;
    }

    public static void main(String[] args) {
        ArrayList<BlueprintSim> bpList = read_file("day19.txt");
        int totalQL = 0, maxQL = 0;
        int no_imp = 0;
        boolean improved = false;

        while(no_imp < 6) {
            System.out.println("Running, best yet: " + maxQL + " no_imp: " + no_imp);
            for (int i = 0; i < 1000000; i++) {
                if (0 == i % 100000) {
                    System.out.println(i + "; best yet: " + maxQL);
                }
                totalQL = 0;
                for (var bp : bpList) {
                    bp.reset_blueprint();
                    totalQL += bp.get_quality_level();
                }
                if (totalQL > maxQL){
                    maxQL = totalQL;
                    improved = true;
                }
            }
            if(!improved) no_imp += 1;
            improved = false;
        }

        System.out.println("Best total quality level: " + maxQL);
    }
}
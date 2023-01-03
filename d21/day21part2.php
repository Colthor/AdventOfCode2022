<?php

$monkeyvals = [];
$pendingmonkeys = [];
$reliedonby = [];

class Monkey {
    public $name;
    public $m1;
    public $m2;
    public $op;
    
    public function reverseOp() {
        if("+" == $this->op) {
            return "-";
        } else if("-" == $this->op) {
            return "+";
        } else if("*" == $this->op) {
            return "/";
        } else if("/" == $this->op) {
            return "*";
        }
    }
    
    public function canEval() {
        global $monkeyvals;
        return isset($monkeyvals[$this->m1]) && isset($monkeyvals[$this->m2]);
    }
    
    public function dependsOn($m) {
        return ($m == this->$m1 || $m == this->$m2);
    }
    
    public function eval() {
    
        global $monkeyvals, $pendingmonkeys;
        //if(!$this->canEval()) {
        
            //echo " (";
            if(isset($pendingmonkeys[$this->m1])) {
                $pendingmonkeys[$this->m1]->eval();
            } else {
                //echo $monkeyvals[$this->m1];
            }
            //echo ") ";
            //echo $this->op;
            //echo " (";
            
            if(isset($pendingmonkeys[$this->m2])) {
                $pendingmonkeys[$this->m2]->eval();
            } else {
                //echo $monkeyvals[$this->m2];
            }
            //echo ") ";
        //}
        
        $v1 = $monkeyvals[$this->m1];
        $v2 = $monkeyvals[$this->m2];
        $ans = 0;
        if("+" == $this->op) {
            $ans = $v1 + $v2;
        } else if("-" == $this->op) {
            $ans = $v1 - $v2;
        } else if("*" == $this->op) {
            $ans = $v1 * $v2;
        } else if("/" == $this->op) {
            $ans = intdiv($v1, $v2);
        } else if("=" == $this->op) {
            echo "Left: {$v1}, Right: {$v2}\n";
            $ans = $v1 - $v2;
        } else {
            echo "error, operator unknown: '" + $this->op + "'\n";
        }
        $monkeyvals[$this->name] = $ans;        
    }
}



$handle = fopen("day21.txt", "r");
if ($handle) {
    while (($line = fgets($handle)) !== false) {
        $sarr = explode(" ", $line);
        if(count($sarr) == 2) { // two entries - number
            //echo $sarr[1];
            
            $monkeyvals[trim($sarr[0], " :\n\r\t\v\x00")] = intval($sarr[1]);
        }
        else { 
            $m = new Monkey();
            $m->name = trim($sarr[0], " :\n\r\t\v\x00");
            $m->m1 = trim($sarr[1], " :\n\r\t\v\x00");
            $m->op = $sarr[2];
            $m->m2 = trim($sarr[3], " :\n\r\t\v\x00");
            
            if($m->name == "root") $m->op = "=";
            
            $reliedonby[$m->m1] = $m->name;
            $reliedonby[$m->m2] = $m->name;
            
            $pendingmonkeys[$m->name] = $m;
        }
    }

    fclose($handle);
}

$pendingmonkeys["root"]->eval();
echo "root says {$monkeyvals["root"]}\n" ;

$sum = [];
$m = "humn";
while(isset($reliedonby[$m] )) {
    $p = $m;
    $m = $reliedonby[$m];
    $v = 0;
    $side = "";
    if($p == $pendingmonkeys[$m]->m1) {
        $v = $monkeyvals[$pendingmonkeys[$m]->m2];
        $side = "r";
    } else {
        $v = $monkeyvals[$pendingmonkeys[$m]->m1];
    }
    $sum[] = intval($v);
    if($m !== "root") $sum[] = $pendingmonkeys[$m]->op . $side;
    //echo "{$m} : {$p} {$pendingmonkeys[$m]->op} {$v}\n";   
}
$l = count($sum);
$humn = intval($sum[$l-1]);
$op = "";

for($i= $l-2; $i>=0; $i--) {
    if(is_int($sum[$i])) {
        if("+" == $op || "+r" == $op) {
            $humn = $humn - $sum[$i];
        } else if("-" == $op) {
            $humn = $sum[$i] - $humn;
        } else if("-r" == $op) {
            $humn = $humn + $sum[$i];
        } else if("*" == $op || "*r" == $op) {
            $humn = intdiv($humn, $sum[$i]); //$humn * $sum[$i];
        } else if("/" == $op) {
            $humn = intdiv($sum[$i] , $humn);// $sum[$i] / $humn;
        } else if("/r" == $op) {
            $humn = $humn * $sum[$i];
        }
    } else {
        $op = $sum[$i];
    }
}

echo "\nhumn should be: {$humn}\n";

?>

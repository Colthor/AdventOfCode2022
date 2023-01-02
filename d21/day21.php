<?php

$monkeyvals = [];
$pendingmonkeys = [];

class Monkey {
    public $name;
    public $m1;
    public $m2;
    public $op;
    
    public function canEval() {
        global $monkeyvals;
        return isset($monkeyvals[$this->m1]) && isset($monkeyvals[$this->m2]);
    }
    
    public function dependsOn($m) {
        return ($m == this->$m1 || $m == this->$m2);
    }
    
    public function eval() {
    
        global $monkeyvals, $pendingmonkeys;
        if(!$this->canEval()) {
            if(isset($pendingmonkeys[$this->m1])) {
                $pendingmonkeys[$this->m1]->eval();
            }
            if(isset($pendingmonkeys[$this->m2])) {
                $pendingmonkeys[$this->m2]->eval();
            }
        }
        
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
            $ans = $v1 / $v2;
        } else {
            echo "error, operand unknown: '" + $this->op + "'\n";
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
            
            if($m->canEval()) {
                $m->eval();
            } else {
                $pendingmonkeys[$m->name] = $m;
            }
        }
    }

    fclose($handle);
}

$pendingmonkeys["root"]->eval();


echo "root says {$monkeyvals["root"]}\n" ;

?>

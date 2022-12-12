import System.IO
import System.Directory
import Debug.Trace

debug = flip trace

data Instruction = Addx Int | Noop deriving (Show)

parseInstruction :: [String] -> Instruction
parseInstruction ("noop":[]) = Noop
parseInstruction ["addx",s]  = Addx (read s :: Int)

strsToInstructions :: [String] -> [Instruction]
strsToInstructions []       = []
strsToInstructions (x : xs) = parseInstruction (words x) : (strsToInstructions xs)

-- (cycle number, X)
execute :: Int -> Int -> [Instruction] -> [(Int, Int)]
execute c x []              = [] --[(n,x)]
execute c x (Noop:list)     = (c, x) : execute (c+1) x list
execute c x ((Addx d):list) = (c, x) : (c+1, x) : execute (c+2) (x+d) list


pixel :: Int -> Int -> Char
pixel c x =
    let p = (c `mod` 40) - 1
    in if p == x-1 || p == x || p == x+1 then '#' else '.'


-- (cycle number, X)
crt :: [(Int, Int)] -> String
crt [] = ""
crt ((c,x) : xs) = pixel c x : 
        if (c `mod` 40) == 0 then '\n' : crt xs else crt xs


main = do
    contents <- readFile "day10.txt"
    putStrLn $ crt $ execute 1 1 $ strsToInstructions $ lines contents

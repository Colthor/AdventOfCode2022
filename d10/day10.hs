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
execute n x []              = [(n,x)]
execute n x (Noop:list)     = (n, x) : execute (n+1) x list
execute n x ((Addx d):list) = (n, x) : (n+1, x) : execute (n+2) (x+d) list

-- (cycle number, X)
signalStrength :: [(Int, Int)] -> Int
signalStrength []          = 0
signalStrength ((c,x):xs)
    | (c-20) `mod` 40 == 0 = c*x + signalStrength xs `debug` (show c)
    | otherwise            = signalStrength xs

main = do
    contents <- readFile "day10.txt"
    print $ signalStrength $ execute 1 1 $ strsToInstructions $ lines contents

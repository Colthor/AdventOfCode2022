module Main where

import Prelude

import Effect (Effect)
import Effect.Console (logShow)
import Data.Map (Map, lookup, singleton)
import Data.List
import Data.String
import TryPureScript (render, withConsole)

data NumList
  = Num Int
  | Lst (List NumList)
  
--Return -1 if left is smaller, 0 if the same, +1 if bigger
comparePacket :: Partial => (List NumList) -> (List NumList) -> Int
comparePacket Nil Nil          = 0
comparePacket (Cons _ _) (Nil) = 1
comparePacket (Nil) (Cons _ _) = -1
comparePacket (Cons (Num a) as) (Cons (Num b) bs)
  | a < b = -1
  | b < a = 1
  | a == b = comparePacket as bs
comparePacket (Cons (Lst a) as) (Cons (Lst b) bs)
  | 0 == comparePacket a b = comparePacket as bs
  | otherwise = comparePacket a b
comparePacket (Cons (Num a) as) (Cons (Lst b) bs) =
  comparePacket (Cons (Lst (Cons (Num a) Nil)) as) (Cons (Lst b) bs)
comparePacket (Cons (Lst b) bs) (Cons (Num a) as) =
  comparePacket (Cons (Lst b) bs) (Cons (Lst (Cons (Num a) Nil)) as)
  
  
strToPacket :: String -> (List NumList)
strToPacket a  
  | uncons a == Nothing = Nil
  | uncons a == Just { a, tail } = 
    if "[" == a then

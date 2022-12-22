module Main where

import Prelude

import Effect (Effect)
import Effect.Console (logShow)
import Data.Map (Map, lookup, singleton)
import Data.List
import Data.String
import TryPureScript (render, withConsole)

data NumList
  = N Int
  | L (List NumList)
  
data Items = I Int (List NumList) (List NumList)

sumPackets :: (List Items) -> Int
sumPackets Nil = 0
sumPackets (Cons (I i left right) tail)
  | -1 == comparePacket left right = i + sumPackets tail
  | otherwise = sumPackets tail
  
--Return -1 if left is smaller, 0 if the same, +1 if bigger
comparePacket :: (List NumList) -> (List NumList) -> Int
comparePacket Nil Nil          = 0
comparePacket (Cons _ _) (Nil) = 1
comparePacket (Nil) (Cons _ _) = -1
comparePacket (Cons (N a) as) (Cons (N b) bs)
  | a < b = -1
  | b < a = 1
  | a == b = comparePacket as bs
comparePacket (Cons (L a) as) (Cons (L b) bs)
  | 0 == comparePacket a b = comparePacket as bs
  | otherwise = comparePacket a b
comparePacket (Cons (N a) as) (Cons (L b) bs) =
  comparePacket (Cons (L (Cons (N a) Nil)) as) (Cons (L b) bs)
comparePacket (Cons (L b) bs) (Cons (N a) as) =
  comparePacket (Cons (L b) bs) (Cons (L (Cons (N a) Nil)) as)
comparePacket (Cons (N _) _) (Cons (N _) _) = 0 --I don't know why this is
  
  
main :: Effect Unit
main = render =<< withConsole do
  logShow( ... )
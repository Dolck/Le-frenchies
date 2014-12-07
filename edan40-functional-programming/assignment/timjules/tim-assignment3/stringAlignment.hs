--By Tim Dolck

import Data.List
import Data.Ord

--1:
--An application of the string alignment problem to computer science is the fact that the maximal 
--common subsequence problem (MCS) is a special case of the string alignment problem.Assuming we 
--had access to an algorithm for the string alignment problem, how could we use it to solve MCS for strings?

--Ans: Set score match to 1 and score mismatch and score space to 0; Then if we'd run the algorithm with theese
--     values the result would be the maximal common subsequence
align1a = "HASKELL"
align1b = "PASCA-L"

align2a = "H-ASKELL"
align2b = "-PASC-AL"

scoreMatch = 1
scoreMismatch = -1
scoreSpace = -2

--2a A farily slow and dumb solution:
score :: Char -> Char -> Int
    score '-' _ = scoreSpace
    score _ '-' = scoreSpace
    score c1 c2
      | c1 == c2  = scoreMatch
      | otherwise = scoreMismatch

similarityScore :: String -> String -> Int
similarityScore string1 = sum . zipWith score string1
  where
    



--2b
--Attaches heads to both lists in a tuple for every tuple in a list
attachHeads :: a -> a -> [([a],[a])] -> [([a],[a])] 
attachHeads h1 h2 aList = [(h1:xs,h2:ys) | (xs,ys) <- aList]

--2c
maximaBy :: Ord b => (a -> b) -> [a] -> [a] 
maximaBy valueFcn xs = filter scoreFilter xs
  where
    scoreFilter x = vMax == valueFcn x
    vMax = maximum $ map valueFcn xs


--2d
type AlignmentType = (String,String)


optAlignments :: String -> String -> [AlignmentType]
optAlignments string1 string2













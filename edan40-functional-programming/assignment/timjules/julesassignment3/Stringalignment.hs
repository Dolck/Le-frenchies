--String Alignment
--Compare two strings and give all optimal alignments

--Input: Two strings s and t, and values for scoreMatch, scoreMismatch, and scoreSpace.
--Output: All optimal alignments between s and t.

import Data.List
import Data.Ord
type AlignmentType = (String, String)

-- w r i t - e r s
-- v i n t n e r -

scoreMatch = 0
scoreMismatch = -1
scoreSpace = -1

-- H A S K E L L
-- P A S C A - L
-- -2
--
-- H - A S K E L L
-- - P A S C - A L
-- -5

similarityScore :: String -> String -> Int
similarityScore "" "" = 0
similarityScore "" (x:xs) = scoreSpace + similarityScore "" xs
similarityScore (x:xs) "" = scoreSpace + similarityScore xs ""
similarityScore (x:xs) (y:ys) = maximum [score x y + similarityScore xs ys, score x '-' + similarityScore xs (y:ys), score '-' y + similarityScore (x:xs) ys]


score :: Char -> Char -> Int
score c1 c2
  | c1 == '-' || c2 == '-' = scoreSpace
  | c1 == c2 = scoreMatch
  | otherwise = scoreMismatch


-- It prepends two new heads to all of the pairs with two lists in aList
attachHeads :: a -> a -> [([a],[a])] -> [([a],[a])]
attachHeads h1 h2 aList = [(h1:xs,h2:ys) | (xs,ys) <- aList] 

maximaBy :: Ord b => (a -> b) -> [a] -> [a]
maximaBy f = head . groupBy equality . sortBy (flip $ comparing f)
  where equality a b = f a == f b


optAlignments :: String -> String -> [AlignmentType]
optAlignments "" "" = [("", "")]
optAlignments "" (x:xs) = attachHeads '-' x $ optAlignments "" xs
optAlignments (x:xs) "" = attachHeads x '-' $ optAlignments xs ""
optAlignments (x:xs) (y:ys) = maximaBy (sum . eval) $ 
  (attachHeads x y $ optAlignments xs ys) ++ (attachHeads x '-' $ optAlignments xs (y:ys)) ++ (attachHeads '-' y $ optAlignments (x:xs) ys)
  where
    eval = uncurry $ zipWith score

optLength :: String -> String -> Int
optLength xs ys = optLen (length xs) (length ys)
  where
    optLen i j = optTable!!i!!j
    optTable = [[ optEntry i j | j <- [0..]] | i <- [0..]]
    optEntry :: Int -> Int -> Int
    optEntry i 0 = scoreSpace * i
    optEntry 0 j = scoreSpace * j
    optEntry i j
      | x == y = scoreMatch + optLen (i-1) (j-1)
      | otherwise = maximum [scoreMismatch + optLen (i-1) (j-1), scoreSpace + optLen i (j-1), scoreSpace + optLen (i-1) j]
      where
        x = xs!!(i-1)
        y = ys!!(j-1)

attachTails :: a -> a -> [([a],[a])] ->[([a],[a])]
attachTails t1 t2 aList = [(xs++[t1],ys++[t2]) | (xs,ys) <- aList]

opAlig :: String -> String -> (Int, [AlignmentType])
opAlig xs ys = let list = opLength xs ys in (optLength (fst $ head list) (snd $ head list), list)
  where
    opLength :: String -> String -> [AlignmentType]
    opLength xs ys = opLen (length xs) (length ys)
    opLen i j = opTable!!i!!j
    opTable = [[ opEntry i j | j <- [0..]] | i <- [0..]]
    opEntry :: Int -> Int -> [AlignmentType]
    opEntry 0 0 = [("","")]
    opEntry i 0 = attachTails (x i) '-' $ opLen (i-1) 0
    opEntry 0 j = attachTails '-' (y j) $ opLen 0 (j-1)
    opEntry i j = maximaBy (sum . eval) $ (attachTails (x i) (y j) $ opLen (i-1) (j-1)) ++ (attachTails (x i) '-' $ opLen (i-1) j) ++ (attachTails '-' (y j) $ opLen i (j-1))
    eval = uncurry $ zipWith score
    x i = xs!!(i-1)
    y j = ys!!(j-1)







--optimalAlignments :: Int -> Int -> Int -> String -> String -> [AlignmentType]

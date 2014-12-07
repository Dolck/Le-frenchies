-- String Alignment
-- Compare two strings and give all optimal alignments
-- by Julian Kroné, dat11jkr

import Data.List
import Data.Ord
type AlignmentType = (String, String)

scoreMatch = 1
scoreMismatch = -1
scoreSpace = -2

-- 1. If we from our algorithm solving the string alignment problem, set the score from spaces and mismatches to 0, this would result in only matches recieving score -> MCS

-- 2.a
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

-- 2.b
-- It prepends two new heads to all of the tuples in aList
attachHeads :: a -> a -> [([a],[a])] -> [([a],[a])]
attachHeads h1 h2 aList = [(h1:xs,h2:ys) | (xs,ys) <- aList] 

-- 2.c
maximaBy :: Ord b => (a -> b) -> [a] -> [a]
maximaBy f = head . groupBy equality . sortBy (flip $ comparing f)
  where equality a b = f a == f b

-- 2.d unoptimized
optAlignments :: String -> String -> [AlignmentType]
optAlignments "" "" = [("", "")]
optAlignments "" (x:xs) = attachHeads '-' x $ optAlignments "" xs
optAlignments (x:xs) "" = attachHeads x '-' $ optAlignments xs ""
optAlignments (x:xs) (y:ys) = maximaBy (sum . eval) $ 
  (attachHeads x y $ optAlignments xs ys) ++ (attachHeads x '-' $ optAlignments xs (y:ys)) ++ (attachHeads '-' y $ optAlignments (x:xs) ys)
  where
    eval = uncurry $ zipWith score

-- 2.e calling the optimized function
outputOptAlignments :: String -> String -> IO()
outputOptAlignments s1 s2 = putStrLn $ format s1 s2
  where
    format :: String -> String -> String
    format s1 s2 = concatMap (\(a,b) -> "\n" ++ fix a ++ "\n" ++ fix b ++ "\n") $ fastAlignments s1 s2
    fix = intersperse ' '

-- 3
-- It appends two new tails to all of the tuples in the aList
attachTails :: a -> a -> [([a],[a])] ->[([a],[a])]
attachTails t1 t2 aList = [(xs++[t1],ys++[t2]) | (xs,ys) <- aList]

-- Optimized
fastAlignments :: String -> String -> [AlignmentType]
fastAlignments xs ys = snd $ getFastTable (length xs) (length ys)
  where
    getFastTable :: Int -> Int -> (Int, [AlignmentType])
    getFastTable i j = fastTable!!i!!j
    fastTable = [[ fastEntry i j | j <- [0..]] | i <- [0..]]
    fastEntry :: Int -> Int -> (Int, [AlignmentType])
    fastEntry 0 0 = (0, [("", "")])
    fastEntry i 0 = let (acc, vec) = getFastTable (i-1) 0 in (scoreSpace + acc, attachTails (x i) '-' vec)
    fastEntry 0 j = let (acc, vec) = getFastTable 0 (j-1) in (scoreSpace + acc, attachTails '-' (y j) vec)
    fastEntry i j = (fst $ head current, concatMap snd current)
      where
        (acc1, vec1) = getFastTable (i-1) (j-1)
        (acc2, vec2) = getFastTable i (j-1)
        (acc3, vec3) = getFastTable (i-1) j
        current = maximaBy fst [((score (x i) (y j)) + acc1, attachTails (x i) (y j) vec1), 
                                (scoreMismatch + acc2, attachTails '-' (y j) vec2),
                                (scoreMismatch + acc3, attachTails (x i) '-' vec3)]

    x i = xs!!(i-1)
    y j = ys!!(j-1)


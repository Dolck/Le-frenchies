--String Alignment
--Compare two strings and give all optimal alignments

--Input: Two strings s and t, and values for scoreMatch, scoreMismatch, and scoreSpace.
--Output: All optimal alignments between s and t.
import Data.List
import Data.Ord
type AlignmentType = (String, String)

-- w r i t e r s
-- v i n t n e r
-- - - - + - - - = 

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





--similarityScore s1 s2 = sum (score s1 s2)
--  where
--    score :: String -> String -> [Int]
--    score [c1] [c2] = [comp c1 c2]
--    score (x:xs) (y:ys) = comp x y : score xs ys
--    comp :: Char -> Char -> Int
--    comp a b
--      | a == '-' || b == '-' = scoreSpace
--      | a == b = scoreMatch
--      | otherwise = scoreMismatch


-- It prepends two new heads to the two lists in aList
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

























--optimalAlignments :: Int -> Int -> Int -> String -> String -> [AlignmentType]

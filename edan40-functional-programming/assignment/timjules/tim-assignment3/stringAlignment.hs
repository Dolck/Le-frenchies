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
align1b = "PASCAL"

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
similarityScore "" "" = 0
similarityScore "" ys = (*) scoreSpace $ length ys
similarityScore xs "" = (*) scoreSpace $ length xs
similarityScore (x:xs) (y:ys) = maximum[score x y + similarityScore xs ys, 
                                        score '-' y + similarityScore (x:xs) ys,
                                        score x '-' + similarityScore xs (y:ys)]
    

--2b
--Attaches heads to lists in a tuple for every tuple in the list
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
optAlignments "" "" = [("", "")]
optAlignments "" (y:ys) = attachHeads '-' y $ optAlignments "" ys
optAlignments (x:xs) "" = attachHeads x '-' $ optAlignments xs ""
optAlignments (x:xs) (y:ys) = maximaBy sumScore allPoss
  where
    sumScore = sum . (uncurry $ zipWith score)
    allPoss = poss x xs y ys ++ poss '-' (x:xs) y ys ++ poss x xs '-' (y:ys)
      where
        poss a as b bs = attachHeads a b $ optAlignments as bs

--2e
outputOptAlignments :: String -> String -> IO ()
outputOptAlignments s1 s2 = mapM_ printAlignment $ optFastAlignments s1 s2
  where
    printAlignment :: AlignmentType -> IO ()
    printAlignment (a, b) = do putStrLn (a ++ "\n" ++ b ++ "\n")


--3 fast solution
optFastAlignments :: String -> String -> [AlignmentType]
optFastAlignments s1 s2 = snd $ tableGet (length s1) (length s2)
  where
    tableGet :: Int -> Int -> (Int, [AlignmentType])
    tableGet i j = table!!i!!j
    table :: [[(Int, [AlignmentType])]]
    table = [[ entry i j | j <- [0..]] | i <- [0..] ]
    attachAndAdd :: Int -> Char -> Char -> (Int, [AlignmentType]) -> (Int, [AlignmentType])
    attachAndAdd s t1 t2 (acc, p) = (s + acc, attachTails t1 t2 p)
    entry :: Int -> Int -> (Int, [AlignmentType])
    entry 0 0 = (0, [("","")])
    entry i 0 = attachAndAdd scoreSpace (s1s i) '-' $ tableGet (i-1) 0
    entry 0 j = attachAndAdd scoreSpace '-' (s2s j) $ tableGet 0 (j-1)
    entry i j = (fst $ head maxis, concatMap snd maxis)
      where
        maxis = maximaBy fst [attachAndAdd (score (s1s i) (s2s j)) (s1s i) (s2s j) $ tableGet (i-1) (j-1),
                              attachAndAdd scoreMismatch (s1s i) '-' $ tableGet (i-1) j,
                              attachAndAdd scoreMismatch '-' (s2s j) $ tableGet i (j-1)]
    s1s i = s1 !! (i-1)
    s2s j = s2 !! (j-1)

    

attachTails :: a -> a -> [([a],[a])] ->[([a],[a])]
attachTails t1 t2 list = [(xs ++ [t1], ys ++ [t2]) | (xs,ys) <- list]


mcsLength :: Eq a => [a] -> [a] -> Int
mcsLength xs ys = mcsLen (length xs) (length ys)
  where
    mcsLen i j = mcsTable!!i!!j
    mcsTable = [[ mcsEntry i j | j<-[0..]] | i<-[0..] ]
       
    mcsEntry :: Int -> Int -> Int
    mcsEntry _ 0 = 0
    mcsEntry 0 _ = 0
    mcsEntry i j
      | x == y    = 1 + mcsLen (i-1) (j-1)
      | otherwise = max (mcsLen i (j-1)) 
                        (mcsLen (i-1) j)
      where
         x = xs!!(i-1)
         y = ys!!(j-1)










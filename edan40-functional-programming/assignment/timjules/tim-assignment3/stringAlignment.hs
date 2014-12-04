--By Tim Dolck

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

--2a
similarityScore :: String -> String -> Int
similarityScore string1 = sum . zipWith score string1
  where
    score :: Char -> Char -> Int
    score '-' _ = scoreSpace
    score _ '-' = scoreSpace
    score c1 c2
      | c1 == c2  = scoreMatch
      | otherwise = scoreMismatch



type AlignmentType = (String,String)

--optimalAlignments :: Int -> Int -> Int -> String -> String -> [AlignmentType]

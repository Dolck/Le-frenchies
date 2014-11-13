module Pattern where
import Utilities


-------------------------------------------------------
-- Match and substitute
--------------------------------------------------------

-- Replaces a wildcard in a list with the list given as the third argument
substitute :: Eq a => a -> [a] -> [a] -> [a]
substitute wc (x:xs) s 
  | wc == x   = s ++ xs
  | otherwise = x : substitute wc xs s
substitute _ _ _ = []


-- Tries to match two lists. If they match, the result consists of the sublist
-- bound to the wildcard in the pattern list.
match :: Eq a => a -> [a] -> [a] -> Maybe [a]
match _ [] [] = Just [] 
match _ [] xs = Nothing
match _ ps [] = Nothing
match wc (p:ps) (y:ys)
  | p == wc = orElse (singleWildcardMatch (p:ps) (y:ys)) (longerWildcardMatch (p:ps) (y:ys))
  | otherwise = match wc ps ys
   where
    singleWildcardMatch :: Eq a => [a] -> [a] -> Maybe [a]
    singleWildcardMatch (p:ps) (x:xs)
      | ps == xs  = Just [x]
      | otherwise = Nothing
    longerWildcardMatch pls (xl:xls) = mmap ([xl]++) (match wc pls xls)
    longerWildcardMatch _ _ = Nothing

{- TO BE WRITTEN -}

singleWildcardMatch :: Eq a => [a] -> [a] -> Maybe [a]
singleWildcardMatch (p:ps) (x:xs)
  | ps == xs  = Just [x]
  | otherwise = Nothing
-- match wc (x:xs) (y:ls)
--  | wc == x   = Just $ extract xs y 
 -- | otherwise = match wc xs ls
  -- where
   -- extract :: Eq a => [a] -> a -> [a]
--    extract (x:xs) stop 
 --   | x == stop = [] 
  --  | otherwise = x : extract xs stop
   -- extract _ _ = [] 

-- Helper function to match
--singleWildcardMatch, longerWildcardMatch :: Eq a => [a] -> [a] -> Maybe [a]
--singleWildcardMatch (wc:ps) (x:xs) = Nothing
{- TO BE WRITTEN -}
--longerWildcardMatch (wc:ps) (x:xs) = Nothing
{- TO BE WRITTEN -}



-- Test cases --------------------

testPattern =  "a=*;"
testSubstitutions = "32"
testString = "a=32;"

substituteTest = substitute '*' testPattern testSubstitutions
substituteCheck = substituteTest == testString

matchTest = match '*' testPattern testString
matchCheck = matchTest == Just testSubstitutions



-------------------------------------------------------
-- Applying patterns
--------------------------------------------------------

-- Applying a single pattern
transformationApply :: Eq a => a -> ([a] -> [a]) -> [a] -> ([a], [a]) -> Maybe [a]
transformationApply _ _ _ _ = Nothing
{- TO BE WRITTEN -}


-- Applying a list of patterns until one succeeds
transformationsApply :: Eq a => a -> ([a] -> [a]) -> [([a], [a])] -> [a] -> Maybe [a]
transformationsApply _ _ _ _ = Nothing
{- TO BE WRITTEN -}


module Pattern where

import Utilities

-------------------------------------------------------
-- Match and substitute
--------------------------------------------------------

-- Replaces a wildcard in a list with the list given as the third argument
substitute :: Eq a => a -> [a] -> [a] -> [a]
substitute _ [] _ = []
substitute wc (x:xs) s  
  | wc == x   = s ++  substitute wc xs s
  | otherwise = x :   substitute wc xs s



-- Tries to match two lists. If they match, the result consists of the sublist
-- bound to the wildcard in the pattern list.
match :: Eq a => a -> [a] -> [a] -> Maybe [a]
match _ ps ys
  | ps == [] && ys == [] = Just []
  | ps == [] || ys == [] = Nothing
match wc (p:ps) (y:ys)
  | (p:ps) == [wc] = Just (y:ys)
  | p == y         = match wc ps ys
  | p == wc        = singleWildcardMatch (p:ps) (y:ys) `orElse` longerWildcardMatch (p:ps) (y:ys)
  | otherwise      = Nothing 

singleWildcardMatch, longerWildcardMatch :: Eq a => [a] -> [a] -> Maybe [a]
singleWildcardMatch (wc:ps) (x:xs) = mmap (x:) $ match wc ps xs
singleWildcardMatch _ _ = Nothing
longerWildcardMatch (wc:ps) (x:xs) = mmap (x:) $ match wc (wc:ps) xs
longerWildcardMatch _ _ = Nothing

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
transformationApply wc f xs (w, t) = mmap helper . match wc w $ xs
  where
    helper = substitute wc t . f

-- Applying a list of patterns until one succeeds
transformationsApply :: Eq a => a -> ([a] -> [a]) -> [([a], [a])] -> [a] -> Maybe [a]
transformationsApply wc f wts xs = foldr (orElse . transformationApply wc f xs) Nothing wts


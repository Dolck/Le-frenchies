module Pattern where
import Utilities
import Data.List

-------------------------------------------------------
-- Match and substitute
--------------------------------------------------------

-- Replaces a wildcard in a list with the list given as the third argument
substitute :: Eq(a) => a -> [a] -> [a] -> [a] 
substitute _ [] _ = []
substitute wc (y:ys) z 
    | wc == y = z ++ substitute wc ys z
    | otherwise = y : substitute wc ys z

-- Tries to match two lists. If they match, the result consists of the sublist
-- bound to the wildcard in the pattern list.
match :: Eq a => a -> [a] -> [a] -> Maybe [a]
match wc xs ys
  | xs == [] && ys == [] = Just []
  | xs == [] || ys == [] = Nothing
match wc (x:xs) (y:ys) 
  | (x:xs) == (y:ys) = Just []
  | [wc] == (x:xs) = Just (y:ys)
  | x == y = match wc xs ys
  | wc == x = singleWildcardMatch (wc:xs) (y:ys) `orElse` longerWildcardMatch (wc:xs) (y:ys)
  | otherwise = Nothing


singleWildcardMatch, longerWildcardMatch :: Eq a => [a] -> [a] -> Maybe [a]
singleWildcardMatch (wc:ps) (x:xs) = mmap (const [x]) $ match wc ps xs

longerWildcardMatch (wc:ps) (x:xs) = mmap (x:) $ match wc (wc:ps) xs


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
transformationApply wc f xs p = mmap (substitute wc (snd p) . f) sub
  where
    sub = match wc (fst p) xs

-- Applying a list of patterns until one succeeds
transformationsApply :: Eq a => a -> ([a] -> [a]) -> [([a], [a])] -> [a] -> Maybe [a]
transformationsApply wc f ps xs = foldr (orElse . transformationApply wc f xs) Nothing ps



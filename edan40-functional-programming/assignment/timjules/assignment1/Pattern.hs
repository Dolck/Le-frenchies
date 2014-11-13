module Pattern where
import Utilities
import Data.List


-------------------------------------------------------
-- Match and substitute
--------------------------------------------------------

-- Replaces a wildcard in a list with the list given as the third argument
substitute :: Eq(a) => a -> [a] -> [a] -> [a]
substitute x (y:ys) z
	| x == y = z ++ substitute x ys z
	| otherwise = y : substitute x ys z
substitute _ _ _ = []
{- WRITTEN -}


-- Tries to match two lists. If they match, the result consists of the sublist
-- bound to the wildcard in the pattern list.
match :: Eq a => a -> [a] -> [a] -> Maybe [a]
match n xs ys 
  | xs == ys = Just []
  | not $ n `elem` xs = Nothing
  | otherwise = head $ matchHelper n xs ys
  where
    matchHelper n (x:xs) (y:ys)
      | x == y = matchHelper n xs ys
      | n == x = singleWildcardMatch (x:xs) (y:ys) `orElse` longerWildcardMatch (x:xs) (y:ys) ++ match n xs ys
      | otherwise = Nothing
{- TO BE WRITTEN -}


-- Helper function to match
singleWildcardMatch, longerWildcardMatch :: Eq a => [a] -> [a] -> Maybe [a]
singleWildcardMatch (wc:ps) (x:xs)
  | ps == xs = Just [x]
  | otherwise = Nothing
longerWildcardMatch (wc:ps) (x:xs)
  | singleWildcardMatch (wc:ps) (x:xs) == Just [x] = Nothing
  | isSuffixOf ps xs = Just (x:(take (length xs - length ps) xs))
  | otherwise = Nothing



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


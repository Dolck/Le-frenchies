module Pattern where
import Utilities
import Data.List


-------------------------------------------------------
-- Match and substitute
--------------------------------------------------------

-- Replaces a wildcard in a list with the list given as the third argument
substitute :: Eq(a) => a -> [a] -> [a] -> [a] 
substitute wc ys z = concatMap (\n -> if n == wc then z else [n]) ys

-- Tries to match two lists. If they match, the result consists of the sublist
-- bound to the wildcard in the pattern list.
match :: Eq a => a -> [a] -> [a] -> Maybe [a]
match wc xs ys 
  | xs == ys = Just []
  | not $ wc `elem` xs = Nothing
  | [wc] == xs = Just ys
  | otherwise = matchHelper xs ys
  where
    matchHelper (x:xs) (y:ys)
      | x == y = matchHelper xs ys
      | wc == x = singleWildcardMatch (x:xs) (y:ys) `orElse` longerWildcardMatch (x:xs) (y:ys)
      | otherwise = Nothing
    matchHelper _ _ = Nothing


singleWildcardMatch, longerWildcardMatch :: Eq a => [a] -> [a] -> Maybe [a]
singleWildcardMatch (wc:ps) (x:xs)
  | match wc (x:ps) (x:xs) /= Nothing = Just [x]
  | otherwise = Nothing

longerWildcardMatch [wc] xs = Just xs
longerWildcardMatch (wc:ps) (x:xs)
  | match wc (subs++ps) (x:xs) /= Nothing = Just subs
  | otherwise = Nothing
  where
    subs = x:(takeWhile (/= head ps) xs)

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
frenchPresentation = ("My name is *", "Je m'appelle *")
-- Applying a single pattern
transformationApply :: Eq a => a -> ([a] -> [a]) -> [a] -> ([a], [a]) -> Maybe [a]
transformationApply wc f xs p = tHelp sub
  where
    sub = match wc (fst p) xs
    tHelp Nothing = Nothing
    tHelp (Just ys) = Just $ substitute wc (snd p) $ f ys


-- Applying a list of patterns until one succeeds
transformationsApply :: Eq a => a -> ([a] -> [a]) -> [([a], [a])] -> [a] -> Maybe [a]
transformationsApply wc f (p:ps) xs = transformationApply wc f xs p `orElse` transformationsApply wc f ps xs
transformationsApply _ _ _ _ = Nothing


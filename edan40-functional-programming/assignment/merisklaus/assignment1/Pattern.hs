module Pattern where

import Utilities

-------------------------------------------------------
-- Match and substitute
--------------------------------------------------------

-- Replaces a wildcard in a list with the list given as the third argument
substitute :: Eq a => a -> [a] -> [a] -> [a]
substitute wc xs s = foldr sub [] xs
  where 
   sub x 
    | wc == x   = (s++)
    | otherwise = (x:)

-- Tries to match two lists. If they match, the result consists of the sublist
-- bound to the wildcard in the pattern list.
match :: Eq a => a -> [a] -> [a] -> Maybe [a]
match _ [] [] = Just [] 
match _ [] _ = Nothing
match _ _ [] = Nothing
match wc (p:ps) (y:ys)
  | (p:ps) == [wc] = Just (y:ys)
  | p == y         = match wc ps ys
  | p == wc        = singleWildcardMatch (p:ps) (y:ys) `orElse` longerWildcardMatch (p:ps) (y:ys)
  | otherwise      = Nothing 
   where
    singleWildcardMatch (p:ps) (x:xs)
      | (match wc ps xs) /= Nothing = Just [x]
      | otherwise = Nothing
    longerWildcardMatch pls (xl:xls) = mmap ([xl]++) (match wc pls xls)
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
transformationApply :: Eq a => a -> ([a] -> [a]) -> ([a], [a]) -> [a]  -> Maybe [a]
transformationApply wc f (w, t) = mmap helper . match wc w
  where
    helper = substitute wc t . f

-- Applying a list of patterns until one succeeds
transformationsApply :: Eq a => a -> ([a] -> [a]) -> [([a], [a])] -> [a] -> Maybe [a]
transformationsApply wc f ((w, t):wts) xs = transformationApply wc f (w,t) xs `orElse` transformationsApply wc f wts xs
transformationsApply _ _ _ _ = Nothing

fetLista = [("My name is *", "Je m'appelle *"), ("Jag äter *", "Je mange *")]
tranz = transformationsApply  '*' id fetLista "Jag äter petit pain" 

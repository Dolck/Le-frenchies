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
  | (p:ps) == [wc] = Just (y:ys)
  | p == y         = match wc ps ys
  | p == wc        = orElse (singleWildcardMatch (p:ps) (y:ys)) (longerWildcardMatch (p:ps) (y:ys))
  | otherwise      = Nothing 
   where
    --singleWildcardMatch :: Eq a => [a] -> [a] -> Maybe [a]
    singleWildcardMatch (p:ps) (x:xs)
      | (match wc ps xs) /= Nothing = Just [x]
      | otherwise = Nothing
    longerWildcardMatch pls (xl:xls) = mmap ([xl]++) (match wc pls xls)
    longerWildcardMatch _ _ = Nothing

{- TO BE WRITTEN -}

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
transformationApply wc f xs (w, t) = helper $ match wc w $ xs 
  where
    helper (Just a) = Just $ substitute wc t $ f a
    helper Nothing = Nothing

-- Applying a list of patterns until one succeeds
transformationsApply :: Eq a => a -> ([a] -> [a]) -> [([a], [a])] -> [a] -> Maybe [a]
transformationsApply wc f ((w, t):wts) xs = transformationApply wc f xs (w,t)) `orElse` transformationsApply wc f wts xs
transformationsApply _ _ _ _ = Nothing

fetLista = [("My name is *", "Je m'appelle *"), ("Jag äter *", "Je mange *")]
tranz = transformationsApply  '*' id fetLista "Jag äter petit pain" 

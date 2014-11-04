import Data.List

--Author: Tim Dolck

--ex 1 find last element in list
myLast :: [a] -> a
myLast [] = error "Empty list"
myLast [x] = x
myLast (x:xs) = myLast xs

--ex 2 find second last element in list
lastButOne :: [a] -> a
lastButOne = last . init

--ex 3 find element at index
elementAt :: [a] -> Int -> a
elementAt (x:_) 1 = x
elementAt (x:xs) k = elementAt xs (k-1)
elementAt [] _ = error "Empty list"

--ex 4 find length of list
myLength :: [a] -> Int
myLength [] = 0
myLength (x:xs) = 1 + myLength xs

--ex 5 reverse list
myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x:xs) = myReverse xs ++ [x]

--ex 6 check if list is palindrome
isPalindrome :: Eq(a) => [a] -> Bool
isPalindrome [] = True
isPalindrome [_] = True
isPalindrome xs = (head xs) == (last xs) && isPalindrome(init (tail xs))

--ex 7 flatten nested list
data NestedList a = Elem a | List [NestedList a]
flatten :: NestedList a -> [a]
flatten (Elem x) = [x]
flatten (List []) = []
flatten (List (x:xs)) = flatten x ++ flatten (List xs)

--ex 8 compress list
compress :: Eq(a) => [a] -> [a]
compress xs
	| xs == [] = []
	| (tail xs == []) = xs
	| ((head xs) == (head (tail xs))) = compress (tail xs)
	| otherwise = [head xs] ++ compress (tail xs)

--ex 9 pack equal objects in list(from solutions...)
pack :: Eq a => [a] -> [[a]]
pack [] = []
pack (x:xs) = (x:first) : pack rest
         where
           getReps [] = ([], [])
           getReps (y:ys)
                   | y == x = let (f,r) = getReps ys in (y:f, r)
                   | otherwise = ([], (y:ys))
           (first,rest) = getReps xs


--ex 10 count following repetitions in list (yay last one in this file)
encode :: Eq a => [a] -> [(Int, a)]
encode [] = []
encode xs = zip len chr
	where
		len = map length (group xs)
		chr = compress xs
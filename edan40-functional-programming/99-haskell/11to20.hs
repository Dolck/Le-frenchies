--Author: Tim Dolck

import Data.List

--ex 11 modified encode. Example: "aaaab" -> [Multiple 4 'a',Single b]
data SingleOrTuple a = Single a | Multiple Int a
	deriving (Show)

modEncode :: Eq a => [a] -> [(SingleOrTuple a)]
modEncode [] = []
modEncode xs = map removeSingles (zip len chr)
	where
		len = map length (group xs)
		chr = map head (group xs)

removeSingles :: (Int, a) -> SingleOrTuple a
removeSingles (1,x) = Single x
removeSingles (n,x) = Multiple n x


--ex 12 decode modified encoding. Example [Multiple 4 'a',Single 'b'] --> "aaaab"
modDecode :: Eq a => [SingleOrTuple a] -> [a]
modDecode = concatMap helper
	where 
		helper (Single c) = [c]
		helper (Multiple n c) = (take n (repeat c))


--ex 13 same as ex11 but without explicity creating lists of all multiples
encodeDirect :: Eq a => [a] -> [(SingleOrTuple a)]
encodeDirect [] = []
encodeDirect xs
	| (length match) == 1 = Single (head xs) : encodeDirect (rest)
	| otherwise = Multiple (length match) (head xs) : encodeDirect(rest)
	where
		(match,rest) = span(==(head xs)) xs


--ex 14
dupli xs = concatMap (\(x,y)->[x,y]) (zip xs xs)

--even better solution:
dupli2 xs = concatMap (\x -> [x,x]) xs


--ex 15
repli xs n = concatMap (\x -> take n (repeat x)) xs


--ex 16
dropEvery :: [a] -> Int -> [a]
dropEvery xs n = dropHelp xs n 1
	where
		dropHelp :: [a] -> Int -> Int -> [a]
		dropHelp [] _ _ = []
		dropHelp (x:xs) n k
			|(k `mod` n) == 0 = dropHelp xs n (k+1)
			|otherwise = [x] ++ (dropHelp xs n (k+1))

--ex 17
split :: [a] -> Int -> ([a],[a])
split xs n
	| n >= (length xs) = (xs,[])
	| otherwise = splitHelp [] xs n
	where
		splitHelp :: [a] -> [a] -> Int -> ([a],[a])
		splitHelp x y n
			| n > len = splitHelp (x ++ [head y]) (tail y) n
			| n <= len = (x,y)
			where len = length x

--ex 18 slice
slice :: [a] -> Int -> Int -> [a]
slice [] _ _ = []
slice xs i j
	| i < 1 = slice xs 1 j
	| otherwise = fst (split (snd (split xs (i-1))) (j - i + 1))


--ex 19 rotate list
rotate :: [a] -> Int -> [a]
rotate [] _ = []
rotate xs 0 = xs
rotate (x:xs) n
	| n < 0 || n > (length xs) = rotate ([x]++xs) (n `mod` (length ([x] ++ xs)))
	| otherwise = rotate (xs ++ [x]) (n-1)

--ex 20 Remove kth element (Yay last one in this file!)
removeAt [] _ = []
removeAt (x:xs) 1 = xs
removeAt (x:xs) n = [x] ++ (removeAt xs (n-1))

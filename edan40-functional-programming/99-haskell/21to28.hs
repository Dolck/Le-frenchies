--Author: Tim Dolck

import System.Random(randomRIO)
import Data.List

--ex 21 insertAt element at given position
insertAt :: a -> [a] -> Int -> [a]
insertAt element [] _ = [element]
insertAt element xs 1 = element:xs
insertAt element (x:xs) n = x:insertAt element xs (n-1)

--ex 22 range i j
range i j
	| i == j = [i]
	| i < j = i:range (i+1) j
	| i > j = i:range (i-1) j

--ex 23
 
rnd_select :: [a] -> Int -> IO [a]
rnd_select _  0 = return []
rnd_select [] _ = return []
rnd_select xs count = do r <- randomRIO (0, (length xs)-1)
                         rest <- rnd_select (removeAt xs (r+1)) (count-1)
                         return ((xs!!r) : rest)

removeAt [] _ = []
removeAt (x:xs) 1 = xs
removeAt (x:xs) n = [x] ++ (removeAt xs (n-1))

--ex 24
lotto :: Int -> Int -> IO [Int]
lotto n m = rnd_select ([1..m]) n

--ex 25 random permutation
rnd_permu :: [a] -> IO [a]
rnd_permu xs = rnd_select xs (length xs)

--ex 26 combinations
combinations :: Int -> [a] -> [[a]]
combinations 0 _ = [[]]
combinations _ [] = []
combinations k (x:xs) = (map (x:) (combinations (k-1) xs)) ++ (combinations k xs)

--ex 27 group combinations

--Todo...


--ex 28 sort list by sublist length
--a)
lsort :: [[a]] -> [[a]]
lsort [] = []
lsort (x:xs) = smallerSorted ++ [x] ++ biggerSorted
	where
		smallerSorted = lsort (filter (\y -> length y <= length x) xs) 
		biggerSorted = lsort (filter (\y -> length y > length x) xs)

--b)
lsortfreq :: [[a]] -> [[a]]
lsortfreq lst = concat (lsort (groupBy (\i j -> length i == length j) (lsort lst)))

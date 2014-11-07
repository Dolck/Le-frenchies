--Author: Tim Dolck

import Data.List

--ex 31 determine if a number is a prime
isPrime :: Int -> Bool
isPrime n
	| n < 4 && n > 1 = True
	| even n = False
	| otherwise =  not (or (map (\i -> n `mod` i == 0) [3,5..(n-1)]))

--ex 32 GCD
myGCD :: Integer -> Integer -> Integer
myGCD a 0 = a
myGCD a b = myGCD b (a `mod` b)

--ex 33 coprime
coprime :: Integer -> Integer -> Bool
coprime a b = (myGCD a b) == 1

--ex 34 totient phi
totient :: Integer -> Integer
totient a = totHelp a (a-1)
	where
		totHelp :: Integer -> Integer -> Integer
		totHelp _ 0 = 0
		totHelp x y
			| coprime x y = 1 + (totHelp x (y-1))
			| otherwise = totHelp x (y-1)

--ex 35 prime factors
primeFactors ::  Fractional a => Integer -> [Integer]
primeFactors i = factorHelp i 2
	where
		factorHelp :: Fractional b => Integer -> Integer -> [Integer]
		factorHelp 1 _ = []
		factorHelp j k
			| j `mod` k == 0 = [k] ++ (factorHelp (j `div` k) k)
			| otherwise = factorHelp j $ k+1


--ex 36 compress primeFactors
compressPF :: Fractional a => Integer -> [(Integer, Integer)]
compressPF n = zip (compress xs) (map toInteger (map length (group xs)))
	where xs = primeFactors n

compress :: Eq(a) => [a] -> [a]
compress xs
	| xs == [] = []
	| (tail xs == []) = xs
	| ((head xs) == (head (tail xs))) = compress (tail xs)
	| otherwise = [head xs] ++ compress (tail xs)


--ex 37 totient phi improve
totImprove :: Fractional a => Integer -> Integer
totImprove n = product (map toti (compressPF n))
	where 
		toti :: (Integer, Integer) -> Integer
		toti t = ((fst t) - 1)*(fst t) ^ ((snd t) - 1)

--ex 39 primes range
primesR :: Int -> Int -> [Int]
primesR a b
	| a > b = []
	| a < 3 = a : primesR (a+1) b
	| a `mod` 2 == 0 = primesR (a+1) b
	| isPrime a = a : primesR (a+2) b
	| otherwise = primesR (a+1) b

--ex 40 goldbach
goldbach :: Int -> (Int,Int)
goldbach n = head [(a,b) | a <- prim, b <- prim, a+b==n]
	where prim = primesR 2 (n-2)

--ex41 to be done




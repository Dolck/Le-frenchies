1:

Q: write a definition of scanr using first recursion and then foldr

A: 

> scanr' :: (a -> b -> b) -> b -> [a] -> [b]
> scanr' f acc [] = [acc]
> scanr' f acc xs = (scanr' f (f (last xs) acc) (init xs)) ++ [acc]

> scanr'' f acc xs = foldr func [acc] xs
>	where func x xs = [f x (head xs)] ++ xs

> scanl' f acc [] = [acc]
> scanl' f acc (x:xs) = acc : (scanl' f (f x acc) xs)

> reverse' = foldl (flip (:)) []


2:

Q: Explain the subclass relation between type classes in Haskell.
Give an example as well

A: (strict) Inheritance from the derived type. 

class Eq a where
  (==), (/=)           :: a -> a -> Bool

class (Eq a) => Ord a where
  (<), (<=), (>=), (>) :: a -> a -> Bool 
  max, min             :: a -> a -> a

where all instances of Ord a has (==) and (/=) defined


3:

twoC f = f.f

plusC twoC twoC f = (twoC f).(twoC f)
=>
Substitute twoC f with f.f =>
(f.f).(f.f) = f.(f.f.f) = f.(threeC) = succ threeC f = fourC


4:

a)
f :: (Num a, Monad m) => m a -> m a -> m a

b)
f [1,2,3] [2,4,8] = [2,4,8,4,8,16,6,12,24]

c)
Nothing

d)
Yes

e)
return 5 :: (Monad m, Num a) => m a


5:

-- seq: SUGGESTS evaluation of its first arg (up to WHNF), returns the second
-- pseq: FORCES evaluation of the first arg first, then returns the second
-- par: like SEQ, but evaluation of the first arg may be done in PARALLEL with returning the second

par2: no real effect. 

par3: forces evaluation of lesser first but still no real effect

par4: evaluates lesser and greater in parallel


6:

(Ish)

lineToList2 ((n :+: ns) :+: nss) = lineToList2 (n ++ ns ++ nss)
lineToList2 n :+: ns = n : lineToList2 ns
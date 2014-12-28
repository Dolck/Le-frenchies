Exam 2011-12-19

1. 
(++) :: [a]  -> [a] -> [a]
const :: a -> b -> a
map :: (a -> b) -> [a] -> [b]

a) 	const (++) :: b -> [a] -> [a] -> [a]
		map (const (++)) :: [a] -> [[b] -> [b] -> [b]]

b) 	map (++) :: [[a]] -> [[a] -> [a]]
		const (map (++)) :: b -> [[a]] -> [[a] -> [a]]


2.
		curry takes a uncurried function and converts it to a curried
		uncurry takes a curried function and converts it to a uncurried

		curry f x y = f (x,y)
		uncurry f (x,y) = f x y


3.

a)	"currycurrycurrycurry"
		type = String or [Char]

b)	["uncurry","uncurry","uncurry","uncurry"]
		type = [String] or [[Char]]

Taken from answers:

-- A possible explanation:

-- do [1, 2, 3, 4]; return "uncurry"
-- is equivalent to
-- [1, 2, 3, 4] >> return "uncurry"
-- or to
-- [1, 2, 3, 4] >>= \_ -> return "uncurry"
-- As the type of bind is
-- (>>=) :: m a -> (a -> m b) -> m b
-- and of return is
-- return :: a -> m a
-- and as the first argument of bind is [1, 2, 3, 4] then the monad in our case must be the List monad.
-- Therefore
-- return x = [x]
-- (>>=) xs f = concat (map f xs)
-- and thus for our values we get
-- concat (map (const ["uncurry"]) [1, 2, 3, 4])


4.

foldl :: (a -> b -> a) -> a -> [b] -> a
flip :: (a -> b -> c) -> b -> a -> c
(.) :: (b -> c) -> (a -> b) -> a -> c

c :: Eq a => [a] -> [a] -> [a]

>c a = (a \\) . (a \\)

where

>(\\) :: Eq a => [a] -> [a] -> [a]
>(\\) = foldl (flip delete)

and

--delete deletes first occurance of x in a list

>delete :: Eq a => a -> [a] -> [a]
>delete x [] = []
>delete x (y:ys)
>	| x == y = ys
>	| otherwise = y:(delete x ys)

flip delete :: Eq a => [a] -> a -> [a]




c takes two lists and returns a list of all overlapping items


5.

f x y = (5 + x) / y
f x y = (/) (5 + x) y
f x 	= (/) (5 + x)
f x 	= (/) (5 + x)

>f 		= (/) . (5+)

g x y = x y

>g 		= id


6.

>data Tree = Leaf Integer | Node Integer Tree Tree

Return true if t1 is a subtree of t2

>subTree :: Tree -> Tree -> Bool
>subTree (Leaf x) (Leaf y) = x == y
>subTree (Leaf x) (Node y yt1 yt2) = (x == y) || (subTree (Leaf x) yt1) || (subTree (Leaf x) yt2)
>subTree (Node _ _ _) (Leaf _) = False
>subTree (Node x xt1 xt2) (Node y yt1 yt2) = ((x == y) && (subTree xt1 yt1) && (subTree xt2 yt2)) || subTree (Node x xt1 xt2) yt1 || subTree (Node x xt1 xt2) yt2
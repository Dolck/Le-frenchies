Exam 2012-12-17

1.
Q: Rewrite into point-free form.

> f x y = 3 + y / x
> g x y = [ y z | z <- [1..x]]

A:

> f' = curry $ ((+) 3) . (uncurry $ flip (/))

> g' x y = map y $ takeWhile ((>=) x) [1..]
> g'' = flip map . (flip takeWhile [1..]) . (>=)


2.
Q: Give the types:
a) (.)(:)
b) (:(.))
c) ((.):)
d) ((:):)
e) (.)(.)

A:

(.) :: (b -> c) -> (a -> b) -> a -> c
(:) :: a -> [a] -> [a]

a) (.)(:) :: (a -> b) -> a -> [b] -> [b]
b) (:(.)) :: ?????
c) ((.):) :: [(b -> c) -> (a -> b) -> a -> c] -> [(b -> c) -> (a -> b) -> a -> c]
d) ((:):) :: [a -> [a] -> [a]] -> [a -> [a] -> [a]]
e) (.)(.) :: ?????


3.

Q: Eplain the concept of a spark in Haskell. How does it 
relate to seq, pseq and par?
seq, pseq, par :: a -> b -> b

A: A spark is a haskell thread. It may not be an actual thread 
in the OS if its not explicity stated to be.

From the soltions:
-- seq: SUGGESTS evaluation of its first arg (up to WHNF), returns the second
-- pseq: FORCES evaluation of the first arg first, then returns the second
-- par: like SEQ, but evaluation of the first arg may be done in PARALLEL with returning the second


4.

Q: Assuming m is a monadic object, show how fmap f m can be 
implemented with a do expression. Then rewrite using bind.

A:

fm :: Functor f => (a -> b) -> f a -> f b

> fm f m = do x <- m 
>             return (f x)

rewritten using bind:

> fm' f m = m >>= \x -> return (f x)


5:

Q: Are the following two expressions equivalent?

> h = [ (x,y) | x <- [1..10000], x == 2000, y <- [1..100], odd y]
> h' = [ (x,y) | x <- [1..10000], y <- [1..100], x == 2000, odd y]

A: Their result are equivalent. The actual computations might not 
	be equivalent?


6:

Q: Implement a data type Tree and a predicate subTree 

A:

> data Tree = Leaf String | Node String Tree Tree
> t1 = Node "one" (Leaf "two") t2
> t2 = Leaf "three"
> t3 = Node "over" t1 t2

> subTree :: Tree -> Tree -> Bool
> subTree (Node _ _ _) (Leaf _) = False
> subTree (Leaf str1) (Leaf str2) = str1 == str2
> subTree t1@(Leaf str1) (Node str2 t21 t22)
> 	| str1 == str2 = True
> 	| otherwise = (||) (subTree t1 t21) $ subTree t1 t22
> subTree t1@(Node str1 t11 t12) (Node str2 t21 t22)
>	| str1 == str2 && ((&&) (subTree t11 t21) $ subTree t12 t22) = True
> 	| otherwise = (||) (subTree t1 t21) $ subTree t1 t22
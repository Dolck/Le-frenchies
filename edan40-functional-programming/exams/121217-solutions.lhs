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


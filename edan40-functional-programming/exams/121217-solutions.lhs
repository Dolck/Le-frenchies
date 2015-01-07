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
1.

>f = flip $ curry $ (+3).(uncurry (/))

>g x y = [ y z | z <- [1..x]]
>g' x = flip map [1..x]
>g'' = flip map . flip take lis
>   where lis = iterate (+1) 1

2.
(.) :: (b -> c) -> (a -> b) -> a -> c
(:) :: a -> [a] -> [a]

a)
(.)(:) :: (a -> b) -> a -> [b] -> [b]
b)
(:(.)) :: not possible
c)
((.):) :: [(b -> c) -> (a -> b) -> a -> c] -> [(b -> c) -> (a -> b) -> a -> c]
d)
((:):) :: [a -> [a] -> [a]] -> [a -> [a] -> [a]]
e)
(.)(.) :: (x -> b -> c) -> x -> (a -> b) -> a -> c

3.

4.

>fmap' func m = do
>           x <- m
>           return $ func x

>fmap'' func m = m >>= \x -> return $ func x








1.

>scanr' :: (a -> b -> b) -> b -> [a] -> [b]
>scanr' _ a [] = [a]
>scanr' f a xs = scanr' f acc (init xs) ++ [a]
> where acc = f (last xs) a

>scanr2' f acc xs = foldr g [acc] xs
> where g a b = f a (head b) : b

>scanl' :: (b -> a -> b) -> b -> [a] -> [b]
>scanl' _ a [] = [a]
>scanl' f a (x:xs) = a : scanl' f acc xs
> where acc = f a x

>scanl2' f acc xs = foldl g [acc] xs
> where g a b = a ++ [f (last a) b]

>reverse' :: [a] -> [a]
>reverse' = foldl (flip (:)) []

2.

Some classes are dependent on other classes beeing previously defined, such as class (Eq a) => Ord a

3.

twoC `plusC` twoC = four:

twoC f `plusC` twoC f f =
plusC f.f f.f f =
(f.f).(f.f) =
(f.f).(twoC f) =
f.(f.(twoC f)) =
f.(succC twoC f) =
f.(threeC f) =
succC threeC f =
fourC f

4.

>f :: (Monad m, Num a) => m a -> m a -> m a
>f x y = do
>       a <- x
>       b <- y
>       return (a*b)

f [1,2,3] [2,4,8] = [2,4,8,4,8,16,6,12,24]
f Just 5 Nothing = Nothing

return 5 :: (Monad m, Num a) => m a

>f' x y = x >>= \a -> y >>= \b -> return (a*b)

5.

ja

6.

(Note (C,5) dur [] :+: Note (D,5) dur [] :+: (Note (E,5) dur [] :+: Rest 0))
(Note (C,5) dur [] :+: (Note (D,5) dur [] :+: (Note (E,5) dur [] :+: Rest 0)))


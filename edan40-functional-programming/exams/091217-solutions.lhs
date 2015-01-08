Exam 2009-12-17

1. 

Q: Rewrite the following definition so that only the function name appears to the
left hand side of the equation and that the right hand side is not a lambda expression:

> f x = (5 - x) / 3

Do the same thing for the following definition:

> g x y = (5 - x) / y

A:

> f' = (flip (/) 3) . (5-)

> g' = (/) . (5-)


2.

Q: Given the following function:

> f2 x y = do
>	a <- x
>	b <- y
>	return (a * b)

a) What is the type of f?
b) What is the value of f [1,2,3] [2,4,8] ?
c) What is the value of f (Just 5) Nothing ?

A:

a)
f2 :: (Num b, Monad m) => m a -> m a -> m a

b)
[2,4,8,4,8,16,6,12,24]

c)
Nothing



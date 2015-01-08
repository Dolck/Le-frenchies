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


3.

Q: 3. Haskell defines functions in so called curried form. Explain what that means and
what its main advantage is.

A: In haskell every function only takes one argument. 
In a function that looks like it takes more than one argument there is actually several functions where functions
are passed between as output/argument. example map :: (a -> b) -> [a] -> [b]. where (a -> b) -> [a] is one function which is
then used as input to the last function that returns [b].

In real world it is benefitial to use curried functions when you want to partially apply functions.
Example:

> q = (1+)

> p = map q [1,2,3]

where 1 is partially applied to (+). This returns a function that increases the input by 1.


4.

Q: The standard prelude contains the function

replicate' :: (Enum a) => Int -> a -> [a]

The following might seem like reasonable definition for it

> replicate' n x = take n [x,x..]

But it is actually not sufficient. Why not?

A: x must be enumerable!

better solution:

> replicate'' n x = take n $ repeat x


5.

Q: Give the types of these three expressions. Also explain what each of the expressions mean.
zipWith map
map zipWith
map.zipWith

A:

zipWith :: (a->b->c) -> [a]->[b]->[c]
map :: (a -> b) -> [a] -> [b] 

zipWith map :: [(a -> b)] -> [[a]] -> [[b]]
takes a list of functions which is applied to every [a] in [[a]] respectivly

map zipWith :: [(a -> b -> c)] -> [[a] -> [b] -> [c]]
Exam 2010-12-16

1.

Q: 1. 
a) Rewrite the defintions below so that only the name of the function appears on the left
hand side of the equation and without using a lambda expression.

> f' x = 5 + 8 / x

b) Do the same thing for the following definition

> g x y = 3 * y + x

A:

a)

> f'' = (5+) . (8/)

b)

> g' = flip ((+) . (*) 3)


2.

Q:  Rewrite the following expression to use higher order functions from the standard prelude
instead of list comprehensions.

> h f ys = [ f x | x <- [ y+4 | y <-ys, y<5]]

A:

> h' f ys = map f $ map (4+) $ filter (<5) ys

or even nicer:

> h'' f ys = map (f . (4+)) $ filter (<5) ys


3.

Q: There is an error in the following definitions

> data Digits = Zero | One | Two | Three | Four | Six | Seven | Eight | Nine  deriving (Enum, Show)

> smallDigits = [Zero .. Three]

Explain what the problem is and suggest a way to fix it.

A: When using [x..y] the datatype must be enumerable to be able to "know" in which order the elements are defined
Solution: Add deriving Enum to the definition. 


4.

Q: Haskell is a pure functional language. Explain what that means and what the consequences
of this property are.

A: A pure functional language have no side effects. i.e any function with a specific input must always
return the same output. In haskell side effects can be added using monads. That will "encapsulate"
the side effects.

In a pure functional haskell you can't (by definition) do anything with sideeffects.

A functional programming language treats all computations as functions


5. 

Q: What is the type and the value of the following expression:

> mchr = do "merry"; return "christmas"

A:

mc :: [String]

output: ["christmas","christmas","christmas","christmas","christmas"]


6.

Q: Give the types for the following operator expressions:
a) (.)(:)
b) (:(.))
c) ((.):)
d) ((:):)

A:

(.) :: (b -> c) -> (a -> b) -> a -> c
(:) :: a -> [a] -> [a]

(.)(:) :: (a -> b) -> a -> [b] -> [b]
(:(.)) :: not valid
((.):) :: [(b -> c) -> (a -> b) -> a -> c] -> [(b -> c) -> (a -> b) -> a -> c]
((:):) :: [a -> [a] -> [a]] -> [a -> [a] -> [a]]

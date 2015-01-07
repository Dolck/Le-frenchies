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
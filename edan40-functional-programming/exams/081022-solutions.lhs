Exam 081022

> import Data.List

1.

Q: Explain what the following expression means:

> n = map (:) 
> n1 = n [1,2,3]

A:

n :: [a] -> [[a] -> [a]]


2.

Q: What is the type and the value of the following expression:

> hw = do "hello"; return "world"

A:
hw :: [String]/[[Char]]
["world","world","world","world","world"]


3:

Q: Functional programming is said to be free of side effects. Explain 
what that means and in what ways it is significant. 

A: Something about functions only depend on the input parameters and that 
they always have the same return value given equal input. 

More bugfree code and mathematicly provable code


4: 

Q: Define a function which has the type:
[(a,b) -> c] -> [a -> b -> c] 

A: 

> lcurry :: [(a,b) -> c] -> [a -> b -> c]
> lcurry = map curry


5:

Q: What does the following function compute?

> g [] = [[]]
> g xs = concat [map (x:) (g (xs \\ [x])) | x <- xs]

where

(\\) :: Eq a => [a] -> [a]-> [a]
(\\) = foldl (flip delete) 

A: Gives all permutations of a list


6:

Q: Give an alternative but equivalent defintion to the prelude function

> filter' :: (a -> Bool) -> [a] -> [a]

in terms of the function foldr so that the definition is on the form:

> filter' p = foldr (\x xs -> if p x then x:xs else xs) []

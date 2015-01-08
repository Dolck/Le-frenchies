1. What is the type of the expression

(++) :: [a] -> [a] -> [a] 
const :: a -> b -> a 
map :: (a -> b) -> [a] -> [b] 

a) map (const (++))
const (++) :: (b) -> ([a] -> [a] -> [a])
map (const (++)) :: [b] -> [[a] -> [a] -> [a]]

b) const (map (++))
map (++) :: [[a]] -> [[a] -> [a]]
const (map (++)) ::b -> [[a]] -> [[a] -> [a]]

2. 
Currying, takes a function that takes a pair, and transforms it so it takes two values instead.
curry :: ((a,b) -> c) -> a -> b -> c
Uncurrying, opposite of currying, takes a function that takes two values, and transforms it so that it takes a pair instead.
uncurry :: (a -> b -> c) -> (a,b) -> c

3. What is the type and value of the expression:
a) do [1, 2, 3, 4]; "curry"
writes "curry" for each object in list, but does not "end" the object inbetween.
do [1,2,3,4]; "curry" :: String
"currycurrycurrycurry"
b) do [1, 2, 3, 4]; return "uncurry"
writes "uncurry" for each objedct in list, "ends" each object with return.
return x = [x]
do [1,2,3,4] ; return "uncurry" :: [String]
["uncurry","uncurry","uncurry","uncurry"]






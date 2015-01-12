Typical subjects
================

1. Point-freeing of simple function
2. Type derivation, define types of function
3. Description, describe keywords
4. Algebraic data types
5. Monadic computation, list and maybe, usage of bind
6. Usage of prelude

(Q&)A
====

1.
map (const (++))
const (map (++))
----------------  
```
(++) :: [a] -> [a] -> [a]
const :: c -> b -> c
const (++) :: b -> [a] -> [a] -> [a]
map :: (d -> e) -> [d] -> [e]
map (const (++)) :: [b] -> [[a] -> [a] -> [a]]
map (++) :: [[a]] -> [[a] -> [a]]
const (map (++)) :: b -> [[a]] -> [[a] -> [a]]
```
Start from the innermost function, and work yourself outwards...

2.
```
do [1,2,3,4]; "curry"         -> [Char]
do [1,2,3,4]; return "curry"  -> [[Char]]
>>= :: m a -> (a -> m b) -> m b
>>= <=> concatMap
```
3.
```
type churchNatural a = (a -> a) -> (a -> a)
zeroC, oneC, twoZ :: churchNatural a
zeroC f = id
oneC f = f
twoC f = f . f
succC n f = f . (n f)
plusC x y f = (x f) . (y f)

twoC `plusC` twoC ==>
plucC twoC twoC   ==>
(twoC f).(twoC f) ==>
(f.f).(twoC f)    ==>
f.(f.(twoC f))    ==>
f.(succC twoC f)  ==>
f.(threeC f)      ==>
succC threeC f    ==>
fourC f
```

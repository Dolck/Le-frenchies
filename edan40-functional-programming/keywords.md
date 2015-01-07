# Keywords

* **Higher order functions** - A function that either takes a function as argument, or outputs a function.
* **Function vs operator**
  * **Function** - add 1 2
  * **Operator** - 1 ´add´ 2
* **Curried functions** - *f a b* is to be read *((f a) b)* and is different from *f (a, b)* Functions always take only one argument!
* **Function composition** - doublePlusOne = (+1).(2*)
* **Lambda expressions** - incAll = map (\i->i+1)
* **Patterns** - 
```
    count :: Int -> String
    count 1 = "one"
    count 2 = "two"
    count _ = "many"
```
* **Guards** - 
```
    oddOrEven :: Int -> String
    oddOrEven i
        | odd i = "odd"
        | even i = "even"
        | otherwise = "strange"
```
* **Local definitions** - functions that can only be used loacally (within function), use with "where" or "let-in".
* **Indentation** - denotes continuation
* **Polymorphic types** - The type of *(.)* is *(b -> c) -> (a -> b) -> a -> c*... (f.g) x = f (g x) 
* **Type variables begin with a lowercase letter**
* **Tuples** - Fixed number of elements, may be of different types. *(4,"four") :: (Int, String)*. Triples, quadruples, etc. analogously
* **Lists** - Arbitrary number of elements of the same type *[1,2,3,4], [1..10], [1,3..10], [2..] :: [Int]*
* **Strings** - A list of chars, *String = [Char]*
* **List comprehensions** - allIntPairs = [ (i,j) | i<-[0..], j<-[0..i]]
* **Type synonyms** - type Name = String
* **Enumerated types** - data Color = Red | Green | Blue | Yellow | Black | White
* **Algebraic datatypes** - data Price = Euro Int Int | Dollar Int Int
* **Recursive type definitions** - data IntTree = IntEmpty | IntNode Int IntTree IntTree
* **Type classes** - Somewhat like Java interfaces
* **Input/Output** - The abstract datatype IO a of I/O actions. putChar :: char -> IO ()
* **Do-notation** - 
```
    greeting :: IO ()
    greeting = do
        putStrLn "Enter your name"
        name <- getLine
        putStrLn ("You " ++ name ++ ", me Haskell!")
```
* 

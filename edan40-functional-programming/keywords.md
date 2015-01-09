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
* **Qualified types** - elem :: (Eq a) => a -> [a] -> Bool. Qualification needed here to ensure that equality test is defined.
* **Recursive type definitions** - data IntTree = IntEmpty | IntNode Int IntTree IntTree
* **Classes and instances** - Haskell types ⇔ Java classes, Haskell class ⇔ Java interface. Java: A class implements an interface, Haskell: A type is an instance of a class. Java: An object is an instance of a class, Haskell: An expression has a type. ex:
```
    class Functor f where
        fmap :: (a -> b) -> f a -> f 
    instance Functor [] where
        fmap = map
```
* **Input/Output** - The abstract datatype IO a of I/O actions. putChar :: char -> IO ()
* **Do-notation** - 
```
    greeting :: IO ()
    greeting = do
        putStrLn "Enter your name"
        name <- getLine
        putStrLn ("You " ++ name ++ ", me Haskell!")
```
* **Modules** - Each Haskell program is a collection of modules. Module is an organizational unit, controlling the name space. One module must be called Main and must export value main.
* **Entity export and import** - A module declares which entities (values, types and classes) it exports (implicitely all). import expression makes exported entities available in another module.
* **Module prelude** - Standard Prelude is a module available in every language implementation and implicitely imported always into all modules (unless there is an explicit import!)
* **Enumerated types** - enumFrom [n..], enumFromThen [m,n..], enumFromThenTo [m,n..o], enumFromTo [m..n]
* **Unit** - the empty tuple, aka ()
* **Sequencing IO** - The type constructor IO is an instance of the Monad class. There are two monadic binding functions used to sequence operations. >> is used when the result of the first operation is uninteresting (e.g. is ()). >>= passes the result of the first operation as an argument to the second. Do-notation: syntactic sugar for bind (>>=) and then (>>)
* **Deriving** - How does deriving work? Answer: “naturally” or “magically”. From Prelude only Eq, Ord, Enum, Bounded, Show and Read can be derived.
* **Type class Monad** - 
```
    class Monad m where
        (>>=) :: m a -> (a -> m b) -> m b
        (>>) :: m a -> m b -> m b
        return :: a -> m a
        fail :: String -> m a
        m >> k = m >>= \_ -> k
        fail s = error s
```
* **Requirement on monadic types** - All instances of Monad should obey the following laws:
```
    return a >>= k = k a
    m >>= return = m
    m >>= (\x -> k x >>= h) = (m >>= k) >>= h
```
* **READ SLIDES ABOUT MONADS!**
* **Strict vs non-strict**- If something evaluates to bottom (an error or endless loop), then strict languages will always find the bottom value, non-strict languages not need to!
* **Laziness** - Evaluate an expression only when its value is needed. Common implementation technique for non-strict languages. Not generally amenable to parallelisation
* **Lenient evaluation** - Alternative to lazy, somewhere between lazy and strict — more promising for parallelisation.
* **Normal form** - An expression in normal form is fully evaluated, and no sub-expression could be evaluated any further (i.e. it contains no un-evaluated thunks).
* ** Weak Head Normal form** - An expression in weak head normal form has been evaluated to the outermost data constructor or lambda abstraction (the head). Sub-expressions may or may not have been evaluated. Therefore, every normal form expression is also in weak head normal form, though the opposite does not hold in general. To determine whether an expression is in weak head normal form, we only have to look at the outermost part of the expression. If it's a data constructor or a lambda, it's in weak head normal form. If it's a function application, it's not.
* **Consequences of laziness** 
  * *Space leaks* - foldl (+) 0 (1:2:3:[]) =  (((0 + 1) + 2) + 3), thunks stored until evaluation. Force evaluation using seq
  * *Short-circuiting*
```
    (&&) :: Bool -> Bool -> Bool
    True && x = x
    False && _ = False
```
  * infinite data structures
  * efficient pipelining
  * dynamic programming “for free” (Assignment 3)
* **Categories** - A category C consists of 
  1. a class ob(C) of objects
  2. a class hom(C) of morphisms (also called arrows or maps). Each morphism f has a unique source object a and a target object b. The expression f : a -> b is read "f is a morphism from a to b". hom(a,b) denotes the class of all morphisms from a to b.
  3. a binary operator o, called compositions of morphisms such that
   * **Associativity** - if f:a->b, g:b->c, h:c->d, then h o (g o f) = (h o g) o f and
   * **Identity** - for every object x there exists a morphism 1x:x->x called the identity morphism of x, such that for every morphism f:a->b we have 1b o f = f = f o 1a
* **Functor** - The Functor class is defined like this:
```
    class Functor f where
        fmap :: (a -> b) -> f a -> f b
```
  Functors are structure-preserving maps between categories

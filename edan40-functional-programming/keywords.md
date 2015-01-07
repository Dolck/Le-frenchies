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
* **Local definitions** - functions that can only be used loacally (within function), use with "where".
* 

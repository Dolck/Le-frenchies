module Chatterbot where
import Utilities
import Pattern
import System.Random
import Data.Char

chatterbot :: String -> [(String, [String])] -> IO ()
chatterbot botName botRules = do
    putStrLn ("\n\nHi! I am " ++ botName ++ ". How are you?")
    botloop
  where
    brain = rulesCompile botRules
    botloop = do
      putStr "\n: "
      question <- getLine
      answer <- stateOfMind brain
      putStrLn (botName ++ ": " ++ (present . answer . prepare) question)
      if (not . endOfDialog) question then botloop else return ()

--------------------------------------------------------

type Phrase = [String]
type PhrasePair = (Phrase, Phrase)
type BotBrain = [(Phrase, [Phrase])]


--------------------------------------------------------

--stateOfMind :: BotBrain -> IO (Phrase -> Phrase)
--stateOfMind _ = return id

stateOfMind :: BotBrain -> IO (Phrase -> Phrase)
stateOfMind bb = do 
                    q <- randomIO :: IO Float
                    return $ rulesApply $ randPairs q bb

randPairs :: Float -> BotBrain -> [PhrasePair]
randPairs r = map (\n -> (fst n, pick r (snd n)))

--pickRandomPairs :: BotBrain -> IO (Phrase -> Phrase)
pickRandomPairs x i = do 
  return $ maybe (\i -> lookup i $ map hax x) i
  where 
    hax (x, y) = (x, pck y)

pck xs = 
  randomRIO (0, length xs - 1) >>=
  return . (xs !!)

rollDice :: IO Integer 
rollDice = do
   r <- randomIO :: IO Float
   return $ floor (6*r+1)
  
rulesApply :: [PhrasePair] -> Phrase -> Phrase
rulesApply pairs = try $ transformationsApply "*" id pairs 
reflect :: Phrase -> Phrase
reflect []     = []
reflect (x:xs) = sub reflections : reflect(xs)
  where 
    sub [] = x
    sub (y:ys)
      | fst y == x = snd y
      | otherwise  = sub ys

reflections =
  [ ("am",     "are"),
    ("was",    "were"),
    ("i",      "you"),
    ("i'm",    "you are"),
    ("i'd",    "you would"),
    ("i've",   "you have"),
    ("i'll",   "you will"),
    ("my",     "your"),
    ("me",     "you"),
    ("are",    "am"),
    ("you're", "i am"),
    ("you've", "i have"),
    ("you'll", "i will"),
    ("your",   "my"),
    ("yours",  "mine"),
    ("you",    "me")
  ]

---------------------------------------------------------------------------------

endOfDialog :: String -> Bool
endOfDialog = (=="quit") . map toLower

present :: Phrase -> String
present = unwords

prepare :: String -> Phrase
prepare = reduce . words . map toLower . filter (not . flip elem ".,:;!#%&|") 

rulesCompile :: [(String, [String])] -> BotBrain
rulesCompile xs = map (\(x,y) -> (prepare x, map(\i -> prepare i) y)) xs


--------------------------------------


reductions :: [PhrasePair]
reductions = (map.map2) (words, words)
  [ ( "please *", "*" ),
    ( "can you *", "*" ),
    ( "could you *", "*" ),
    ( "tell me if you are *", "are you *" ),
    ( "tell me who * is", "who is *" ),
    ( "tell me what * is", "what is *" ),
    ( "do you know who * is", "who is *" ),
    ( "do you know what * is", "what is *" ),
    ( "are you very *", "are you *" ),
    ( "i am very *", "i am *" ),
    ( "hi *", "hello *")
  ]

reduce :: Phrase -> Phrase
reduce = reductionsApply reductions

reductionsApply :: [PhrasePair] -> Phrase -> Phrase
{- TO BE WRITTEN -}
reductionsApply _ = id



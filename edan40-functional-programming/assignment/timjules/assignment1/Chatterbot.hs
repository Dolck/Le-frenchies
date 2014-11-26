module Chatterbot where
import Utilities
import Pattern
import System.Random
import Data.Char
import Data.Tuple

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

stateOfMind :: BotBrain -> IO (Phrase -> Phrase)
stateOfMind bb = do 
                    q <- randomIO :: IO Float
                    return . rulesApply $ map (map2 (id, pick q)) bb

--randPairs :: Float -> BotBrain -> [PhrasePair]
--randPairs r = map (\n -> (fst n, pick r (snd n)))

rulesApply :: [PhrasePair] -> Phrase -> Phrase
rulesApply = try . transformationsApply "*" reflect

reflect :: Phrase -> Phrase
reflect = map $ try $ flip lookup reflections

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
    ("you're", "i am"),
    ("you've", "i have"),
    ("you'll", "i will"),
    ("yours",  "mine")
  ]

---------------------------------------------------------------------------------

endOfDialog :: String -> Bool
endOfDialog = (=="quit") . map toLower

present :: Phrase -> String
present = unwords

prepare :: String -> Phrase
prepare = reduce . words . map toLower . filter (not . flip elem ".,:;!#%&|") 

rulesCompile :: [(String, [String])] -> BotBrain
rulesCompile = map $ map2 (prepare, map prepare)

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

reduce = reductionsApply reductions

reductionsApply :: [PhrasePair] -> Phrase -> Phrase
reductionsApply = fix . try . transformationsApply "*" id

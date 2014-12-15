module Statement(T, parse, toString, fromString, exec) where
import Prelude hiding (return, fail)
import Parser hiding (T)
import qualified Dictionary
import qualified Expr
type T = Statement
data Statement =
    Assignment String Expr.T |
    Skip |
    Begin [Statement] |
    If Expr.T Statement Statement |
    While Expr.T Statement |
    Read String |
    Write Expr.T
    deriving Show

assignment, skip, begin, ifStatement, while, readStatement, writeStatement :: Parser Statement
statement = assignment ! skip ! begin ! ifStatement ! while ! readStatement ! writeStatement

assignment = word #- accept ":=" # Expr.parse #- require ";" >-> buildAss
  where
    buildAss (v, e) = Assignment v e

skip = accept "skip" # require ";" >-> buildSkip
  where
    buildSkip _ = Skip

begin = accept "begin" -# iter statement #- require "end" >-> Begin

ifStatement = accept "if" -# Expr.parse # require "then" -# statement # require "else" -# statement >-> buildIf
  where
    buildIf ((ex, s1), s2) = If ex s1 s2

while = accept "while" -# Expr.parse # require "do" -#  statement >-> buildWhile
  where
    buildWhile (ex, s) = While ex s

readStatement = accept "read" -# word #- require ";" >-> buildRead
  where
    buildRead str = Read str

writeStatement = accept "write" -# Expr.parse #- require ";" >-> buildWrite
  where
    buildWrite ex = Write ex



exec :: [T] -> Dictionary.T String Integer -> [Integer] -> [Integer]
exec [] _ _ = []

exec (If cond thenStmts elseStmts: stmts) dict input = 
    if (Expr.value cond dict)>0 
    then exec (thenStmts: stmts) dict input
    else exec (elseStmts: stmts) dict input


exec (Assignment var ex : stmts) dict input = exec stmts (Dictionary.insert (var,exprVal) dict) input
  where
    exprVal = Expr.value ex dict

exec (Skip : stmts) dict input = exec stmts dict input

exec (Begin bgnStmts : stmts) dict input = exec (bgnStmts ++ stmts) dict input

exec (While ex s : stmts) dict input = exec [If ex (Begin (s : While ex s : stmts)) (Begin stmts)] dict input

exec (Read var : stmts) dict (i : input) = exec stmts (Dictionary.insert (var,i) dict) input

exec (Write ex : stmts) dict input = Expr.value ex dict : exec stmts dict input


instance Parse Statement where
  parse = statement
  toString (Assignment var ex) = var ++ " := " ++ Expr.toString ex ++ ";\n"
  toString (Skip) = "skip;\n"
  toString (Begin stmts) = "begin\n" ++ concatMap toString stmts ++ "end\n"
  toString (If ex s1 s2) = "if " ++ Expr.toString ex ++ " then \n" ++ toString s1 ++ "else\n" ++ toString s2
  toString (While ex s) = "while " ++ Expr.toString ex ++ " do\n" ++ toString s
  toString (Read var) = "read " ++ var ++ ";\n"
  toString (Write ex) = "write " ++ Expr.toString ex ++ ";\n"

module Statement(T, parse, toString, fromString, exec) where
import Prelude hiding (return, fail)
import Parser hiding (T)
import qualified Dictionary
import qualified Expr
type T = Statement
data Statement = Assignment String Expr.T 
                |Skip 
                |Begin [Statement] 
                |If Expr.T Statement Statement 
                |While Expr.T Statement 
                |Read String 
                |Write Expr.T deriving Show

assignment, begin, iif, while, read, write, skip :: Parser Statement
assignment  = word #- accept ":=" # Expr.parse #- require ";" >-> uncurry Assignment
begin       = accept "begin" -# iter parse #- require "end" >-> Begin
iif         = accept "if" -# Expr.parse #- require "then" # parse #- require "else" # parse >-> (uncurry . uncurry) If
while       = accept "while" -# Expr.parse #- require "do" # parse >-> uncurry While
read        = accept "read" -# word #- require ";" >-> Read
write       = accept "write" -# Expr.parse #- require ";" >-> Write
skip        = accept "skip" #- require ";" >-> buildSkip
buildSkip a = Skip

exec :: [T] -> Dictionary.T String Integer -> [Integer] -> [Integer]
exec [] _ _                                   = []
exec (If cond thenStmts elseStmts: stmts) dict input = 
                                                if (Expr.value cond dict)>0 
                                                then exec (thenStmts: stmts) dict input
                                                else exec (elseStmts: stmts) dict input
exec (Assignment name exp: stmts) dict input  = exec stmts (Dictionary.insert (name,Expr.value exp dict) dict) input
exec (Skip: stmts) dict input                 = exec stmts dict input
exec ((Begin mstmts): stmts) dict input       = exec (mstmts++stmts) dict input
exec (While cond stmt: stmts) dict input      = 
                                                if (Expr.value cond dict)>0
                                                then exec (stmt:(While cond stmt):stmts) dict input
                                                else exec stmts dict input
exec (Read name: stmts) dict (i:is)           = exec stmts (Dictionary.insert (name,i) dict) is
exec (Write exp: stmts) dict input            = (Expr.value exp dict): (exec stmts dict input)


shww :: Statement -> String
shww (Assignment name exp)        = name++" := "++(Expr.toString exp)++";\n"
shww (Skip)                       = "skip;\n"
shww (If cond thenStmt elseStmt)  = "if "++(Expr.toString cond)++" then\n"++(shww thenStmt)++"else\n"++(shww elseStmt)
shww (While cond stmt)            = "while "++(Expr.toString cond)++" do\n"++(shww stmt)
shww (Read name)                  = "read "++name++";\n"
shww (Write cond)                 = "write "++(Expr.toString cond)++";\n"
shww (Begin stmts)                = "begin\n"++(concatMap shww stmts)++"end\n"

instance Parse Statement where
  parse = skip ! assignment ! begin ! iif ! while ! Statement.read ! write
  toString = shww

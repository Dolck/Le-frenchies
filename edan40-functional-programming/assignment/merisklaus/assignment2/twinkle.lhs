\section{Encoding of Twinkle Twinkle}
\label{chick}

{\small\begin{verbatim} 

> module TwinkleTwinkle where
> import Haskore
> 
> -- note updaters for mappings
> fd d n = n d v
> vol  n = n   v
> v      = [Volume 100]
> lmap f l = line (map f l)
> 
> -- repeat something n times
> times  1    m = m
> times n m = m :+: (times (n - 1) m)
>
> -- Main Voice:
> v1  = v1a :+: v1b
> v2  = times 2 $ v2a 
> v1a = lmap vol [c 5 qn, c 5 qn, g 5 qn, g 5 qn, a 5 qn, a 5 qn, g 5 hn]
> v1b = lmap vol [f 5 qn, f 5 qn, e 5 qn, e 5 qn, d 5 qn, d 5 qn, c 5 hn]
> v2a = lmap vol [g 5 qn, g 5 qn, f 5 qn, f 5 qn, e 5 qn, e 5 qn, d 5 hn]
> mainVoice = v1 :+: v2 :+: v1
> 
> -- Putting it all together:
> twinkleTwinkle = Instr "piano" (Tempo 2 (Phrase [Dyn SF] mainVoice))


\end{verbatim} }

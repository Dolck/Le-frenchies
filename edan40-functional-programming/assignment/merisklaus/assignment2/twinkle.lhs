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
> v1a = lmap vol [c 4 qn, c 4 qn, g 4 qn, g 4 qn, a 4 qn, a 4 qn, g 4 hn]
> v1b = lmap vol [f 4 qn, f 4 qn, e 4 qn, e 4 qn, d 4 qn, d 4 qn, c 4 hn]
> v2a = lmap vol [g 4 qn, g 4 qn, f 4 qn, f 4 qn, e 4 qn, e 4 qn, d 4 hn]
> mainVoice = v1 :+: v2 :+: v1
> 
> -- Putting it all together:
> twinkleTwinkle = Instr "piano" (Tempo 2 (Phrase [Dyn SF] mainVoice))


\end{verbatim} }

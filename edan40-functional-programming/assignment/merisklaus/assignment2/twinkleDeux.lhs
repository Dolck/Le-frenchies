\section{Encoding of Twinkle Twinkle}
\label{chick}

{\small\begin{verbatim} 

> module TwinkleDeux where
> import AutoComp 
> import Haskore hiding (Major, Minor)
> import Data.Ratio
> 
> -- note updaters for mappings
> fd d n = n d v
> vol  n = n   v
> v      = [Volume 80]
> vk     = [Volume 60]
> lmap f l = line (map f l)
> 
> -- repeat something n times
> times  1    m = m
> times n m = m :+: (times (n - 1) m)
> -- Choose Scale

> cfm = (F, Major, 1%2)
> cgm = (G, Major, 1%2)
> cc1m = (C, Major, 1)
> cc2m = (C, Major, 1%2)
> cp1 = [cc1m, cfm, cc2m, cgm, cc2m, cgm, cc2m]
> cp2 = take 8 $ cycle [cc2m, cgm]
> chords = cp1 ++ cp2 ++ cp1

> -- Main Voice:
> scale x = Note $ generateScalePattern (C, 5) Major !! x
> v1  = v1a :+: v1b
> v2  = times 2 $ v2a 
> v1a = lmap vol [scale 0 qn, scale 0 qn, scale 4 qn, scale 4 qn, scale 5 qn, scale 5 qn, scale 4 hn]
> v1b = lmap vol [scale 3 qn, scale 3 qn, scale 2 qn, scale 2 qn, scale 1 qn, scale 1 qn, scale 0 hn]
> v2a = lmap vol [scale 4 qn, scale 4 qn, scale 3 qn, scale 3 qn, scale 2 qn, scale 2 qn, scale 1 hn]
> mainVoice = v1 :+: v2 :+: v1
> 
> -- Putting it all together:
> twinkleTwinkle = Instr "piano" (Tempo 3 $ mainVoice) :=: autoComp Basic chords

\end{verbatim} }

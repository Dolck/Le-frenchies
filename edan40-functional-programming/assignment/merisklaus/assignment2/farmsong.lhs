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
> lmap f l = line (map f l)
> 
> -- repeat something n times
> times  1    m = m
> times n m = m :+: (times (n - 1) m)
> -- Choose Scale

> cd2m = (D, Major, 1%2)
> cd1m = (D, Major, 1  )
> cc1m = (C, Major, 1%2)
> cc2m = (C, Major, 1%2)
> cg1m = (G, Major, 1  )
> cg2m = (G, Major, 1%2)

> cp1 = [cg1m, cc2m, cg1m, cd2m]
> cp2 = [cg1m, cg1m, cc2m, cg1m]
> cp3 = [cd1m, cd1m, cd1m, cd1m]
> cp4 = [cd1m, cd1m, cd2m, cc2m]
> cp5 = [cg1m, cd2m, cg1m]

> chords = cp1 ++ cp2 ++ cp3 ++ cp4 ++ cp5

> mainVoiceBass = autoBass Basic (chords)
> mainVoiceChords = autoChord (chords)

> -- Main Voice:
> scale x = Note $ generateScalePattern (C, 5) Major !! x
> v1 = lmap vol [ 
>                 scale 4 qn, scale 4 qn, scale 4 qn, scale 1 qn, scale 2 qn, scale 2 qn, 
>                 scale 1 hn, scale 6 qn, scale 6 qn, scale 5 qn, scale 5 qn
>                ]

> v2 = lmap vol [ 
>                 scale 4 dhn, scale 1 qn, scale 4 qn, scale 4 qn, scale 4 qn, scale 1 qn, 
>                 scale 2 qn, scale 2 qn, scale 1 hn 
>                ]

> v3 = lmap vol [ 
>                 scale 6 qn, scale 6 qn, scale 5 qn, scale 5 qn, scale 4 dhn, scale 1 en, 
>                 scale 1 en, scale 4 qn, scale 4 qn, scale 4 qn, scale 1 en, scale 1 en
>                ]

> v4 = lmap vol [scale 4 qn, scale 4 qn, scale 4 qn] :+: Rest qn  :+: lmap vol [
>                 scale 4 en, scale 4 en, scale 4 qn, scale 4 en, scale 4 en, scale 4 qn
>                ]

> v5 = lmap vol [scale 4 en, scale 4 en, scale 4 en, scale 4 en, scale 4 qn, scale 4 qn, 
>                 scale 4 qn, scale 4 qn, scale 4 qn, scale 1 qn]

> v6 = lmap vol [scale 2 qn, scale 2 qn, scale 1 hn, scale 6 qn, scale 6 qn, scale 5 qn, scale 5 qn, scale 4 1]

> mainVoice = v1 :+: v2 :+: v3 :+: v4 :+: v5 :+: v6
> 
> -- Putting it all together:
> twinkleTwinkle = Instr "piano" (Tempo 3 (mainVoiceChords :=: mainVoice :=: mainVoiceBass))

\end{verbatim} }

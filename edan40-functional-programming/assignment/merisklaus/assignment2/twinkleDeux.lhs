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
> mainVoiceBass = autoBass Calypso (C, Major) (cp1++ cp2 ++ cp1)

> -- Chords 
> cC  = c 5 hn vk :=: e 4 hn vk :=: g 4 hn vk
> cF  = f 5 hn vk :=: a 5 hn vk :=: c 5 hn vk
> cG  = g 5 hn vk :=: b 5 hn vk :=: d 5 hn vk
> fp  = cC :+: cC :+: cF :+: cC :+: cG :+: cC :+: cG :+: cC
> sp  = cC :+: cG :+: cC :+: cG
> mainVoiceC = fp :+: sp :+: sp :+: fp

> -- Main Voice:
> v1  = v1a :+: v1b
> v2  = times 2 $ v2a 
> v1a = lmap vol [c 5 qn, c 5 qn, g 5 qn, g 5 qn, a 5 qn, a 5 qn, g 5 hn]
> v1b = lmap vol [f 5 qn, f 5 qn, e 5 qn, e 5 qn, d 5 qn, d 5 qn, c 5 hn]
> v2a = lmap vol [g 5 qn, g 5 qn, f 5 qn, f 5 qn, e 5 qn, e 5 qn, d 5 hn]
> mainVoice = v1 :+: v2 :+: v1
> 
> -- Putting it all together:
> twinkleTwinkle = Instr "piano" (Tempo 2 (mainVoice :=: mainVoiceC :=: mainVoiceBass))

\end{verbatim} }

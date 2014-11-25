\section{Encoding of Twinkle Twinkle}
\label{chick}

{\small\begin{verbatim} 

> module TwinkleDeux where
> import AutoComp 
> import Haskore hiding (Major, Minor)
> 
> -- note updaters for mappings
> fd d n = n d v
> vol  n = n   v
> v      = [Volume 100]
> vk     = [Volume 80]
> lmap f l = line (map f l)
> 
> -- repeat something n times
> times  1    m = m
> times n m = m :+: (times (n - 1) m)
> -- Choose Scale
> scale :: Pitch -> ScalePattern -> Int -> Pitch
> scale p sp x = generateScalePattern p sp !! mod x 7
>
> -- Main Voice:
> v1  = v1a :+: v1b
> v2  = times 2 $ v2a 
> cC = c 5 hn vk :=: e 5 hn vk :=: g 5 hn vk
> cF = f 5 hn vk :=: a 5 hn vk :=: c 5 hn vk
> cG = g 5 hn vk :=: b 5 hn vk :=: d 5 hn vk
> fp = cC :+: cC :+: cF :+: cC :+: cG :+: cC :+: cG :+: cC
> sp = cC :+: cG :+: cC :+: cG

> mainVoiceC= fp :+: sp :+: sp :+: fp

> v1a = lmap vol [c 5 qn, c 5 qn, g 5 qn, g 5 qn, a 5 qn, a 5 qn, g 5 hn]
> v1b = lmap vol [f 5 qn, f 5 qn, e 5 qn, e 5 qn, d 5 qn, d 5 qn, c 5 hn]
> v2a = lmap vol [g 5 qn, g 5 qn, f 5 qn, f 5 qn, e 5 qn, e 5 qn, d 5 hn]
> mainVoice = v1 :+: v2 :+: v1
> 
> -- Putting it all together:
> twinkleTwinkle = Instr "piano" (Tempo 2 (Phrase [Dyn SF] (mainVoiceC :=: mainVoice)))


Chord = [Pitch]
ChordPattern = [Int]
major = [0, 2, 4]
minor = [0, 2, 3]

\end{verbatim} }

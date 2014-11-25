module Twinkle where
import Haskore hiding(Major, Minor)
import AutoComp


 -- note updaters for mappings (from Childsong6.lhs)
fd d n = n d v
vol  n = n   v
v      = [Volume 80]
lmap f l = line (map f l)

-- Main melody: (using Childsong6.lhs as the rolemodel)
mainMelody = v1 :+: v2 :+: v2 :+: v1

--qn = quarter note, hn = half note etc..
v1 = v1a :+: v1b :+: v1c :+: v1d
v1a = lmap (fd qn) [c 5, c 5, g 5, g 5, a 5, a 5]
v1b = lmap (fd hn) [g 5]
v1c = lmap (fd qn) [f 5, f 5, e 5, e 5, d 5, d 5]
v1d = lmap (fd hn) [c 5]

v2 = v2a :+: v2b
v2a = lmap (fd qn) [g 5, g 5 , f 5, f 5, e 5, e 5]
v2b = lmap (fd hn) [d 5]

cC, gG, fF :: Chord 
cC = (C, Major, hn)
gG = (G, Major, hn)
fF = (F, Major, hn)

chordProg = [cC, cC, fF, cC, gG, cC, gG, cC, cC, gG, cC, gG, cC, gG, cC, gG, cC, cC, fF, cC, gG, cC, gG, cC]
key = (C, Major)
boogieBass = autoBass Boogie key chordProg 
basicBass = autoBass Basic key chordProg 
calypsoBass = autoBass Calypso key chordProg 

--twinkleBoogie = Instr "piano" (Tempo 3 (Phrase [Dyn SF] mainMelody)) :=: Instr "bass" (Tempo 3 (Phrase [Dyn SF] boogieBass))
--twinkleBasic = Instr "piano" (Tempo 3 (Phrase [Dyn SF] mainMelody)) :=: Instr "bass" (Tempo 3 (Phrase [Dyn SF] basicBass))
--twinkleCalypso = Instr "piano" (Tempo 3 (Phrase [Dyn SF] mainMelody)) :=: Instr "bass" (Tempo 3 (Phrase [Dyn SF] calypsoBass))

twinkleBasic = mainMelody :=: (autoComp Basic (C,Major) chordProg)
twinkleCalypso = mainMelody :=: (autoComp Calypso (C,Major) chordProg)
twinkleBoogie = mainMelody :=: (autoComp Boogie (C,Major) chordProg)
--twinkle = Instr "piano" (Tempo 3 (Phrase [Dyn SF] mainMelody)) :=: Instr "guitarr" (Tempo 3 (Phrase [Dyn SF] chordsMusic))


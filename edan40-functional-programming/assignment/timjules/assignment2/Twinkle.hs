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
v1a = lmap (fd qn) [c 4, c 4, g 4, g 4, a 4, a 4]
v1b = lmap (fd hn) [g 4]
v1c = lmap (fd qn) [f 4, f 4, e 4, e 4, d 4, d 4]
v1d = lmap (fd hn) [c 4]

v2 = v2a :+: v2b
v2a = lmap (fd qn) [g 4, g 4 , f 4, f 4, e 4, e 4]
v2b = lmap (fd hn) [d 4]

--cChord, gChord, fChord :: TriChord
--cChord = ([(C, 4), (E, 4), (G, 4)], hn)
--gChord = ([(G, 4), (B, 4), (D, 5)], hn)
--fChord = ([(F, 4), (A, 4), (C, 5)], hn)

--twinkleChords = ccf ++ take 8 (cycle cg) ++ ccf
--ccf = [cChord] ++ [cChord] ++ [fChord] ++ (take 4 (cycle cg)) ++ [cChord]
--cg = [cChord] ++ [gChord]

--chordsMusic = foldr1 (:+:) $ map musicFromChord twinkleChords

cC, gG, fF :: Chord 
cC = (C, Major, hn)
gG = (G, Major, hn)
fF = (F, Major, hn)

chordProg = [cC, cC, fF, cC, gG, cC, gG, cC, cC, gG, cC, gG, cC, gG, cC, gG, cC, cC, fF, cC, gG, cC, gG, cC]
key = (C, Major)
boogieBass = autoBass Boogie key chordProg 
basicBass = autoBass Basic key chordProg 
calypsoBass = autoBass Calypso key chordProg 

twinkleBoogie = Instr "piano" (Tempo 3 (Phrase [Dyn SF] mainMelody)) :=: Instr "bass" (Tempo 3 (Phrase [Dyn SF] boogieBass))
twinkleBasic = Instr "piano" (Tempo 3 (Phrase [Dyn SF] mainMelody)) :=: Instr "bass" (Tempo 3 (Phrase [Dyn SF] basicBass))
twinkleCalypso = Instr "piano" (Tempo 3 (Phrase [Dyn SF] mainMelody)) :=: Instr "bass" (Tempo 3 (Phrase [Dyn SF] calypsoBass))


--twinkle = Instr "piano" (Tempo 3 (Phrase [Dyn SF] mainMelody)) :=: Instr "guitarr" (Tempo 3 (Phrase [Dyn SF] chordsMusic))


module JingleBells where
import Haskore hiding (Major, Minor)
import AutoComp

-- note updaters for mappings (from Childsong6.lhs)
fd d n = n d v
vol  n = n   v
v      = [Volume 80]
lmap f l = line (map f l)

-- Main melody: (using Childsong6.lhs as the rolemodel)
mainMelody = p1 :+: p2 :+: p1 :+: p3

p1 = p1a :+: p1a :+: p1b
p1a = lmap vol [(e 5 qn), (e 5 qn), (e 5 hn)] 
p1b = lmap vol [(e 5 qn), (g 5 qn), (c 5 qn), (d 5 qn), (e 5 wn)]

p2 = p2a :+: p2b :+: p2c :+: p2d
p2a = lmap vol [(f 5 qn), (f 5 qn), (f 5 dqn), (g 5 en)]
p2b = lmap vol [(f 5 qn), (e 5 qn), (e 5 dqn), (f 5 en)]
p2c = lmap vol [(e 5 qn), (d 5 qn), (d 5 qn), (e 5 qn)]
p2d = lmap vol [(d 5 hn), (g 5 hn)]

p3 = p2a :+: p2b :+: p3a
p3a = lmap vol [(g 5 qn), (g 5 qn), (f 5 qn), (d 5 qn), (c 5 wn)]

cC = (C, Major, wn)
fF = (F, Major, wn)
dD = (D, Major, wn) --d7 but we settle with d
gG = (G, Major, wn)

chordProg = [cC, cC, cC, cC, fF, cC, dD, gG, cC, cC, cC, cC, fF, cC, gG, cC]

jingleBoogie = Tempo 3 ((Instr "piano" (Phrase [Dyn SF] mainMelody)) :=: (autoComp Boogie (C,Major) chordProg))
jingleBasic = Tempo 3 ((Instr "piano" (Phrase [Dyn SF] mainMelody)) :=: (autoComp Basic (C,Major) chordProg))
jingleCalypso = Tempo 3 ((Instr "piano" (Phrase [Dyn SF] mainMelody)) :=: (autoComp Calypso (C,Major) chordProg))


module Twinkle where
import Haskore
import AutoComp


 -- note updaters for mappings (from Childsong6.lhs)
fd d n = n d v
vol  n = n   v
v      = [Volume 80]
lmap f l = line (map f l)

-- repeat something n times
times  1    m = m
times n m = m :+: (times (n - 1) m)

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

cChord, gChord, fChord :: Music
cChord = musicFromChord ([(C, 4), (E, 4), (G, 4)], hn)
gChord = musicFromChord ([(G, 4), (B, 4), (D, 5)], hn)
fChord = musicFromChord ([(F, 4), (A, 4), (C, 5)], hn)

twinkleChords = c1 :+: (times 4 c2) :+: c1
c1 = cChord :+: cChord :+: fChord :+: cChord :+: gChord :+: cChord :+: gChord :+: cChord
c2 = cChord :+: gChord

twinkle = Instr "piano" (Tempo 3 (Phrase [Dyn SF] mainMelody)) :=: Instr "guitarr" (Tempo 3 (Phrase [Dyn SF] twinkleChords))
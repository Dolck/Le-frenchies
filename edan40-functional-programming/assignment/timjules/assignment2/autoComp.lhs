
Some awsome imports:

>module AutoComp where
>import Haskore hiding(Key)
>import Data.Ratio

To simplify things we create the type Tone which is the same as pitch. pitch = (PitchClass, Octave)

>type Tone = Pitch
>type Key = (Tone, [PitchClass])
>type Position = Int
>type HarmonicQuality = String
>type Scale = [Tone]


>genKey :: Tone -> String -> Key 
>genKey t s = (t, fst $ unzip $ createScale t s)


>type BassStyle = [(Position,Dur)]
>basic, calypso, boogie :: Dur -> BassStyle
>basic dur = take (ceiling (2 * dur)) [(0, hn), (4, hn)]
>calypso dur = take (ceiling (6 * dur)) $ cycle [(-1, qn), (0, en), (2, en)]
>boogie dur = take (ceiling (8 * dur)) $ cycle [(0, en), (4, en), (5, en), (4, en)]


>createScale :: Tone -> HarmonicQuality -> Scale
>createScale n hq = map (\pos -> pitch $ (+) pos $ absPitch n) $ scalePattern hq

>scalePattern :: HarmonicQuality -> [Position]
>scalePattern "Major" = [0, 2, 4, 5, 7, 9, 11]
>scalePattern "Minor" = [0, 2, 3, 5, 7, 8, 10]
>scalePattern "Ionian" = scalePattern "Major"
>scalePattern "Lydian" = [0, 2, 4, 6, 7, 9, 11]
>scalePattern "Mixolydian" = [0, 2, 4, 5, 7, 9, 10]
>scalePattern "Aeolian" = scalePattern "Minor" 
>scalePattern "Dorian" = [0, 2, 3, 5, 7, 9, 10]
>scalePattern "Phrygian" = [0, 1, 3, 5, 7, 8, 10]


>type TriChord = ([Tone], Dur)
>type Chord = (PitchClass, HarmonicQuality, Dur)
>type ChordProgression = [Chord]

>musicFromChord :: TriChord -> Music
>musicFromChord (a, b) = foldr1 (:=:) [Note (x,y) b [Volume 40]| (x,y) <- a]

>autoBass :: BassStyle -> Key -> ChordProgression -> Music
>autoBass bs k cp = foldr1 (:+:) $ map (bassFromChord bs) cp

>bassFromChord :: BassStyle -> Chord -> Music
>bassFromChord bs (pc, hq, _) = foldr1 (:+:) $ map toNote (zip (snd ubs) (map ((!!) (createScale (pc, 3) hq)) $ fst ubs))
>	where
>		   ubs = unzip bs
>		   toNote :: (Dur, Tone) -> Music
>		   toNote (d,t) = Note t d [Volume 80]



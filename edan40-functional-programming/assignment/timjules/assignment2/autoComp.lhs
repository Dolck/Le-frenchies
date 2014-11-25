
Some awsome imports:

>module AutoComp where
>import Haskore hiding(Key)
>import Data.Ratio

To simplify things we create the type Tone which is the same as pitch. pitch = (PitchClass, Octave)

>type Tone = Pitch
>type Key = (PitchClass, HarmonicQualilty)
>type Position = Int
>data HarmonicQuality = Major | Minor | Ionian | Lydian | Mixolydian | Aeolian | Dorian | Phrygian deriving (Read, Show, Eq)
>type Scale = [Tone]

>createScale :: Tone -> HarmonicQuality -> Scale
>createScale n hq = map (\pos -> pitch $ (+) pos $ absPitch n) $ scalePattern hq

>scalePattern :: HarmonicQuality -> [Position]
>scalePattern s = case s of Major       -> [0, 2, 4, 5, 7, 9, 11]
>                           Minor       -> [0, 2, 3, 5, 7, 8, 10]
>                           Ionian      -> scalePattern Major
>                           Lydian      -> [0, 2, 4, 6, 7, 9, 11]
>                           Mixolydian  -> [0, 2, 4, 5, 7, 9, 10]
>                           Aeolian     -> scalePattern Minor 
>                           Dorian      -> [0, 2, 3, 5, 7, 9, 10]
>                           Phrygian    -> [0, 1, 3, 5, 7, 8, 10]

>type BassStyleM = [(Position,Dur)]
>data BassStyle = Basic | Calypso | Boogie deriving (Read)

>basic, calypso, boogie :: Dur -> BassStyleM
>basic dur = take (ceiling (2 * dur)) [(0, hn), (4, hn)]
>calypso dur = take (ceiling (6 * dur)) $ cycle [(-1, qn), (0, en), (2, en)]
>boogie dur = take (ceiling (8 * dur)) $ cycle [(0, en), (4, en), (5, en), (4, en)]

>bassStyleM :: BassStyle -> Dur -> BassStyleM
>bassStyleM Basic = basic
>bassStyleM Calypso = calypso
>bassStyleM Boogie = boogie

>type TriChord = ([Tone], Dur)
>type Chord = (PitchClass, HarmonicQuality, Dur)
>type ChordProgression = [Chord]

>musicFromChord :: TriChord -> Music
>musicFromChord (a, b) = foldr1 (:=:) [Note (x,y) b [Volume 40]| (x,y) <- a]

>autoBass :: BassStyle -> Key -> ChordProgression -> Music
>autoBass bs k cp = foldr1 (:+:) $ map (bassFromChord bs) cp

>bassFromChord :: BassStyle -> Chord -> Music
>bassFromChord bs (pc, hq, dur) = foldr1 (:+:) $ map toNote (zip (snd ubs) (map ((!!) (createScale (pc, 3) hq)) $ fst ubs))
>	where
>		   ubs = unzip $ bassStyleM bs dur
>		   toNote :: (Dur, Tone) -> Music
>		   toNote (d,t) = Note t d [Volume 80]

>autoChord :: Key -> ChordProgression -> Music











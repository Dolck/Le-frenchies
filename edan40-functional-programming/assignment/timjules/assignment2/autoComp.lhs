
Some awsome imports:

>module AutoComp where
>import Haskore hiding(Key)

To simplify things we create the type Tone which is the same as pitch. pitch = (PitchClass, Octave)

>type Tone = Pitch
>
>type Key = [Int]

>type Position = Int
>type BassStyle = [(Position,Dur)]
>basic, calypso, boogie :: BassStyle
>basic = [(0, hn), (4, hn)]
>calypso = take 6 $ cycle [(-1, qn), (0, en), (2, en)]
>boogie = take 8 $ cycle [(0, en), (4, en), (5, en), (4, en)]


>type Scale = [Tone]


>createScale :: Tone -> String -> Scale
>createScale n hq = map (\pos -> pitch $ (+) pos $ absPitch n) $ scalePattern hq

>scalePattern :: String -> Key
>scalePattern "Major" = [0, 2, 4, 5, 7, 9, 11]
>scalePattern "Minor" = [0, 2, 3, 5, 7, 8, 10]
>scalePattern "Ionian" = scalePattern "Major"
>scalePattern "Lydian" = [0, 2, 4, 6, 7, 9, 11]
>scalePattern "Mixolydian" = [0, 2, 4, 5, 7, 9, 10]
>scalePattern "Aeolian" = scalePattern "Minor" 
>scalePattern "Dorian" = [0, 2, 3, 5, 7, 9, 10]
>scalePattern "Phrygian" = [0, 1, 3, 5, 7, 8, 10]

>type Chord = (Tone, Tone, Tone)

--autoBass :: BassStyle -> Key -> ChordProgression -> Music

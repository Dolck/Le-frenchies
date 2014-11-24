
Some awsome imports:

>module AutoComp where
>import Haskore hiding(Key)

To simplify things we create the type Note which is the same as pitch. pitch = (PitchClass, Octave)

>type Tone = Pitch
>
>type Key = [Int]

--type RestOrPos = Rest | Int

--type BassStyle = [(RestOrPos,Dur)]

>type Scale = [Tone]


>createScale :: Tone -> String -> Scale
>createScale n hq = map (createNote n) $ scalePattern hq
>	where 
>		createNote :: Tone -> Int -> Tone
>		createNote n pos = pitch $ (+) pos $ absPitch n


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

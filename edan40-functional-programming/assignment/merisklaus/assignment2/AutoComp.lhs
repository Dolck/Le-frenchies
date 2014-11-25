> module AutoComp where
> import Haskore hiding (Major, Minor, Key)
> import Data.Ratio
> import Data.List

> data HarmonicQuality = Ionian | Major | Lydian | Mixolonyan | Aeolian | Minor | Dorian | Phrygian  
> harmonicQuality:: HarmonicQuality-> [Int]
> harmonicQuality pc = case pc of
>      Ionian     -> [0, 2, 4, 5, 7, 9, 11]; 
>      Lydian     -> [0, 2, 4, 6, 7, 9, 11]; 
>      Mixolonyan -> [0, 2, 4, 5, 7, 9, 10];
>      Aeolian    -> [0, 2, 3, 5, 7, 8, 10];
>      Dorian     -> [0, 2, 3, 5, 7, 9, 10];
>      Phrygian   -> [0, 1, 3, 5, 7, 8, 10];
>      Major      -> harmonicQuality Ionian;
>      Minor      -> harmonicQuality Aeolian;

> type Key = (PitchClass, HarmonicQuality)

Generate scale based on which groundtone (pitchclass) and harmonic quality specified.

> generateScalePattern :: Pitch -> HarmonicQuality -> [Pitch]

> generateScalePattern p = map doMath . harmonicQuality 
>   where 
>    doMath = pitch . add p
>    add = (+) . absPitch 

type Duration = Ratio

> type Chord = (PitchClass, HarmonicQuality, Dur)
> getClass      :: Chord -> PitchClass
> getClass      (c, _, _) = c
> getHarmonics  :: Chord -> HarmonicQuality 
> getHarmonics  (_, h, _) = h
> getDuration   :: Chord -> Dur 
> getDuration   (_, _, d) = d

> type ChordProgression  = [Chord]

Let's do the autobasss
We always start in the 3rd octave.



> data BassNote = Silence Dur | Position Int Dur deriving Show
> data BassStyle = Basic | Calypso | Boogie 
> bassStyle :: BassStyle -> [BassNote]
> bassStyle pc = case pc of
>      Basic    -> [Position 0 (1%2), Position 4 (1%2)]; 
>      Calypso  -> take 6 $ cycle [Silence (1%4), Position 0 (1%8), Position 2 (1%8)]; 
>      Boogie   -> take 8 $ cycle [Position 0 (1%8), Position 4 (1%8), Position 5 (1%8), Position 4 (1%8)];

autoBass bs key cp = foldr1 (:+:) (\x -> generateBass bs key x) cp 

> takePart :: [a] -> Dur -> [a]
> takePart [] _ = []
> takePart xs x = take (n `div` denominator x) xs
>     where n = length xs

> generateBass :: BassStyle -> Key -> Chord -> Music
> generateBass bs (_, _) ch = line $ map (\x -> bassNoteTo (getScale ch) x) baseLine 
>   where 
>     baseLine = takePart (bassStyle bs) $ getDuration ch
>     bassNoteTo :: [Pitch] -> BassNote -> Music
>     bassNoteTo _ (Silence d)      = Rest d
>     bassNoteTo s (Position pos d) = Note (s !! pos) d [Volume 70]
>     getScale ch = generateScalePattern (getClass ch, 3) $ getHarmonics ch

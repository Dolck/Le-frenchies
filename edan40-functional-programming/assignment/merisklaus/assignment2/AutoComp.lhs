> module AutoComp where
> import Haskore hiding (Major, Minor, Key)
> import Data.Ratio
> import Data.List

> data ScalePattern = Ionian | Major | Lydian | Mixolonyan | Aeolian | Minor | Dorian | Phrygian  
> scalePattern :: ScalePattern -> [Int]
> scalePattern pc = case pc of
>      Ionian     -> [0, 2, 4, 5, 7, 9, 11]; 
>      Lydian     -> [0, 2, 4, 6, 7, 9, 11]; 
>      Mixolonyan -> [0, 2, 4, 5, 7, 9, 10];
>      Aeolian    -> [0, 2, 3, 5, 7, 8, 10];
>      Dorian     -> [0, 2, 3, 5, 7, 9, 10];
>      Phrygian   -> [0, 1, 3, 5, 7, 8, 10];
>      Major      -> scalePattern Ionian;
>      Minor      -> scalePattern Aeolian;

Generate key scale based on which groundtone (pitchclass) and scale pattern specified.

> generateScalePattern :: Pitch -> ScalePattern -> [Pitch]

> generateScalePattern p = map doMath . scalePattern 
>   where 
>    doMath = pitch . add p
>    add = (+) . absPitch 

Let's do the autobasss

> type Key = (PitchClass, ScalePattern)

data BassStyle = Basic | Calypso | Boogie 
bassStyle :: BassStyle -> [Pitch]
autoBass :: BassStyle -> Key -> ChordProgression -> Music

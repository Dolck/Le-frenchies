> module AutoComp where
> import Haskore hiding (Major, Minor)
> import Data.Ratio
> import Data.List

> pitchClasses = [C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B]

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

Generate pattern based on which groundtone (pitchclass) and scale specified.


> generateScalePattern :: PitchClass -> ScalePattern -> [PitchClass]
> generateScalePattern pc sp = map (\x -> (concat $ repeat pitchClasses) !! (pitchClass pc + x) ) $ scalePattern sp



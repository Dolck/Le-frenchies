> module AutoComp where
> import Haskore
> import Data.Ratio
> import Data.List

> pitchClasses = [C, Cs, D, Ds, E, F, Fs, G, Gs, A, As, B]

Generate pattern based on which groundtone (pitchclass) and scale specified.

> type ScalePattern = [Int]
> type Tone         = (Int, Int)

> generateScalePattern :: PitchClass -> ScalePattern -> [PitchClass]
> generateScalePattern pc sp = map (\x -> (concat $ repeat pitchClasses) !! (pitchClass pc + x) ) sp



> module AutoComp where
> import Haskore hiding (Major, Minor, Key)
> import Data.Ratio
> import Data.List
> import Data.Ord

> data HarmonicQuality = Ionian | Major | Lydian | Mixolonyan | Aeolian | Minor | Dorian | Phrygian deriving Show
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


Let's do the autobasss
We always start in the 3rd octave.

> data BassNote = Silence Dur | Position Int Dur deriving Show
> data BassStyle = Basic | Calypso | Boogie 
> bassStyle :: BassStyle -> [BassNote]
> bassStyle pc = case pc of
>      Basic    ->                [Position 0 (1%2), Position 4 (1%2)]; 
>      Calypso  -> take 6 $ cycle [Silence (1%4), Position 0 (1%8), Position 2 (1%8)]; 
>      Boogie   -> take 8 $ cycle [Position 0 (1%8), Position 4 (1%8), Position 5 (1%8), Position 4 (1%8)];

> autoBass bs key cp = foldr1 (:+:) $ map (\x -> generateBass bs key x) cp 
>   where
>     generateBass :: BassStyle -> Key -> Chord -> Music
>     generateBass bs (_, _) ch = line $ map (\x -> bassNoteTo (getScale ch) x) baseLine 
>       where
>         baseLine = takePart (bassStyle bs) $ getDuration ch
>         bassNoteTo :: [Pitch] -> BassNote -> Music
>         bassNoteTo _ (Silence d)      = Rest d
>         bassNoteTo scale (Position pos d) = Note (scale !! pos) d [Volume 70]
>         getScale ch = generateScalePattern (getClass ch, 3) $ getHarmonics ch

> takePart :: [a] -> Ratio Int -> [a]
> takePart [] _ = []
> takePart xs x = take (n `div` denominator x) xs
>     where n = length xs

> chordRange = map pitch [absPitch (E, 4) .. absPitch (G, 5)]

> majorChordScale = [0, 2, 4]

> permittedTones :: Chord -> [Pitch]
> permittedTones (pc, hq, _) = filter inRange [(generateScalePattern (pc, oct) hq) !! x | x <- majorChordScale, oct <- [3..5]]
>   where inRange =  flip elem (map absPitch chordRange) . absPitch 

> permittedTrips :: [Pitch] -> [[Pitch]]
> permittedTrips = (filter length3) . (filter $ length3 . uniquePitchClass) . subsequences 
>   where
>     length3           = (3==) . length
>     uniquePitchClass  = nub . fst . unzip

> pitchDiff :: (Pitch, Pitch) -> Int
> pitchDiff (a, b) = abs $ absPitch a - absPitch b

> melodyDifference :: [Pitch] -> [Pitch] -> Int
> melodyDifference a b = sum $ map pitchDiff (zip (sortChord a) (sortChord b))
> sortChord :: [Pitch] -> [Pitch]
> sortChord = sortBy (comparing absPitch)

autoChord :: ChordProgression -> [[Pitch]]

> type Chord = (PitchClass, HarmonicQuality, Dur)
> getClass      :: Chord -> PitchClass
> getClass      (c, _, _) = c
> getHarmonics  :: Chord -> HarmonicQuality 
> getHarmonics  (_, h, _) = h
> getDuration   :: Chord -> Dur 
> getDuration   (_, _, d) = d
> type ChordProgression   = [Chord]
> type Triple             = (Pitch, Pitch, Pitch)

> autoChord :: Key -> ChordProgression -> Music
> autoChord _ (x:xs) = foldr1 (:+:) ((chordToMusic (tighten x) x) : (doRest (tighten x) xs))
>   where 
>     doRest :: [Pitch] -> ChordProgression -> [Music]
>     dorest _    []       = []
>     doRest prev (c:curr) = [chordToMusic (resolvedChord prev c) c] ++ (doRest (resolvedChord prev c) curr)
>     doRest _ _           = []
>     resolvedChord :: [Pitch] -> Chord -> [Pitch] 
>     resolvedChord p c = (minChordDiff p c)

> chordToMusic :: [Pitch] -> Chord -> Music
> chordToMusic ps (_, _, dur) = foldr1 (:=:) (map (\x -> (Note x dur [Volume 70])) ps)


> generateAllChords :: Chord -> [[Pitch]]
> generateAllChords = permittedTrips . permittedTones

> tighten :: Chord -> [Pitch]
> tighten xs = getTightestChord $ generateAllChords xs 
>  where 
>   getTightestChord :: [[Pitch]] -> [Pitch]
>   getTightestChord x = head $ sortBy (comparing tightness) x
>   tightness :: [Pitch] -> Int
>   tightness p = absPitch(last (sortChord p)) - absPitch(head (sortChord p)) 

> minChordDiff :: [Pitch] -> Chord -> [Pitch]
> minChordDiff prev = calcMin prev . generateAllChords 
>  where
>  calcMin :: [Pitch] -> [[Pitch]] -> [Pitch]
>  calcMin = minimumBy . comparing . chordDiff
>  chordDiff c1 c2 = sum $ map (pitchDiff) $ zip (sortChord c1) (sortChord c2)

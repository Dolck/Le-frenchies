
Some awsome imports:

>module AutoComp where
>import Haskore hiding(Key, Major, Minor)
>import Data.Ratio
>import Data.Maybe
>import Data.List

To simplify things we create the type Tone which is the same as pitch. pitch = (PitchClass, Octave)

>type Tone = Pitch
>type Key = (PitchClass, HarmonicQuality)
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

>type Chord = (PitchClass, HarmonicQuality, Dur)
>type ChordProgression = [Chord]

>autoBass :: BassStyle -> Key -> ChordProgression -> Music
>autoBass bs _ cp = foldr1 (:+:) $ map (bassFromChord bs) cp

>bassFromChord :: BassStyle -> Chord -> Music
>bassFromChord bs (pc, hq, dur) = foldr1 (:+:) $ map toMusic (zip (snd ubs) (maybeFunc (fst ubs) (createScale (pc, 3) hq)))
>	  where
>     ubs = unzip $ bassStyleM bs dur
>     maybeFunc :: [Position] -> Scale -> [Maybe Tone]
>     maybeFunc [] _ = []
>     maybeFunc (p:ps) sc 
>             | p == -1 = Nothing : maybeFunc ps sc
>             | otherwise = Just (sc !! p) : maybeFunc ps sc
>     toMusic :: (Dur, Maybe Tone) -> Music
>     toMusic (d, Nothing) = Rest d
>     toMusic (d, Just t) = Note t d [Volume 80]

Autochord takes a Key and a ChordProgression and chooses the notes for all chords based on them beeing 
1: in a limited range
2: small changes between chords 
3: small tone steps within the chord

Ex. autoChord (C, Major) [(C, Major, hn),(C, Major, hn),(G, Major, hn),(C, Major, hn)]

From this we will receive a series of chords that are playable as parallel notes.

>autoChord :: Key -> ChordProgression -> Music
>autoChord _ cp = foldr1 (:+:) $ autoHelper Nothing cp
>   where
>     autoHelper :: Maybe [Tone] -> ChordProgression -> [Music]
>     autoHelper ts [c] = let prev = minChordDiff ts c in [musicFromTones prev (third c)]
>     autoHelper ts (c:cs) = let prev = minChordDiff ts c in (musicFromTones prev (third c)) : (autoHelper (Just prev) cs)
>     third (_,_,x) = x

The function musicFromTones takes a list of tones that chould be combined into a chord, and a duration.

Ex. musicFromTones [(C,5),(E,5),(G,5)] hn

>musicFromTones :: [Tone] -> Dur -> Music
>musicFromTones ts d = foldr1 (:=:) [Note x d [Volume 40] | x <- ts]

The fixed chord range in which the produced chords are allowed to be are defined in chordRange.

>chordRange :: (Tone, Tone)
>chordRange = ((E,4), (G,5))

The function chordTones takes a chord name and returns all Tones that could be played in this chord. 

Ex. chordTones (C, Major, hn)

>chordTones :: Chord -> [Tone]
>chordTones (pc, hq, d) = filter filt $ [(!!) (createScale(pc, o) hq) x | x <- [0,2,4], o <- [((snd $ fst chordRange)-1)..(snd $ snd chordRange)]]
>	  where 
>	    filt t = (absPitch t) >= absR1 && (absPitch t) <= absR2
>	    absR1 = absPitch $ fst chordRange
>	    absR2 = absPitch $ snd chordRange

The function minChordDiff takes a possible previous chord and the name of the current chord that should be played, 
and evaluates the chord that has the smallest combined distance to the previous one and also the smallest internal width.

Ex. minChordDiff (Just [(C,5)(E,5)(G,5)]) (C, Major, hn)

>minChordDiff :: Maybe [Tone] -> Chord -> [Tone]
>minChordDiff Nothing c = minChord $ uniqueValidTrips c
>minChordDiff (Just prev) c = calcMin prev $ uniqueValidTrips c
>   where
>	    calcMin :: [Tone] -> [[Tone]] -> [Tone]
>	    calcMin p v = minimumBy (\v1 v2 -> compare (chordDiff p v1) (chordDiff p v2)) v
>	    chordDiff c1 c2 = sum $ map (\(t1,t2) -> toneDiff t1 t2) $ zip (sortChord c1) (sortChord c2)

The function uniqueValiedTrips takes a Chord (more like a chord name), 
and evaluates all chords of size three that are within the given range. 
These chords are all unique and internally sorted.

Ex. uniqueValidTrips (C, Major, hn)

>uniqueValidTrips :: Chord -> [[Tone]]
>uniqueValidTrips c = filter (\ts -> allUnique $ fst $ unzip ts) $ choose3 $ chordTones c
>	  where	
>	    allUnique pcs = 3 == (length $ nub pcs)
>	    choose3 xs = filter (\x -> 3 == (length x)) $ subsequences xs

The function toneDiff takes two Tones and evaluates the distance between them.

Ex. toneDiff (C,5) (G,5)

>toneDiff :: Tone -> Tone -> Int
>toneDiff t1 t2 = abs $ (-) (absPitch t1) $ absPitch t2

The function sortChord sorts a chord (list of Tones), 

Ex, sortChord [(C,5),(E,4),(G,4)]

according to the absolute pitch.

>sortChord :: [Tone] -> [Tone]
>sortChord ts = sortBy (\a b -> compare (absPitch a) (absPitch b)) ts

The function minChord takes a list of chord collections (list of list of Tones), 

Ex. minChord [[(C,5),(E,5),(G,5)],[(E,4),(G,4),(C,5)]]

and evaluates which of these chords that are minimally spread out.

>minChord :: [[Tone]] -> [Tone]
>minChord cs = minimumBy (\x y -> compare (distance x) $ distance y) cs
>	  where 
>		  distance :: [Tone] -> Int
>		  distance ts = let sorted = sortChord ts in toneDiff (head sorted) $ last sorted 

The function autoComp takes the desired bass style (basic, calypso, or boogie), 
the desired key that the song should be played in, and a basic chord progression.

Ex. autoComp basic (C, Major) twinkleChords

From this, it produces a bassline and a series of chords that should be played 
in parallel.

>autoComp :: BassStyle -> Key -> ChordProgression -> Music
>autoComp b k cp = (autoBass b k cp) :=: (autoChord k cp)








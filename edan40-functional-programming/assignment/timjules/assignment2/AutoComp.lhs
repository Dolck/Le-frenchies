
Functional Music by Tim Dolck (dat11tdo) and Julian Kroné (dat11jkr)

=======================================================================

In this assignment we aim to create automatic bass and chord comp to a given piece of music.

We begin our journey through the haskell code with some imports. Theese will be used later on.

>module AutoComp where
>import Haskore hiding(Key, Major, Minor)
>import Data.Ratio
>import Data.Maybe
>import Data.List
>import Data.Ord

To simplify the logic and understanding of our code we create some data types.  
- Tone is the same as Pitch in Haskore. Pitch = (PitchClass, Octave)
- Key contains a PitchClass and a HarmonicQuality (explained soon). 
	A key is essentially a set of all possible tones we want to play in a piece of music.
	You could think of it as the scale from the HarmonicQuality and PitchClass for every possible Octave
- Position is defined as a Int and should only denote the position in a scale.
- HarmonicQuality denotes the style/feeling of Keys, Scales and Chords 
- Scale is a list of tones. The list contains some notes between the base tone and the base tone 1 octave up.

>type Tone = Pitch
>type Key = (PitchClass, HarmonicQuality)
>type Position = Int
>data HarmonicQuality = Major | Minor | Ionian | Lydian | Mixolydian | Aeolian | Dorian | Phrygian deriving (Read, Show, Eq)
>type Scale = [Tone]

Scales are defined as patterns of steps from the base tone. The possible steps are t (tone) and s (semitone).
A simple major scale has the pattern ttsttts.
In our program though this whould be a quite inpractical pattern so we define the positions instead of the positions in our patterns.

Below is two important functions for scales.
Create Scale does exactly as the name denotes. It creates a list of notes in a certain scale
To create the scale in the createScale function we use scale patterns that we get from out next function scalePattern

>createScale :: Tone -> HarmonicQuality -> Scale
>createScale n = map (\pos -> pitch $ (+) pos (absPitch n)) . scalePattern

>scalePattern :: HarmonicQuality -> [Position]
>scalePattern s = case s of Major       -> [0, 2, 4, 5, 7, 9, 11]
>                           Minor       -> [0, 2, 3, 5, 7, 8, 10]
>                           Ionian      -> scalePattern Major
>                           Lydian      -> [0, 2, 4, 6, 7, 9, 11]
>                           Mixolydian  -> [0, 2, 4, 5, 7, 9, 10]
>                           Aeolian     -> scalePattern Minor 
>                           Dorian      -> [0, 2, 3, 5, 7, 9, 10]
>                           Phrygian    -> [0, 1, 3, 5, 7, 8, 10]


The next step is to start building the BassStyles for the bass.
In similarity to what we defined above we need some find of patterns to define how to play.
In this case though our pattern consists of a list of positions and durations

>type BStyleImpl = [(Position,Dur)]
>data BassStyle = Basic | Calypso | Boogie deriving (Read)

>basic, calypso, boogie :: Dur -> BStyleImpl
>basic = flip take [(0, hn), (4, hn)] . ceiling . (2*)
>calypso = flip take (cycle [(-1, qn), (0, en), (2, en)]) . ceiling . (4*)
>boogie = flip take (cycle [(0, en), (4, en), (5, en), (4, en)]) . ceiling . (8*)

To translate from a given baseStyle to an actual pattern we use the function below.

>bStyleImpl :: BassStyle -> Dur -> BStyleImpl
>bStyleImpl bs = case bs of Basic   -> basic
>                           Calypso -> calypso
>                           Boogie  -> boogie

Next we introduce some new types Chord and ChordProgression. 
A chord is a small set of Notes played simultaniously. These notes are chosen from a given 
pattern from the corresponding scale. In this assigment we only handle major and minor chords which use the
same pattern but picks from different scales. 

A ChordProgression is a list of chords that should be played in sequence. 

>type Chord = (PitchClass, HarmonicQuality, Dur)
>type ChordProgression = [Chord]

Finally we arrive to a little treasure in the code.
The autoBass function creates a playable bass line for a ChordProgression.
To do this we denote which bass style that should be used and which key the notes should be played in.

Although you might think the autoBass function has a lot going on the real workhorse here is the bassFromChord function.
bassFromChord finds the bassline during a given chord.

>autoBass :: BassStyle -> Key -> ChordProgression -> Music
>autoBass bs _ = foldr1 (:+:) . map (bassFromChord bs)

>bassFromChord :: BassStyle -> Chord -> Music
>bassFromChord bs (pc, hq, dur) = foldr1 (:+:) $ map toMusic (zip (snd ubs) (maybeFunc (fst ubs) (createScale (pc, 3) hq)))
>	  where
>     ubs = unzip $ bStyleImpl bs dur
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
>autoChord _ = foldr1 (:+:) . autoHelper Nothing
>   where
>     autoHelper :: Maybe [Tone] -> ChordProgression -> [Music]
>     autoHelper ts [c] = let prev = minChordDiff ts c in [musicFromTones prev (third c)]
>     autoHelper ts (c:cs) = let prev = minChordDiff ts c in (musicFromTones prev (third c)) : (autoHelper (Just prev) cs)
>     third (_,_,x) = x

The function musicFromTones takes a list of tones that chould be combined into a chord, and a duration.

Ex. musicFromTones [(C,5),(E,5),(G,5)] hn
-> Note (C,5) (1 % 2) [Volume 40.0] :=: (Note (E,5) (1 % 2) [Volume 40.0] :=: Note (G,5) (1 % 2) [Volume 40.0])

>musicFromTones :: [Tone] -> Dur -> Music
>musicFromTones ts d = foldr1 (:=:) [Note x d [Volume 40] | x <- ts]

The fixed chord range in which the produced chords are allowed to be are defined in chordRange.

>chordRange :: (Tone, Tone)
>chordRange = ((E,4), (G,5))

The function chordTones takes a chord name and returns all Tones that could be played in this chord. 

Ex. chordTones (C, Major, hn)
-> [(C,5),(E,4),(E,5),(G,4),(G,5)]

>chordTones :: Chord -> [Tone]
>chordTones (pc, hq, d) = filter filt $ [(!!) (createScale(pc, o) hq) x | x <- [0,2,4], o <- [((snd $ fst chordRange)-1)..(snd $ snd chordRange)]]
>	  where 
>	    filt t = (absPitch t) >= absR1 && (absPitch t) <= absR2
>	    absR1 = absPitch $ fst chordRange
>	    absR2 = absPitch $ snd chordRange

The function minChordDiff takes a possible previous chord and the name of the current chord that should be played, 
and evaluates the chord that has the smallest combined distance to the previous one and also the smallest internal width.

Ex. minChordDiff (Just [(C,5),(E,5),(G,5)]) (C, Major, hn)
-> [(C,5),(E,5),(G,5)]

>minChordDiff :: Maybe [Tone] -> Chord -> [Tone]
>minChordDiff Nothing = minChord . uniqueValidTrips
>minChordDiff (Just prev) = calcMin prev . uniqueValidTrips
>   where
>     calcMin :: [Tone] -> [[Tone]] -> [Tone]
>     calcMin = minimumBy . comparing . chordDiff
>     chordDiff c1 c2 = sum $ map (uncurry $ toneDiff) $ zip (sortChord c1) (sortChord c2)

The function uniqueValiedTrips takes a Chord (more like a chord name), 
and evaluates all chords of size three that are within the given range. 
These chords are all unique and internally sorted.

Ex. uniqueValidTrips (C, Major, hn)
-> [[(C,5),(E,4),(G,4)],[(C,5),(E,5),(G,4)],[(C,5),(E,4),(G,5)],[(C,5),(E,5),(G,5)]]

>uniqueValidTrips :: Chord -> [[Tone]]
>uniqueValidTrips = filter (allUnique . fst . unzip) . choose3 . chordTones
>	  where	
>	    allUnique = (==) 3 . length . nub
>	    choose3 = filter ((==) 3 . length) . subsequences

The function toneDiff takes two Tones and evaluates the distance between them.

Ex. toneDiff (C,5) (G,5)
-> 7

>toneDiff :: Tone -> Tone -> Int
>toneDiff t1 t2 = abs $ (-) (absPitch t1) $ absPitch t2

The function sortChord sorts a chord (list of Tones), 

Ex. sortChord [(C,5),(E,4),(G,4)]
-> [(E,4),(G,4),(C,5)]

according to the absolute pitch.

>sortChord :: [Tone] -> [Tone]
>sortChord = sortBy $ comparing absPitch

The function minChord takes a list of chord collections (list of list of Tones), 

Ex. minChord [[(C,5),(E,5),(G,5)],[(E,4),(G,4),(C,5)]]
-> [(C,5)(E,5)(G,5)]

and evaluates which of these chords that are minimally spread out.

>minChord :: [[Tone]] -> [Tone]
>minChord = minimumBy $ comparing distance
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








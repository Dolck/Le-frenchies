Functional Music by Meris Bahtijaragic (dat11mba) & Klas Sonesson (dat11kso)
===============================================================================

Introduction
-------------------------------------------------------------------------------

The assignment is to create a module which creates a  automatic accompaniment 
to a given set of chords and notes. To do this, 
we will use functional programming and a  music library, Haskore, 
which simplifies the process by providing means to express music. 

This module is called AutoComp.

> module AutoComp where

Libraries Used
-------------------------------------------------------------------------------

To help us on this assignment, we will be using several imports, one of 
them which is Haskore. Since we will create our own definitions of the types 
Major and Minor we will exclude these.

> import Haskore hiding (Major, Minor)
> import Data.Ratio
> import Data.List
> import Data.Ord
> import Data.Function (on)


The Beginning - Data Types
-------------------------------------------------------------------------------

In Western Music, a scale is a subset of 7 notes from an octave consisting of 
12 notes. The exact subset is called a Harmonic Quality and is used to 
compose the melody of the song.

Below we create an algebraic data structure to describe harmonic qualities:

> data HarmonicQuality = Ionian | Major | Lydian | Mixolonyan 
>                        | Aeolian | Minor | Dorian | Phrygian deriving Show

and a function to retrieve the scale pattern associated with the given harmonic 
quality.

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

In order to represent chords we create a type that contains a PitchClass
which specifies the root of the chord, a HarmonicQuality which specifies
the pattern in which the rest of the notes are retrieved, and a duration
which specifies the duration of the chord.

> type Chord = (PitchClass, HarmonicQuality, Dur)
  
A ChordProgression which represents a number of chords which will be played
in sequence.

> type ChordProgression   = [Chord]

Scales
-------------------------------------------------------------------------------

To actually make use of our data types we have to write functions which will
help us compose songs, which consist of melodies and chords.

To help us write melodies we use a function called generateScalePattern,

> generateScalePattern :: Pitch -> HarmonicQuality -> [Pitch]
> generateScalePattern p = map doMath . harmonicQuality 
>   where 
>    doMath = pitch . add p
>    add = (+) . absPitch 

which will provide a scale based on the provided root and harmonic quality.

For example:
  *AutoComp> generateScalePattern (C, 3) Major
  [(C,3),(D,3),(E,3),(F,3),(G,3),(A,3),(B,3)]

Generating the bass
-------------------------------------------------------------------------------

The first part of the accompaniment is the Bass.
The bass patterns describe a bar, which consists several elements. 
The elements can be either silence or a "Sound" telling 
which note in the scale to be used .


> data BassNote = Silence Dur | Sound Int Dur deriving Show

We have three bass styles described below.

> data BassStyle = Basic | Calypso | Boogie 
> bassStyle :: BassStyle -> [BassNote]
> bassStyle pc = case pc of
>  Basic    ->                [Sound 0 (1%2), Sound 4 (1%2)]; 
>  Calypso  -> take 6 $ cycle [Silence (1%4), Sound 0 (1%8), Sound 2 (1%8)]; 
>  Boogie   -> take 8 $ cycle [Sound 0 (1%8), Sound 4 (1%8), 
>                              Sound 5 (1%8), Sound 4 (1%8)]

Below we have function, which, given a bass style and a chordprogression
will produce a bassline based on the chordprogression.

For example, if we want to produce a bass line in the boogie style 
to accompany a G Major chord of duration 1 whole bar we will get the following: 

  *AutoComp> autoBass Boogie [(G, Major, 1)]
  (Note (G,3) (1 % 8) [Volume 70.0]) :+: 
  (Note (D,4) (1 % 8) [Volume 70.0]) :+: 
  (Note (E,4) (1 % 8) [Volume 70.0]) :+: 
  (Note (D,4) (1 % 8) [Volume 70.0]) :+: 
  (Note (G,3) (1 % 8) [Volume 70.0]) :+: 
  (Note (D,4) (1 % 8) [Volume 70.0]) :+: 
  (Note (E,4) (1 % 8) [Volume 70.0]) :+: 
  (Note (D,4) (1 % 8) [Volume 70.0])


In the "special" case where we must generate a bass line segment for a 
chord which has a duration of for instance 1/2, we simply split the 
bass pattern in half and proceed from there.

> autoBass :: BassStyle -> ChordProgression -> Music
> autoBass bs cp = foldr1 (:+:) $ map (\x -> generateBass bs x) cp 
>   where
>     generateBass :: BassStyle -> Chord -> Music
>     generateBass bs (pc, hs, dur) = line $ map (bassNoteToMusic (getScale (pc, hs, dur))) baseLine 
>       where
>         baseLine = takePart (bassStyle bs) $ dur
>         bassNoteToMusic :: [Pitch] -> BassNote -> Music
>         bassNoteToMusic _ (Silence d)       = Rest d
>         bassNoteToMusic scale (Sound pos d) = Note (scale !! pos) d [Volume 60]
>         getScale (pc, hms, _)  = generateScalePattern (pc, 3) $ hms 
>         takePart :: [a] -> Ratio Int -> [a]
>         takePart xs x = take (length xs `div` denominator x) xs


Generating the Chord Voicing
-------------------------------------------------------------------------------------

We've previously described Chords as a tuple consiting of a PitchClass, HarmonicQuality 
and a duration. For the purpose of converting a sequence of Chords into actual 
notes played in parallel (traditionally called chords) we have to create 
a function called autoChord.

The rules (of thumb) we have to follow when creating the chord voicing are:
  1. Keep the notes within a range,
  2. Keep the melody diffrence between two *chords* in sequence at a minimum.
  3. Keep the difference between the actual elements in a *chord* at a minimum.
     (Tighten the chords).

We will also enforce that *chords* will be of length 3 and played in a major 
chord scale.

To achieve this, we will first enforce the rule of thumb #3 on the first note
in the whole ChordProgression. For the rest of the notes, we will optimize the
difference between melodies based on the _previous_ chord.

> autoChord :: ChordProgression -> Music
> autoChord (x:xs) = foldr1 (:+:) ((chordToMusic (tighten x) x) : (doRest (tighten x) xs))
>   where 
>     doRest :: [Pitch] -> ChordProgression -> [Music]
>     doRest prev (c:curr) = [chordToMusic (resolvedChord prev c) c] ++ (doRest (resolvedChord prev c) curr)
>     doRest _ _           = []
>     resolvedChord :: [Pitch] -> Chord -> [Pitch] 
>     resolvedChord p c = (minChordDiff p c)

To enforce rule of thumb #1 we create a range of Pitches which are allowed 
in our *chords* (also referred to as triples).

> chordRange = map pitch [absPitch (E, 4) .. absPitch (G, 5)]

The chords will be played in a major scale.

> majorChordScale = [0, 2, 4]

To generate all permitted *chords* given a Chord, we will create the following function:

> generateAllChords :: Chord -> [[Pitch]]
> generateAllChords = nub . permittedTrips . permittedTones

this is composed of two functions, which will be described below.

permittedTones will generate all Pitches which are allowed to be a component of a *chord*.
This is where the the first rule of thumb is applied.

Example: 
  *AutoComp> permittedTones (C, Major, 1)
  [(C,5),(E,4),(E,5),(G,4),(G,5)]

> permittedTones :: Chord -> [Pitch]
> permittedTones (pc, hq, _) = filter inRange [
>                                               (generateScalePattern (pc, oct) hq) !! x |
>                                               x <- majorChordScale, 
>                                               oct <- 
>                                               [(snd . head $ chordRange) .. (snd . last $ chordRange)]
>                                             ]
>   where inRange =  flip elem (map absPitch chordRange) . absPitch 


This function generates all *chords* of length 3 based on a list of Pitches, 
another requirement is that a *chord* cannot contain two pitches of the exact same pitch.

For example:
  *AutoComp> permittedTrips $ permittedTones (E, Major, 1)
  [[(E,4),(Gs,4),(B,4)],[(E,5),(Gs,4),(B,4)],[(E,4),(Gs,4),(B,4)]]

> permittedTrips :: [Pitch] -> [[Pitch]]
> permittedTrips x = (filter ((3==).length)) (map (nubBy ((==) `on` fst)) (subsequences x))

In order to enforce rule of thumb #2 we need to be able to calculate the difference
between two pitches. 

> pitchDiff :: (Pitch, Pitch) -> Int
> pitchDiff (a, b) = abs $ absPitch a - absPitch b

In order to enforce rule of thumb #3 we need to be able to calculate 
the melodic difference between two *chords* we create the function 
melodydifference. 

Example: 
  *AutoComp> melodyDifference [(E,4), (G,4), (C,5)] [(D,4), (G,4), (B,4)]
  3

> melodyDifference :: [Pitch] -> [Pitch] -> Int
> melodyDifference a b = sum $ map pitchDiff (zip (sortChord a) (sortChord b))

In order to easily calculate the lowest melodic difference 
between two chords, we need to be able simply to sort the melodies 
of the *chord*.

> sortChord :: [Pitch] -> [Pitch]
> sortChord = sortBy (comparing absPitch)

As said before, for the first chord in any given ChordProgression we will
find the tightest *chord* for the first element.

For example:
  *AutoComp> tighten (C, Major, 1)
  [(C,5),(E,5),(G,5)]


> tighten :: Chord -> [Pitch]
> tighten xs = getTightestChord $ generateAllChords xs 
>  where 
>   getTightestChord :: [[Pitch]] -> [Pitch]
>   getTightestChord = head . sortBy (comparing tightness) 
>   tightness :: [Pitch] -> Int
>   tightness p = absPitch(last (sortChord p)) - absPitch(head (sortChord p)) 

And for the remaining *chords* we need to be able to find the *chord*
which has the lowest melodic difference in relation to the previous.

> minChordDiff :: [Pitch] -> Chord -> [Pitch]
> minChordDiff prev = calcMin prev . generateAllChords 
>  where
>  calcMin :: [Pitch] -> [[Pitch]] -> [Pitch]
>  calcMin = minimumBy . comparing . chordDiff
>  chordDiff c1 c2 = sum $ map pitchDiff $ zip (sortChord c1) (sortChord c2)

To convert our *chords* to music we will have to get the duration of the previous Chord.
This function converts a Chord into notes played in parallel. 

> chordToMusic :: [Pitch] -> Chord -> Music
> chordToMusic ps (_, _, dur) = foldr1 (:=:) (map (\x -> (Note x dur [Volume 60])) ps)

The next part of this problem is to create a function autoComp, which combines autoBass
and autoChord:

> autoComp :: BassStyle -> ChordProgression -> Music
> autoComp bs cp = Instr "bass" (Tempo 3 $ autoBass bs cp) :=:  Instr "guitar" (Tempo 3 $ autoChord cp)





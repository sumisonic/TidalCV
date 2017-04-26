module Sound.Tidal.Sumisonic.CvOsc where
import Sound.Tidal.OscStream
import Sound.Tidal.Context as C
import Sound.OSC.FD as C

cvShape = Shape {
  params = [
    F "cv" (Just 0.0),
    F "glide" (Just 0.0),
    F "curve" (Just 0.0)
  ],
  cpsStamp = True,
  C.latency = 0.02
}

cvSlang ch = OscSlang {
  path = "/cv",
  timestamp = NoStamp,
  namedParams = True,
  preamble = [C.string "ch", C.int32 ch]
}

cvStream port ch = do
  s <- makeConnection "127.0.0.1" port (cvSlang ch)
  stream (Backend s $ (\_ _ _ -> return ())) cvShape

cv = makeF cvShape "cv"
glide = makeF cvShape "glide"
curve = makeF cvShape "curve"

cvnote :: Pattern String -> ParamPattern
cvnote = cv.(readCV <$>)

readCV :: String -> Double
readCV s@(n:ns)
  | n == 'c' = note 0 ns
  | n == 'd' = note 2 ns
  | n == 'e' = note 4 ns
  | n == 'f' = note 5 ns
  | n == 'g' = note 7 ns
  | n == 'a' = note 9 ns
  | n == 'b' = note 11 ns
  | otherwise = read s :: Double
  where
    note :: Double -> String -> Double
    note i s = (i + modifireAndOctave s) / 120.0
    modifireAndOctave :: String -> Double
    modifireAndOctave s@(m:ms)
      | m == 's' = 1 + octave ms
      | m == 'f' = (-1) + octave ms
      | otherwise = octave s
    octave :: String -> Double
    octave o = ((read o :: Double)+2) * 12

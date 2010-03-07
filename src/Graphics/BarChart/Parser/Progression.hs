{-# LANGUAGE NamedFieldPuns, RecordWildCards #-}

module Graphics.BarChart.Parser.Progression where

import Text.CSV

import System.FilePath

import Graphics.BarChart.Types
import Graphics.BarChart.Parser
import Graphics.BarChart.Rendering

-- | Used by 'writeProgressionChart' to generate a bar chart from
--   progression's @plot.csv@ file.
-- 
progressionChart :: Bool -> [Label] -> CSV -> BarChart Ratio
progressionChart flip labels csv
  = drawMultiBarIntervals
  . (if flip then flipMultiBarIntervals else id)
  . parseMultiBarIntervals block_labels
  $ csv
 where block_labels | null labels = replicate (length csv) ""
                    | otherwise   = labels

-- | Reads the @plot.csv@ file generated by progression and creates a
--   corresponding bar chart.
-- 
writeProgressionChart :: Bool -> Config -> FilePath -> [Label] -> IO ()
writeProgressionChart flip config@Config{..} file block_labels =
  do csv <- readCSV file
     let chart = progressionChart flip block_labels csv
     renderWith config chart
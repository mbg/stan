module Main (main) where

import HieTypes (HieFile (..))
import Test.Hspec (hspec)

import Stan.Hie (readHieFiles)
import Test.Stan.Analysis (analysisSpec)
import Test.Stan.Inspection (inspectionsSpec)
import Test.Stan.Number (linesOfCodeSpec, modulesNumSpec)
import Test.Stan.Observation (observationSpec)


main :: IO ()
main = do
    hieFiles <- readHieFiles ".hie"
    case filter isTargetFile hieFiles of
        [] -> do
            putStrLn "FAILED: target/ files are not found"
            exitFailure
        testHies -> do
            Just exampleHie <- pure $
                find ((==) "target/Target/Partial.hs" . hie_hs_file) testHies
            hspec $ do
                linesOfCodeSpec exampleHie
                modulesNumSpec $ length hieFiles
                inspectionsSpec
                observationSpec
                analysisSpec testHies

isTargetFile :: HieFile -> Bool
isTargetFile HieFile{..} = "target" `isPrefixOf` hie_hs_file

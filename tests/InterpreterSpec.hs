{-# LANGUAGE OverloadedLists       #-}
module InterpreterSpec (classIncludeSpec, main) where

import           Helpers

import qualified Data.Text                as Text



classIncludeSpec :: Spec
classIncludeSpec = do
  describe "Multiple loading" $ do
    it "should work when using several include statements" $
      pureCatalog (Text.unlines ["include foo", "include foo"]) `shouldSatisfy` (has _Right)
    it "should work when using class before include" $
      pureCatalog (Text.unlines [ "class { 'foo': }", "include foo"]) `shouldSatisfy` (has _Right)
    it "should fail when using include before class" $
      pureCatalog (Text.unlines [ "include foo", "class { 'foo': }" ]) `shouldSatisfy` (has _Left)

main :: IO ()
main = hspec $ do
  describe "Class inclusion" classIncludeSpec

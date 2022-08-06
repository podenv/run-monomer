{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

-- |
-- Module      : Tutorial01_Basics
-- Copyright   : (c) 2018 Francisco Vallarino
-- License     : BSD-3-Clause (see the LICENSE file)
-- Maintainer  : fjvallarino@gmail.com
-- Stability   : experimental
-- Portability : non-portable
--
-- Main module for the '01 - Basics' tutorial.
module Main where

import Data.Text (Text, pack)
import Monomer
import System.Environment (getEnv)
import TextShow

newtype AppModel = AppModel
  { counter :: Int
  }
  deriving (Eq, Show)

data AppEvent
  = AppInit
  | AppIncrease
  deriving (Eq, Show)

buildUI :: WidgetEnv AppModel AppEvent -> AppModel -> WidgetNode AppModel AppEvent
buildUI wenv model =
  vstack
    [ label "Hello world",
      spacer,
      hstack
        [ label $ "Click count: " <> showt (model.counter),
          spacer,
          button "Increase count" AppIncrease
        ]
    ]
    `styleBasic` [padding 10]

handleEvent ::
  WidgetEnv AppModel AppEvent ->
  WidgetNode AppModel AppEvent ->
  AppModel ->
  AppEvent ->
  [AppEventResponse AppModel AppEvent]
handleEvent wenv node model evt = case evt of
  AppInit -> []
  AppIncrease -> [Model (model {counter = model.counter + 1})]

main :: IO ()
main = do
  robotFont <- pack <$> getEnv "ROBOTO_TTF"
  startApp model handleEvent buildUI (config robotFont)
  where
    config f =
      [ appWindowTitle "Tutorial 01 - Basics",
        appTheme darkTheme,
        appFontDef "Regular" f,
        appInitEvent AppInit
      ]
    model = AppModel 0

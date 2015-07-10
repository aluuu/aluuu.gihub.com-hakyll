{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend)
import Hakyll

postCtx :: Context String
postCtx =
    dateField "date" "%d.%m.%Y" `mappend`
    defaultContext

main :: IO ()
main = hakyll $ do
    match "images/*" $
          do
            route idRoute
            compile copyFileCompiler

    match "css/*" $
          do
            route idRoute
            compile compressCssCompiler

    match "posts/ru/*" $
          do
            route $ setExtension "html"
            compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/post.html"    postCtx
                >>= loadAndApplyTemplate "templates/default.html" postCtx
                >>= relativizeUrls

    match "templates/index.html" $ do
        route $ constRoute "index.html"
        compile $ do
            posts <- loadAll "posts/ru/*" >>= recentFirst
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    defaultContext
            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "pages/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
                >>= loadAndApplyTemplate "templates/default.html" defaultContext
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend)
import Hakyll

matchPosts lang =
    match pattern $ do
      route $ setExtension "html"
      compile $ pandocCompiler
                  >>= loadAndApplyTemplate "templates/post.html"    postCtx
                  >>= loadAndApplyTemplate "templates/default.html" postCtx
                  >>= relativizeUrls
    where pattern = fromGlob ("posts/" ++ lang ++ "/*")

matchArchive lang =
    create [pattern] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll postsPattern
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives" `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls
    where pattern = fromFilePath ("archive_" ++ lang ++ ".html")
          postsPattern = fromGlob ("posts/" ++ lang ++ "/*")

main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route idRoute
        compile compressCssCompiler

    matchPosts "ru"
    matchPosts "en"

    matchArchive "ru"
    matchArchive "en"

    match "index.html" $ do
        route idRoute
        compile $ do
            let indexCtx =
                    constField "title" "Home" `mappend`
                    defaultContext
            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

postCtx :: Context String
postCtx =
    dateField "date" "%d.%m.%Y" `mappend`
    defaultContext

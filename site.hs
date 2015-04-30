{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend)
import Hakyll

lastNPosts n pattern=
    fmap (take n) $ loadAll pattern >>= recentFirst

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
            ru_posts <- lastNPosts 5 "posts/ru/*"
            en_posts <- lastNPosts 5 "posts/en/*"
            let indexCtx =
                    listField "ru_posts" postCtx (return ru_posts) `mappend`
                    listField "en_posts" postCtx (return en_posts) `mappend`
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

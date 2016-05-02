--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    -- Images
    -- TODO(alemedeiros): compress images before deploying / try to make this automatic
    match ("images/*" .||. "favicon.ico") $ do
        route   idRoute
        compile copyFileCompiler

    -- CSS
    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    -- Files
    match ("files/*" .||. "files/*/*" .||. "files/*/*/*" .||. "files/*/*/*/*") $ do
        route   idRoute
        compile copyFileCompiler

    -- Content pages
    match (fromList ["about.md", "contact.md"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/content.html" defaultContext
            >>= loadAndApplyTemplate "templates/base.html"    defaultContext
            >>= relativizeUrls

    -- TODO(alemedeiros): Teaching pages

    -- TODO(alemedeiros): Create Categories pages
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")
    tagsRules tags $ \tag pattern -> do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll pattern
            let tagCtx =
                    constField "title" (tag ++ " Posts")                    `mappend`
                    constField "tab_blog" ""                                `mappend`
                    listField "posts" (postCtxWithTags tags) (return posts) `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" tagCtx
                >>= loadAndApplyTemplate "templates/base.html"    tagCtx
                >>= relativizeUrls

    -- Posts
    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/content.html" (postCtxWithTags tags)
            >>= loadAndApplyTemplate "templates/base.html"    (postCtxWithTags tags)
            >>= relativizeUrls

    -- Blog main page
    -- TODO(alemedeiros): Paginate blog page
    create ["blog.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAllSnapshots "posts/*" "content"
            let archiveCtx =
                    constField "tab_blog" ""                                `mappend`
                    listField "posts" (postCtxWithTags tags) (return posts) `mappend`
                    constField "title" "Blog posts"                         `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/base.html"    archiveCtx
                >>= relativizeUrls

    -- Main page
    match "index.md" $ do
        route $ setExtension "html"
        compile $ do
            posts <- fmap (take 3) .
                    recentFirst =<< loadAllSnapshots "posts/*" "content"
            let indexCtx =
                    constField "tab_home" ""                                `mappend`
                    constField "card" ""                                    `mappend`
                    listField "posts" (postCtxWithTags tags) (return posts) `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/archive.html" indexCtx
                >>= loadAndApplyTemplate "templates/base.html"    indexCtx
                >>= relativizeUrls

    -- Templates
    match "templates/*" $ compile templateBodyCompiler

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    teaserField "teaser" "content" `mappend`
    constField "tab_blog" "" `mappend`
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

postCtxWithTags :: Tags -> Context String
postCtxWithTags tags = tagsField "tags" tags `mappend` postCtx

--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

import           Data.List                      ( intersperse )
import           Data.Monoid                    ( mappend )
import           Text.Blaze.Html                ( toHtml
                                                , toValue
                                                , (!)
                                                )
import qualified Text.Blaze.Html5              as H
import qualified Text.Blaze.Html5.Attributes   as A

import           Hakyll

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
  -- Images
  -- TODO: compress images before deploying / try to make this automatic
  match ("images/*" .||. "favicon.ico") $ do
    route idRoute
    compile copyFileCompiler

  -- CSS
  match "css/*" $ do
    route idRoute
    compile compressCssCompiler

  -- Files
  match ("files/*" .||. "files/*/*" .||. "files/*/*/*" .||. "files/*/*/*/*")
    $ do
        route idRoute
        compile copyFileCompiler

  -- Content pages
  match (fromList ["about.md", "contact.md"]) $ do
    route $ setExtension "html"
    compile
      $   pandocCompiler
      >>= loadAndApplyTemplate "templates/content.html" defaultContext
      >>= loadAndApplyTemplate "templates/base.html"    defaultContext
      >>= relativizeUrls

  -- TODO: Teaching pages

  -- TODO: Create Categories pages
  tags <- buildTags "posts/*" (fromCapture "tags/*.html")
  tagsRules tags $ \tag pattern -> do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAll pattern
      let tagCtx =
            constField "title" (tag ++ " Posts")
              `mappend` constField "tab_blog" ""
              `mappend` listField "posts"
                                  (postCtxWithChipTags tags)
                                  (return posts)
              `mappend` defaultContext

      makeItem ""
        >>= loadAndApplyTemplate "templates/archive.html" tagCtx
        >>= loadAndApplyTemplate "templates/base.html"    tagCtx
        >>= relativizeUrls

  -- Posts
  match "posts/*" $ do
    route $ setExtension "html"
    compile
      $   pandocCompiler
      >>= saveSnapshot "content"
      >>= loadAndApplyTemplate "templates/content.html"
                               (postCtxWithChipTags tags)
      >>= loadAndApplyTemplate "templates/base.html" (postCtxWithChipTags tags)
      >>= relativizeUrls

  -- Blog main page
  -- TODO: Paginate blog page
  create ["blog.html"] $ do
    route idRoute
    compile $ do
      posts <- recentFirst =<< loadAllSnapshots "posts/*" "content"
      let archiveCtx =
            constField "tab_blog" ""
              `mappend` listField "posts"
                                  (postCtxWithChipTags tags)
                                  (return posts)
              `mappend` constField "title" "Blog posts"
              `mappend` defaultContext

      makeItem ""
        >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
        >>= loadAndApplyTemplate "templates/base.html"    archiveCtx
        >>= relativizeUrls

  -- Main page
  match "index.md" $ do
    route $ setExtension "html"
    compile $ do
      posts <- fmap (take 3) . recentFirst =<< loadAllSnapshots "posts/*"
                                                                "content"
      let indexCtx =
            constField "tab_home" ""
              `mappend` constField "card" ""
              `mappend` listField "posts"
                                  (postCtxWithChipTags tags)
                                  (return posts)
              `mappend` defaultContext

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
  teaserField "teaser" "content"
    `mappend` constField "tab_blog" ""
    `mappend` dateField "date" "%e %B, %Y"
    `mappend` defaultContext

postCtxWithTags :: Tags -> Context String
postCtxWithTags tags = tagsField "tags" tags `mappend` postCtx

postCtxWithChipTags :: Tags -> Context String
postCtxWithChipTags tags =
  tagsFieldWith getTags
                renderTagWithChip
                (mconcat . intersperse " ")
                "chiptags"
                tags
    `mappend` (postCtxWithTags tags)
 where
  renderTagWithChip _ Nothing = Nothing
  renderTagWithChip tag (Just filePath) =
    Just $ H.a ! A.href (toValue $ toUrl filePath) $ mdlChip $ toHtml tag

  mdlChip =
    (H.span ! A.class_ "mdl-chip") . (H.span ! A.class_ "mdl-chip__text")

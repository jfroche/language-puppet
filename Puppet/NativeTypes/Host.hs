module Puppet.NativeTypes.Host (nativeHost) where

import Puppet.NativeTypes.Helpers
import Puppet.Interpreter.Types
import Data.Char (isAlphaNum)
import qualified Data.Text as T
import Control.Lens
import qualified Data.Vector as V

nativeHost :: (NativeTypeName, NativeTypeMethods)
nativeHost = ("host", nativetypemethods parameterfunctions return)

-- Autorequires: If Puppet is managing the user or group that owns a file, the file resource will autorequire them. If Puppet is managing any parent directories of a file, the file resource will autorequire them.
parameterfunctions :: [(T.Text, [T.Text -> NativeTypeValidate])]
parameterfunctions =
    [("comment"      , [string, values ["true","false"]])
    ,("ensure"       , [defaultvalue "present", string, values ["present","absent"]])
    ,("host_aliases" , [rarray, strings, checkhostname])
    ,("ip"           , [string, mandatory, ipaddr])
    ,("name"         , [nameval, checkhostname])
    ,("provider"     , [string, values ["parsed"]])
    ,("target"       , [string, fullyQualified])
    ]

checkhostname :: T.Text -> NativeTypeValidate
checkhostname param res = case res ^. rattributes . at param of
    Nothing            -> Right res
    Just (PArray xs)   -> V.foldM (checkhostname' param) res xs
    Just x@(PString _) -> checkhostname' param res x
    Just x             -> perror $ paramname param <+> "should be an array or a single string, not" <+> pretty x

checkhostname' :: T.Text -> Resource -> PValue -> Either PrettyError Resource
checkhostname' prm _   (PString "") = perror $ "Empty hostname for parameter" <+> paramname prm
checkhostname' prm res (PString x ) = checkhostname'' prm res x
checkhostname' prm _   x            = perror $ "Parameter " <+> paramname prm <+> "should be an string or an array of strings, but this was found :" <+> pretty x

checkhostname'' :: T.Text -> Resource -> T.Text -> Either PrettyError Resource
checkhostname'' prm _   "" = perror $ "Empty hostname part in parameter" <+> paramname prm
checkhostname'' prm res prt =
    let (cur,nxt) = T.break (=='.') prt
        nextfunc = if T.null nxt
                        then Right res
                        else checkhostname'' prm res (T.tail nxt)
    in if T.null cur || (T.head cur == '-') || not (T.all (\x -> isAlphaNum x || (x=='-')) cur)
            then perror $ "Invalid hostname part for parameter" <+> paramname prm
            else nextfunc

package com.rokannon.core.utils.string
{
    public function getExtension(path:String, pathSeparator:String = "/"):String
    {
        var indexOfDot:int = path.lastIndexOf(".");
        var indexOfSlash:int = path.lastIndexOf(pathSeparator);
        if (indexOfDot <= indexOfSlash)
            return "";
        return cleanMasterString(path.substr(indexOfDot + 1).toLowerCase());
    }
}
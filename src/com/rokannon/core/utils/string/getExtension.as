package com.rokannon.core.utils.string
{
    public function getExtension(string:String):String
    {
        var indexOfDot:int = string.lastIndexOf(".");
        var indexOfSlash:int = string.lastIndexOf("/");
        if (indexOfDot <= indexOfSlash)
            return "";
        return cleanMasterString(string.substr(indexOfDot + 1).toLowerCase());
    }
}
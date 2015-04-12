package com.rokannon.core.utils.string
{
    public function trimExtension(path:String):String
    {
        var index:uint = path.lastIndexOf(".");
        return cleanMasterString(index == -1 ? path : path.substr(0, index));
    }
}
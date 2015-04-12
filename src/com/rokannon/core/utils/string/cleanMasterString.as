package com.rokannon.core.utils.string
{
    public function cleanMasterString(string:String):String
    {
        return ("_" + string).substr(1);
    }
}
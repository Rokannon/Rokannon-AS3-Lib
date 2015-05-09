package com.rokannon.core.utils.dictionary
{
    import flash.utils.Dictionary;

    public function isDictionaryEmpty(dictionary:Dictionary):Boolean
    {
        for (var key:* in dictionary)
            return false;
        return true;
    }
}
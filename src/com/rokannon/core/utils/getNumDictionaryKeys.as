package com.rokannon.core.utils
{
    import flash.utils.Dictionary;

    public function getNumDictionaryKeys(dictionary:Dictionary):uint
    {
        var numKeys:uint = 0;
        for (var key:* in dictionary)
            ++numKeys;
        return numKeys;
    }
}
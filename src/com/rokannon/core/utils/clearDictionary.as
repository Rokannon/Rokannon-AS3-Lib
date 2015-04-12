package com.rokannon.core.utils
{
    import flash.utils.Dictionary;

    public function clearDictionary(dictionary:Dictionary):void
    {
        for (var key:* in dictionary)
            delete dictionary[key];
    }
}
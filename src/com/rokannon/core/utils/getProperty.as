package com.rokannon.core.utils
{
    public function getProperty(data:Object, name:String, defaultValue:*):*
    {
        if (!data.hasOwnProperty(name))
            return defaultValue;
        return data[name];
    }
}
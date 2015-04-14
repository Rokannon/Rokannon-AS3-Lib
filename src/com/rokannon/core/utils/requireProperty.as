package com.rokannon.core.utils
{
    import com.rokannon.core.utils.string.stringFormat;

    public function requireProperty(data:Object, name:String):*
    {
        if (!data.hasOwnProperty(name))
            throw new Error(stringFormat("Property not found: {0}", name));
        return data[name];
    }
}
package com.rokannon.core.utils
{
    import com.rokannon.core.utils.string.stringFormat;

    /**
     * Returns object property value in a more controlled way.
     * @param data Object to get value from.
     * @param name Name of a property.
     * @param defaultValue Default value returned if no property if not found.
     * If no default value specified exception will be thrown.
     */
    public function getProperty(data:Object, name:String, defaultValue:* = null):*
    {
        if (!data.hasOwnProperty(name))
        {
            if (defaultValue == null)
                throw new Error(stringFormat("Property '{0}' not found and there's no default value.", name));
            return defaultValue;
        }
        return data[name];
    }
}
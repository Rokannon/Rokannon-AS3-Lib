package com.rokannon.core.utils.classUtils
{
    import avmplus.describeType;

    import com.rokannon.core.ClassUtilsCache;

    public function getClassProperties(classDefinition:Class, classUtilsCache:ClassUtilsCache = null):Vector.<String>
    {
        var xml:XML;
        if (classUtilsCache == null)
            xml = describeType(classDefinition, ~0);
        else
            xml = classUtilsCache.describeType(classDefinition);

        var properties:Vector.<String> = new Vector.<String>();
        for each (var variable:XML in xml.factory.variable)
            properties.push(variable.@name);
        return properties;
    }
}
package com.rokannon.core.utils.classUtils
{
    import com.rokannon.core.ClassUtilsCache;

    import flash.utils.describeType;

    public function getClassVariables(classDefinition:Class, type:String = null,
                                      classUtilsCache:ClassUtilsCache = null):Vector.<String>
    {
        var xml:XML;
        if (classUtilsCache == null)
            xml = describeType(classDefinition);
        else
            xml = classUtilsCache.describeType(classDefinition);

        var variables:Vector.<String> = new <String>[];
        for each (var variable:XML in xml.factory.variable)
        {
            if (type == null || type == variable.@type)
                variables.push(variable.@name);
        }
        return variables;
    }
}
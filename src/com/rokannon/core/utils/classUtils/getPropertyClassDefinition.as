package com.rokannon.core.utils.classUtils
{
    import avmplus.describeType;

    import com.rokannon.core.ClassUtilsCache;

    import flash.utils.getDefinitionByName;

    public function getPropertyClassDefinition(classDefinition:Class, propertyName:String,
                                               classUtilsCache:ClassUtilsCache = null):Class
    {
        var xml:XML;
        if (classUtilsCache == null)
            xml = describeType(classDefinition, ~0);
        else
            xml = classUtilsCache.describeType(classDefinition);

        for each (var variable:XML in xml.factory.variable)
        {
            if (variable.@name != propertyName)
                continue;
            if (classUtilsCache == null)
                return getDefinitionByName(variable.@type) as Class;
            else
                return classUtilsCache.getDefinitionByName(variable.@type) as Class;
        }
        return null;
    }
}
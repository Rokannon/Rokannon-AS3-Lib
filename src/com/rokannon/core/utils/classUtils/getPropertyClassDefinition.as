package com.rokannon.core.utils.classUtils
{
    import com.rokannon.core.ClassUtilsCache;

    import flash.utils.describeType;

    import flash.utils.getDefinitionByName;

    public function getPropertyClassDefinition(classDefinition:Class, propertyName:String,
                                               classUtilsCache:ClassUtilsCache = null):Class
    {
        var xml:XML;
        if (classUtilsCache == null)
            xml = describeType(classDefinition);
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
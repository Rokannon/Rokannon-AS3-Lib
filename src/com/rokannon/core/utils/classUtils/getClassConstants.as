package com.rokannon.core.utils.classUtils
{
    import com.rokannon.core.ClassUtilsCache;

    import flash.utils.describeType;

    public function getClassConstants(classDefinition:Class, type:String = null,
                                      classUtilsCache:ClassUtilsCache = null):Vector.<String>
    {
        var xml:XML;
        if (classUtilsCache == null)
            xml = describeType(classDefinition);
        else
            xml = classUtilsCache.describeType(classDefinition);

        var constants:Vector.<String> = new <String>[];
        for each (var constant:XML in xml.factory.constant)
        {
            if (type == null || type == constant.@type)
                constants.push(constant.@name);
        }
        return constants;
    }
}
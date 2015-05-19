package com.rokannon.core.utils.classUtils
{
    import avmplus.getQualifiedClassName;

    import com.rokannon.core.ClassUtilsCache;

    import flash.utils.describeType;

    public function extendsClass(classDefinition1:Class, classDefinition2:Class,
                                 classUtilsCache:ClassUtilsCache = null):Boolean
    {
        var className:String;
        if (classUtilsCache == null)
            className = getQualifiedClassName(classDefinition2);
        else
            className = classUtilsCache.getQualifiedClassName(classDefinition2);

        var xml:XML;
        if (classUtilsCache == null)
            xml = describeType(classDefinition1);
        else
            xml = classUtilsCache.describeType(classDefinition1);

        for each (var classXML:XML in xml.factory.extendsClass)
        {
            if (classXML.@type == className)
                return true;
        }
        return false;
    }
}
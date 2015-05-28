package com.rokannon.core.utils.classUtils
{
    import avmplus.getQualifiedClassName;

    import com.rokannon.core.ClassUtilsCache;

    import flash.utils.describeType;

    public function implementsInterface(classDefinition:Class, interfaceDefinition:Class,
                                        classUtilsCache:ClassUtilsCache = null):Boolean
    {
        var interfaceName:String;
        if (classUtilsCache == null)
            interfaceName = getQualifiedClassName(interfaceDefinition);
        else
            interfaceName = classUtilsCache.getQualifiedClassName(interfaceDefinition);

        var xml:XML;
        if (classUtilsCache == null)
            xml = describeType(classDefinition);
        else
            xml = classUtilsCache.describeType(classDefinition);

        for each (var interfaceXML:XML in xml.factory.implementsInterface)
        {
            if (interfaceXML.@type == interfaceName)
                return true;
        }
        return false;
    }
}
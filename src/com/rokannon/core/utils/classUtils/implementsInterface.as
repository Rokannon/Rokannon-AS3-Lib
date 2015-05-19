package com.rokannon.core.utils.classUtils
{
    import avmplus.describeType;
    import avmplus.getQualifiedClassName;

    import com.rokannon.core.ClassUtilsCache;

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
            xml = describeType(classDefinition, ~0);
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
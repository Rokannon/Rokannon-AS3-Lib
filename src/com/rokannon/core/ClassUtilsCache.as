package com.rokannon.core
{
    import avmplus.getQualifiedClassName;

    import com.rokannon.core.errors.SingletonClassError;
    import com.rokannon.core.utils.classUtils.extendsClass;
    import com.rokannon.core.utils.classUtils.getClassStaticConstants;
    import com.rokannon.core.utils.classUtils.getClassVariables;
    import com.rokannon.core.utils.classUtils.getPropertyClassDefinition;
    import com.rokannon.core.utils.classUtils.implementsInterface;

    import flash.utils.Dictionary;
    import flash.utils.describeType;

    public class ClassUtilsCache
    {
        public static const instance:ClassUtilsCache = new ClassUtilsCache();

        private const _typeDescriptionByValue:Dictionary = new Dictionary(true);
        private const _definitionByName:Dictionary = new Dictionary();
        private const _nameByValue:Dictionary = new Dictionary(true);
        private const _propertiesByClass:Dictionary = new Dictionary();
        private const _classDefinitionByClassAndName:TwoKeysDictionary = new TwoKeysDictionary();
        private const _extendsClassByClasses:TwoKeysDictionary = new TwoKeysDictionary();
        private const _constantsByClassAndType:TwoKeysDictionary = new TwoKeysDictionary();
        private const _implementsInterfaceByClassAndInterface:TwoKeysDictionary = new TwoKeysDictionary();

        public function ClassUtilsCache()
        {
            if (instance != null)
                throw new SingletonClassError();
        }

        //
        // Native utils
        //

        public function describeType(value:*):XML
        {
            if (!(value in _typeDescriptionByValue))
                _typeDescriptionByValue[value] = flash.utils.describeType(value);
            return _typeDescriptionByValue[value];
        }

        public function getDefinitionByName(name:String):Object
        {
            if (!(name in _definitionByName))
                _definitionByName[name] = flash.utils.getDefinitionByName(name);
            return _definitionByName[name];
        }

        public function getQualifiedClassName(value:*):String
        {
            if (!(value in _nameByValue))
                _nameByValue[value] = avmplus.getQualifiedClassName(value);
            return _nameByValue[value];
        }

        //
        // com.rokannon.core.utils.classUtils
        //

        public function getClassVariables(classDefinition:Class):Vector.<String>
        {
            if (!(classDefinition in _propertiesByClass))
                _propertiesByClass[classDefinition] = com.rokannon.core.utils.classUtils.getClassVariables(classDefinition,
                    this);
            return _propertiesByClass[classDefinition];
        }

        public function getPropertyClassDefinition(classDefinition:Class, propertyName:String):Class
        {
            if (!_classDefinitionByClassAndName.hasValue(classDefinition, propertyName))
                _classDefinitionByClassAndName.setValue(classDefinition, propertyName,
                    com.rokannon.core.utils.classUtils.getPropertyClassDefinition(classDefinition, propertyName, this));
            return _classDefinitionByClassAndName.getValue(classDefinition, propertyName);
        }

        public function extendsClass(classDefinition1:Class, classDefinition2:Class):Boolean
        {
            if (!_extendsClassByClasses.hasValue(classDefinition1, classDefinition2))
                _extendsClassByClasses.setValue(classDefinition1, classDefinition2,
                    com.rokannon.core.utils.classUtils.extendsClass(classDefinition1, classDefinition2, this));
            return _extendsClassByClasses.getValue(classDefinition1, classDefinition2);
        }

        public function getClassStaticConstants(classDefinition:Class, type:String = null):Vector.<String>
        {
            if (!_constantsByClassAndType.hasValue(classDefinition, type))
                _constantsByClassAndType.setValue(classDefinition, type,
                    com.rokannon.core.utils.classUtils.getClassStaticConstants(classDefinition, type, this));
            return _constantsByClassAndType.getValue(classDefinition, type);
        }

        public function implementsInterface(classDefinition:Class, interfaceDefinition:Class):Boolean
        {
            if (!_implementsInterfaceByClassAndInterface.hasValue(classDefinition, interfaceDefinition))
                _implementsInterfaceByClassAndInterface.setValue(classDefinition, interfaceDefinition,
                    com.rokannon.core.utils.classUtils.implementsInterface(classDefinition, interfaceDefinition, this));
            return _implementsInterfaceByClassAndInterface.getValue(classDefinition, interfaceDefinition);
        }
    }
}
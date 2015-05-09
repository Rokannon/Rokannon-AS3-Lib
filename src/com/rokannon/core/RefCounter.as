package com.rokannon.core
{
    import com.rokannon.core.errors.SingletonClassError;
    import com.rokannon.core.utils.dictionary.getNumDictionaryKeys;

    import flash.utils.Dictionary;

    public class RefCounter
    {
        public static const instance:RefCounter = new RefCounter();

        private const _refsByType:Dictionary = new Dictionary();
        private const _refTypes:Vector.<String> = new <String>[];

        public function RefCounter()
        {
            if (instance != null)
                throw new SingletonClassError();
        }

        public function get refTypes():Vector.<String>
        {
            return _refTypes;
        }

        public function addRef(ref:*, refType:String):void
        {
            getRefsByType(refType)[ref] = true;
        }

        public function getNumRefsByType(refType:String):uint
        {
            return getNumDictionaryKeys(getRefsByType(refType));
        }

        private function getRefsByType(refType:String):Dictionary
        {
            if (_refsByType[refType] == null)
            {
                _refsByType[refType] = new Dictionary(true);
                _refTypes.push(refType);
            }
            return _refsByType[refType];
        }
    }
}
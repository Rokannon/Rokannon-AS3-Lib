package com.rokannon.core
{
    import com.rokannon.core.errors.SingletonClassError;
    import com.rokannon.core.utils.getNumDictionaryKeys;

    import flash.utils.Dictionary;

    public class ReferenceManager
    {
        public static const instance:ReferenceManager = new ReferenceManager();

        private const _refsByType:Dictionary = new Dictionary();

        public function ReferenceManager()
        {
            if (instance != null)
                throw new SingletonClassError();
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
                _refsByType[refType] = new Dictionary(true);
            return _refsByType[refType];
        }
    }
}
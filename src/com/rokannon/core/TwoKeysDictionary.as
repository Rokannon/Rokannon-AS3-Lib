package com.rokannon.core
{
    import com.rokannon.core.utils.dictionary.clearDictionary;
    import com.rokannon.core.utils.dictionary.isDictionaryEmpty;

    import flash.utils.Dictionary;

    public class TwoKeysDictionary
    {
        private static const dictionaryPool:Vector.<Dictionary> = new Vector.<Dictionary>();

        private var _valueByKey1AndKey2:Dictionary;

        public function TwoKeysDictionary()
        {
            _valueByKey1AndKey2 = createDictionary();
        }

        public function setValue(key1:*, key2:*, value:*):void
        {
            if (!(key1 in _valueByKey1AndKey2))
                _valueByKey1AndKey2[key1] = createDictionary();
            var valueByKey2:Dictionary = _valueByKey1AndKey2[key1];
            if (!(key2 in valueByKey2))
                valueByKey2[key2] = createDictionary();
            valueByKey2[key2] = value;
        }

        public function getValue(key1:*, key2:*):*
        {
            if (!(key1 in _valueByKey1AndKey2))
                return null;
            var valueByKey2:Dictionary = _valueByKey1AndKey2[key1];
            if (!(key2 in valueByKey2))
                return null;
            return valueByKey2[key2];
        }

        public function hasValue(key1:*, key2:*):Boolean
        {
            if (!(key1 in _valueByKey1AndKey2))
                return false;
            var valueByKey2:Dictionary = _valueByKey1AndKey2[key1];
            return key2 in valueByKey2;
        }

        public function deleteValue(key1:*, key2:*):void
        {
            if (!(key1 in _valueByKey1AndKey2))
                return;
            var valueByKey2:Dictionary = _valueByKey1AndKey2[key1];
            if (key2 in valueByKey2)
                delete valueByKey2[key2];
            if (isDictionaryEmpty(valueByKey2))
            {
                delete _valueByKey1AndKey2[key1];
                releaseDictionary(valueByKey2);
            }
        }

        public function getValuesByKey1(key1:*, resultValues:Array = null):Array
        {
            if (resultValues == null)
                resultValues = [];
            if (key1 in _valueByKey1AndKey2)
            {
                var valueByKey2:Dictionary = _valueByKey1AndKey2[key1];
                var numValues:uint = 0;
                for each (var value:* in valueByKey2)
                    resultValues[numValues++] = value;
            }
            return resultValues;
        }

        public function clear():void
        {
            for each (var dictionary:Dictionary in _valueByKey1AndKey2)
                releaseDictionary(dictionary);
            releaseDictionary(_valueByKey1AndKey2);
        }

        [Inline]
        private static function createDictionary():Dictionary
        {
            return dictionaryPool.pop() || new Dictionary();
        }

        [Inline]
        private static function releaseDictionary(dictionary:Dictionary):void
        {
            clearDictionary(dictionary);
            dictionaryPool.push(dictionary);
        }
    }
}
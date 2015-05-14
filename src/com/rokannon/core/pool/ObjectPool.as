package com.rokannon.core.pool
{
    import com.rokannon.core.ClassUtilsCache;
    import com.rokannon.core.errors.SingletonClassError;
    import com.rokannon.logging.Log;
    import com.rokannon.logging.Logger;

    import flash.utils.Dictionary;

    public class ObjectPool
    {
        public static const instance:ObjectPool = new ObjectPool();

        private static const logger:Logger = Log.instance.getLogger(ObjectPool);
        private static const classUtilsCache:ClassUtilsCache = ClassUtilsCache.instance;

        private var _objectsByClass:Dictionary = new Dictionary();
        private var _classByObject:Dictionary = new Dictionary();

        public function ObjectPool()
        {
            if (instance != null)
                throw new SingletonClassError();
        }

        public function createObject(objectClass:Class):IPoolObject
        {
            CONFIG::log_fatal
            {
                if (!classUtilsCache.implementsInterface(objectClass, IPoolObject))
                    logger.fatal("Attempt to create pool object using invalid object class.");
            }
            var objects:Vector.<IPoolObject> = getObjectsByClass(objectClass);
            var object:IPoolObject;
            if (objects.length == 0)
            {
                object = new objectClass();
                _classByObject[object] = objectClass;
            }
            else
                object = objects.pop();
            return object;
        }

        public function releaseObject(object:IPoolObject):void
        {
            object.resetPoolObject();
            var objectClass:Class = _classByObject[object];
            CONFIG::log_fatal
            {
                if (objectClass == null)
                    logger.fatal("No object class found during attempt to release pool object.");
            }
            getObjectsByClass(objectClass).push(objectClass);
        }

        private function getObjectsByClass(objectClass:Class):Vector.<IPoolObject>
        {
            var objects:Vector.<IPoolObject>;
            if (objectClass in _objectsByClass)
                objects = _objectsByClass[objectClass];
            else
            {
                objects = new <IPoolObject>[];
                _objectsByClass[objectClass] = objects;
            }
            return objects;
        }
    }
}
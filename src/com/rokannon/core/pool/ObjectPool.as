package com.rokannon.core.pool
{
    import com.rokannon.core.Broadcaster;
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

        private const _objectsByClass:Dictionary = new Dictionary();
        private const _classByObject:Dictionary = new Dictionary();
        private const _handlerClassByObjectClass:Dictionary = new Dictionary();
        private const _handlerByObject:Dictionary = new Dictionary();

        public function ObjectPool()
        {
            if (instance != null)
                throw new SingletonClassError();
        }

        public function registerPoolObjectHandler(objectClass:Class, handlerClass:Class):void
        {
            _handlerClassByObjectClass[objectClass] = handlerClass;
        }

        public function createObject(objectClass:Class):Object
        {
            if (!classUtilsCache.implementsInterface(objectClass, IPoolObject))
            {
                var handlerClass:Class = _handlerClassByObjectClass[objectClass];
                CONFIG::log_fatal
                {
                    if (handlerClass == null)
                        logger.fatal("Attempt to create pool object using invalid object class.");
                }
                var handler:IPoolHandler = IPoolHandler(createObject(handlerClass));
                var object:Object = handler.getObject();
                _handlerByObject[object] = handler;
                _classByObject[object] = objectClass;
                return object;
            }

            var objects:Vector.<IPoolObject> = getPoolObjectsByClass(objectClass);
            if (objects.length > 0)
                return objects.pop();

            var poolObject:Object = new objectClass();
            _classByObject[poolObject] = objectClass;
            return poolObject;
        }

        public function releaseObject(object:Object):void
        {
            var poolObject:IPoolObject = object as IPoolObject;
            if (poolObject == null)
            {
                var handler:IPoolHandler = _handlerByObject[object];
                CONFIG::log_fatal
                {
                    if (handler == null)
                        logger.fatal("No handler found during attempt to release object.");
                }
                releaseObject(handler);
            }
            else
            {
                var objectClass:Class = _classByObject[poolObject];
                CONFIG::log_fatal
                {
                    if (objectClass == null)
                        logger.fatal("No object class found during attempt to release pool object.");
                }
                poolObject.resetPoolObject();
                getPoolObjectsByClass(objectClass).push(poolObject);
            }
            CONFIG::debug
            {
                CONFIG::log_warn
                {
                    var broadcasterQName:String = classUtilsCache.getQualifiedClassName(Broadcaster);
                    for each (var variableName:String in classUtilsCache.getClassVariables(_classByObject[object],
                        broadcasterQName))
                        checkObjectBroadcaster(object, variableName);
                    for each (var constantName:String in classUtilsCache.getClassConstants(_classByObject[object],
                        broadcasterQName))
                        checkObjectBroadcaster(object, constantName);
                }
            }
        }

        private function getPoolObjectsByClass(objectClass:Class):Vector.<IPoolObject>
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

        private function checkObjectBroadcaster(object:Object, broadcasterName:String):void
        {
            var broadcaster:Broadcaster = object[broadcasterName];
            if (broadcaster != null && broadcaster.numCallbacks > 0)
                logger.warn("Broadcaster '{0}' is not empty on object reset.", broadcasterName);
        }
    }
}
package com.rokannon.core
{
    public class Broadcaster
    {
        private const _callbacks:Vector.<Function> = new Vector.<Function>();
        private const _queue:Vector.<Function> = new Vector.<Function>();

        private var _target:*;
        private var _numCallbacks:uint;

        public function Broadcaster(target:*)
        {
            _target = target;
            _numCallbacks = 0;
        }

        public function get numCallbacks():uint
        {
            return _numCallbacks;
        }

        public function add(callback:Function):void
        {
            var index:int = _callbacks.indexOf(callback);
            if (index == -1)
                _callbacks[_numCallbacks++] = callback;
        }

        public function remove(callback:Function):void
        {
            var index:int = _callbacks.indexOf(callback);
            if (index == -1)
                return;
            --_numCallbacks;
            if (index != _numCallbacks)
                _callbacks[index] = _callbacks[_numCallbacks];
            --_callbacks.length;
        }

        public function broadcast():void
        {
            var i:int;
            var length:int = _callbacks.length;
            for (i = 0; i < length; ++i)
                _queue[i] = _callbacks[i];
            for (i = 0; i < length; ++i)
                _queue[i](_target);
            _queue.length = 0;
        }
    }
}
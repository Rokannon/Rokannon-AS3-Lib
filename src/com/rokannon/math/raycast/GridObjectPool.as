package com.rokannon.math.raycast
{
    public class GridObjectPool
    {
        private const _gridObjects:Vector.<GridObject> = new <GridObject>[];

        public function GridObjectPool()
        {
        }

        public function create():GridObject
        {
            return _gridObjects.length == 0 ? new GridObject() : _gridObjects.pop();
        }

        public function release(gridObject:GridObject):void
        {
            gridObject.reset();
            _gridObjects.push(gridObject);
        }
    }
}
package com.rokannon.math.raycast
{
    import com.rokannon.core.pool.IPoolObject;

    public class Voxel implements IPoolObject
    {
        public const gridObjects:Vector.<GridObject> = new Vector.<GridObject>();

        public var index:int;

        public function Voxel()
        {
        }

        public function releasePoolObject():void
        {
            gridObjects.length = 0;
            index = 0;
        }
    }
}
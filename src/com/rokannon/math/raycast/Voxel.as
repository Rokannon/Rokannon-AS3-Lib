package com.rokannon.math.raycast
{
    import com.rokannon.core.pool.IPoolObject;

    public class Voxel implements IPoolObject
    {
        public const gridObjects:Vector.<GridObject> = new <GridObject>[];

        public var index:int;

        public function Voxel()
        {
        }

        public function resetPoolObject():void
        {
            gridObjects.length = 0;
            index = 0;
        }
    }
}
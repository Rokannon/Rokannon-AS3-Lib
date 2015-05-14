package com.rokannon.math.raycast
{
    import com.rokannon.core.pool.IPoolObject;
    import com.rokannon.math.geom.IShape;

    public class GridObject implements IPoolObject
    {
        public const voxels:Vector.<Voxel> = new Vector.<Voxel>();

        public var lastActionID:uint;
        public var shape:IShape;

        public function GridObject()
        {
        }

        public function releasePoolObject():void
        {
            voxels.length = 0;
            lastActionID = 0;
            shape = null;
        }
    }
}
package com.rokannon.math.raycast
{
    import com.rokannon.math.geom.IShape;

    public class GridObject
    {
        public const voxels:Vector.<Voxel> = new Vector.<Voxel>();

        public var lastActionID:uint;
        public var shape:IShape;

        public function GridObject()
        {
        }

        public function reset():void
        {
            voxels.length = 0;
            lastActionID = 0;
            shape = null;
        }
    }
}
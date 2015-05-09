package com.rokannon.math.raycast
{
    public class VoxelPool
    {
        private const _voxels:Vector.<Voxel> = new <Voxel>[];

        public function VoxelPool()
        {
        }

        public function create():Voxel
        {
            return _voxels.length == 0 ? new Voxel() : _voxels.pop();
        }

        public function release(voxel:Voxel):void
        {
            voxel.reset();
            _voxels.push(voxel);
        }
    }
}
package com.rokannon.math.raycast
{
    public class Voxel
    {
        public const gridObjects:Vector.<GridObject> = new Vector.<GridObject>();

        public var index:int;

        public function Voxel()
        {
        }

        public function reset():void
        {
            gridObjects.length = 0;
            index = 0;
        }
    }
}
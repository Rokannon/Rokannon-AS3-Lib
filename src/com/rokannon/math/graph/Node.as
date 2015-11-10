package com.rokannon.math.graph
{
    import com.rokannon.core.pool.IPoolObject;

    public class Node implements IPoolObject
    {
        public var x:Number = 0;
        public var y:Number = 0;

        internal const toNodes:Vector.<Node> = new <Node>[];
        internal const fromNodes:Vector.<Node> = new <Node>[];

        internal var known:Boolean = false;
        internal var path:Node;
        internal var distance:Number = Infinity;

        public function Node()
        {
        }

        public function setTo(x:Number, y:Number):void
        {
            this.x = x;
            this.y = y;
        }

        public function resetPoolObject():void
        {
            x = 0;
            y = 0;
            known = false;
            path = null;
            distance = Infinity;
            toNodes.length = 0;
            fromNodes.length = 0;
        }
    }
}
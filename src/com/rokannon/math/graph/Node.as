package com.rokannon.math.graph
{
    public class Node
    {
        public var x:Number;
        public var y:Number;

        internal const toNodes:Vector.<Node> = new Vector.<Node>();
        internal const fromNodes:Vector.<Node> = new Vector.<Node>();

        internal var known:Boolean;
        internal var path:Node;
        internal var distance:Number;

        public function Node()
        {
        }

        public function reset():void
        {
            known = false;
            path = null;
            distance = Infinity;
        }

        public function setTo(x:Number, y:Number):void
        {
            this.x = x;
            this.y = y;
        }
    }
}
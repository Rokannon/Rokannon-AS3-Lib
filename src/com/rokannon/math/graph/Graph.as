package com.rokannon.math.graph
{
    import com.rokannon.core.pool.ObjectPool;
    import com.rokannon.core.utils.getProperty;
    import com.rokannon.display.render.IRenderTarget;
    import com.rokannon.display.render.IRenderable;

    public class Graph implements IRenderable
    {
        private static const helperNodes:Vector.<Node> = new Vector.<Node>();
        private static const objectPool:ObjectPool = ObjectPool.instance;

        public const nodes:Vector.<Node> = new Vector.<Node>();

        public function Graph()
        {
        }

        public function createNode():Node
        {
            var node:Node = Node(objectPool.createObject(Node));
            nodes.push(node);
            return node;
        }

        public function releaseNode(node:Node):void
        {
            var adjacentNode:Node;
            for each (adjacentNode in node.toNodes)
                adjacentNode.fromNodes.splice(adjacentNode.fromNodes.indexOf(node), 1);
            for each (adjacentNode in node.fromNodes)
                adjacentNode.toNodes.splice(adjacentNode.toNodes.indexOf(node), 1);
            nodes.splice(nodes.indexOf(node), 1);
            objectPool.releaseObject(node);
        }

        public function connect(fromNode:Node, toNode:Node):void
        {
            var index:int;
            index = fromNode.toNodes.indexOf(toNode);
            if (index == -1)
                fromNode.toNodes.push(toNode);
            index = toNode.fromNodes.indexOf(fromNode);
            if (index == -1)
                toNode.fromNodes.push(fromNode);
        }

        public function disconnect(fromNode:Node, toNode:Node):void
        {
            var index:int;
            index = fromNode.toNodes.indexOf(toNode);
            if (index != -1)
                fromNode.toNodes.splice(index, 1);
            index = toNode.fromNodes.indexOf(fromNode);
            if (index != -1)
                toNode.fromNodes.splice(index, 1);
        }

        public function getPath(startNode:Node, endNode:Node, resultNodes:Vector.<Node> = null):Vector.<Node>
        {
            var node:Node;
            for each (node in nodes)
            {
                node.path = null;
                node.known = false;
                node.distance = Infinity;
            }

            startNode.distance = 0;

            while (true)
            {
                var minNode:Node = getMinNode();
                if (minNode == null)
                    break;
                minNode.known = true;
                if (minNode == endNode)
                    break;
                for each (node in minNode.toNodes)
                {
                    if (node.known)
                        continue;
                    var dx:Number = minNode.x - node.x;
                    var dy:Number = minNode.y - node.y;
                    var distance:Number = minNode.distance + Math.sqrt(dx * dx + dy * dy);
                    if (distance < node.distance)
                    {
                        node.distance = distance;
                        node.path = minNode;
                    }
                }
            }

            if (resultNodes == null)
                resultNodes = new Vector.<Node>();
            else
                resultNodes.length = 0;
            if (endNode.known)
            {
                node = endNode;
                var i:int = 0;
                while (node != null)
                {
                    helperNodes[i] = node;
                    ++i;
                    node = node.path;
                }
                var length:int = helperNodes.length;
                for (i = 0; i < length; ++i)
                    resultNodes[i] = helperNodes[length - i - 1];
                helperNodes.length = 0;
            }
            return resultNodes;
        }

        private function getMinNode():Node
        {
            var minNode:Node;
            var minDistance:Number = Infinity;

            for each (var node:Node in nodes)
            {
                if (!node.known && node.distance < minDistance)
                {
                    minDistance = node.distance;
                    minNode = node;
                }
            }

            return minNode;
        }

        public function render(renderTarget:IRenderTarget, renderSettings:Object):void
        {
            var color:uint = getProperty(renderSettings, "color", 0x000000);
            var nodeSize:Number = getProperty(renderSettings, "nodeSize", 2);

            var node:Node;
            for each (node in nodes)
            {
                var x:Number = node.x;
                var y:Number = node.y;
                renderTarget.drawFilledCircle(x, y, nodeSize, color);
                var toNodes:Vector.<Node> = node.toNodes;
                for each (node in toNodes)
                    renderTarget.drawLine(x, y, node.x, node.y, color);
            }
        }
    }
}
package com.rokannon.math.geom
{
    import com.rokannon.core.pool.IPoolObject;
    import com.rokannon.core.pool.ObjectPool;
    import com.rokannon.core.utils.getProperty;
    import com.rokannon.display.render.IRenderTarget;
    import com.rokannon.logging.Log;
    import com.rokannon.logging.Logger;
    import com.rokannon.math.geom.enum.VerticesOrder;
    import com.rokannon.math.utils.getAbs;
    import com.rokannon.math.utils.getMax;
    import com.rokannon.math.utils.getMin;
    import com.rokannon.math.utils.matrix.matrixTransformPoint;
    import com.rokannon.math.utils.point.getPointDistance;

    import flash.geom.Matrix;
    import flash.geom.Point;

    public class PolygonShape implements IShape, IPoolObject
    {
        private static const logger:Logger = Log.instance.getLogger(PolygonShape);
        private static const helperSegment1:Segment = new Segment();
        private static const helperSegment2:Segment = new Segment();
        private static const helperVector1:Vector2D = new Vector2D();
        private static const helperVector2:Vector2D = new Vector2D();
        private static const helperPoint1:Point = new Point();
        private static const helperPoint2:Point = new Point();
        private static const helperNumbers:Vector.<Number> = new Vector.<Number>();

        public const vertices:Vector.<Number> = new Vector.<Number>();

        private var _numVertices:int;
        private var _bounds:AABBox;
        private var _boundsInvalidated:Boolean = true;

        public function PolygonShape(vertices:Vector.<Number> = null):void
        {
            if (vertices != null)
                setTo(vertices);
        }

        public function get numVertices():int
        {
            return _numVertices;
        }

        public function setTo(vertices:Vector.<Number>):void
        {
            this.vertices.length = 0;
            var length:int = vertices.length;
            for (var i:int = 0; i < length; ++i)
                this.vertices[i] = vertices[i];
            _numVertices = this.vertices.length >> 1;
            _boundsInvalidated = true;

            CONFIG::log_fatal
            {
                if (vertices.length < 6 || (vertices.length & 1) == 1)
                    logger.fatal("Invalid vertices: {0}", toString());
            }
        }

        public function getVertex(index:int, resultPoint:Point = null):Point
        {
            if (resultPoint == null)
                resultPoint = new Point();
            while (index < 0)
                index += _numVertices;
            index %= _numVertices;
            resultPoint.setTo(vertices[index << 1], vertices[(index << 1) + 1]);
            return resultPoint;
        }

        public function getSide(index:int, resultSegment:Segment = null):Segment
        {
            if (resultSegment == null)
                resultSegment = new Segment();
            while (index < 0)
                index += _numVertices;
            index %= _numVertices;
            if (index == _numVertices - 1)
                resultSegment.setTo(vertices[(_numVertices << 1) - 2], vertices[(_numVertices << 1) - 1], vertices[0],
                    vertices[1]);
            else
                resultSegment.setTo(vertices[index << 1], vertices[(index << 1) + 1], vertices[(index << 1) + 2],
                    vertices[(index << 1) + 3]);
            return resultSegment;
        }

        public function getVerticesOrder():String
        {
            var currentSign:Number = 0;
            for (var i:int = 0; i < _numVertices; ++i)
            {
                getVertex(i, helperPoint1);
                getVertex(i + 1, helperPoint2);
                helperVector1.setTo(helperPoint1.x - helperPoint2.x, helperPoint1.y - helperPoint2.y);
                for (var j:int = i + 2; j < i + _numVertices; ++j)
                {
                    getVertex(j, helperPoint2);
                    helperVector2.setTo(helperPoint1.x - helperPoint2.x, helperPoint1.y - helperPoint2.y);
                    var sign:Number = helperVector2.cross(helperVector1);
                    if (sign == 0)
                        continue;
                    if (currentSign > 0 && sign < 0 || currentSign < 0 && sign > 0)
                        return VerticesOrder.NONE;
                    if (currentSign == 0)
                        currentSign = sign;
                }
            }
            if (currentSign > 0)
                return VerticesOrder.CCW;
            else if (currentSign < 0)
                return VerticesOrder.CW;
            return VerticesOrder.NONE;
        }

        public function reverseVerticesOrder():void
        {
            vertices.reverse();
            var length:int = vertices.length;
            for (var i:int = 0; i < length; i += 2)
            {
                var temp:Number = vertices[i + 1];
                vertices[i + 1] = vertices[i];
                vertices[i] = temp;
            }
        }

        public function render(renderTarget:IRenderTarget, renderSettings:Object):void
        {
            var color:uint = getProperty(renderSettings, "color", 0x000000);
            var filled:Boolean = getProperty(renderSettings, "filled", false);

            if (filled)
                renderTarget.drawFilledPolygon(vertices, color);
            else
                renderTarget.drawPolygon(vertices, color);
        }

        public function toString():String
        {
            var object:Object = {
                vertices: vertices
            };
            return JSON.stringify(object);
        }

        public function closestPointToXY(x:Number, y:Number, resultPoint:Point = null):Point
        {
            if (resultPoint == null)
                resultPoint = new Point();
            helperPoint2.setTo(x, y);
            var distance:Number = Infinity;
            for (var i:int = 0; i < _numVertices; ++i)
            {
                getSide(i, helperSegment1).closestPointToXY(x, y, helperPoint1);
                var _distance:Number = getPointDistance(helperPoint1, helperPoint2);
                if (_distance < distance)
                {
                    resultPoint.copyFrom(helperPoint1);
                    distance = _distance;
                }
            }
            return resultPoint;
        }

        public function closestPointToP(point:Point, resultPoint:Point = null):Point
        {
            return closestPointToXY(point.x, point.y, resultPoint);
        }

        public function getBounds():AABBox
        {
            if (_boundsInvalidated)
            {
                var left:Number = +Infinity;
                var right:Number = -Infinity;
                var bottom:Number = +Infinity;
                var top:Number = -Infinity;
                for (var i:int = 0; i < vertices.length; i += 2)
                {
                    left = getMin(vertices[i], left);
                    right = getMax(vertices[i], right);
                    bottom = getMin(vertices[i + 1], bottom);
                    top = getMax(vertices[i + 1], top);
                }
                if (_bounds == null)
                    _bounds = new AABBox();
                _bounds.setTo(left, bottom, right, top);
                _boundsInvalidated = false;
            }
            return _bounds;
        }

        public function containsXY(x:Number, y:Number):Boolean
        {
            var numCrosses:int = 0;
            helperSegment1.setTo(x, y, x + 1, y + 1);
            for (var i:int = 0; i < _numVertices; ++i)
            {
                if (getSide(i, helperSegment2).intersectsRay(helperSegment1))
                    ++numCrosses;
                if (vertices[i << 1] == x && vertices[(i << 1) + 1] == y)
                    return true;
            }
            return (numCrosses & 1) == 1;
        }

        public function containsP(point:Point):Boolean
        {
            return containsXY(point.x, point.y);
        }

        public function intersectsSegment(segment:Segment):Boolean
        {
            if (!getBounds().intersectsSegment(segment))
                return false;
            if (containsXY(segment.x1, segment.y1) || containsXY(segment.x2, segment.y2))
                return true;
            for (var i:int = 0; i < _numVertices; ++i)
            {
                if (segment.intersectsSegment(getSide(i, helperSegment1)))
                    return true;
            }
            return false;
        }

        public function intersectsBox(box:AABBox):Boolean
        {
            if (!getBounds().intersectsBox(box))
                return false;
            if (box.containsXY(vertices[0], vertices[1]))
                return true;
            if (containsXY(0.5 * (box.xMin + box.xMax), 0.5 * (box.yMin + box.yMax)))
                return true;
            for (var i:int = 0; i < _numVertices; ++i)
            {
                if (box.intersectsSegment(getSide(i, helperSegment1)))
                    return true;
            }
            return false;
        }

        public function offsetXY(dx:Number, dy:Number):void
        {
            var length:int = vertices.length;
            for (var i:int = 0; i < length; i += 2)
            {
                vertices[i] += dx;
                vertices[i + 1] += dy;
            }
            _boundsInvalidated = true;
        }

        public function offsetP(point:Point):void
        {
            offsetXY(point.x, point.y);
        }

        public function rotate(angle:Number):void
        {
            var cos:Number = Math.cos(angle);
            var sin:Number = Math.sin(angle);
            var length:int = vertices.length;
            for (var i:int = 0; i < length; i += 2)
            {
                var _x:Number = vertices[i];
                var _y:Number = vertices[i + 1];
                var x:Number = cos * _x - sin * _y;
                var y:Number = sin * _x + cos * _y;
                vertices[i] = x;
                vertices[i + 1] = y;
            }
            _boundsInvalidated = true;
        }

        public function applyTransform(transform:Matrix):void
        {
            var length:int = vertices.length;
            for (var i:int = 0; i < length; i += 2)
            {
                helperPoint1.setTo(vertices[i], vertices[i + 1]);
                matrixTransformPoint(transform, helperPoint1, helperPoint1);
                vertices[i] = helperPoint1.x;
                vertices[i + 1] = helperPoint1.y;
            }
            _boundsInvalidated = true;
        }

        public function getRandomPoint(resultPoint:Point = null):Point
        {
            CONFIG::log_fatal
            {
                if (getVerticesOrder() == VerticesOrder.NONE)
                    logger.fatal("Unable to get random point in non-convex polygon.");
            }

            if (resultPoint == null)
                resultPoint = new Point();
            var polygonArea:Number = 0;
            var area:Number;
            var i:int;
            for (i = 1; i < _numVertices - 1; ++i)
            {
                getVertex(i, helperPoint1);
                getVertex(i + 1, helperPoint2);
                area = getTriangleArea(vertices[0], vertices[1], helperPoint1.x, helperPoint1.y, helperPoint2.x,
                    helperPoint2.y);
                polygonArea += area;
                helperNumbers.push(area);
            }
            var randomArea:Number = polygonArea * Math.random();
            area = 0;
            var triangleIndex:int = -1;
            while (randomArea >= area)
            {
                ++triangleIndex;
                area += helperNumbers[triangleIndex];
            }
            getVertex(triangleIndex + 1, helperPoint1);
            getVertex(triangleIndex + 2, helperPoint2);
            return getRandomPointInTriangle(vertices[0], vertices[1], helperPoint1.x, helperPoint1.y, helperPoint2.x,
                helperPoint2.y, resultPoint);
        }

        public function getInternalPoint(resultPoint:Point = null):Point
        {
            if (resultPoint == null)
                resultPoint = new Point();
            else
                resultPoint.setTo(0, 0);
            for (var i:int = 0; i < _numVertices; ++i)
                resultPoint.offset(vertices[(i << 1)], vertices[(i << 1) + 1]);
            resultPoint.x /= _numVertices;
            resultPoint.y /= _numVertices;
            return resultPoint;
        }

        [Inline]
        private final function getRandomPointInTriangle(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number,
                                                        y2:Number, resultPoint:Point):Point
        {
            var u:Number = Math.random();
            var v:Number = Math.random();
            if (u + v > 1)
            {
                u = 1 - u;
                v = 1 - v;
            }
            resultPoint.setTo(x0 + u * (x1 - x0) + v * (x2 - x0), y0 + u * (y1 - y0) + v * (y2 - y0));
            return resultPoint;
        }

        [Inline]
        private final function getTriangleArea(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number):Number
        {
            return 0.5 * getAbs((x2 - x0) * (y1 - y0) - (y2 - y0) * (x1 - x0));
        }

        public function releasePoolObject():void
        {
            vertices.length = 0;
            _numVertices = 0;
            _boundsInvalidated = true;
        }
    }
}
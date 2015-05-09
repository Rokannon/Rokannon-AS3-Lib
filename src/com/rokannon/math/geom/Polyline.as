package com.rokannon.math.geom
{
    import com.rokannon.core.utils.getProperty;
    import com.rokannon.display.render.IRenderTarget;
    import com.rokannon.display.render.IRenderable;
    import com.rokannon.logging.Log;
    import com.rokannon.logging.Logger;
    import com.rokannon.math.utils.getMax;
    import com.rokannon.math.utils.point.getPointDistance;

    import flash.geom.Point;

    public class Polyline implements IGeometricObject, IRenderable
    {
        private static const logger:Logger = Log.instance.getLogger(Polyline);
        private static const HELPER_POINT_1:Point = new Point();
        private static const HELPER_POINT_2:Point = new Point();
        private static const HELPER_SEGMENT:Segment = new Segment();

        private const _vertices:Vector.<Number> = new <Number>[];
        private var _numVertices:int;

        public function Polyline(vertices:Vector.<Number> = null)
        {
            if (vertices != null)
                setTo(vertices);
        }

        public function get vertices():Vector.<Number>
        {
            return _vertices;
        }

        public function get numVertices():int
        {
            return _numVertices;
        }

        public function setTo(vertices:Vector.<Number>):void
        {
            _vertices.length = 0;
            var length:int = vertices.length;
            for (var i:int = 0; i < length; ++i)
                _vertices[i] = vertices[i];
            _numVertices = _vertices.length >> 1;

            CONFIG::log_fatal
            {
                if (vertices.length < 4 || (vertices.length & 1) == 1)
                    logger.fatal("Invalid vertices: {0}", toString());
            }
        }

        /** From 0 to numVertices - 1. */
        public function getVertex(index:int, resultPoint:Point = null):Point
        {
            if (resultPoint == null)
                resultPoint = new Point();
            while (index < 0)
                index += _numVertices;
            index = index % _numVertices;
            resultPoint.setTo(_vertices[index << 1], _vertices[(index << 1) + 1]);
            return resultPoint;
        }

        /** From 0 to numVertices - 2. */
        public function getSide(index:int, resultSegment:Segment = null):Segment
        {
            if (resultSegment == null)
                resultSegment = new Segment();
            getVertex(index, HELPER_POINT_1);
            var x1:Number = HELPER_POINT_1.x;
            var y1:Number = HELPER_POINT_1.y;
            getVertex(index + 1, HELPER_POINT_1);
            resultSegment.setTo(x1, y1, HELPER_POINT_1.x, HELPER_POINT_1.y);
            return resultSegment;
        }

        public function proceedXY(x:Number, y:Number, d:Number, resultPoint:Point = null):Point
        {
            d = getMax(d, 0);
            if (resultPoint == null)
                resultPoint = new Point();
            HELPER_POINT_2.setTo(x, y);
            var distance:Number = Infinity;
            var sideIndex:int;
            for (var i:int = 0; i < _numVertices - 1; ++i)
            {
                getSide(i, HELPER_SEGMENT).closestPointToXY(x, y, HELPER_POINT_1);
                var _distance:Number = getPointDistance(HELPER_POINT_1, HELPER_POINT_2);
                if (_distance < distance)
                {
                    resultPoint.copyFrom(HELPER_POINT_1);
                    distance = _distance;
                    sideIndex = i;
                }
            }
            getSide(sideIndex, HELPER_SEGMENT).getPoint1(HELPER_POINT_1);
            d += getPointDistance(HELPER_POINT_1, resultPoint);
            while (true)
            {
                if (sideIndex == _numVertices - 1)
                {
                    getVertex(-1, resultPoint);
                    break;
                }
                else
                {
                    getSide(sideIndex, HELPER_SEGMENT);
                    var _d:Number = HELPER_SEGMENT.getLength();
                    if (d > _d)
                    {
                        d -= _d;
                        ++sideIndex;
                    }
                    else
                    {
                        HELPER_SEGMENT.lerp(d / _d, resultPoint);
                        break;
                    }
                }
            }
            return resultPoint;
        }

        public function proceedP(point:Point, d:Number, resultPoint:Point = null):Point
        {
            return proceedXY(point.x, point.y, d, resultPoint);
        }

        public function render(renderTarget:IRenderTarget, renderSettings:Object):void
        {
            var color:uint = getProperty(renderSettings, "color", 0x000000);

            for (var i:int = 0; i < _numVertices - 1; ++i)
            {
                getVertex(i, HELPER_POINT_1);
                getVertex(i + 1, HELPER_POINT_2);
                renderTarget.drawLine(HELPER_POINT_1.x, HELPER_POINT_1.y, HELPER_POINT_2.x, HELPER_POINT_2.y, color);
            }
        }

        public function toString():String
        {
            var object:Object = {
                vertices: _vertices
            };
            return JSON.stringify(object);
        }

        public function closestPointToXY(x:Number, y:Number, resultPoint:Point = null):Point
        {
            if (resultPoint == null)
                resultPoint = new Point();
            HELPER_POINT_2.setTo(x, y);
            var distance:Number = Infinity;
            for (var i:int = 0; i < _numVertices - 1; ++i)
            {
                getSide(i, HELPER_SEGMENT).closestPointToXY(x, y, HELPER_POINT_1);
                var _distance:Number = getPointDistance(HELPER_POINT_1, HELPER_POINT_2);
                if (_distance < distance)
                {
                    resultPoint.copyFrom(HELPER_POINT_1);
                    distance = _distance;
                }
            }
            return resultPoint;
        }

        public function closestPointToP(point:Point, resultPoint:Point = null):Point
        {
            return closestPointToXY(point.x, point.y, resultPoint);
        }
    }
}
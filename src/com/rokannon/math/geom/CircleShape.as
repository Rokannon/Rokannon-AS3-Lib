package com.rokannon.math.geom
{
    import com.rokannon.core.utils.getProperty;
    import com.rokannon.display.render.IRenderTarget;
    import com.rokannon.logging.Log;
    import com.rokannon.logging.Logger;
    import com.rokannon.math.utils.matrix.matrixGetScaleX;
    import com.rokannon.math.utils.matrix.matrixGetScaleY;
    import com.rokannon.math.utils.matrix.matrixTransformPoint;

    import flash.geom.Matrix;
    import flash.geom.Point;

    public class CircleShape implements IShape
    {
        private static const logger:Logger = Log.instance.getLogger(CircleShape);
        private static const helperPoint:Point = new Point();

        private var _x:Number;
        private var _y:Number;
        private var _radius:Number;
        private var _bounds:AABBox;
        private var _boundsInvalidated:Boolean;

        public function CircleShape(x:Number = 0, y:Number = 0, radius:Number = 0):void
        {
            setTo(x, y, radius);
        }

        public function get x():Number
        {
            return _x;
        }

        public function get y():Number
        {
            return _y;
        }

        public function get radius():Number
        {
            return _radius;
        }

        public function setTo(x:Number, y:Number, radius:Number):void
        {
            _x = x;
            _y = y;
            _radius = radius;
            _boundsInvalidated = true;

            CONFIG::log_fatal
            {
                if (radius < 0)
                    logger.fatal("Radius must not be negative: {0}", this.toString());
            }
        }

        public function intersects(geometricObject:IGeometricObject):Boolean
        {
            return containsP(geometricObject.closestPointToXY(_x, _y, helperPoint));
        }

        public function render(renderTarget:IRenderTarget, renderSettings:Object):void
        {
            var color:uint = getProperty(renderSettings, "color", 0x000000);
            var filled:Boolean = getProperty(renderSettings, "filled", false);

            if (filled)
                renderTarget.drawFilledCircle(_x, _y, _radius, color);
            else
                renderTarget.drawCircle(_x, _y, _radius, color);
        }

        public function toString():String
        {
            var object:Object = {
                x: _x, y: _y, radius: _radius
            };
            return JSON.stringify(object);
        }

        public function closestPointToXY(x:Number, y:Number, resultPoint:Point = null):Point
        {
            resultPoint ||= new Point();
            var d:Number = Math.sqrt((x - _x) * (x - _x) + (y - _y) * (y - _y));
            if (d == 0)
                resultPoint.setTo(_x + _radius, y);
            else
            {
                d = _radius / d;
                resultPoint.setTo(_x + d * (x - _x), _y + d * (y - _y));
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
                _bounds ||= new AABBox();
                _bounds.setTo(_x - _radius, _y - _radius, _x + _radius, _y + _radius);
                _boundsInvalidated = false;
            }
            return _bounds;
        }

        public function containsXY(x:Number, y:Number):Boolean
        {
            return ((x - _x) * (x - _x) + (y - _y) * (y - _y)) <= _radius * _radius;
        }

        public function containsP(point:Point):Boolean
        {
            return containsXY(point.x, point.y);
        }

        public function intersectsSegment(segment:Segment):Boolean
        {
            return containsP(segment.closestPointToXY(_x, _y, helperPoint));
        }

        public function intersectsBox(box:AABBox):Boolean
        {
            return containsP(box.closestPointToXY(_x, _y, helperPoint));
        }

        public function offsetXY(dx:Number, dy:Number):void
        {
            _x += dx;
            _y += dy;
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
            setTo(cos * _x - sin * _y, sin * _x + cos * _y, _radius);
        }

        public function applyTransform(transform:Matrix):void
        {
            helperPoint.setTo(_x, _y);
            matrixTransformPoint(transform, helperPoint, helperPoint);
            setTo(helperPoint.x, helperPoint.y,
                0.5 * (matrixGetScaleX(transform) + matrixGetScaleY(transform)) * _radius);
        }

        public function getRandomPoint(resultPoint:Point = null):Point
        {
            resultPoint ||= new Point();
            var t:Number = 2 * Math.PI * Math.random();
            var u:Number = Math.random() + Math.random();
            var r:Number = u > 1 ? 2 - u : u;
            resultPoint.setTo(_x + _radius * r * Math.cos(t), _y + _radius * r * Math.sin(t));
            return resultPoint;
        }

        public function getInternalPoint(resultPoint:Point = null):Point
        {
            resultPoint ||= new Point();
            resultPoint.setTo(_x, _y);
            return resultPoint;
        }

        public function resetPoolObject():void
        {
            _x = 0;
            _y = 0;
            _radius = 0;
            _boundsInvalidated = true;
        }
    }
}
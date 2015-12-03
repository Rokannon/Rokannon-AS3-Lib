package com.rokannon.math.geom
{
    import com.rokannon.core.pool.IPoolObject;
    import com.rokannon.core.utils.getProperty;
    import com.rokannon.display.render.IRenderTarget;
    import com.rokannon.display.render.IRenderable;
    import com.rokannon.math.utils.getAbs;

    import flash.geom.Point;

    public class Segment implements IGeometricObject, IRenderable, IPoolObject
    {
        private static const helperPoint:Point = new Point();
        private static const helperVector1:Vector2D = new Vector2D();
        private static const helperVector2:Vector2D = new Vector2D();

        private var _x1:Number;
        private var _y1:Number;
        private var _x2:Number;
        private var _y2:Number;

        public function Segment(x1:Number = 0, y1:Number = 0, x2:Number = 0, y2:Number = 0):void
        {
            setTo(x1, y1, x2, y2);
        }

        public function get x1():Number
        {
            return _x1;
        }

        public function get y1():Number
        {
            return _y1;
        }

        public function get x2():Number
        {
            return _x2;
        }

        public function get y2():Number
        {
            return _y2;
        }

        public function getLength():Number
        {
            return Math.sqrt((_x2 - _x1) * (_x2 - _x1) + (_y2 - _y1) * (_y2 - _y1));
        }

        public function getSquaredLength():Number
        {
            return (_x2 - _x1) * (_x2 - _x1) + (_y2 - _y1) * (_y2 - _y1);
        }

        public function getPoint1(resultPoint:Point = null):Point
        {
            resultPoint ||= new Point();
            resultPoint.setTo(_x1, _y1);
            return resultPoint;
        }

        public function getPoint2(resultPoint:Point = null):Point
        {
            resultPoint ||= new Point();
            resultPoint.setTo(_x2, _y2);
            return resultPoint;
        }

        public function setTo(x1:Number, y1:Number, x2:Number, y2:Number):void
        {
            _x1 = x1;
            _y1 = y1;
            _x2 = x2;
            _y2 = y2;
        }

        public function toVector2D(resultVector:Vector2D = null):Vector2D
        {
            resultVector ||= new Vector2D();
            resultVector.setTo(_x2 - _x1, _y2 - _y1);
            return resultVector;
        }

        public function lerp(t:Number, resultPoint:Point = null):Point
        {
            resultPoint ||= new Point();
            resultPoint = toVector2D(helperVector1).lerp(t, resultPoint);
            resultPoint.offset(_x1, _y1);
            return resultPoint;
        }

        public function shift(t:Number, s:Number, resultPoint:Point = null):Point
        {
            resultPoint ||= new Point();
            resultPoint = toVector2D(helperVector1).shift(t, s, resultPoint);
            resultPoint.offset(_x1, _y1);
            return resultPoint;
        }

        public function reflectPoint(point:Point, resultPoint:Point = null):Point
        {
            resultPoint ||= new Point();
            var u1:Number = _x1 - _x2;
            var v1:Number = _y1 - _y2;
            var u2:Number = point.x - _x2;
            var v2:Number = point.y - _y2;
            var p:Number = u1 * u2 + v1 * v2;
            var q:Number = v1 * u2 - u1 * v2;
            var r:Number = u1 * u1 + v1 * v1;
            resultPoint.setTo(_x2 + (u1 * p - v1 * q) / r, _y2 + (v1 * p + u1 * q) / r);
            return resultPoint;
        }

        public function lineXY(x:Number, y:Number):Number
        {
            return (_x2 - _x1) * (y - _y1) - (_y2 - _y1) * (x - _x1);
        }

        public function lineP(point:Point):Number
        {
            return lineXY(point.x, point.y);
        }

        public function intersectsLine(line:Segment):Boolean
        {
            return line.lineXY(_x1, _y1) * line.lineXY(_x2, _y2) < 0;
        }

        public function intersectsSegment(segment:Segment):Boolean
        {
            var value:Number;
            helperVector1.setTo(_x2 - _x1, _y2 - _y1); // r
            helperVector2.setTo(segment._x2 - segment._x1, segment._y2 - segment._y1); // s
            if (helperVector1.cross(helperVector2) == 0)
            { // r x s == 0
                helperVector2.setTo(segment._x1 - _x1, segment._y1 - _y1); // q - p
                if (helperVector2.cross(helperVector1) == 0)
                { // (q - p) x r == 0
                    value = helperVector2.dot(helperVector1); // (q - p) . r
                    if (0 <= value && value <= helperVector1.dot(helperVector1))
                        return true; // collinear and overlapping

                    helperVector2.inverse(helperVector2); // p - q
                    helperVector1.setTo(segment._x2 - segment._x1, segment._y2 - segment._y1); // s
                    value = helperVector2.dot(helperVector1); // (p - q) . s
                    if (0 <= value && value <= helperVector1.dot(helperVector1))
                        return true; // collinear and overlapping
                    return false; // collinear but disjoint
                }
                else
                    return false; // parallel and non-intersecting
            }
            else
            {
                helperVector2.setTo(segment._x1 - _x1, segment._y1 - _y1); // q - p
                value = helperVector2.cross(helperVector1); // (q - p) x r
                helperVector2.setTo(segment._x2 - segment._x1, segment._y2 - segment._y1); // s
                value /= helperVector1.cross(helperVector2); // (q - p) x r / r x s
                if (value < 0 || value > 1)
                    return false; // meet at the point

                helperVector1.setTo(segment._x1 - _x1, segment._y1 - _y1); // q - p
                value = helperVector1.cross(helperVector2); // (q - p) x s
                helperVector1.setTo(_x2 - _x1, _y2 - _y1); // r
                value /= helperVector1.cross(helperVector2); // (q - p) x s / r x s
                if (value < 0 || value > 1)
                    return false; // meet at the point
                return true;
            }
        }

        public function intersectsRay(ray:Segment):Boolean
        {
            if (ray.lineXY(_x1, _y1) * ray.lineXY(_x2, _y2) > 0)
                return false;
            var line1:Number = lineXY(ray._x1, ray._y1);
            var line2:Number = lineP(ray.lerp(2, helperPoint));
            return line1 * line2 <= 0 || getAbs(line1) > getAbs(line2);

        }

        public function render(renderTarget:IRenderTarget, renderSettings:Object):void
        {
            var color:uint = getProperty(renderSettings, "color", 0x000000);
            renderTarget.drawLine(_x1, _y1, _x2, _y2, color);
        }

        public function toString():String
        {
            var object:Object = {
                x1: _x1, y1: _y1, x2: _x2, y2: _y2
            };
            return JSON.stringify(object);
        }

        public function closestPointToXY(x:Number, y:Number, resultPoint:Point = null):Point
        {
            resultPoint ||= new Point();
            resultPoint = toVector2D(helperVector1).closestPointToXY(x - _x1, y - _y1, resultPoint);
            resultPoint.offset(_x1, _y1);
            return resultPoint;
        }

        public function closestPointToP(point:Point, resultPoint:Point = null):Point
        {
            return closestPointToXY(point.x, point.y, resultPoint);
        }

        public function resetPoolObject():void
        {
            _x1 = 0;
            _y1 = 0;
            _x2 = 0;
            _y2 = 0;
        }
    }
}
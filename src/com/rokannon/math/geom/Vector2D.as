package com.rokannon.math.geom
{
    import com.rokannon.core.utils.getProperty;
    import com.rokannon.display.render.IRenderTarget;
    import com.rokannon.display.render.IRenderable;
    import com.rokannon.math.utils.getMax;
    import com.rokannon.math.utils.getMin;

    import flash.geom.Point;

    public class Vector2D implements IGeometricObject, IRenderable
    {
        private var _x:Number;
        private var _y:Number;

        public function Vector2D(x:Number = 0, y:Number = 0)
        {
            setTo(x, y);
        }

        public function get x():Number
        {
            return _x;
        }

        public function get y():Number
        {
            return _y;
        }

        public function setTo(x:Number, y:Number):void
        {
            _x = x;
            _y = y;
        }

        public function getLength():Number
        {
            return Math.sqrt(_x * _x + _y * _y);
        }

        public function getSquaredLength():Number
        {
            return _x * _x + _y * _y;
        }

        public function clone(resultVector:Vector2D = null):Vector2D
        {
            if (resultVector == null)
                resultVector = new Vector2D();
            resultVector.setTo(_x, _y);
            return resultVector;
        }

        public function dot(vector:Vector2D):Number
        {
            return _x * vector._x + _y * vector._y;
        }

        public function cross(vector:Vector2D):Number
        {
            return _x * vector._y - _y * vector._x;
        }

        public function lerp(t:Number, resultPoint:Point = null):Point
        {
            if (resultPoint == null)
                resultPoint = new Point();
            resultPoint.setTo(t * _x, t * _y);
            return resultPoint;
        }

        public function shift(t:Number, s:Number, resultPoint:Point = null):Point
        {
            if (resultPoint == null)
                resultPoint = new Point();
            var length:Number = getLength();
            resultPoint.setTo(t * _x - s * _y / length, t * _y + s * _x / length);
            return resultPoint;
        }

        public function project(onVector:Vector2D, resultVector:Vector2D = null):Vector2D
        {
            if (resultVector == null)
                resultVector = new Vector2D();
            var t:Number = (_x * onVector._x + _y * onVector._y) / (onVector._x * onVector._x + onVector._y * onVector._y);
            resultVector.setTo(t * onVector._x, t * onVector._y);
            return resultVector;
        }

        public function multiply(t:Number, resultVector:Vector2D = null):Vector2D
        {
            if (resultVector == null)
                resultVector = new Vector2D();
            resultVector.setTo(t * _x, t * _y);
            return resultVector;
        }

        public function inverse(resultVector:Vector2D = null):Vector2D
        {
            if (resultVector == null)
                resultVector = new Vector2D();
            resultVector.setTo(-_x, -_y);
            return resultVector;
        }

        public function rotate(angle:Number, resultVector:Vector2D = null):Vector2D
        {
            if (resultVector == null)
                resultVector = new Vector2D();
            var cos:Number = Math.cos(angle);
            var sin:Number = Math.sin(angle);
            resultVector.setTo(_x * cos - _y * sin, _x * sin + _y * cos);
            return resultVector;
        }

        public function normalize(length:Number, resultVector:Vector2D = null):Vector2D
        {
            if (resultVector == null)
                resultVector = new Vector2D();
            var t:Number = length / getLength();
            resultVector.setTo(t * _x, t * _y);
            return resultVector;
        }

        public static function createVector(start:Point, end:Point, resultVector:Vector2D = null):Vector2D
        {
            if (resultVector == null)
                resultVector = new Vector2D();
            resultVector.setTo(end.x - start.x, end.y - start.y);
            return resultVector;
        }

        public function render(renderTarget:IRenderTarget, renderSettings:Object):void
        {
            var color:uint = getProperty(renderSettings, "color", 0x000000);
            renderTarget.drawLine(0, 0, _x, _y, color);
        }

        public function toString():String
        {
            var object:Object = {
                x: _x, y: _y
            };
            return JSON.stringify(object);
        }

        public function closestPointToXY(x:Number, y:Number, resultPoint:Point = null):Point
        {
            if (resultPoint == null)
                resultPoint = new Point();
            var squareLength:Number = _x * _x + _y * _y;
            if (squareLength == 0)
                resultPoint.setTo(0, 0);
            else
            {
                var t:Number = (_x * x + _y * y) / squareLength;
                t = getMax(0, getMin(1, t));
                resultPoint.setTo(t * _x, t * _y);
            }
            return resultPoint;
        }

        public function closestPointToP(point:Point, resultPoint:Point = null):Point
        {
            return closestPointToXY(point.x, point.y, resultPoint);
        }
    }
}
package com.rokannon.math.geom
{
    import com.rokannon.core.pool.IPoolObject;

    public class Vector3D implements IPoolObject
    {
        private var _x:Number;
        private var _y:Number;
        private var _z:Number;

        public function Vector3D(x:Number = 0, y:Number = 0, z:Number = 0)
        {
            setTo(x, y, z);
        }

        public function get x():Number
        {
            return _x;
        }

        public function get y():Number
        {
            return _y;
        }

        public function get z():Number
        {
            return _z;
        }

        public function toString():String
        {
            var object:Object = {
                x: _x, y: _y, z: _z
            };
            return JSON.stringify(object);
        }

        public function setTo(x:Number, y:Number, z:Number):void
        {
            _x = x;
            _y = y;
            _z = z;
        }

        public function getLength():Number
        {
            return Math.sqrt(_x * _x + _y * _y + _z * _z);
        }

        public function getSquaredLength():Number
        {
            return _x * _x + _y * _y + _z * _z;
        }

        public function dot(v:Vector3D):Number
        {
            return _x * v._x + _y * v._y + _z * v._z;
        }

        public function cross(v:Vector3D, resultVector:Vector3D = null):Vector3D
        {
            if (resultVector == null)
                resultVector = new Vector3D();
            resultVector.setTo(cross2D(_y, v._y, _z, v._z), -cross2D(_x, v._x, _z, v._z), cross2D(_x, v._x, _y, v._y));
            return resultVector;
        }

        public function normalize(length:Number, resultVector:Vector3D = null):Vector3D
        {
            if (resultVector == null)
                resultVector = new Vector3D();
            var t:Number = length / getLength();
            resultVector.setTo(t * _x, t * _y, t * _z);
            return resultVector;
        }

        [Inline]
        private final function cross2D(u1:Number, u2:Number, v1:Number, v2:Number):Number
        {
            return u1 * v2 - u2 * v1;
        }

        public function resetPoolObject():void
        {
            _x = 0;
            _y = 0;
            _z = 0;
        }
    }
}
package com.rokannon.math.geom
{
    import flash.geom.Point;

    public interface IGeometricObject
    {
        function toString():String;

        function closestPointToXY(x:Number, y:Number, resultPoint:Point = null):Point;

        function closestPointToP(point:Point, resultPoint:Point = null):Point;
    }
}
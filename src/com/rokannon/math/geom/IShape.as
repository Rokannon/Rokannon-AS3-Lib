package com.rokannon.math.geom
{
    import com.rokannon.core.pool.IPoolObject;
    import com.rokannon.display.render.IRenderable;

    import flash.geom.Matrix;
    import flash.geom.Point;

    public interface IShape extends IGeometricObject, IRenderable, IPoolObject
    {
        function getBounds():AABBox;

        function containsXY(x:Number, y:Number):Boolean;

        function containsP(point:Point):Boolean;

        function intersectsSegment(segment:Segment):Boolean;

        function intersectsBox(box:AABBox):Boolean;

        function offsetXY(dx:Number, dy:Number):void;

        function offsetP(point:Point):void;

        function rotate(angle:Number):void;

        function applyTransform(transform:Matrix):void;

        function getRandomPoint(resultPoint:Point = null):Point;

        function getInternalPoint(resultPoint:Point = null):Point;
    }
}
package com.rokannon.math.utils.point
{
    import flash.geom.Point;

    public function scalePoint(point:Point, toPoint:Point, scaleX:Number, scaleY:Number, resultPoint:Point = null):Point
    {
        resultPoint ||= new Point();
        resultPoint.setTo(scaleX * (point.x - toPoint.x) + toPoint.x, scaleY * (point.y - toPoint.y) + toPoint.y);
        return resultPoint;
    }
}
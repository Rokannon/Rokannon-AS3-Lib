package com.rokannon.math.utils.point
{
    import flash.geom.Point;

    public function getPointLerp(point1:Point, point2:Point, t:Number, resultPoint:Point = null):Point
    {
        resultPoint ||= new Point();
        resultPoint.setTo(point1.x + t * (point2.x - point1.x), point1.y + t * (point2.y - point1.y));
        return resultPoint;
    }
}
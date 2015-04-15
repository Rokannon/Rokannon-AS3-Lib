package com.rokannon.math.utils.point
{
    import flash.geom.Point;

    public function getPointDistance(point1:Point, point2:Point):Number
    {
        var dx:Number = point1.x - point2.x;
        var dy:Number = point1.y - point2.y;
        return Math.sqrt(dx * dx + dy * dy);
    }
}
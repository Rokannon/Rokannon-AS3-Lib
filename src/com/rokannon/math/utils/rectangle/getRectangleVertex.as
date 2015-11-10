package com.rokannon.math.utils.rectangle
{
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public function getRectangleVertex(index:int, rectangle:Rectangle, resultPoint:Point = null):Point
    {
        resultPoint ||= new Point();
        index = index & 3;
        resultPoint.setTo(rectangle.x + (((index + 1) & 3) >> 1) * rectangle.width,
            rectangle.y + (index >> 1) * rectangle.height);
        return resultPoint;
    }
}
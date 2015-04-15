package com.rokannon.math.utils.rectangle
{
    import com.rokannon.math.utils.getMax;
    import com.rokannon.math.utils.getMin;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    public function inflateRectangleToPoint(rectangle:Rectangle, point:Point):void
    {
        rectangle.left = getMin(rectangle.left, point.x);
        rectangle.right = getMax(rectangle.right, point.x);
        rectangle.top = getMin(rectangle.top, point.y);
        rectangle.bottom = getMax(rectangle.bottom, point.y);
    }
}
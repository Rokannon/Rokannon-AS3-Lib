package com.rokannon.math.utils.rectangle
{
    import com.rokannon.math.utils.getMax;
    import com.rokannon.math.utils.getMin;

    import flash.geom.Rectangle;

    public function unionRectangle(rectangle1:Rectangle, rectangle2:Rectangle,
                                   resultRectangle:Rectangle = null):Rectangle
    {
        resultRectangle ||= new Rectangle();
        var x:Number = getMin(rectangle1.x, rectangle2.x);
        var y:Number = getMin(rectangle1.y, rectangle2.y);
        resultRectangle.setTo(x, y, getMax(rectangle1.x + rectangle1.width, rectangle2.x + rectangle2.width) - x,
            getMax(rectangle1.y + rectangle1.height, rectangle2.y + rectangle2.height) - y);
        return resultRectangle;
    }
}
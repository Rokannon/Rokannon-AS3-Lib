package com.rokannon.math.utils.matrix
{
    import flash.geom.Matrix;
    import flash.geom.Point;

    public function matrixTransformPoint(matrix:Matrix, point:Point, resultPoint:Point = null):Point
    {
        resultPoint ||= new Point();
        resultPoint.setTo(matrix.a * point.x + matrix.c * point.y + matrix.tx,
            matrix.b * point.x + matrix.d * point.y + matrix.ty);
        return resultPoint;
    }
}
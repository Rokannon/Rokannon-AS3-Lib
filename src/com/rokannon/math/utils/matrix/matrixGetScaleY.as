package com.rokannon.math.utils.matrix
{
    import flash.geom.Matrix;

    public function matrixGetScaleY(matrix:Matrix):Number
    {
        return Math.sqrt(matrix.c * matrix.c + matrix.d * matrix.d);
    }
}
package com.rokannon.math.utils.matrix
{
    import flash.geom.Matrix;

    public function matrixGetScaleX(matrix:Matrix):Number
    {
        return Math.sqrt(matrix.a * matrix.a + matrix.b * matrix.b);
    }
}
package com.rokannon.math.utils.angle
{
    public function getNormalizedAngle(angle:Number):Number
    {
        angle %= 2 * Math.PI;
        if (angle < 0)
            angle += 2 * Math.PI;
        return angle;
    }
}
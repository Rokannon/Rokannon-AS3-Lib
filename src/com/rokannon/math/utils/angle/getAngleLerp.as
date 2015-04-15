package com.rokannon.math.utils.angle
{
    public function getAngleLerp(angle1:Number, angle2:Number, t:Number):Number
    {
        angle1 %= 2 * Math.PI;
        angle2 %= 2 * Math.PI;
        if (angle1 < 0)
            angle1 += 2 * Math.PI;
        if (angle2 < 0)
            angle2 += 2 * Math.PI;

        if (angle1 < angle2)
        {
            if (angle2 - angle1 > Math.PI)
                angle1 += 2 * Math.PI;
            return (1 - t) * angle1 + t * angle2;
        }

        if (angle2 < angle1)
        {
            if (angle1 - angle2 > Math.PI)
                angle2 += 2 * Math.PI;
            return (1 - t) * angle2 + t * angle1;
        }

        return angle1;
    }
}
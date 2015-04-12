package com.rokannon.math.utils
{
    public function getNumDigits(n:int):int
    {
        if (n == 0)
            return 1;
        n = getAbs(n);
        for (var i:int = 0; n != 0; ++i)
            n = int(n / 10);
        return i;
    }
}
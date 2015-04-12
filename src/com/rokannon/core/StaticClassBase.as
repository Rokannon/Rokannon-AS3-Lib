package com.rokannon.core
{
    import com.rokannon.core.errors.StaticClassError;

    public class StaticClassBase
    {
        public function StaticClassBase()
        {
            throw new StaticClassError();
        }
    }
}
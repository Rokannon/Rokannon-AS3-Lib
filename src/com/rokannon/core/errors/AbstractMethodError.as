package com.rokannon.core.errors
{
    public class AbstractMethodError extends Error
    {
        public function AbstractMethodError()
        {
            super("This method must be implemented in subclass.");
        }
    }
}
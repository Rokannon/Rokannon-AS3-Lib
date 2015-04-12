package com.rokannon.core.errors
{
    public class SingletonClassError extends Error
    {
        public function SingletonClassError()
        {
            super("This is a singleton class. Use 'instance' property.");
        }
    }
}
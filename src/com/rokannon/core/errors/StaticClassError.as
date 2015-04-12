package com.rokannon.core.errors
{
    public class StaticClassError extends Error
    {
        public function StaticClassError()
        {
            super("This is static class. It cannot be instantiated.");
        }
    }
}
package com.rokannon.display.render
{
    public interface IRenderTarget
    {
        function drawCircle(x:Number, y:Number, radius:Number, color:uint):void;

        function drawPolygon(vertices:Vector.<Number>, color:uint):void;

        function drawFilledCircle(x:Number, y:Number, radius:Number, color:uint):void;

        function drawFilledPolygon(vertices:Vector.<Number>, color:uint):void;

        function drawLine(startX:Number, startY:Number, endX:Number, endY:Number, color:uint):void;
    }
}
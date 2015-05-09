package com.rokannon.display.render
{
    import flash.display.Graphics;

    public class NativeRenderTarget implements IRenderTarget
    {
        private var _lineThickness:Number;
        private var _graphics:Graphics;

        public function NativeRenderTarget(graphics:Graphics, lineThickness:Number = 1)
        {
            _graphics = graphics;
            _lineThickness = lineThickness;
        }

        public function drawCircle(x:Number, y:Number, radius:Number, color:uint):void
        {
            _graphics.lineStyle(_lineThickness, color);
            _graphics.drawCircle(x, y, radius);
        }

        public function drawPolygon(vertices:Vector.<Number>, color:uint):void
        {
            _graphics.lineStyle(_lineThickness, color);
            _graphics.moveTo(vertices[0], vertices[1]);
            for (var i:int = vertices.length - 1; i >= 0; i -= 2)
                _graphics.lineTo(vertices[i - 1], vertices[i]);
        }

        public function drawFilledCircle(x:Number, y:Number, radius:Number, color:uint):void
        {
            _graphics.lineStyle();
            _graphics.beginFill(color);
            _graphics.drawCircle(x, y, radius);
            _graphics.endFill();
        }

        public function drawFilledPolygon(vertices:Vector.<Number>, color:uint):void
        {
            _graphics.lineStyle();
            _graphics.beginFill(color);
            _graphics.moveTo(vertices[0], vertices[1]);
            for (var i:int = vertices.length - 1; i >= 0; i -= 2)
                _graphics.lineTo(vertices[i - 1], vertices[i]);
            _graphics.endFill();
        }

        public function drawLine(startX:Number, startY:Number, endX:Number, endY:Number, color:uint):void
        {
            _graphics.lineStyle(_lineThickness, color);
            _graphics.moveTo(startX, startY);
            _graphics.lineTo(endX, endY);
        }
    }
}
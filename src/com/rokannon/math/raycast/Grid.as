package com.rokannon.math.raycast
{
    import com.rokannon.core.pool.ObjectPool;
    import com.rokannon.core.utils.getProperty;
    import com.rokannon.display.render.IRenderTarget;
    import com.rokannon.display.render.IRenderable;
    import com.rokannon.logging.Log;
    import com.rokannon.logging.Logger;
    import com.rokannon.math.geom.AABBox;
    import com.rokannon.math.geom.IShape;
    import com.rokannon.math.geom.Segment;
    import com.rokannon.math.utils.getAbs;
    import com.rokannon.math.utils.getFloor;
    import com.rokannon.math.utils.getMax;
    import com.rokannon.math.utils.getMin;

    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    public class Grid implements IRenderable
    {
        private static const logger:Logger = Log.instance.getLogger(Grid);
        private static const helperBox:AABBox = new AABBox();
        private static const helperSegment:Segment = new Segment();
        private static const helperObject:Object = {};
        private static const objectPool:ObjectPool = ObjectPool.instance;

        private const _voxels:Vector.<Voxel> = new <Voxel>[];
        private const _gridObjectByShape:Dictionary = new Dictionary();

        private var _voxelWidth:Number;
        private var _voxelHeight:Number;
        private var _inv_voxelWidth:Number;
        private var _inv_voxelHeight:Number;
        private var _minIndexX:int;
        private var _maxIndexX:int;
        private var _minIndexY:int;
        private var _maxIndexY:int;
        private var _numVoxelsX:int;
        private var _numVoxelsY:int;
        private var _numVoxels:int;
        private var _actionIDCounter:uint;
        private var _minX:Number;
        private var _maxX:Number;
        private var _minY:Number;
        private var _maxY:Number;

        public function Grid(voxelWidth:Number, voxelHeight:Number, minIndexX:int, maxIndexX:int, minIndexY:int,
                             maxIndexY:int)
        {
            CONFIG::log_fatal
            {
                if (voxelWidth <= 0 || voxelHeight <= 0)
                    logger.fatal("Invalid voxel size: (voxelWidth={0}, voxelHeight={1})", voxelWidth, voxelHeight);
                if (minIndexX > maxIndexX || minIndexY > maxIndexY)
                    logger.fatal("Invalid min/max indices: {0}",
                        new AABBox(minIndexX, minIndexY, maxIndexX, maxIndexY).toString());
            }

            _voxelWidth = voxelWidth;
            _voxelHeight = voxelHeight;
            _inv_voxelWidth = 1.0 / _voxelWidth;
            _inv_voxelHeight = 1.0 / _voxelHeight;
            _minIndexX = minIndexX;
            _maxIndexX = maxIndexX;
            _minIndexY = minIndexY;
            _maxIndexY = maxIndexY;
            _numVoxelsX = _maxIndexX - _minIndexX + 1;
            _numVoxelsY = _maxIndexY - _minIndexY + 1;
            _numVoxels = _numVoxelsX * _numVoxelsY;
            _actionIDCounter = 0;
            _minX = _voxelWidth * _minIndexX;
            _maxX = _voxelWidth * (_maxIndexX + 1);
            _minY = _voxelHeight * _minIndexY;
            _maxY = _voxelHeight * (_maxIndexY + 1);
            _voxels.length = _numVoxels;
            _voxels.fixed = true;
        }

        public function segmentCheckXY(x1:Number, y1:Number, x2:Number, y2:Number):Boolean
        {
            var actionID:uint = ++_actionIDCounter;

            var uX:Number = x1;
            var uY:Number = y1;
            var vX:Number = x2 - x1;
            var vY:Number = y2 - y1;
            var inv_vX:Number = 1.0 / vX;
            var inv_vY:Number = 1.0 / vY;

            var indexX:int;
            var indexY:int;

            if (uX < _minX || uX >= _maxX || uY < _minY || uY >= _maxY)
            {
                var tBest:Number = 1;
                var t:Number;
                var found:Boolean = false;
                var value:Number;
                if (vX > 0)
                {
                    t = (_minX - uX) * inv_vX;
                    value = uY + t * vY;
                    if (0 < t && t < tBest && _minY <= value && value < _maxY)
                    {
                        tBest = t;
                        indexX = _minIndexX;
                        indexY = getFloor(value * _inv_voxelHeight);
                        found = true;
                    }
                }
                else if (vX < 0)
                {
                    t = (_maxX - uX) * inv_vX;
                    value = uY + t * vY;
                    if (0 < t && t < tBest && _minY <= value && value < _maxY)
                    {
                        tBest = t;
                        indexX = _maxIndexX;
                        indexY = getFloor(value * _inv_voxelHeight);
                        found = true;
                    }
                }
                if (vY > 0)
                {
                    t = (_minY - uY) * inv_vY;
                    value = uX + t * vX;
                    if (0 < t && t < tBest && _minX <= value && value < _maxX)
                    {
                        tBest = t;
                        indexX = getFloor(value * _inv_voxelWidth);
                        indexY = _minIndexY;
                        found = true;
                    }
                }
                else if (vY < 0)
                {
                    t = (_maxY - uY) * inv_vY;
                    value = uX + t * vX;
                    if (0 < t && t < tBest && _minX <= value && value < _maxX)
                    {
                        tBest = t;
                        indexX = getFloor(value * _inv_voxelWidth);
                        indexY = _maxIndexY;
                        found = true;
                    }
                }
                if (!found)
                    return true;
            }
            else
            {
                indexX = getFloor(uX * _inv_voxelWidth);
                indexY = getFloor(uY * _inv_voxelHeight);
            }

            var tDeltaX:Number = getAbs(_voxelWidth * inv_vX);
            var tDeltaY:Number = getAbs(_voxelHeight * inv_vY);

            var stepIndexX:int;
            if (vX > 0)
                stepIndexX = +1;
            else if (vX < 0)
                stepIndexX = -1;
            else
                stepIndexX = 0;

            var stepIndexY:int;
            if (vY > 0)
                stepIndexY = +1;
            else if (vY < 0)
                stepIndexY = -1;
            else
                stepIndexY = 0;

            var tMaxX:Number = vX == 0 ? Infinity : (_voxelWidth * (indexX + int(vX > 0)) - uX) * inv_vX;
            var tMaxY:Number = vY == 0 ? Infinity : (_voxelHeight * (indexY + int(vY > 0)) - uY) * inv_vY;

            var minIndexX:int;
            var maxIndexX:int;
            if (vX > 0)
            {
                minIndexX = _minIndexX;
                maxIndexX = getMin(_maxIndexX, getFloor(x2 * _inv_voxelWidth));
            }
            else
            {
                minIndexX = getMax(_minIndexX, getFloor(x2 * _inv_voxelWidth));
                maxIndexX = _maxIndexX;
            }

            var minIndexY:int;
            var maxIndexY:int;
            if (vY > 0)
            {
                minIndexY = _minIndexY;
                maxIndexY = getMin(_maxIndexY, getFloor(y2 * _inv_voxelHeight));
            }
            else
            {
                minIndexY = getMax(_minIndexY, getFloor(y2 * _inv_voxelHeight));
                maxIndexY = _maxIndexY;
            }

            helperSegment.setTo(x1, y1, x2, y2);
            var firstVoxel:Boolean = true;

            while (true)
            {
                var voxel:Voxel = getVoxel(indexX, indexY);

                CONFIG::debug
                {
                    var intersects:Boolean = false;
                }

                if (voxel != null)
                {
                    for each (var gridObject:GridObject in voxel.gridObjects)
                    {
                        if (gridObject.lastActionID == actionID)
                            continue;
                        gridObject.lastActionID = actionID;
                        if (gridObject.shape.intersectsSegment(helperSegment) && (!firstVoxel || !gridObject.shape.containsXY(x1,
                                y1)))
                        {
                            CONFIG::release
                            {
                                return false;
                            }

                            CONFIG::debug
                            {
                                intersects = true;
                            }
                        }
                    }
                    if (firstVoxel)
                        firstVoxel = false;
                }

                CONFIG::debug
                {
                    if (intersects)
                    {
                        if (_renderTarget != null)
                        {
                            getVoxelBounds(indexX, indexY, helperBox);
                            helperObject["color"] = getProperty(_renderSettings, "hitVoxelColor", 0x000000);
                            helperObject["filled"] = true;
                            helperObject["offset"] = -1;
                            helperBox.render(_renderTarget, _renderSettings);
                        }
                        return false;
                    }
                    else
                    {
                        if (_renderTarget != null)
                        {
                            getVoxelBounds(indexX, indexY, helperBox);
                            helperObject["color"] = getProperty(_renderSettings, "visitedVoxelColor", 0x000000);
                            helperObject["filled"] = true;
                            helperObject["offset"] = -1;
                            helperBox.render(_renderTarget, _renderSettings);
                        }
                    }
                }

                if (tMaxX < tMaxY)
                {
                    indexX += stepIndexX;
                    if (indexX < minIndexX || indexX > maxIndexX)
                        break;
                    tMaxX += tDeltaX;
                }
                else if (tMaxX >= tMaxY)
                {
                    indexY += stepIndexY;
                    if (indexY < minIndexY || indexY > maxIndexY)
                        break;
                    tMaxY += tDeltaY;
                }
                if (tMaxX == Infinity && tMaxY == Infinity)
                    break;
            }
            return true;
        }

        public function segmentCheckP(point1:Point, point2:Point):Boolean
        {
            return segmentCheckXY(point1.x, point1.y, point2.x, point2.y);
        }

        public function getShapesInBox(box:AABBox, resultShapes:Vector.<IShape> = null):Vector.<IShape>
        {
            resultShapes ||= new <IShape>[];
            var actionID:uint = ++_actionIDCounter;
            var minIndexX:int = getMax(getFloor(box.xMin / _voxelWidth), _minIndexX);
            var maxIndexX:int = getMin(getFloor(box.xMax / _voxelWidth), _maxIndexX);
            var minIndexY:int = getMax(getFloor(box.yMin / _voxelHeight), _minIndexY);
            var maxIndexY:int = getMin(getFloor(box.yMax / _voxelHeight), _maxIndexY);
            for (var indexX:int = minIndexX; indexX <= maxIndexX; ++indexX)
            {
                for (var indexY:int = minIndexY; indexY <= maxIndexY; ++indexY)
                {
                    var voxel:Voxel = getVoxel(indexX, indexY);
                    if (voxel == null)
                        continue;
                    for each (var gridObject:GridObject in voxel.gridObjects)
                    {
                        if (gridObject.lastActionID != actionID && gridObject.shape.intersectsBox(box))
                        {
                            gridObject.lastActionID = actionID;
                            resultShapes.push(gridObject.shape);
                        }
                    }
                }
            }
            return resultShapes;
        }

        public function getShapesUnderXY(x:Number, y:Number, resultShapes:Vector.<IShape> = null):Vector.<IShape>
        {
            resultShapes ||= new <IShape>[];
            var indexX:int = getFloor(x / _voxelWidth);
            var indexY:int = getFloor(y / _voxelHeight);
            if (_minIndexX <= indexX && indexX <= _maxIndexX && _minIndexY <= indexY && indexY <= _maxIndexY)
            {
                var voxel:Voxel = getVoxel(indexX, indexY);
                if (voxel != null)
                {
                    for each (var gridObject:GridObject in voxel.gridObjects)
                    {
                        if (gridObject.shape.containsXY(x, y))
                            resultShapes.push(gridObject.shape);
                    }
                }
            }
            return resultShapes;
        }

        public function getShapesUnderP(point:Point, resultShapes:Vector.<IShape> = null):Vector.<IShape>
        {
            return getShapesUnderXY(point.x, point.y, resultShapes);
        }

        public function addShape(shape:IShape):void
        {
            if (_gridObjectByShape[shape] != null)
                return;

            var gridObject:GridObject = GridObject(objectPool.createObject(GridObject));
            _gridObjectByShape[shape] = gridObject;
            gridObject.shape = shape;
            var bounds:AABBox = shape.getBounds();
            var minIndexX:int = getMax(getFloor(bounds.xMin / _voxelWidth), _minIndexX);
            var maxIndexX:int = getMin(getFloor(bounds.xMax / _voxelWidth), _maxIndexX);
            var minIndexY:int = getMax(getFloor(bounds.yMin / _voxelHeight), _minIndexY);
            var maxIndexY:int = getMin(getFloor(bounds.yMax / _voxelHeight), _maxIndexY);
            for (var indexX:int = minIndexX; indexX <= maxIndexX; ++indexX)
            {
                for (var indexY:int = minIndexY; indexY <= maxIndexY; ++indexY)
                {
                    getVoxelBounds(indexX, indexY, helperBox);
                    if (!helperBox.intersectsShape(shape))
                        continue;
                    var voxelIndex:int = getVoxelIndex(indexX, indexY);
                    _voxels[voxelIndex] ||= Voxel(objectPool.createObject(Voxel));
                    var voxel:Voxel = _voxels[voxelIndex];
                    voxel.index = voxelIndex;
                    voxel.gridObjects.push(gridObject);
                    gridObject.voxels.push(voxel);
                }
            }
        }

        public function removeShape(shape:IShape):void
        {
            var gridObject:GridObject = _gridObjectByShape[shape];
            if (gridObject == null)
                return;
            delete _gridObjectByShape[shape];
            for each (var voxel:Voxel in gridObject.voxels)
            {
                var index:int = voxel.gridObjects.indexOf(gridObject);
                if (index != -1)
                    voxel.gridObjects.splice(index, 1);
                if (voxel.gridObjects.length == 0)
                {
                    _voxels[voxel.index] = null;
                    objectPool.releaseObject(voxel);
                }
            }
            objectPool.releaseObject(gridObject);
        }

        [Inline]
        private final function getVoxelIndex(indexX:int, indexY:int):int
        {
            return (indexY - _minIndexY) * _numVoxelsX + (indexX - _minIndexX);
        }

        [Inline]
        private final function getVoxel(indexX:int, indexY:int):Voxel
        {
            return _voxels[(indexY - _minIndexY) * _numVoxelsX + (indexX - _minIndexX)];
        }

        [Inline]
        private final function getVoxelBounds(indexX:int, indexY:int, resultBounds:AABBox):AABBox
        {
            resultBounds.setTo(indexX * _voxelWidth, indexY * _voxelHeight, (indexX + 1) * _voxelWidth,
                (indexY + 1) * _voxelHeight);
            return resultBounds;
        }

        private var _renderTarget:IRenderTarget;
        private var _renderSettings:Object;

        public function render(renderTarget:IRenderTarget, renderSettings:Object):void
        {
            var gridColor:uint = getProperty(renderSettings, "gridColor", 0x000000);
            var emptyVoxelColor:uint = getProperty(renderSettings, "emptyVoxelColor", 0x000000);
            var occupiedVoxelColor:uint = getProperty(renderSettings, "occupiedVoxelColor", 0x000000);
            var fillEmptyVoxels:Boolean = getProperty(renderSettings, "fillEmptyVoxels", false);
            var fillOccupiedVoxels:Boolean = getProperty(renderSettings, "fillOccupiedVoxels", false);
            var renderGridObjects:Boolean = getProperty(renderSettings, "renderGridObjects", false);
            var gridObjectColor:uint = getProperty(renderSettings, "gridObjectColor", 0x000000);

            _renderTarget = renderTarget;
            _renderSettings = renderSettings;

            var actionID:uint = ++_actionIDCounter;

            for (var indexX:int = _minIndexX; indexX <= _maxIndexX; ++indexX)
            {
                for (var indexY:int = _minIndexY; indexY <= _maxIndexY; ++indexY)
                {
                    var voxel:Voxel = _voxels[getVoxelIndex(indexX, indexY)];
                    getVoxelBounds(indexX, indexY, helperBox);

                    // Grid
                    helperObject["color"] = gridColor;
                    helperObject["filled"] = false;
                    helperBox.render(renderTarget, helperObject);

                    // Voxel
                    if (voxel != null && voxel.gridObjects.length != 0)
                    {
                        if (fillOccupiedVoxels)
                        {
                            helperObject["color"] = occupiedVoxelColor;
                            helperObject["filled"] = true;
                            helperObject["offset"] = -1;
                            helperBox.render(renderTarget, helperObject);
                        }
                    }
                    else
                    {
                        if (fillEmptyVoxels)
                        {
                            helperObject["color"] = emptyVoxelColor;
                            helperObject["filled"] = true;
                            helperObject["offset"] = -1;
                            helperBox.render(renderTarget, helperObject);
                        }
                    }

                    // Grid objects
                    if (voxel != null && renderGridObjects)
                    {
                        for each (var gridObject:GridObject in voxel.gridObjects)
                        {
                            if (gridObject.lastActionID == actionID)
                                continue;
                            gridObject.lastActionID = actionID;
                            helperObject["color"] = gridObjectColor;
                            helperObject["filled"] = true;
                            gridObject.shape.render(renderTarget, helperObject);
                        }
                    }
                }
            }
        }

        public static function createFromRectangle(voxelWidth:Number, voxelHeight:Number, rectangle:Rectangle):Grid
        {
            var minIndexX:int = int.MAX_VALUE;
            var maxIndexX:int = int.MIN_VALUE;
            var minIndexY:int = int.MAX_VALUE;
            var maxIndexY:int = int.MIN_VALUE;

            for (var i:int = 0; i < 4; ++i)
            {
                var indexX:int = getFloor((rectangle.x + int(((i + 1) % 4) * 0.5) * rectangle.width) / voxelWidth);
                var indexY:int = getFloor((rectangle.y + int(i * 0.5) * rectangle.height) / voxelHeight);
                minIndexX = getMin(minIndexX, indexX);
                maxIndexX = getMax(maxIndexX, indexX);
                minIndexY = getMin(minIndexY, indexY);
                maxIndexY = getMax(maxIndexY, indexY);
            }

            return new Grid(voxelWidth, voxelHeight, minIndexX, maxIndexX, minIndexY, maxIndexY);
        }
    }
}
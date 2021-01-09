if app.activeSprite then
  local dialog = Dialog("Deduplicate Tiles")

  dialog:number { id = "sizeX", label = "Tile width", text = "8", decimals = 0 }
        :number { id = "sizeY", label = "Tile height", text = "8", decimals = 0 }
        :check { id = "useGrid", text = "Use grid settings", selected = true }
        :button { id="ok", text = "OK" }
        :button { id="cancel", text = "Cancel" }

  dialog:show()

  local data = dialog.data

  if data.ok then
    local sprite = app.activeSprite
    local image = app.activeImage

    function computeSizes()
      if data.useGrid then
        return sprite.gridBounds.width, sprite.gridBounds.height
      else
        return data.sizeX, data.sizeY
      end
    end

    local sizeX, sizeY = computeSizes() 
    local tilesX, tilesY = sprite.width / sizeX, sprite.height / sizeY

    function computeEmptyColor()
      if sprite.colorMode == ColorMode.RGB then
        return app.pixelColor.rgba(0, 0, 0, 0)
      elseif sprite.colorMode == ColorMode.GRAY then
        return app.pixelColor.greya(0, 0)
      elseif sprite.colorMode == ColorMode.INDEXED then
        return sprite.transparentColor
      else
        return 0
      end
    end

    local emptyColor = computeEmptyColor()

    function tileEquals(x1, y1, x2, y2)
      for y = 0, sizeY - 1 do
        for x = 0, sizeX - 1 do
          if image:getPixel(x1 * sizeX + x, y1 * sizeY + y) ~= image:getPixel(x2 * sizeX + x, y2 * sizeY + y) then
            return false
          end
        end
      end

      return true
    end

    function isTileEmpty(startX, startY)
      for y = startY * sizeY, startY * sizeY + sizeY - 1 do
        for x = startX * sizeX, startX * sizeX + sizeX - 1 do
          if image:getPixel(x, y) ~= emptyColor then
            return false
          end
        end
      end

      return true
    end

    function isDuplicate(x1, y1, x2, y2)
      return not (x1 == x2 and y1 == y2)
        and not isTileEmpty(x1, y1)
        and not isTileEmpty(x2, y2)
        and tileEquals(x1, y1, x2, y2)
    end

    function clearTile(startX, startY)
      for y = startY * sizeY, startY * sizeY + sizeY - 1 do
        for x = startX * sizeX, startX * sizeX + sizeX - 1 do
          image:drawPixel(x, y, emptyColor)
        end
      end
    end

    app.transaction(function()
      for tileY = 0, tilesY - 1 do
        for tileX = 0, tilesX - 1 do
          for otherY = 0, tilesY - 1 do
            for otherX = 0, tilesX - 1 do
              if isDuplicate(tileX, tileY, otherX, otherY) then
                clearTile(otherX, otherY)
              end
            end
          end
        end
      end
    end)
  end
end
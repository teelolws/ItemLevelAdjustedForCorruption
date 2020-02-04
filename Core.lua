ItemLevelAdjustedForCorruption = LibStub("AceAddon-3.0"):NewAddon("ItemLevelAdjustedForCorruption", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceTimer-3.0")

function linkToID(itemLink)
	local _, _, _, _, Id = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*):?(%-?%d*):?(%-?%d*):?(%d*):?(%d*)|?h?%[?([^%[%]]*)%]?|?h?|?r?")
	return tonumber(Id)
end

function scanStats(tooltip)
    local corruption = 0
    local infiniteStars = false
	for i = 30,1,-1 do
		local frame = _G[tooltip:GetName() .. "TextLeft" .. i]
		local text
		local right
		if frame then text = frame:GetText() end
		if text then			
			sdata = string.match(text, "\+([%d]+) Corruption")
			if sdata ~= nil then
                corruption = tonumber(sdata)
            end
            if (string.find(text, "Infinite Stars")) then
                infiniteStars = true
            end
            sdata = string.match(text, "Item Level ([%d]+)")
            if (sdata ~= nil) and (corruption ~= 0) then
                -- Hey, thanks for reading the code. This line here makes it so T3 Infinite Stars makes the item level OVER NINE THOUSANNNNNNNNNDDDD!!!!!!!11111 What? Nine thousand? Theres no way that can be right.
                if ((corruption == 75) and (infiniteStars == true)) then
                    frame:SetText(string.gsub(text, "Item Level ([%d]+)", "Item Level 9001"))
                    text = frame:GetText()
                else
                    local newItemLevel = (corruption * 2) + sdata
                    frame:SetText(string.gsub(text, "Item Level ([%d]+)", "Item Level "..newItemLevel))
                    text = frame:GetText()
                end
            end
        end
	end
end

function OnTooltip_Item(self, tooltip)
	local name,link = self:GetItem()

	if link == nil then
		return
	end
    
    -- Don't process the legendary cloak        
	if linkToID(link) == 169223 then tooltip:Show() return end

	scanStats(tooltip)

	tooltip:Show()
end


function ItemLevelAdjustedForCorruption:OnEnable()
	GameTooltip:HookScript("OnTooltipSetItem", function(...) OnTooltip_Item(..., GameTooltip) end)
	ItemRefTooltip:HookScript("OnTooltipSetItem", function(...) OnTooltip_Item(..., ItemRefTooltip) end)
	ShoppingTooltip1:HookScript("OnTooltipSetItem", function(...) OnTooltip_Item(..., ShoppingTooltip1) end)
	ShoppingTooltip2:HookScript("OnTooltipSetItem", function(...) OnTooltip_Item(..., ShoppingTooltip2) end)
	WorldMapTooltip.ItemTooltip.Tooltip:HookScript('OnTooltipSetItem', function(...) OnTooltip_Item(..., WorldMapTooltip.ItemTooltip.Tooltip) end)
end
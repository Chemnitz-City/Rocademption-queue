local connected = false

AddEventHandler("playerSpawned", function()
	if not connected then
		connected = true
		TriggerServerEvent("rocademption:playerConnected")
	end
end)

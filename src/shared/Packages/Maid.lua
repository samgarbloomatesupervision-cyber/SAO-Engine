-- Maid.lua
-- Author: Quenty
-- Source: https://github.com/Quenty/NevermoreEngine/blob/version2/Modules/Shared/Events/Maid.lua

local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({
		_tasks = {}
	}, Maid)
end

function Maid:GiveTask(task)
	if not task then
		error("Task cannot be false or nil", 2)
	end

	local taskId = #self._tasks + 1
	self._tasks[taskId] = task

	if type(task) == "function" then
		return taskId
	elseif typeof(task) == "RBXScriptConnection" then
		return taskId
	elseif type(task) == "table" and (type(task.Destroy) == "function" or type(task.Disconnect) == "function") then
		return taskId
	end

	return taskId
end

function Maid:DoCleaning()
	local tasks = self._tasks
	for i, task in ipairs(tasks) do
		if type(task) == "function" then
			task()
		elseif typeof(task) == "RBXScriptConnection" then
			task:Disconnect()
		elseif type(task) == "table" then
			if type(task.Destroy) == "function" then
				task:Destroy()
			elseif type(task.Disconnect) == "function" then
				task:Disconnect()
			end
		end
		tasks[i] = nil
	end
end

Maid.Destroy = Maid.DoCleaning

return Maid

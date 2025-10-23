for _, v in script.Parent.Services:GetChildren() do
    pcall(function()
        task.spawn(function()
            if v:IsA("ModuleScript") then
                require(v)
            else
                warn("Skipping non-ModuleScript: " .. v.Name)
            end
        end)
    end)
end

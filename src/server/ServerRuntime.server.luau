for _,v in script.Parent.Services:GetChildren() do
    pcall(function()
        task.spawn(function()
            require(v)
        end)
    end)
end
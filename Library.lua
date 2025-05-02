-- ModuleScript: SimpleUI
local SimpleUI = {}
SimpleUI.__index = SimpleUI

-- Utility: Create a UI instance
local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

-- Main CreateWindow
function SimpleUI:CreateWindow(title)
    local self = setmetatable({}, SimpleUI)

    -- ScreenGui
    local gui = create("ScreenGui", {
        Name = "SimpleUI_" .. title,
        ResetOnSpawn = false,
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    })

    -- Main Frame
    local main = create("Frame", {
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.5, -200, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = gui
    })

    create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = main })

    -- Tab buttons container
    local tabButtons = create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = main
    })

    local tabContainer = create("Frame", {
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 1, -30),
        BackgroundTransparency = 1,
        Parent = main
    })

    self._gui = gui
    self._tabs = {}
    self._tabButtons = tabButtons
    self._tabContainer = tabContainer
    self._selectedTab = nil

    function self:CreateTab(tabName)
        local tab = {}

        -- Create Tab Content Frame
        local tabFrame = create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            Parent = tabContainer
        })

        local layout = create("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabFrame
        })

        -- Create Tab Button
        local button = create("TextButton", {
            Size = UDim2.new(0, 100, 1, 0),
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            Text = tabName,
            TextColor3 = Color3.new(1, 1, 1),
            Parent = tabButtons
        })

        create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = button })

        button.MouseButton1Click:Connect(function()
            for _, t in pairs(self._tabs) do
                t._frame.Visible = false
            end
            tabFrame.Visible = true
            self._selectedTab = tab
        end)

        tab._frame = tabFrame

        function tab:AddToggle(name, default, callback)
            local toggle = create("TextButton", {
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundColor3 = Color3.fromRGB(70, 70, 70),
                Text = name .. ": " .. (default and "ON" or "OFF"),
                TextColor3 = Color3.new(1, 1, 1),
                Parent = tabFrame
            })

            create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = toggle })

            local state = default

            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.Text = name .. ": " .. (state and "ON" or "OFF")
                if callback then callback(state) end
            end)
        end

        function tab:AddButton(name, callback)
            local button = create("TextButton", {
                Size = UDim2.new(1, -10, 0, 30),
                BackgroundColor3 = Color3.fromRGB(100, 100, 100),
                Text = name,
                TextColor3 = Color3.new(1, 1, 1),
                Parent = tabFrame
            })

            create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = button })

            button.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end

        table.insert(self._tabs, tab)
        if #self._tabs == 1 then
            tabFrame.Visible = true
            self._selectedTab = tab
        end

        return tab
    end

    return self
end

return SimpleUI

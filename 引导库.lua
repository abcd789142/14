-- RainbowUI Library (模仿您提供的模板风格)
-- 版本: 1.0
-- 作者: AI助手

local RainbowUI = {}
RainbowUI.__index = RainbowUI

-- 默认配置
local DEFAULT_CONFIG = {
    Title = "彩虹UI",
    Version = "1.0",
    PrimaryColor = Color3.fromRGB(25, 25, 25),
    SecondaryColor = Color3.fromRGB(45, 45, 45),
    AccentColor = Color3.fromRGB(0, 170, 255),
    Size = UDim2.new(0.35, 0, 0.5, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    RainbowSpeed = 1
}

-- 创建新窗口
function RainbowUI:Create(Title, Version)
    local self = setmetatable({}, RainbowUI)
    self.Config = table.clone(DEFAULT_CONFIG)
    self.Config.Title = Title or DEFAULT_CONFIG.Title
    self.Config.Version = Version or DEFAULT_CONFIG.Version
    self.Tabs = {}
    
    -- 初始化UI
    self:InitUI()
    return self
end

-- 初始化UI
function RainbowUI:InitUI()
    -- 创建ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "RainbowUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    -- 主窗口
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Config.Size
    self.MainFrame.Position = self.Config.Position
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = self.Config.PrimaryColor
    self.MainFrame.Parent = self.ScreenGui
    
    -- 圆角
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainFrame
    
    -- 彩虹边框
    self.BorderFrame = Instance.new("Frame")
    self.BorderFrame.Name = "Border"
    self.BorderFrame.Size = UDim2.new(1, 6, 1, 6)
    self.BorderFrame.Position = UDim2.new(0, -3, 0, -3)
    self.BorderFrame.BackgroundTransparency = 1
    self.BorderFrame.ZIndex = -1
    self.BorderFrame.Parent = self.MainFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 165, 0)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130))
    })
    gradient.Parent = self.BorderFrame
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0, 10)
    borderCorner.Parent = self.BorderFrame
    
    -- 标题栏
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.BackgroundColor3 = self.Config.SecondaryColor
    self.TitleBar.Parent = self.MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = self.TitleBar
    
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -60, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    self.TitleLabel.Text = self.Config.Title .. " | v" .. self.Config.Version
    self.TitleLabel.TextColor3 = self.Config.AccentColor
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.TextSize = 14
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar
    
    -- 标签页容器
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(1, 0, 1, -30)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 30)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.MainFrame
    
    -- 彩虹动画
    spawn(function()
        while self.BorderFrame do
            gradient.Rotation = gradient.Rotation + self.Config.RainbowSpeed
            wait()
            if gradient.Rotation >= 360 then
                gradient.Rotation = 0
            end
        end
    end)
    
    -- 拖动功能
    self:Draggable(self.MainFrame, self.TitleBar)
end

-- 创建标签页
function RainbowUI:tab(TabName, Default)
    local tab = {
        Name = TabName,
        Buttons = {}
    }
    
    -- 创建标签按钮
    local tabButton = Instance.new("TextButton")
    tabButton.Name = TabName
    tabButton.Size = UDim2.new(0, 100, 0, 25)
    tabButton.Position = UDim2.new(0, 10 + (#self.Tabs * 110), 0, 2)
    tabButton.Text = TabName
    tabButton.TextColor3 = self.Config.AccentColor
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 12
    tabButton.BackgroundColor3 = self.Config.SecondaryColor
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TitleBar
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = tabButton
    
    -- 创建内容框架
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = TabName .. "_Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -20)
    contentFrame.Position = UDim2.new(0, 10, 0, 10)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ScrollBarThickness = 5
    contentFrame.Visible = Default or false
    contentFrame.Parent = self.TabContainer
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = contentFrame
    
    -- 自动调整画布大小
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    -- 标签按钮点击事件
    tabButton.MouseButton1Click:Connect(function()
        for _, frame in ipairs(self.TabContainer:GetChildren()) do
            if frame:IsA("ScrollingFrame") then
                frame.Visible = false
            end
        end
        contentFrame.Visible = true
    end)
    
    -- 添加按钮方法
    function tab:button(Text, Callback)
        local button = Instance.new("TextButton")
        button.Name = Text
        button.Size = UDim2.new(1, 0, 0, 30)
        button.Text = Text
        button.TextColor3 = self.Config.AccentColor
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.BackgroundColor3 = self.Config.SecondaryColor
        button.AutoButtonColor = false
        button.Parent = contentFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = button
        
        -- 悬停效果
        button.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.2),
                {BackgroundColor3 = self.Config.SecondaryColor:Lighten(0.1)}
            ):Play()
        end)
        
        button.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.2),
                {BackgroundColor3 = self.Config.SecondaryColor}
            ):Play()
        end)
        
        -- 点击效果
        button.MouseButton1Down:Connect(function()
            game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.1),
                {Size = UDim2.new(0.95, 0, 0, 28)}
            ):Play()
        end)
        
        button.MouseButton1Up:Connect(function()
            game:GetService("TweenService"):Create(
                button,
                TweenInfo.new(0.1),
                {Size = UDim2.new(1, 0, 0, 30)}
            ):Play()
            if Callback then
                Callback(button)
            end
        end)
        
        table.insert(self.Buttons, button)
        return button
    end
    
    -- 添加标签方法
    function tab:label(Text)
        local label = Instance.new("TextLabel")
        label.Name = "Label_" .. Text
        label.Size = UDim2.new(1, 0, 0, 20)
        label.Text = Text
        label.TextColor3 = self.Config.AccentColor
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = contentFrame
        
        return label
    end
    
    table.insert(self.Tabs, tab)
    return tab
end

-- 拖动功能
function RainbowUI:Draggable(Frame, Handle)
    local dragging = false
    local dragInput, dragStart, startPos
    
    Handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

return RainbowUI

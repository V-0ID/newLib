--// Services
local players = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")

local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse()

--//Vars
local viewport = workspace.CurrentCamera.ViewportSize
local tweeninfo = TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

-- source
local library = {}

-- methods
function library:validate(defaults, options)
	for i, v in pairs(defaults) do
		if options[i] == nil then
			options[i] = v
		end
	end
	return options
end

function library:tween(object, goal, callback)
	local tween = tweenService:Create(object, tweeninfo, goal)
	tween.Completed:Connect(callback or function() end)
	tween:Play()
end

function library:create(options)
	options = library:validate({
		name = "MatLib",
		theme = "legacy",
		sizeX = 750,
		sizeY = 400,
		toggleKeybind = Enum.KeyCode.RightShift,
	}, options or {} )
	
	-- Main tables
	local notification = {}
	local window = {
		reOpenWindow = nil,
		
		currentTab = nil,
		pageActive = false,
		
		tempDisableDrag = false,
		disableDrag = false,
		
		requestedrainbows = 0,
		rainbowColour = nil,
	}
	
	--Misc Tables
	local themeColours = {
		
		base = Color3.fromRGB(46, 44, 53);
		background = Color3.fromRGB(28, 27, 30);
		
		componentBase = Color3.fromRGB(62, 61, 69);
		text = Color3.fromRGB(255, 255, 255);
		subText = Color3.fromRGB(117, 116, 117);
		accent = Color3.fromRGB(191, 185, 221);	

		storedThemes = {
			
			
			["legacy"] = {
				base = Color3.fromRGB(46, 44, 53);
				background = Color3.fromRGB(28, 27, 30);

				componentBase = Color3.fromRGB(62, 61, 69);
				text = Color3.fromRGB(255, 255, 255);
				subText = Color3.fromRGB(117, 116, 117);
				accent = Color3.fromRGB(191, 185, 221);	
			};
			
			["legacy_v2"] = {
				base = Color3.fromRGB(22, 22, 30);
				background = Color3.fromRGB(26, 27, 37);

				componentBase = Color3.fromRGB(37, 38, 50);
				text = Color3.fromRGB(156, 162, 198);
				subText = Color3.fromRGB(87, 95, 133);
				accent = Color3.fromRGB(120, 138, 214);	
			};
			
			
			["light"] = {
				base = Color3.fromRGB(255, 255, 255);
				background = Color3.fromRGB(255, 255, 255);

				componentBase = Color3.fromRGB(179, 179, 179);
				text = Color3.fromRGB(0, 0, 0);
				subText = Color3.fromRGB(59, 59, 59);
				accent = Color3.fromRGB(0, 0, 0)
			};
			
			["dark"] = {
				base = Color3.fromRGB(20,20,20);
				background = Color3.fromRGB(10,10,10);

				componentBase = Color3.fromRGB(85, 85, 85);
				text = Color3.fromRGB(255, 255, 255);
				subText = Color3.fromRGB(140, 140, 140);
				accent = Color3.fromRGB(255, 255, 255)
			};
			
			
			["aimware"] = {
				base = Color3.fromRGB(26, 26, 26);
				background = Color3.fromRGB(33, 33, 32);

				componentBase = Color3.fromRGB(51, 51, 51);
				text = Color3.fromRGB(220, 220, 220);
				subText = Color3.fromRGB(133, 133, 132);
				accent = Color3.fromRGB(184, 46, 36);	
			};
			
			["discord"] = {
				base = Color3.fromRGB(43, 45, 49);
				background = Color3.fromRGB(49, 51, 56);

				componentBase = Color3.fromRGB(64, 66, 72);
				text = Color3.fromRGB(255,255,255);
				subText = Color3.fromRGB(124, 133, 133);
				accent = Color3.fromRGB(120, 135, 223);	
			};
			
			["embers"] = {
				base = Color3.fromRGB(66, 68, 105);
				background = Color3.fromRGB(46, 57, 79);

				componentBase = Color3.fromRGB(139, 70, 98);
				text = Color3.fromRGB(224, 88, 104);
				subText = Color3.fromRGB(131, 126, 140);
				accent = Color3.fromRGB(239, 155, 123);	
			};
			
			["valiant"] = {
				base = Color3.fromRGB(50, 49, 58);
				background = Color3.fromRGB(40, 39, 46);

				componentBase = Color3.fromRGB(81, 79, 93);
				text = Color3.fromRGB(200,200,200);
				subText = Color3.fromRGB(140,140,140);
				accent = Color3.fromRGB(130, 216, 135);	
			};
			
			["lily"] = {
				base = Color3.fromRGB(53, 43, 52);
				background = Color3.fromRGB(30, 26, 30);

				componentBase = Color3.fromRGB(67, 55, 69);
				text = Color3.fromRGB(240, 178, 255);
				subText = Color3.fromRGB(167, 132, 173);
				accent = Color3.fromRGB(255, 215, 254)
			};
			
			["matrix"] = {
				base = Color3.fromRGB(10,10,10);
				background = Color3.fromRGB(0, 0, 0);

				componentBase = Color3.fromRGB(20,20,20);
				text = Color3.fromRGB(0, 255, 0);
				subText = Color3.fromRGB(0, 100, 0);
				accent = Color3.fromRGB(0, 255, 0)
			};
			
			
			
		};
		
	}	
	
	-- Methods/recipes
	function window:setTheme(themeName)
		if not themeColours.storedThemes[themeName] then
			themeName = "legacy"
		end

		local newTheme = themeColours.storedThemes[themeName]
		themeColours.base = newTheme.base
		themeColours.background = newTheme.background

		themeColours.componentBase = newTheme.componentBase	
		themeColours.text = newTheme.text
		themeColours.subText = newTheme.subText
		themeColours.accent = newTheme.accent

	end	
	
	do -- Recipe Ripple effect
		local _RippleActive = false

		local function _createCircle()

			local circle = Instance.new("Frame")
			local l = Instance.new("UICorner")

			circle.Size = UDim2.new(0,0,0,0)
			circle.AnchorPoint = Vector2.new(0.5,0.5)
			circle.BackgroundColor3 = themeColours.accent --Color3.fromRGB(211, 211, 211)
			circle.BackgroundTransparency = 0.85
			l.Parent = circle
			l.CornerRadius = UDim.new(1,0)

			return circle
		end

		local function _calcDistance(pointA,PointB)
			return math.sqrt(((PointB.X - pointA.X) ^ 2) + ((PointB.Y - PointB.Y) ^ 2))
		end

		function library:rippleEffect(btnObj: GuiObject, elementTable)
			local function onMouseButton1Down()


				_RippleActive = true

				local btnAbsoluteSize = btnObj.AbsoluteSize
				local btnAbsolutePosition = btnObj.AbsolutePosition

				local mouseAbsolutePosition = Vector2.new(mouse.X, mouse.Y)
				local mouseRelativePosition = (mouseAbsolutePosition - btnAbsolutePosition)

				local circle = _createCircle()

				circle.Position = UDim2.new(0, mouseRelativePosition.X, 0, mouseRelativePosition.Y)
				circle.Parent = btnObj

				local topLeft = _calcDistance(mouseRelativePosition, Vector2.new(0,0))
				local topRight = _calcDistance(mouseRelativePosition, Vector2.new(btnAbsoluteSize.X, 0))
				local bottomRight = _calcDistance(mouseRelativePosition, btnAbsoluteSize)
				local bottomLeft = _calcDistance(mouseRelativePosition, Vector2.new(0, btnAbsoluteSize.Y))

				local size = math.max(topLeft, topRight, bottomRight, bottomLeft) * 2

				local tweenTime = 0.25 -- in seconds
				local startedTimeStamp
				local completed = false

				local expand = tweenService:Create(
					circle,
					TweenInfo.new(
						tweenTime,
						Enum.EasingStyle.Linear,
						Enum.EasingDirection.Out
					),
					{Size = UDim2.new(0,size,0,size)}
				)

				local connection
				connection = runService.RenderStepped:Connect(function()
					if not _RippleActive then
						connection:Disconnect()

						local defTime = (tweenTime / 3)
						local timeRemaining = tweenTime - (os.time() - startedTimeStamp)
						local newTweenTime = not completed and timeRemaining > defTime and timeRemaining or defTime
						local fadeOut = tweenService:Create(
							circle,
							TweenInfo.new(
								newTweenTime,
								Enum.EasingStyle.Linear,
								Enum.EasingDirection.Out
							),
							{BackgroundTransparency = 1}
						)

						fadeOut:Play()
						fadeOut.Completed:Wait()

						circle:Destroy()

					end
				end)

				expand:Play()
				startedTimeStamp = os.time()
				expand.Completed:Wait()

				completed = true
			end

			local function onMouseButton1Up()
				_RippleActive = false
			end



			if btnObj:IsA("GuiButton") then
				btnObj.MouseButton1Down:Connect(onMouseButton1Down)
				btnObj.MouseButton1Down:Connect(onMouseButton1Down)
			else
				uis.InputBegan:Connect(function(input, gpe)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and elementTable.hover == true then
						onMouseButton1Down()
					end
				end)

				uis.InputEnded:Connect(function(input, gpe)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and _RippleActive == true then
						onMouseButton1Up()
					end
				end)
			end



		end
	end
	
	do -- constant rgb
		local rainbow
		local hue = 0
		local saturation = 1
		local value = 1
		local step = 1/360  -- The step size for changing colors (1 degree of hue)

		rainbow = task.spawn(function()
			while wait(0.1) do
				if window.requestedrainbows >= 0 then 
					hue = hue + step
					if hue >= 1 then
						hue = 0
					end

					local color = Color3.fromHSV(hue, saturation, value)
					window.rainbowColour = color
				end
			end
		end)
		
	end
	
	window:setTheme(options.theme)
	do -- render main window
		-- StarterGui.MatLib
		window["1"] = Instance.new("ScreenGui");
		if runService:IsStudio() then
			window['1'].Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
		else
			window['1'].Parent = coreGui
		end
		window["1"]["IgnoreGuiInset"] = true;
		window["1"]["DisplayOrder"] = 1;
		window["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
		window["1"]["Name"] = [[MatLib]];
		window["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;

		-- StarterGui.MatLib.MainWindow
		window["2"] = Instance.new("Frame", window["1"]);
		window["2"]["BorderSizePixel"] = 0;
		window["2"]["BackgroundColor3"] = themeColours.background;
		window["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
		window["2"]["Size"] = UDim2.new(0, options['sizeX'], 0, options['sizeY']);
		window["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		window["2"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
		window["2"]["Name"] = [[MainWindow]];
		
		
		-- StarterGui.MatLib.MainWindow.UICorner
		window["9"] = Instance.new("UICorner", window["2"]);
		window["9"]["CornerRadius"] = UDim.new(0, 2);
		
		-- StarterGui.MatLib.MainWindow.ElementsContainer
		window["a"] = Instance.new("Frame", window["2"]);
		window["a"]["ZIndex"] = 2;
		window["a"]["BorderSizePixel"] = 0;
		window["a"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
		window["a"]["BackgroundTransparency"] = 1;
		window["a"]["Size"] = UDim2.new(1, 0, 1, 0);
		window["a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		window["a"]["Visible"] = false;
		window["a"]["Name"] = [[ElementsContainer]];
		window["a"]["ClipsDescendants"] = true
		
		do -- topbar
			-- StarterGui.MatLib.MainWindow.Topbar
			window["3"] = Instance.new("Frame", window["2"]);
			window["3"]["BorderSizePixel"] = 0;
			window["3"]["BackgroundColor3"] = themeColours.base;
			window["3"]["Size"] = UDim2.new(1, 0, 0, 25);
			window["3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			window["3"]["Name"] = [[Topbar]];

			-- StarterGui.MatLib.MainWindow.Topbar.UICorner
			window["4"] = Instance.new("UICorner", window["3"]);
			window["4"]["CornerRadius"] = UDim.new(0, 2);

			-- StarterGui.MatLib.MainWindow.Topbar.fluency_icon
			window["5"] = Instance.new("ImageLabel", window["3"]);
			window["5"]["BorderSizePixel"] = 0;
			window["5"]["ScaleType"] = Enum.ScaleType.Fit;
			window["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			window["5"]["AnchorPoint"] = Vector2.new(0, 0.5);
			window["5"]["Image"] = [[rbxassetid://13072296588]];
			window["5"]["Size"] = UDim2.new(0, 25, 0, 25);
			window["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			window["5"]["Name"] = [[fluency_icon]];
			window["5"]["BackgroundTransparency"] = 1;
			window["5"]["Position"] = UDim2.new(0, 0, 0.5, 0);

			-- StarterGui.MatLib.MainWindow.Topbar.TextLabel
			window["6"] = Instance.new("TextLabel", window["3"]);
			window["6"]["TextWrapped"] = true;
			window["6"]["BorderSizePixel"] = 0;
			window["6"]["TextScaled"] = true;
			window["6"]["BackgroundColor3"] = themeColours.text;
			window["6"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			window["6"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
			window["6"]["TextSize"] = 14;
			window["6"]["TextColor3"] = themeColours.subText;
			window["6"]["Size"] = UDim2.new(0, 350, 1, 0);
			window["6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			window["6"]["Text"] = options['name'];
			window["6"]["BackgroundTransparency"] = 1;
			window["6"]["Position"] = UDim2.new(0, 25, 0, 0);

			-- StarterGui.MatLib.MainWindow.Topbar.TextLabel.UIPadding
			window["7"] = Instance.new("UIPadding", window["6"]);
			window["7"]["PaddingTop"] = UDim.new(0, 3);
			window["7"]["PaddingBottom"] = UDim.new(0, 4);

			-- StarterGui.MatLib.MainWindow.Topbar.dehaze
			window["8"] = Instance.new("ImageButton", window["3"]);
			window["8"]["ZIndex"] = 2;
			window["8"]["ImageColor3"] = Color3.fromRGB(201, 201, 201);
			window["8"]["LayoutOrder"] = 10;
			window["8"]["AnchorPoint"] = Vector2.new(1, 0.5);
			window["8"]["Image"] = [[rbxassetid://3926305904]];
			window["8"]["ImageRectSize"] = Vector2.new(36, 36);
			window["8"]["Size"] = UDim2.new(0, 25, 0, 25);
			window["8"]["Name"] = [[dehaze]];
			window["8"]["ImageRectOffset"] = Vector2.new(84, 644);
			window["8"]["Position"] = UDim2.new(1, -3, 0.5, 0);
			window["8"]["BackgroundTransparency"] = 1;
			
			-- StarterGui.MatLib.MainWindow.Topbar.minimize
			window["f1"] = Instance.new("ImageButton", window["3"]);
			window["f1"]["ZIndex"] = 2;
			window["f1"]["ImageColor3"] = Color3.fromRGB(201, 201, 201);
			window["f1"]["LayoutOrder"] = 10;
			window["f1"]["AnchorPoint"] = Vector2.new(1, 0.5);
			window["f1"]["Image"] = [[rbxassetid://3926305904]];
			window["f1"]["ImageRectSize"] = Vector2.new(36, 36);
			window["f1"]["Size"] = UDim2.new(0, 25, 0, 25);
			window["f1"]["Name"] = [[dehaze]];
			window["f1"]["ImageRectOffset"] = Vector2.new(244, 204);
			window["f1"]["Position"] = UDim2.new(1, -28, 0.5, 0);
			window["f1"]["BackgroundTransparency"] = 1;
			window["f1"]["Visible"] = true
			
		end
		
		do -- navbar
			
			-- StarterGui.MatLib.MainWindow.NavBar
			window["33"] = Instance.new("Frame", window["2"]);
			window["33"]["ZIndex"] = 2;
			window["33"]["BorderSizePixel"] = 0;
			window["33"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
			window["33"]["BackgroundTransparency"] = 1;
			window["33"]["Size"] = UDim2.new(1, 0, 1, 0);
			window["33"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			window["33"]["Visible"] = false;
			window["33"]["Name"] = [[NavBar]];
			window["33"]["ClipsDescendants"] = true
			
			window["navbarClickOff"] = Instance.new("TextButton", window["33"]);
			window["navbarClickOff"]["ZIndex"] = 2;
			window["navbarClickOff"]["Text"] = ""
			window["navbarClickOff"]["BorderSizePixel"] = 0;
			window["navbarClickOff"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
			window["navbarClickOff"]["BackgroundTransparency"] = 1;
			window["navbarClickOff"]["Size"] = UDim2.new(0.65, 0, 1, 0);
			window["navbarClickOff"]["Position"] = UDim2.new(1,0,0,0)
			window["navbarClickOff"]["AnchorPoint"] = Vector2.new(1, 0);
			window["navbarClickOff"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			window["navbarClickOff"]["Name"] = [[NavBar]];
			

			
			do -- tabcontainer
				-- Starterwindow.MatLib.MainWindow.NavBar.TabContainer
				window["34"] = Instance.new("ScrollingFrame", window["33"]);
				window["34"]["BorderSizePixel"] = 0;
				window["34"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
				window["34"]["TopImage"] = [[rbxasset://textures/ui/Scroll/scroll-middle.png]];
				window["34"]["BackgroundColor3"] = themeColours.base;
				window["34"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
				window["34"]["Size"] = UDim2.new(0.35, 0, 1, 0);
				window["34"]["ScrollBarImageColor3"] = Color3.fromRGB(63, 62, 65);
				window["34"]["Selectable"] = false;
				window["34"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				window["34"]["ScrollBarThickness"] = 3;
				window["34"]["Name"] = [[TabContainer]];
				window["34"]["BottomImage"] = [[rbxasset://textures/ui/Scroll/scroll-middle.png]];
				window["34"]["SelectionGroup"] = false;
				window["34"]["AnchorPoint"] = Vector2.new(1,0)
				
				-- StarterGui.MatLib.MainWindow.NavBar.Shadow
				window["3f"] = Instance.new("Frame", window["33"]);
				window["3f"]["BorderSizePixel"] = 0;
				window["3f"]["BackgroundColor3"] = window["34"].BackgroundColor3;
				window["3f"]["Size"] = UDim2.new(0.35, 0, 0, 100);
				window["3f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				window["3f"]["Position"] = UDim2.new(0, 0, 1, 0);
				window["3f"]["Name"] = [[Shadow]];
				window["3f"]["ZIndex"] = 5
				window["3f"]["AnchorPoint"] = Vector2.new(1,0)

				-- StarterGui.MatLib.MainWindow.NavBar.Shadow.UIGradient
				window["40"] = Instance.new("UIGradient", window["3f"]);
				window["40"]["Transparency"] = NumberSequence.new{NumberSequenceKeypoint.new(0.000, 0),NumberSequenceKeypoint.new(1.000, 1)};
				window["40"]["Rotation"] = -90;
				
				-- StarterGui.MatLib.MainWindow.UICorner
				window["414"] = Instance.new("UICorner", window["34"]);
				window["414"]["CornerRadius"] = UDim.new(0, 2);

				-- Starterwindow.MatLib.MainWindow.NavBar.TabContainer.UIListLayout
				window["35"] = Instance.new("UIListLayout", window["34"]);
				window["35"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
				window["35"]["Padding"] = UDim.new(0, 3);
				window["35"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

				-- Starterwindow.MatLib.MainWindow.NavBar.TabContainer.UIPadding
				window["36"] = Instance.new("UIPadding", window["34"]);
				window["36"]["PaddingTop"] = UDim.new(0, 3);
				window["36"]["PaddingRight"] = UDim.new(0, 3);
				window["36"]["PaddingBottom"] = UDim.new(0, 3);
				
			end
			
		end
		
		do -- misc containers
			

			
			-- StarterGui.MatLib.MainWindow.ElementsContainer.Shadow
			window["26"] = Instance.new("Frame", window["a"]);
			window["26"]["ZIndex"] = 6;
			window["26"]["BorderSizePixel"] = 0;
			window["26"]["BackgroundColor3"] = themeColours.background;
			window["26"]["AnchorPoint"] = Vector2.new(0, 1);
			window["26"]["Size"] = UDim2.new(0.65, 0, 0, 100);
			window["26"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			window["26"]["Position"] = UDim2.new(1, 0, 1, 0);
			window["26"]["Name"] = [[Shadow]];

			-- StarterGui.MatLib.MainWindow.ElementsContainer.Shadow.UIGradient
			window["27"] = Instance.new("UIGradient", window["26"]);
			window["27"]["Transparency"] = NumberSequence.new{NumberSequenceKeypoint.new(0.000, 0),NumberSequenceKeypoint.new(1.000, 1)};
			window["27"]["Rotation"] = -90;
			
			-- StarterGui.MatLib.MainWindow.ElementsContainer.closeFrame
			window["28"] = Instance.new("TextButton", window["a"]);
			window["28"]["ZIndex"] = 3;
			window["28"]["Text"] = ""
			window["28"]["AutoButtonColor"] = false
			window["28"]["BorderSizePixel"] = 0;
			window["28"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			window["28"]["BackgroundTransparency"] = 1;
			window["28"]["Size"] = UDim2.new(0.35, 0, 1, 0);
			window["28"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			window["28"]["Name"] = [[closeFrame]];
			
			
			
			-- StarterGui.MatLib.MainWindow.PageContainer
			window["29"] = Instance.new("Frame", window["2"]);
			window["29"]["BorderSizePixel"] = 0;
			window["29"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			window["29"]["BackgroundTransparency"] = 1;
			window["29"]["Size"] = UDim2.new(1, 0, 1, -25);
			window["29"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
			window["29"]["Position"] = UDim2.new(0, 0, 0, 25);
			window["29"]["Name"] = [[PageContainer]];
			
		end
		
		
	end
	
	do -- notification render
		-- StarterGui.Notifs.notifs
		notification["2"] = Instance.new("Frame", window["1"]);
		notification["2"]["ZIndex"] = 20;
		notification["2"]["BorderSizePixel"] = 0;
		notification["2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		notification["2"]["BackgroundTransparency"] = 1;
		notification["2"]["Size"] = UDim2.new(1, 0, 1, 0);
		notification["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
		notification["2"]["Name"] = [[notifs]];

		-- StarterGui.Notifs.notifs.UIListLayout
		notification["3"] = Instance.new("UIListLayout", notification["2"]);
		notification["3"]["VerticalAlignment"] = Enum.VerticalAlignment.Bottom;
		notification["3"]["Padding"] = UDim.new(0, 3);
		notification["3"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

		-- StarterGui.Notifs.notifs.UIPadding
		notification["4"] = Instance.new("UIPadding", notification["2"]);
		notification["4"]["PaddingTop"] = UDim.new(0, 5);
		notification["4"]["PaddingRight"] = UDim.new(0, 5);
		notification["4"]["PaddingBottom"] = UDim.new(0, 5);
		notification["4"]["PaddingLeft"] = UDim.new(0, 5);
	end	

	do -- ui Elements
		
		function window:createTab(options)
			options = library:validate({
				name = "name",
				subtext = "subtext"
			}, options or {} )
			
			local tab = {
				hover = false,
				active = false,
			}
			
			do -- render

				do -- tabbutton
					-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample
					tab["39"] = Instance.new("Frame", window["34"]);
					tab["39"]["ZIndex"] = 2;
					tab["39"]["BorderSizePixel"] = 0;
					tab["39"]["BackgroundTransparency"] = 0.8
					tab["39"]["BackgroundColor3"] = themeColours.componentBase;
					tab["39"]["Size"] = UDim2.new(1, -6, 0, 30);
					tab["39"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					tab["39"]["Name"] = "newTab."..options['name'].."";
					tab["39"]["ClipsDescendants"] = true

					-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.UICorner
					tab["3a"] = Instance.new("UICorner", tab["39"]);
					tab["3a"]["CornerRadius"] = UDim.new(0, 3);

					-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Heading
					tab["3b"] = Instance.new("TextLabel", tab["39"]);
					tab["3b"]["TextWrapped"] = true;
					tab["3b"]["BorderSizePixel"] = 0;
					tab["3b"]["TextScaled"] = true;
					tab["3b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					tab["3b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					tab["3b"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					tab["3b"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
					tab["3b"]["TextSize"] = 14;
					tab["3b"]["TextColor3"] = themeColours.text;
					tab["3b"]["Size"] = UDim2.new(1, 0, 1, 0);
					tab["3b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					tab["3b"]["Text"] = options['name'];
					tab["3b"]["Name"] = [[Heading]];
					tab["3b"]["BackgroundTransparency"] = 1;

					-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Heading.UIPadding
					tab["3c"] = Instance.new("UIPadding", tab["3b"]);
					tab["3c"]["PaddingBottom"] = UDim.new(0, 15);
					tab["3c"]["PaddingLeft"] = UDim.new(0, 5);

					-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label
					tab["3d"] = Instance.new("TextLabel", tab["39"]);
					tab["3d"]["TextWrapped"] = true;
					tab["3d"]["BorderSizePixel"] = 0;
					tab["3d"]["TextScaled"] = true;
					tab["3d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
					tab["3d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
					tab["3d"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
					tab["3d"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
					tab["3d"]["TextSize"] = 14;
					tab["3d"]["TextColor3"] = themeColours.subText;
					tab["3d"]["Size"] = UDim2.new(1, 0, 1, 0);
					tab["3d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					tab["3d"]["Text"] = options['subtext'];
					tab["3d"]["Name"] = options['subtext'];
					tab["3d"]["BackgroundTransparency"] = 1;

					-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label.UIPadding
					tab["3e"] = Instance.new("UIPadding", tab["3d"]);
					tab["3e"]["PaddingTop"] = UDim.new(0, 15);
					tab["3e"]["PaddingBottom"] = UDim.new(0, 3);
					tab["3e"]["PaddingLeft"] = UDim.new(0, 5);
				end

				do -- newPage
					-- StarterGui.MatLib.MainWindow.PageContainer.ElementContainer
					tab["2a"] = Instance.new("ScrollingFrame", window["29"]);
					tab["2a"]["BorderSizePixel"] = 0;
					tab["2a"]["CanvasPosition"] = Vector2.new(0, 75);
					tab["2a"]["TopImage"] = [[rbxasset://textures/ui/Scroll/scroll-middle.png]];
					tab["2a"]["BackgroundColor3"] = Color3.fromRGB(63, 62, 65);
					tab["2a"]["BackgroundTransparency"] = 1;
					tab["2a"]["Size"] = UDim2.new(1, 0, 1, 0);
					tab["2a"]["ScrollBarImageColor3"] = Color3.fromRGB(63, 62, 65);
					tab["2a"]["Selectable"] = false;
					tab["2a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
					tab["2a"]["ScrollBarThickness"] = 3;
					tab["2a"]["Visible"] = false;
					tab["2a"]["Name"] = "newTab."..options['name'].."";
					tab["2a"]["BottomImage"] = [[rbxasset://textures/ui/Scroll/scroll-middle.png]];
					tab["2a"]["CanvasSize"] = UDim2.new(0,0,0,0)
					tab["2a"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
					tab["2a"]["SelectionGroup"] = false;

					-- StarterGui.MatLib.MainWindow.PageContainer.ElementContainer.UIListLayout
					tab["2b"] = Instance.new("UIListLayout", tab["2a"]);
					tab["2b"]["HorizontalAlignment"] = Enum.HorizontalAlignment.Center;
					tab["2b"]["Padding"] = UDim.new(0, 3);
					tab["2b"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

					-- StarterGui.MatLib.MainWindow.PageContainer.ElementContainer.UIPadding
					tab["32"] = Instance.new("UIPadding", tab["2a"]);
					tab["32"]["PaddingTop"] = UDim.new(0, 3);
					tab["32"]["PaddingBottom"] = UDim.new(0, 3);

				end

			end
			
			-- methods
			function tab:_DeActivate()
				if tab.active then
					tab.active = false
					tab.hover = false

					library:tween(tab['39'], {BackgroundTransparency = 0.8})
					tab['2a'].Visible = false
					
				end
			end

			function tab:_Activate()
				if tab.active == false then
					if window.currentTab ~= nil then
						window.currentTab:_DeActivate()
					end

					tab.active = true
					library:tween(tab['39'], {BackgroundTransparency = 0})
					tab['2a'].Visible = true

					window.currentTab = tab
				end
			end
			
			if window.currentTab == nil then
				window.currentTab = tab
				tab:_Activate()
			end
			
			do -- logic
				library:rippleEffect(tab['39'], tab)
				
				tab['39'].MouseEnter:Connect(function()
					tab.hover = true
					if tab.active == false then
						library:tween(tab['39'], {BackgroundTransparency = 0.5})
					end
				end)
				
				tab['39'].MouseLeave:Connect(function()
					tab.hover = false
					if tab.active == false then
						library:tween(tab['39'], {BackgroundTransparency = 0.8})
					end
				end)
				
				uis.InputBegan:Connect(function(input, gpe)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if tab.hover == true then
							tab:_Activate()
						end
					end
				end)
				
			end

			do -- tab elements
					
				function tab:createButton(options)
					options = library:validate({
						name = "name",
						subtext = "",
						callback = function() end
					}, options or {} )
					
					local button = {
						hover = false,
						active = false,
						_detectForPage = false,
					}
					
					do -- render
						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample
						button["10"] = Instance.new("Frame", tab["2a"]);
						button["10"]["ZIndex"] = 2;
						button["10"]["BorderSizePixel"] = 0;
						button["10"]["BackgroundColor3"] = themeColours.componentBase;
						button["10"]["Size"] = UDim2.new(1, -6, 0, 30);
						button["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						button["10"]["Name"] = options['name'];
						button["10"]["ClipsDescendants"] = true
						button["10"]["BackgroundTransparency"] = 0.4


						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.UICorner
						button["11"] = Instance.new("UICorner", button["10"]);
						button["11"]["CornerRadius"] = UDim.new(0, 3);

						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.Heading
						button["12"] = Instance.new("TextLabel", button["10"]);
						button["12"]["TextWrapped"] = true;
						button["12"]["BorderSizePixel"] = 0;
						button["12"]["TextScaled"] = true;
						button["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						button["12"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						button["12"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						button["12"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						button["12"]["TextSize"] = 14;
						button["12"]["TextColor3"] = themeColours.text;
						button["12"]["Size"] = UDim2.new(1, 0, 1, 0);
						button["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						button["12"]["Text"] = options['name'];
						button["12"]["Name"] = [[Heading]];
						button["12"]["BackgroundTransparency"] = 1;
						
						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.Heading.UIPadding
						button["13"] = Instance.new("UIPadding", button["12"]);
						button["13"]["PaddingBottom"] = UDim.new(0, 15);
						button["13"]["PaddingLeft"] = UDim.new(0, 5);
						
						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label
						button["3d"] = Instance.new("TextLabel", button["10"]);
						button["3d"]["TextWrapped"] = true;
						button["3d"]["BorderSizePixel"] = 0;
						button["3d"]["TextScaled"] = true;
						button["3d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						button["3d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						button["3d"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						button["3d"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						button["3d"]["TextSize"] = 14;
						button["3d"]["TextColor3"] = themeColours.subText;
						button["3d"]["Size"] = UDim2.new(1, 0, 1, 0);
						button["3d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						button["3d"]["Text"] = options['subtext'];
						button["3d"]["Name"] = options['subtext'];
						button["3d"]["BackgroundTransparency"] = 1;

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label.UIPadding
						button["3e"] = Instance.new("UIPadding", button["3d"]);
						button["3e"]["PaddingTop"] = UDim.new(0, 15);
						button["3e"]["PaddingBottom"] = UDim.new(0, 3);
						button["3e"]["PaddingLeft"] = UDim.new(0, 5);

						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.pointer
						button["14"] = Instance.new("ImageButton", button["10"]);
						button["14"]["ZIndex"] = 2;
						button["14"]["ImageColor3"] = themeColours.accent
						button["14"]["LayoutOrder"] = 5;
						button["14"]["AnchorPoint"] = Vector2.new(1, 0.5);
						button["14"]["Image"] = [[rbxassetid://6764432293]];
						button["14"]["ImageRectSize"] = Vector2.new(100, 100);
						button["14"]["Size"] = UDim2.new(0, 25, 0, 25);
						button["14"]["Name"] = [[pointer]];
						button["14"]["ImageRectOffset"] = Vector2.new(100, 400);
						button["14"]["Position"] = UDim2.new(1, -3, 0.5, 0);
						button["14"]["BackgroundTransparency"] = 1;
					end						
					
					--methods
					function button:setText(txt)
						button["12"].Text = txt
					end
					
					function button:setSubText(txt)
						button['3d'].Text = txt
					end
					
					function button:setCallback(fn)
						options['callback'] = fn
					end
					
					do -- logic
						library:rippleEffect(button['10'], button)
						
						--should check for page open or not?
						if (string.split(tostring(button['10'].Parent.Name), ".")[1] == "newTab") then
							button._detectForPage = true
						end

						button['10'].MouseEnter:Connect(function()
							if window.pageActive == false or button._detectForPage == false then
								library:tween(button['10'], {BackgroundTransparency = 0})
								button.hover = true
							end
						end)
						
						button['10'].MouseLeave:Connect(function()
							library:tween(button['10'], {BackgroundTransparency = 0.4})
							button.hover = false
						end)
						
						uis.InputBegan:Connect(function(input, gpe)
							if input.UserInputType == Enum.UserInputType.MouseButton1 and button.hover == true then
								options.callback()
							end
						end)
						
					end
					
					return button
				end
				
				function tab:createToggle(options)
					options = library:validate({
						name = "name",
						subtext = "",
						state = false,
						callback = function(v) end
					}, options or {} )

					local tog = {
						hover = false,
						state = options['state'],
						_detectForPage = false,
					}

					do -- render
						-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample
						tog["15"] = Instance.new("Frame", tab["2a"]);
						tog["15"]["ZIndex"] = 2;
						tog["15"]["BorderSizePixel"] = 0;
						tog["15"]["BackgroundColor3"] = themeColours.componentBase;
						tog["15"]["Size"] = UDim2.new(1, -6, 0, 30);
						tog["15"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						tog["15"]["Name"] = [[ToggleSample]];
						tog["15"]["BackgroundTransparency"] = 0.4
						tog["15"]["ClipsDescendants"] = true


						-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample.UICorner
						tog["16"] = Instance.new("UICorner", tog["15"]);
						tog["16"]["CornerRadius"] = UDim.new(0, 3);

						-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample.Heading
						tog["17"] = Instance.new("TextLabel", tog["15"]);
						tog["17"]["TextWrapped"] = true;
						tog["17"]["BorderSizePixel"] = 0;
						tog["17"]["TextScaled"] = true;
						tog["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						tog["17"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						tog["17"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						tog["17"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						tog["17"]["TextSize"] = 14;
						tog["17"]["TextColor3"] = themeColours.text;
						tog["17"]["Size"] = UDim2.new(1, 0, 1, 0);
						tog["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						tog["17"]["Text"] = options['name'];
						tog["17"]["Name"] = options['name'];
						tog["17"]["BackgroundTransparency"] = 1;

						-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample.Heading.UIPadding
						tog["18"] = Instance.new("UIPadding", tog["17"]);
						tog["18"]["PaddingBottom"] = UDim.new(0, 15);
						tog["18"]["PaddingLeft"] = UDim.new(0, 5);

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label
						tog["3d"] = Instance.new("TextLabel", tog["15"]);
						tog["3d"]["TextWrapped"] = true;
						tog["3d"]["BorderSizePixel"] = 0;
						tog["3d"]["TextScaled"] = true;
						tog["3d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						tog["3d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						tog["3d"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						tog["3d"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						tog["3d"]["TextSize"] = 14;
						tog["3d"]["TextColor3"] = themeColours.subText;
						tog["3d"]["Size"] = UDim2.new(1, 0, 1, 0);
						tog["3d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						tog["3d"]["Text"] = options['subtext'];
						tog["3d"]["Name"] = options['subtext'];
						tog["3d"]["BackgroundTransparency"] = 1;

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label.UIPadding
						tog["3e"] = Instance.new("UIPadding", tog["3d"]);
						tog["3e"]["PaddingTop"] = UDim.new(0, 15);
						tog["3e"]["PaddingBottom"] = UDim.new(0, 3);
						tog["3e"]["PaddingLeft"] = UDim.new(0, 5);

						-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample.pointer
						tog["19"] = Instance.new("Frame", tog["15"]);
						tog["19"]["Active"] = true;
						tog["19"]["ZIndex"] = 2;
						tog["19"]["AnchorPoint"] = Vector2.new(1, 0.5);
						tog["19"]["BackgroundTransparency"] = 1;
						tog["19"]["LayoutOrder"] = 5;
						tog["19"]["BackgroundColor3"] = themeColours.accent;
						tog["19"]["Size"] = UDim2.new(0, 20, 0, 20);
						tog["19"]["Selectable"] = true;
						tog["19"]["Position"] = UDim2.new(1, -7, 0.5, 0);
						tog["19"]["Name"] = [[pointer]];

						-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample.pointer.UICorner
						tog["1a"] = Instance.new("UICorner", tog["19"]);
						tog["1a"]["CornerRadius"] = UDim.new(0, 2);

						-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample.pointer.UIStroke
						tog["1b"] = Instance.new("UIStroke", tog["19"]);
						tog["1b"]["Color"] = themeColours.accent;
						tog["1b"]["Thickness"] = 1;
						
						tog["12b"] = Instance.new("ImageLabel", tog["19"]);
						tog['12b']["Image"] = 'rbxassetid://3926305904';
						tog['12b']["ImageColor3"] = themeColours.componentBase;
						tog['12b']["ImageRectOffset"] = Vector2.new(644,204);
						tog['12b']["ImageRectSize"] = Vector2.new(36,36);
						tog["12b"]["ZIndex"] = 5;
						tog['12b']["Size"] = UDim2.fromScale(1,1);
						tog['12b']["ImageTransparency"] = 1;
						tog['12b']["BackgroundTransparency"] = 1;
						
					end

					-- methods

					function tog:setState(v)
						tog.state = v
						options.callback(v)

						if v == true then
							library:tween(tog['19'], {BackgroundTransparency = 0})
							library:tween(tog['12b'], {ImageTransparency = 0})
						elseif v == false then
							library:tween(tog['19'], {BackgroundTransparency = 1})
							library:tween(tog['12b'], {ImageTransparency = 1})
						end
					end

					function tog:_changeState()
						tog:setState(not tog.state)
					end

					function tog:setText(txt)
						tog['17'].Text = txt
					end

					function tog:setSubText(txt)
						tog['3d'].Text = txt
					end


					do -- logic
						library:rippleEffect(tog['15'], tog)
						tog:setState(tog.state)

						--should check for page open or not?
						if (string.split(tostring(tog['15'].Parent.Name), ".")[1] == "newTab") then
							tog._detectForPage = true
						end

						tog['15'].MouseEnter:Connect(function()
							if window.pageActive == false or tog._detectForPage == false then
								library:tween(tog['15'], {BackgroundTransparency = 0})
								tog.hover = true
							end
						end)

						tog['15'].MouseLeave:Connect(function()
							library:tween(tog['15'], {BackgroundTransparency = 0.4})
							tog.hover = false
						end)

						uis.InputBegan:Connect(function(input, gpe)
							if input.UserInputType == Enum.UserInputType.MouseButton1 and tog.hover == true then
								tog:_changeState()
							end
						end)

					end

					return tog
				end
				
				function tab:createSlider(options)
					options = library:validate({
						name = "name",
						max = 100,
						def = 50,
						min = 0,
						callback = function(v) end
					}, options or {} )
					
					local slider = {
						hover = false,
						mouseDown = false,
						mouseMovement = nil,
						_detectForPage = false,
					}
					
					do -- render
						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample
						slider["1c"] = Instance.new("Frame", tab["2a"]);
						slider["1c"]["ZIndex"] = 2;
						slider["1c"]["BorderSizePixel"] = 0;
						slider["1c"]["BackgroundColor3"] = themeColours.componentBase;
						slider["1c"]["BackgroundTransparency"] = 0.4
						slider["1c"]["Size"] = UDim2.new(1, -6, 0, 30);
						slider["1c"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						slider["1c"]["Name"] = [[SliderSample]];
						slider["1c"]["ClipsDescendants"] = true

						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.UICorner
						slider["1d"] = Instance.new("UICorner", slider["1c"]);
						slider["1d"]["CornerRadius"] = UDim.new(0, 3);

						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.Heading
						slider["1e"] = Instance.new("TextLabel", slider["1c"]);
						slider["1e"]["TextWrapped"] = true;
						slider["1e"]["BorderSizePixel"] = 0;
						slider["1e"]["TextScaled"] = true;
						slider["1e"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						slider["1e"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						slider["1e"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						slider["1e"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						slider["1e"]["TextSize"] = 14;
						slider["1e"]["TextColor3"] = themeColours.text;
						slider["1e"]["Size"] = UDim2.new(1, 0, 1, 0);
						slider["1e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						slider["1e"]["Text"] = options.name;
						slider["1e"]["Name"] = [[Heading]];
						slider["1e"]["BackgroundTransparency"] = 1;

						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.Heading.UIPadding
						slider["1f"] = Instance.new("UIPadding", slider["1e"]);
						slider["1f"]["PaddingBottom"] = UDim.new(0, 15);
						slider["1f"]["PaddingLeft"] = UDim.new(0, 5);
						
						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.varDisplay
						slider["2e"] = Instance.new("TextLabel", slider["1c"]);
						slider["2e"]["TextWrapped"] = true;
						slider["2e"]["BorderSizePixel"] = 0;
						slider["2e"]["TextScaled"] = true;
						slider["2e"]["BackgroundColor3"] = themeColours.base;
						slider["2e"]["TextXAlignment"] = Enum.TextXAlignment.Right;
						slider["2e"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						slider["2e"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						slider["2e"]["TextSize"] = 14;
						slider["2e"]["TextColor3"] = themeColours.subText;
						slider["2e"]["Size"] = UDim2.new(1,0,1,0);
						slider["2e"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						slider["2e"]["Text"] = options.def;
						slider["2e"]["Name"] = [[Heading]];
						slider["2e"]["BackgroundTransparency"] = 1;

						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.varDisplay.UIPadding
						slider["2f"] = Instance.new("UIPadding", slider["2e"]);
						slider["2f"]["PaddingBottom"] = UDim.new(0, 15);
						slider["2f"]["PaddingRight"] = UDim.new(0, 3);
						

						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.background
						slider["20"] = Instance.new("Frame", slider["1c"]);
						slider["20"]["Active"] = true;
						slider["20"]["ZIndex"] = 2;
						slider["20"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
						slider["20"]["BackgroundColor3"] = themeColours.background;
						slider["20"]["LayoutOrder"] = 5;
						slider["20"]["Size"] = UDim2.new(1, -10, 0, 4);
						slider["20"]["Selectable"] = true;
						slider["20"]["Position"] = UDim2.new(0.5, 0, 0.7, 0);
						slider["20"]["Name"] = [[background]];

						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.background.UICorner
						slider["21"] = Instance.new("UICorner", slider["20"]);
						slider["21"]["CornerRadius"] = UDim.new(0, 2);

						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.background.frame
						slider["23"] = Instance.new("Frame", slider["20"]);
						slider["23"]["Active"] = true;
						slider["23"]["ZIndex"] = 2;
						slider["23"]["AnchorPoint"] = Vector2.new(0, 0.5);
						slider["23"]["BackgroundColor3"] = themeColours.accent;
						slider["23"]["LayoutOrder"] = 5;
						slider["23"]["Size"] = UDim2.new(0.7, 0, 0, 3);
						slider["23"]["Selectable"] = true;
						slider["23"]["Position"] = UDim2.new(0, 0, 0.5, 0);
						slider["23"]["Name"] = [[frame]];

						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.background.frame.UICorner
						slider["24"] = Instance.new("UICorner", slider["23"]);
						slider["24"]["CornerRadius"] = UDim.new(0, 2);
						
						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.background.frame.end
						slider["26"] = Instance.new("Frame", slider["23"]);
						slider["26"]["Active"] = true;
						slider["26"]["ZIndex"] = 3;
						slider["26"]["AnchorPoint"] = Vector2.new(1, 0.5);
						slider["26"]["BackgroundColor3"] = themeColours.accent;
						slider["26"].BackgroundTransparency = 1;
						slider["26"]["Size"] = UDim2.new(0,8,0,8);
						slider["26"]["Selectable"] = true;
						slider["26"]["Position"] = UDim2.new(1, 0, 0.5, 0);
						slider["26"]["Name"] = [[frame]];
						
						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.background.frame.end
						slider["b26"] = Instance.new("Frame", slider["23"]);
						slider["b26"]["Active"] = true;
						slider["b26"]["ZIndex"] = 3;
						slider["b26"]["AnchorPoint"] = Vector2.new(1, 0.5);
						slider["b26"]["BackgroundColor3"] = themeColours.accent;
						slider["b26"]["LayoutOrder"] = 5;
						slider["b26"]["Size"] = UDim2.new(0,8,0,8);
						slider["b26"]["Selectable"] = true;
						slider["b26"]["Position"] = UDim2.new(1, 0, 0.5, 0);
						slider["b26"]["Name"] = [[frame]];

						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.background.frame.UICorner
						slider["b27"] = Instance.new("UICorner", slider["b26"]);
						slider["b27"]["CornerRadius"] = UDim.new(1,0);
						
						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.background.frame.end
						slider["a26"] = Instance.new("Frame", slider["26"]);
						slider["a26"]["Active"] = true;
						slider["a26"]["ZIndex"] = 2;
						slider["a26"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
						slider["a26"]["BackgroundColor3"] = themeColours.accent;
						slider["a26"]["LayoutOrder"] = 5;
						slider['a26']['BackgroundTransparency'] = 0.35
						slider["a26"]["Size"] = UDim2.new(0,0,0,0);
						slider["a26"]["Selectable"] = true;
						slider["a26"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
						slider["a26"]["Name"] = [[frame]];

						-- Starterslider.MatLib.MainWindow.ElementsContainer.PageSample.SliderSample.background.frame.UICorner
						slider["a27"] = Instance.new("UICorner", slider["a26"]);
						slider["a27"]["CornerRadius"] = UDim.new(1,0);
						
					end
					
					--methods
					function slider:setValue(SliderVal)
						slider["23"].Size = UDim2.new(math.clamp((SliderVal - options.min) / (options.max - options.min), 0, 1), 0, 1, 0)
						if SliderVal <= options.min then
							slider["23"].Size = UDim2.new(math.clamp(((options.min + 1) - options.min) / (options.max - options.min), 0, 1), 0, 1, 0)
						end
						if SliderVal < options.min then SliderVal = options.min elseif SliderVal > options.max then SliderVal = options.max end
						options.callback(SliderVal)
						slider["2e"].Text = tostring(SliderVal)

					end
					
					
					do --logic
						library:rippleEffect(slider['1c'], slider)
						slider:setValue(options.def)
						
						--should check for page open or not?
						if (string.split(tostring(slider['1c'].Parent.Name), ".")[1] == "newTab") then
							slider._detectForPage = true
						end

						slider['1c'].MouseEnter:Connect(function()
							if window.pageActive == false or slider._detectForPage == false then
								library:tween(slider['1c'], {BackgroundTransparency = 0})
								window.tempDisableDrag = true
								slider.hover = true
							end
						end)

						slider['1c'].MouseLeave:Connect(function()
							library:tween(slider['1c'], {BackgroundTransparency = 0.4})
							window.tempDisableDrag = false
							slider.hover = false
						end)
						
						uis.InputBegan:Connect(function(input, gpe)
							if input.UserInputType == Enum.UserInputType.MouseButton1 and slider.hover == true then
								library:tween(slider['a26'], {Size = UDim2.fromScale(1.8,1.8)})
								slider.mouseDown = true
								
								local function updateSlider()
									local mouseLoc = game:GetService("UserInputService"):GetMouseLocation()
									local sliderpos = slider["20"].AbsolutePosition
									local slidersize = slider["20"].AbsoluteSize
									local SliderVal = math.floor(((mouseLoc.X - sliderpos.X) / slidersize.X * (options.max - options.min)) + options.min)
									slider:setValue(SliderVal)
								end
								
								updateSlider()
								slider.mouseMovement = uis.InputChanged:Connect(function()
									updateSlider()
								end)
							end
						end)
						
						uis.InputEnded:Connect(function(input, gpe)
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								library:tween(slider['a26'], {Size = UDim2.fromScale(0,0)})
								slider.mouseDown = false
								if slider.mouseMovement ~= nil then
									slider.mouseMovement:Disconnect()
									slider.mouseMovement = nil
								end
							end
						end)
						
					end
					
					return slider
				end
				
				function tab:createTextBox(options)
					options = library:validate({
						name = "",
						subtext = "",
						placeholder = "",
						def = "",
						clearOnFocus = true,
						callback = function(v) end
					}, options or {} )
					
					local textbox = {
						hover = false,
						_detectForPage = false,
					}
					
					do -- render
						-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample
						textbox["15"] = Instance.new("Frame", tab["2a"]);
						textbox["15"]["ZIndex"] = 2;
						textbox["15"]["BorderSizePixel"] = 0;
						textbox["15"]["BackgroundColor3"] = themeColours.componentBase;
						textbox["15"]["Size"] = UDim2.new(1, -6, 0, 30);
						textbox["15"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						textbox["15"]["Name"] = [[textboxgleSample]];
						textbox["15"]["BackgroundTransparency"] = 0.4
						textbox["15"]["ClipsDescendants"] = true


						-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.UICorner
						textbox["16"] = Instance.new("UICorner", textbox["15"]);
						textbox["16"]["CornerRadius"] = UDim.new(0, 3);

						-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.Heading
						textbox["17"] = Instance.new("TextLabel", textbox["15"]);
						textbox["17"]["TextWrapped"] = true;
						textbox["17"]["BorderSizePixel"] = 0;
						textbox["17"]["TextScaled"] = true;
						textbox["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						textbox["17"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						textbox["17"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						textbox["17"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						textbox["17"]["TextSize"] = 14;
						textbox["17"]["TextColor3"] = themeColours.text;
						textbox["17"]["Size"] = UDim2.new(1, 0, 1, 0);
						textbox["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						textbox["17"]["Text"] = options['name'];
						textbox["17"]["Name"] = options['name'];
						textbox["17"]["BackgroundTransparency"] = 1;

						-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.Heading.UIPadding
						textbox["18"] = Instance.new("UIPadding", textbox["17"]);
						textbox["18"]["PaddingBottom"] = UDim.new(0, 15);
						textbox["18"]["PaddingLeft"] = UDim.new(0, 5);

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label
						textbox["3d"] = Instance.new("TextLabel", textbox["15"]);
						textbox["3d"]["TextWrapped"] = true;
						textbox["3d"]["BorderSizePixel"] = 0;
						textbox["3d"]["TextScaled"] = true;
						textbox["3d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						textbox["3d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						textbox["3d"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						textbox["3d"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						textbox["3d"]["TextSize"] = 14;
						textbox["3d"]["TextColor3"] = themeColours.subText;
						textbox["3d"]["Size"] = UDim2.new(1, 0, 1, 0);
						textbox["3d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						textbox["3d"]["Text"] = options['subtext'];
						textbox["3d"]["Name"] = options['subtext'];
						textbox["3d"]["BackgroundTransparency"] = 1;

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label.UIPadding
						textbox["3e"] = Instance.new("UIPadding", textbox["3d"]);
						textbox["3e"]["PaddingTop"] = UDim.new(0, 15);
						textbox["3e"]["PaddingBottom"] = UDim.new(0, 3);
						textbox["3e"]["PaddingLeft"] = UDim.new(0, 5);

						-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer
						textbox["19"] = Instance.new("Frame", textbox["15"]);
						textbox["19"]["Active"] = true;
						textbox["19"]["ZIndex"] = 2;
						textbox["19"]["AnchorPoint"] = Vector2.new(1, 0.5);
						textbox["19"]["LayoutOrder"] = 5;
						textbox["19"]["BackgroundColor3"] = themeColours.base;
						textbox["19"]["Size"] = UDim2.new(0, 50, 0, 20);
						textbox["19"]["Selectable"] = true;
						textbox["19"]["Position"] = UDim2.new(1, -7, 0.5, 0);
						textbox["19"]["Name"] = [[pointer]];
						textbox['19'].AutomaticSize = Enum.AutomaticSize.X

						-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer.UICorner
						textbox["1a"] = Instance.new("UICorner", textbox["19"]);
						textbox["1a"]["CornerRadius"] = UDim.new(0, 2);

						-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer.UIStroke
						textbox["1b"] = Instance.new("UIStroke", textbox["19"]);
						textbox["1b"]["Color"] = themeColours.accent;
						textbox["1b"]["Thickness"] = 1;
						textbox["1b"].Transparency = 0.4
						
						textbox['box'] = Instance.new("TextBox", textbox['19'])
						textbox['box'].Text = options.def
						textbox['box'].TextColor3 = themeColours.text
						textbox['box'].PlaceholderText = options.placeholder
						textbox['box'].PlaceholderColor3 = themeColours.subText
						textbox['box'].BackgroundTransparency = 1
						textbox['box'].FontFace = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						textbox['box'].ClearTextOnFocus = options.clearOnFocus
						textbox['box'].TextXAlignment = Enum.TextXAlignment.Left
						textbox['box'].TextYAlignment = Enum.TextYAlignment.Center
						textbox['box'].AutomaticSize = Enum.AutomaticSize.X
						textbox['box'].Size = UDim2.fromScale(1,1)
						textbox['box'].TextSize = 14
						
						textbox["2f"] = Instance.new("UIPadding", textbox["box"]);
						textbox["2f"]["PaddingTop"] = UDim.new(0, 3);
						textbox["2f"]["PaddingBottom"] = UDim.new(0, 3);
						textbox["2f"]["PaddingLeft"] = UDim.new(0, 3);
						textbox["2f"]["PaddingRight"] = UDim.new(0, 3);

						
					end						
					
					-- methods
					
					do -- logic
						library:rippleEffect(textbox['15'], textbox)
						
						--should check for page open or not?
						if (string.split(tostring(textbox['15'].Parent.Name), ".")[1] == "newTab") then
							textbox._detectForPage = true
						end

						textbox['15'].MouseEnter:Connect(function()
							if window.pageActive == false or textbox._detectForPage == false then
								library:tween(textbox['15'], {BackgroundTransparency = 0})
								textbox.hover = true
							end
						end)

						textbox['15'].MouseLeave:Connect(function()
							library:tween(textbox['15'], {BackgroundTransparency = 0.4})
							textbox.hover = false
						end)
						
						uis.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 and textbox.hover == true then
								textbox['box']:CaptureFocus()
							end
						end)							

						textbox['box'].Focused:Connect(function()
							library:tween(textbox["1b"], {Transparency = 0})
							library:tween(textbox['19'], {Size = UDim2.new(0.35, 0, 0, 20)})
						end)
						
						textbox['box'].FocusLost:Connect(function(enterPressed)
							library:tween(textbox["1b"], {Transparency = 0.4})
							library:tween(textbox['19'], {Size = UDim2.new(0, 50, 0, 20)})
							if enterPressed then
								options.callback(textbox['box'].Text)
							end
						end)
						
					end
					
					return textbox
				end
				
				function tab:createKeyBind(options)
					options = library:validate({
						name = "",
						subtext = "",
						keybind = nil,
						callback = function() end
					}, options or {} )

					local keybind = {
						hover = false,
						listening = false,
						keycode = options.keybind, 
						_detectForPage = false,
					}

					do -- render
						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample
						keybind["15"] = Instance.new("Frame", tab["2a"]);
						keybind["15"]["ZIndex"] = 2;
						keybind["15"]["BorderSizePixel"] = 0;
						keybind["15"]["BackgroundColor3"] = themeColours.componentBase;
						keybind["15"]["Size"] = UDim2.new(1, -6, 0, 30);
						keybind["15"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						keybind["15"]["Name"] = [[keybindgleSample]];
						keybind["15"]["BackgroundTransparency"] = 0.4
						keybind["15"]["ClipsDescendants"] = true


						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample.UICorner
						keybind["16"] = Instance.new("UICorner", keybind["15"]);
						keybind["16"]["CornerRadius"] = UDim.new(0, 3);

						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample.Heading
						keybind["17"] = Instance.new("TextLabel", keybind["15"]);
						keybind["17"]["TextWrapped"] = true;
						keybind["17"]["BorderSizePixel"] = 0;
						keybind["17"]["TextScaled"] = true;
						keybind["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						keybind["17"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						keybind["17"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						keybind["17"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						keybind["17"]["TextSize"] = 14;
						keybind["17"]["TextColor3"] = themeColours.text;
						keybind["17"]["Size"] = UDim2.new(1, 0, 1, 0);
						keybind["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						keybind["17"]["Text"] = options['name'];
						keybind["17"]["Name"] = options['name'];
						keybind["17"]["BackgroundTransparency"] = 1;

						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample.Heading.UIPadding
						keybind["18"] = Instance.new("UIPadding", keybind["17"]);
						keybind["18"]["PaddingBottom"] = UDim.new(0, 15);
						keybind["18"]["PaddingLeft"] = UDim.new(0, 5);

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label
						keybind["3d"] = Instance.new("TextLabel", keybind["15"]);
						keybind["3d"]["TextWrapped"] = true;
						keybind["3d"]["BorderSizePixel"] = 0;
						keybind["3d"]["TextScaled"] = true;
						keybind["3d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						keybind["3d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						keybind["3d"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						keybind["3d"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						keybind["3d"]["TextSize"] = 14;
						keybind["3d"]["TextColor3"] = themeColours.subText;
						keybind["3d"]["Size"] = UDim2.new(1, 0, 1, 0);
						keybind["3d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						keybind["3d"]["Text"] = options['subtext'];
						keybind["3d"]["Name"] = options['subtext'];
						keybind["3d"]["BackgroundTransparency"] = 1;

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label.UIPadding
						keybind["3e"] = Instance.new("UIPadding", keybind["3d"]);
						keybind["3e"]["PaddingTop"] = UDim.new(0, 15);
						keybind["3e"]["PaddingBottom"] = UDim.new(0, 3);
						keybind["3e"]["PaddingLeft"] = UDim.new(0, 5);

						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample.pointer
						keybind["19"] = Instance.new("Frame", keybind["15"]);
						keybind["19"]["Active"] = true;
						keybind["19"]["ZIndex"] = 2;
						keybind["19"]["AnchorPoint"] = Vector2.new(1, 0.5);
						keybind["19"]["LayoutOrder"] = 5;
						keybind["19"]["BackgroundColor3"] = themeColours.base;
						keybind["19"]["Size"] = UDim2.new(0, 50, 0, 20);
						keybind["19"]["Selectable"] = true;
						keybind["19"]["Position"] = UDim2.new(1, -7, 0.5, 0);
						keybind["19"]["Name"] = [[pointer]];
						keybind['19'].AutomaticSize = Enum.AutomaticSize.X

						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample.pointer.UICorner
						keybind["1a"] = Instance.new("UICorner", keybind["19"]);
						keybind["1a"]["CornerRadius"] = UDim.new(0, 2);

						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample.pointer.UIStroke
						keybind["1b"] = Instance.new("UIStroke", keybind["19"]);
						keybind["1b"]["Color"] = themeColours.accent;
						keybind["1b"]["Thickness"] = 1;
						keybind["1b"].Transparency = 0.4

						keybind['box'] = Instance.new("TextBox", keybind['19'])
						if keybind.keycode == nil then
							keybind['box'].Text = 'nil'
						else
							keybind['box'].Text = string.split(tostring(keybind.keycode), ".")[3]
						end
						keybind['box'].TextColor3 = themeColours.text
						keybind['box'].PlaceholderColor3 = themeColours.subText
						keybind['box'].BackgroundTransparency = 1
						keybind['box'].FontFace = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						keybind['box'].ClearTextOnFocus = false
						keybind['box'].TextEditable = false
						keybind['box'].TextXAlignment = Enum.TextXAlignment.Center
						keybind['box'].TextYAlignment = Enum.TextYAlignment.Center
						keybind['box'].AutomaticSize = Enum.AutomaticSize.X
						keybind['box'].Size = UDim2.fromScale(1,1)
						keybind['box'].TextSize = 14



						keybind["2f"] = Instance.new("UIPadding", keybind["box"]);
						keybind["2f"]["PaddingTop"] = UDim.new(0, 3);
						keybind["2f"]["PaddingBottom"] = UDim.new(0, 3);
						keybind["2f"]["PaddingLeft"] = UDim.new(0, 3);
						keybind["2f"]["PaddingRight"] = UDim.new(0, 3);
					end						

					-- methods
					function keybind:_updatenewKeybind()
						if keybind.keycode == nil then
							keybind['box'].Text = 'nil'
							options.callback(keybind.keycode)
						else
							keybind['box'].Text = string.split(tostring(keybind.keycode), ".")[3]
							options.callback(keybind.keycode)
						end
					end

					function keybind:_setPlaceholder()
						keybind['box'].Text = ""
						keybind['box'].PlaceholderText = "Listening For Key. . ."
					end
					
					function keybind:_stopListeningForKey()
						library:tween(keybind["1b"], {Transparency = 0.4})
						library:tween(keybind['19'], {Size = UDim2.new(0, 50, 0, 20)}, function()
							keybind.listening = false
						end)
					end
					
					function keybind:_listenForKey()

						keybind.listening = true
						
						task.spawn(function()
							library:tween(keybind["1b"], {Transparency = 0})
							library:tween(keybind['19'], {Size = UDim2.new(0.35, 0, 0, 20)})
						end)
						
						local recording
						recording = uis.InputBegan:Connect(function(input)
							
							if input.UserInputType == Enum.UserInputType.MouseButton1 then
								keybind.keycode = Enum.UserInputType.MouseButton1
							elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
								keybind.keycode = Enum.UserInputType.MouseButton2
							elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
								keybind.keycode = Enum.UserInputType.MouseButton3
							else
								keybind.keycode = input.KeyCode
							end

							keybind:_updatenewKeybind()			
							keybind:_stopListeningForKey()
							
							recording:Disconnect()
						end)
					end
					
					do -- logic
						library:rippleEffect(keybind['15'], keybind)

						--should check for page open or not?
						if (string.split(tostring(keybind['15'].Parent.Name), ".")[1] == "newTab") then
							keybind._detectForPage = true
						end

						keybind['15'].MouseEnter:Connect(function()
							if window.pageActive == false or keybind._detectForPage == false then
								library:tween(keybind['15'], {BackgroundTransparency = 0})
								keybind.hover = true
							end
						end)

						keybind['15'].MouseLeave:Connect(function()
							library:tween(keybind['15'], {BackgroundTransparency = 0.4})
							keybind.hover = false
						end)
						
						uis.InputBegan:Connect(function(input)
							if input.UserInputType == Enum.UserInputType.MouseButton1 and keybind.hover == true and keybind.listening == false then
								keybind:_setPlaceholder()
								keybind:_listenForKey()
							end
							
							if input.KeyCode == Enum.KeyCode.Escape and keybind.listening == true then
								keybind:_stopListeningForKey()
								keybind.keycode = nil
								keybind:_updatenewKeybind()
							end
							
						end)
						

						
					end
					
						
					return keybind
				end
				
				function tab:createLabel(options)
					options = library:validate({
						name = "",
						subtext = "",
					}, options or {} )

					local label = {
						hover = false,
						_detectForPage = false,
					}

					do -- render
						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample
						label["15"] = Instance.new("Frame", tab["2a"]);
						label["15"]["ZIndex"] = 2;
						label["15"]["BorderSizePixel"] = 0;
						label["15"]["BackgroundColor3"] = themeColours.componentBase;
						label["15"]["Size"] = UDim2.new(1, -6, 0, 30);
						label["15"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						label["15"]["Name"] = [[keybindgleSample]];
						label["15"]["BackgroundTransparency"] = 0.4
						label["15"]["ClipsDescendants"] = true


						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample.UICorner
						label["16"] = Instance.new("UICorner", label["15"]);
						label["16"]["CornerRadius"] = UDim.new(0, 3);

						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample.Heading
						label["17"] = Instance.new("TextLabel", label["15"]);
						label["17"]["TextWrapped"] = true;
						label["17"]["BorderSizePixel"] = 0;
						label["17"]["TextScaled"] = true;
						label["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						label["17"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						label["17"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						label["17"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						label["17"]["TextSize"] = 14;
						label["17"]["TextColor3"] = themeColours.text;
						label["17"]["Size"] = UDim2.new(1, 0, 1, 0);
						label["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						label["17"]["Text"] = options['name'];
						label["17"]["Name"] = options['name'];
						label["17"]["BackgroundTransparency"] = 1;

						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample.Heading.UIPadding
						label["18"] = Instance.new("UIPadding", label["17"]);
						label["18"]["PaddingBottom"] = UDim.new(0, 15);
						label["18"]["PaddingLeft"] = UDim.new(0, 5);

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label
						label["3d"] = Instance.new("TextLabel", label["15"]);
						label["3d"]["TextWrapped"] = true;
						label["3d"]["BorderSizePixel"] = 0;
						label["3d"]["TextScaled"] = true;
						label["3d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						label["3d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						label["3d"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						label["3d"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						label["3d"]["TextSize"] = 14;
						label["3d"]["TextColor3"] = themeColours.subText;
						label["3d"]["Size"] = UDim2.new(1, 0, 1, 0);
						label["3d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						label["3d"]["Text"] = options['subtext'];
						label["3d"]["Name"] = options['subtext'];
						label["3d"]["BackgroundTransparency"] = 1;

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label.UIPadding
						label["3e"] = Instance.new("UIPadding", label["3d"]);
						label["3e"]["PaddingTop"] = UDim.new(0, 15);
						label["3e"]["PaddingBottom"] = UDim.new(0, 3);
						label["3e"]["PaddingLeft"] = UDim.new(0, 5);

					end
					
					do -- logic
						library:rippleEffect(label['15'], label)

						--should check for page open or not?
						if (string.split(tostring(label['15'].Parent.Name), ".")[1] == "newTab") then
							label._detectForPage = true
						end

						label['15'].MouseEnter:Connect(function()
							if window.pageActive == false or label._detectForPage == false then
								library:tween(label['15'], {BackgroundTransparency = 0})
								label.hover = true
							end
						end)

						label['15'].MouseLeave:Connect(function()
							library:tween(label['15'], {BackgroundTransparency = 0.4})
							label.hover = false
						end)
					end
					
					return label
				end					
				
				function tab:createHeading(options)
					options = library:validate({
						name = "",
						subtext = "",
					}, options or {} )

					local heading = {
						hover = false,
						_detectForPage = false,
					}

					do -- render
						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample
						heading["15"] = Instance.new("Frame", tab["2a"]);
						heading["15"]["ZIndex"] = 2;
						heading["15"]["BorderSizePixel"] = 0;
						heading["15"]["BackgroundColor3"] = themeColours.componentBase;
						heading["15"]["Size"] = UDim2.new(1, -6, 0, 30);
						heading["15"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						heading["15"]["Name"] = [[keybindgleSample]];
						heading["15"]["BackgroundTransparency"] = 0.4
						heading["15"]["ClipsDescendants"] = true


						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample.UICorner
						heading["16"] = Instance.new("UICorner", heading["15"]);
						heading["16"]["CornerRadius"] = UDim.new(0, 3);

						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample.Heading
						heading["17"] = Instance.new("TextLabel", heading["15"]);
						heading["17"]["TextWrapped"] = true;
						heading["17"]["BorderSizePixel"] = 0;
						heading["17"]["TextScaled"] = true;
						heading["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						heading["17"]["TextXAlignment"] = Enum.TextXAlignment.Center;
						heading["17"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
						heading["17"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						heading["17"]["TextSize"] = 14;
						heading["17"]["TextColor3"] = themeColours.accent;
						heading["17"]["Size"] = UDim2.new(1, 0, 1, 0);
						heading["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						heading["17"]["Text"] = options['name'];
						heading["17"]["Name"] = options['name'];
						heading["17"]["BackgroundTransparency"] = 1;

						-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample.Heading.UIPadding
						heading["18"] = Instance.new("UIPadding", heading["17"]);
						heading["18"]["PaddingBottom"] = UDim.new(0, 15);
						heading["18"]["PaddingLeft"] = UDim.new(0, 5);

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.heading
						heading["3d"] = Instance.new("TextLabel", heading["15"]);
						heading["3d"]["TextWrapped"] = true;
						heading["3d"]["BorderSizePixel"] = 0;
						heading["3d"]["TextScaled"] = true;
						heading["3d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						heading["3d"]["TextXAlignment"] = Enum.TextXAlignment.Center;
						heading["3d"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						heading["3d"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						heading["3d"]["TextSize"] = 14;
						heading["3d"]["TextColor3"] = themeColours.subText;
						heading["3d"]["Size"] = UDim2.new(1, 0, 1, 0);
						heading["3d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						heading["3d"]["Text"] = options['subtext'];
						heading["3d"]["Name"] = options['subtext'];
						heading["3d"]["BackgroundTransparency"] = 1;

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.heading.UIPadding
						heading["3e"] = Instance.new("UIPadding", heading["3d"]);
						heading["3e"]["PaddingTop"] = UDim.new(0, 15);
						heading["3e"]["PaddingBottom"] = UDim.new(0, 3);
						heading["3e"]["PaddingLeft"] = UDim.new(0, 5);

					end
					
					do -- logic
						library:rippleEffect(heading['15'], heading)

						--should check for page open or not?
						if (string.split(tostring(heading['15'].Parent.Name), ".")[1] == "newTab") then
							heading._detectForPage = true
						end

						heading['15'].MouseEnter:Connect(function()
							if window.pageActive == false or heading._detectForPage == false then
								library:tween(heading['15'], {BackgroundTransparency = 0})
								heading.hover = true
							end
						end)

						heading['15'].MouseLeave:Connect(function()
							library:tween(heading['15'], {BackgroundTransparency = 0.4})
							heading.hover = false
						end)
					end
					
					return heading
				end
				
				function tab:createDropdown(options)
					options = library:validate({
						name = "name",
						def = nil,
						callback = function(v) end
					}, options or {} )

					local dropdown = {
						hover = false,
						active = false,
						amount = 0,
						current = options.def,
					}
					
					do -- render
						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample
						dropdown["10"] = Instance.new("Frame", tab["2a"]);
						dropdown["10"]["ZIndex"] = 2;
						dropdown["10"]["BorderSizePixel"] = 0;
						dropdown["10"]["BackgroundColor3"] = themeColours.componentBase;
						dropdown["10"]["Size"] = UDim2.new(1, -6, 0, 30);
						dropdown["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						dropdown["10"]["Name"] = options['name'];
						dropdown["10"]["ClipsDescendants"] = true
						dropdown["10"].BackgroundTransparency = 0.4


						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.UICorner
						dropdown["11"] = Instance.new("UICorner", dropdown["10"]);
						dropdown["11"]["CornerRadius"] = UDim.new(0, 3);

						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.Heading
						dropdown["12"] = Instance.new("TextLabel", dropdown["10"]);
						dropdown["12"]["BorderSizePixel"] = 0;
						dropdown["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						dropdown["12"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						dropdown["12"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						dropdown["12"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						dropdown["12"]["TextSize"] = 15;
						dropdown["12"]["TextColor3"] = themeColours.text;
						dropdown["12"]["Size"] = UDim2.new(1, 0, 0, 15);
						dropdown["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						dropdown["12"]["Text"] = options['name'];
						dropdown["12"]["Name"] = [[Heading]];
						dropdown["12"]["BackgroundTransparency"] = 1;

						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.Heading.UIPadding
						dropdown["13"] = Instance.new("UIPadding", dropdown["12"]);
						dropdown["13"]["PaddingBottom"] = UDim.new(0, 0);
						dropdown["13"]["PaddingLeft"] = UDim.new(0, 5);

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label
						dropdown["3d"] = Instance.new("TextLabel", dropdown["10"]);
						dropdown["3d"]["BorderSizePixel"] = 0;
						dropdown["3d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						dropdown["3d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						dropdown["3d"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						dropdown["3d"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						dropdown["3d"]["TextSize"] = 12;
						dropdown["3d"]["TextColor3"] = themeColours.subText;
						dropdown["3d"]["Size"] = UDim2.new(1, 0, 0, 15);
						dropdown["3d"].AnchorPoint = Vector2.new(1,0)
						dropdown["3d"].Position = UDim2.new(1,0,0,15)
						dropdown["3d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						dropdown["3d"]["Name"] = "Notifier";
						dropdown["3d"]["BackgroundTransparency"] = 1;

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label.UIPadding
						dropdown["3e"] = Instance.new("UIPadding", dropdown["3d"]);
						dropdown["3e"]["PaddingBottom"] = UDim.new(0, 3);
						dropdown["3e"]["PaddingLeft"] = UDim.new(0, 5);
						
						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.pointer
						dropdown["14"] = Instance.new("ImageButton", dropdown["10"]);
						dropdown["14"]["ZIndex"] = 2;
						dropdown["14"]["ImageColor3"] = themeColours.accent
						dropdown["14"]["LayoutOrder"] = 5;
						dropdown["14"]["AnchorPoint"] = Vector2.new(1, 0.5);
						dropdown["14"]["Image"] = [[rbxassetid://3926305904]];
						dropdown["14"]["ImageRectSize"] = Vector2.new(36, 36);
						dropdown["14"]["Size"] = UDim2.new(0, 25, 0, 25);
						dropdown["14"]["Name"] = [[pointer]];
						dropdown["14"]["ImageRectOffset"] = Vector2.new(564, 284);
						dropdown["14"]["Position"] = UDim2.new(1, -3, 0, 15);
						dropdown["14"]["BackgroundTransparency"] = 1;
						

					end			
					
					--methods
					function dropdown:setText(txt)
						dropdown["12"].Text = txt
					end

					function dropdown:setSubText(txt)
						dropdown['3d'].Text = txt
					end
					
					function dropdown:setCurrent(_name)
						dropdown.current = _name
						dropdown:setSubText(tostring(_name))
						options.callback(_name)
					end
					
					function dropdown:createOptions(_name)
						
						dropdown.amount += 1
						
						local option = {
							hover = false,
							active = false,
							_detectForPage = false,
						}
						
						do -- render
							-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample
							option["10"] = Instance.new("Frame", dropdown["10"]);
							option["10"]["ZIndex"] = 2;
							option["10"]["BorderSizePixel"] = 0;
							option["10"]["BackgroundColor3"] = themeColours.base;
							option["10"]["Size"] = UDim2.new(1, -12, 0, 25);
							option["10"].AnchorPoint = Vector2.new(0.5,0)
							option["10"].Position = UDim2.new(0.5,0,0, (32 * dropdown.amount) )
							option["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							option["10"]["Name"] = options['name'];
							option["10"]["ClipsDescendants"] = true
							
							-- Starterkeybind.MatLib.MainWindow.ElementsContainer.PageSample.keybindgleSample.pointer.UIStroke
							option["1b"] = Instance.new("UIStroke", option["10"]);
							option["1b"]["Color"] = themeColours.accent;
							option["1b"]["Thickness"] = 1;
							option["1b"].Transparency = 0.4

							-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.UICorner
							option["11"] = Instance.new("UICorner", option["10"]);
							option["11"]["CornerRadius"] = UDim.new(0, 3);

							-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.Heading
							option["12"] = Instance.new("TextLabel", option["10"]);
							option["12"]["BorderSizePixel"] = 0;
							option["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
							option["12"]["TextXAlignment"] = Enum.TextXAlignment.Left;
							option["12"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
							option["12"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
							option["12"]["TextSize"] = 15;
							option["12"]["TextColor3"] = themeColours.text;
							option["12"]["Size"] = UDim2.new(1, 0, 0, 15);
							option["12"].AnchorPoint = Vector2.new(0,0.5)
							option["12"].Position = UDim2.fromScale(0,0.5)
							option["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							option["12"]["Text"] = _name;
							option["12"]["Name"] = [[Heading]];
							option["12"]["BackgroundTransparency"] = 1;

							-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.Heading.UIPadding
							option["13"] = Instance.new("UIPadding", option["12"]);
							option["13"]["PaddingBottom"] = UDim.new(0, 0);
							option["13"]["PaddingLeft"] = UDim.new(0, 5);
							
						end
						
						do -- logic
							library:rippleEffect(option['10'], option)

							option['10'].MouseEnter:Connect(function()
								library:tween(option["1b"], {Transparency = 0})
								option.hover = true

							end)
							
							option['10'].MouseLeave:Connect(function()
								library:tween(option["1b"], {Transparency = 0.4})
								option.hover = false
							end)
							
							uis.InputBegan:Connect(function(input)
								if option.hover == true and dropdown.active == true then
									dropdown:setCurrent(_name)
								end
							end)
							
						end
						
					end
					
					do -- logic
						library:rippleEffect(dropdown['10'], dropdown)
						
						dropdown:setSubText(tostring(options.current))
						
						--should check for page open or not?
						if (string.split(tostring(dropdown['10'].Parent.Name), ".")[1] == "newTab") then
							dropdown._detectForPage = true
						end

						dropdown['10'].MouseEnter:Connect(function()
							if window.pageActive == false or dropdown._detectForPage == false then
								library:tween(dropdown['10'], {BackgroundTransparency = 0})
								dropdown.hover = true
							end
						end)

						dropdown['10'].MouseLeave:Connect(function()
							library:tween(dropdown['10'], {BackgroundTransparency = 0.4})
							dropdown.hover = false
						end)

						uis.InputBegan:Connect(function(input, gpe)
							if input.UserInputType == Enum.UserInputType.MouseButton1 and dropdown.hover == true then
								if dropdown.active == false then
									
									dropdown.active = true
									library:tween(dropdown['10'], {Size = UDim2.new(1,-6,0, (30 + (32 * dropdown.amount) + 5) )})
									library:tween(dropdown['14'], {Rotation = 180})
									
								else
									
									dropdown.active = false
									library:tween(dropdown['10'], {Size = UDim2.new(1,-6,0,30)})
									library:tween(dropdown['14'], {Rotation = 0})

									
								end
							end
						end)

					end

					return dropdown
				end					
				
				function tab:createColorPicker(options)
					options = library:validate({
						name = "name",
						subtext = "",
						def = Color3.fromRGB(255,255,255),
						callback = function(r,g,b) end
					}, options or {} )

					local picker = {
						hover = false,
						active = false,
						
						sliderHover = false,
						
						wheelHover = false,
						wheelMouesDown = false,
						wheelfunction = nil,
						
						current = options.def,
						R = 0,
						G = 0,
						B = 0,

						_detectForPage = false,
					}

					do -- render
						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample
						picker["10"] = Instance.new("Frame", tab["2a"]);
						picker["10"]["ZIndex"] = 2;
						picker["10"]["BorderSizePixel"] = 0;
						picker["10"]["BackgroundColor3"] = themeColours.componentBase;
						picker["10"]["Size"] = UDim2.new(1, -6, 0, 30);
						picker["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						picker["10"]["Name"] = options['name'];
						picker["10"]["ClipsDescendants"] = true
						picker["10"]["BackgroundTransparency"] = 0.4


						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.UICorner
						picker["11"] = Instance.new("UICorner", picker["10"]);
						picker["11"]["CornerRadius"] = UDim.new(0, 3);

						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.Heading
						picker["12"] = Instance.new("TextLabel", picker["10"]);
						picker["12"]["TextWrapped"] = true;
						picker["12"]["BorderSizePixel"] = 0;
						picker["12"]["TextScaled"] = true;
						picker["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						picker["12"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						picker["12"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						picker["12"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						picker["12"]["TextSize"] = 14;
						picker["12"]["TextColor3"] = themeColours.text;
						picker["12"]["Size"] = UDim2.new(1, 0, 1, 0);
						picker["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						picker["12"]["Text"] = options['name'];
						picker["12"]["Name"] = [[Heading]];
						picker["12"]["BackgroundTransparency"] = 1;

						-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.Heading.UIPadding
						picker["13"] = Instance.new("UIPadding", picker["12"]);
						picker["13"]["PaddingBottom"] = UDim.new(0, 15);
						picker["13"]["PaddingLeft"] = UDim.new(0, 5);

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label
						picker["3d"] = Instance.new("TextLabel", picker["10"]);
						picker["3d"]["TextWrapped"] = true;
						picker["3d"]["BorderSizePixel"] = 0;
						picker["3d"]["TextScaled"] = true;
						picker["3d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
						picker["3d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
						picker["3d"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
						picker["3d"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
						picker["3d"]["TextSize"] = 14;
						picker["3d"]["TextColor3"] = themeColours.subText;
						picker["3d"]["Size"] = UDim2.new(1, 0, 1, 0);
						picker["3d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
						picker["3d"]["Text"] = options['subtext'];
						picker["3d"]["Name"] = options['subtext'];
						picker["3d"]["BackgroundTransparency"] = 1;

						-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label.UIPadding
						picker["3e"] = Instance.new("UIPadding", picker["3d"]);
						picker["3e"]["PaddingTop"] = UDim.new(0, 15);
						picker["3e"]["PaddingBottom"] = UDim.new(0, 3);
						picker["3e"]["PaddingLeft"] = UDim.new(0, 5);

						-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer
						picker["19"] = Instance.new("Frame", picker["10"]);
						picker["19"]["Active"] = true;
						picker["19"]["ZIndex"] = 2;
						picker["19"]["AnchorPoint"] = Vector2.new(1, 0.5);
						picker["19"]["LayoutOrder"] = 5;
						picker["19"]["BackgroundColor3"] = themeColours.base;
						picker["19"]["Size"] = UDim2.new(0, 50, 0, 20);
						picker["19"]["Selectable"] = true;
						picker["19"]["Position"] = UDim2.new(1, -7, 0.5, 0);
						picker["19"]["Name"] = [[pointer]];

						-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer.UICorner
						picker["1a"] = Instance.new("UICorner", picker["19"]);
						picker["1a"]["CornerRadius"] = UDim.new(0, 2);

						-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer.UIStroke
						picker["1b"] = Instance.new("UIStroke", picker["19"]);
						picker["1b"]["Color"] = themeColours.accent;
						picker["1b"]["Thickness"] = 1;
						picker["1b"].Transparency = 0.4
						
						do -- create pickerFrame
							--frame
							picker['a1'] = Instance.new("Frame", window['2'])
							picker['a1'].Visible = false
							picker['a1'].BackgroundColor3 = themeColours.background
							picker['a1'].BorderSizePixel = 0
							picker['a1'].ClipsDescendants = true
							picker['a1'].Name = options.name.."colourPicker"
							picker['a1'].Size = UDim2.fromOffset(290,405)
							
							picker['b1'] = Instance.new("UICorner", picker['a1'])
							picker['b1'].CornerRadius = UDim.new(0,3)
							
							-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.Heading
							picker["12"] = Instance.new("TextLabel", picker["a1"]);
							picker["12"]["BorderSizePixel"] = 0;
							picker["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
							picker["12"]["TextXAlignment"] = Enum.TextXAlignment.Left;
							picker["12"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
							picker["12"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
							picker["12"]["TextSize"] = 15;
							picker["12"]["TextColor3"] = themeColours.text;
							picker["12"]["Size"] = UDim2.new(1, 0, 0, 15);
							picker["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							picker["12"]["Text"] = options['name'];
							picker["12"]["Name"] = [[Heading]];
							picker["12"]["BackgroundTransparency"] = 1;

							-- Starterbutton.MatLib.MainWindow.ElementsContainer.PageSample.ButtonSample.Heading.UIPadding
							picker["13"] = Instance.new("UIPadding", picker["12"]);
							picker["13"]["PaddingBottom"] = UDim.new(0, 0);
							picker["13"]["PaddingLeft"] = UDim.new(0, 5);

							-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label
							picker["3d"] = Instance.new("TextLabel", picker["a1"]);
							picker["3d"]["BorderSizePixel"] = 0;
							picker["3d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
							picker["3d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
							picker["3d"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
							picker["3d"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
							picker["3d"]["TextSize"] = 12;
							picker["3d"]["TextColor3"] = themeColours.subText;
							picker["3d"]["Size"] = UDim2.new(1, 0, 0, 15);
							picker["3d"].AnchorPoint = Vector2.new(1,0)
							picker["3d"].Position = UDim2.new(1,0,0,15)
							picker["3d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
							picker["3d"]["Name"] = "Notifier";
							picker['3d'].Text = options.subtext
							picker["3d"]["BackgroundTransparency"] = 1;

							-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label.UIPadding
							picker["3e"] = Instance.new("UIPadding", picker["3d"]);
							picker["3e"]["PaddingBottom"] = UDim.new(0, 3);
							picker["3e"]["PaddingLeft"] = UDim.new(0, 5);
							
							-- StarterGui.MatLib.MainWindow.Topbar.minimize
							picker["f1"] = Instance.new("ImageButton", picker["a1"]);
							picker["f1"]["ZIndex"] = 2;
							picker["f1"]["ImageColor3"] = Color3.fromRGB(201, 201, 201);
							picker["f1"]["LayoutOrder"] = 10;
							picker["f1"]["AnchorPoint"] = Vector2.new(1, 0);
							picker["f1"]["Image"] = [[rbxassetid://3926305904]];
							picker["f1"]["ImageRectSize"] = Vector2.new(36, 36);
							picker["f1"]["Size"] = UDim2.new(0, 20, 0, 20);
							picker["f1"]["Name"] = [[dehaze]];
							picker["f1"]["ImageRectOffset"] = Vector2.new(924, 724);
							picker["f1"]["Position"] = UDim2.new(1, -3, 0, 2);
							picker["f1"]["BackgroundTransparency"] = 1;
							picker["f1"]["Visible"] = true
							
							--wheel
							picker['a2'] = Instance.new("ImageLabel", picker['a1'])
							picker['a2'].BackgroundTransparency = 1
							picker['a2'].Image = "rbxassetid://6020299385"
							picker['a2'].Position = UDim2.fromOffset(15,42.5)
							picker['a2'].Size = UDim2.fromOffset(225,225)
							
							--picker
							picker['a3'] = Instance.new("Frame", picker['a2'])
							picker['a3'].BackgroundColor3 = picker.current
							picker['a3'].AnchorPoint = Vector2.new(.5,.5)
							picker['a3'].Position = UDim2.new(0.5,0,0.5)
							picker['a3'].Size = UDim2.fromOffset(10,10)
							
							picker['b2'] = Instance.new("UICorner", picker['a3'])
							picker['b2'].CornerRadius = UDim.new(1,0)
							
							picker['b3'] = Instance.new("UIStroke", picker['a3'])
							picker['b3'].Color = Color3.fromRGB(255,255,255)
							picker['b3'].Thickness = 3
							
							--slider
							picker['a4'] = Instance.new("Frame", picker['a1'])
							picker['a4'].BackgroundColor3 = Color3.fromRGB(255,255,255)
							picker['a4'].Size = UDim2.fromOffset(18,picker['a2'].Size.X.Offset)
							picker['a4'].Position = UDim2.new(0,(picker['a2'].Size.X.Offset + 30), 0, 42.5)
							
							picker['b4'] = Instance.new("UIGradient", picker['a4'])
							picker['b4'].Rotation = 90
							
							picker['b6'] = Instance.new("UICorner", picker['a4'])
							picker['b6'].CornerRadius = UDim.new(0,3)
							
							picker['b7'] = Instance.new("UIStroke", picker['a4'])
							picker['b7'].Color = themeColours.base
							picker['b7'].Thickness = 1
							
							--sliderpicker
							picker['a5'] = Instance.new("Frame", picker['a4'])
							picker['a5'].Size = UDim2.new(0,picker['a4'].Size.X.Offset, 0, 5)
							picker['a5'].AnchorPoint = Vector2.new(.5,0)
							picker['a5'].Position = UDim2.fromScale(.5,0)
							
							picker['b9'] = Instance.new("UIStroke", picker['a5'])
							picker['b9'].Color = Color3.fromRGB(255,255,255)
							picker['b9'].Thickness = 3
							
							picker['b10'] = Instance.new("UICorner", picker['a5'])
							picker['b10'].CornerRadius = UDim.new(0,3)
							
							--R textbox
							picker['a6'] = Instance.new("TextBox", picker['a1'])
							picker['a6'].Size = UDim2.fromOffset(80,20)
							picker['a6'].Position = UDim2.fromOffset(
								16,300
							)
							picker['a6'].BackgroundColor3 = themeColours.base
							picker['a6'].TextColor3 = themeColours.text
							picker['a6'].TextXAlignment = Enum.TextXAlignment.Left
							picker['a6'].Text = "255"
							
							-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer.UICorner
							picker["11b"] = Instance.new("UICorner", picker["a6"]);
							picker["11b"]["CornerRadius"] = UDim.new(0, 2);

							-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer.UIStroke
							picker["12b"] = Instance.new("UIStroke", picker["a6"]);
							picker["12b"]["Color"] = themeColours.accent;
							picker["12b"]["Thickness"] = 1;
							picker['12b'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
							picker["12b"].Transparency = 0.4
							
							picker['a7'] = Instance.new("TextLabel", picker['a6'])
							picker['a7'].AnchorPoint = Vector2.new(0,1)
							picker['a7'].Position = UDim2.new(0,2,0,-8)	
							picker['a7'].Text = "R"
							picker['a7'].TextSize = 8
							picker['a7'].TextColor3 = themeColours.subText
							
							picker['a8'] = Instance.new("UIPadding", picker['a6'])
							picker['a8'].PaddingLeft = UDim.new(0,3)
							
							--G textbox
							picker['2a6'] = Instance.new("TextBox", picker['a1'])
							picker['2a6'].Size = UDim2.fromOffset(80,20)
							picker['2a6'].AnchorPoint = Vector2.new(.5,0)
							picker['2a6'].Position = UDim2.new(
								0.5,0,
								0,300
							)
							picker['2a6'].BackgroundColor3 = themeColours.base
							picker['2a6'].TextColor3 = themeColours.text
							picker['2a6'].TextXAlignment = Enum.TextXAlignment.Left
							picker['2a6'].Text = "255"

							-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer.UICorner
							picker["211b"] = Instance.new("UICorner", picker["2a6"]);
							picker["211b"]["CornerRadius"] = UDim.new(0, 2);

							-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer.UIStroke
							picker["212b"] = Instance.new("UIStroke", picker["2a6"]);
							picker["212b"]["Color"] = themeColours.accent;
							picker["212b"]["Thickness"] = 1;
							picker['212b'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
							picker["212b"].Transparency = 0.4

							picker['2a7'] = Instance.new("TextLabel", picker['2a6'])
							picker['2a7'].AnchorPoint = Vector2.new(0,1)
							picker['2a7'].Position = UDim2.new(0,2,0,-8)	
							picker['2a7'].Text = "G"
							picker['2a7'].TextSize = 8
							picker['2a7'].TextColor3 = themeColours.subText

							picker['2a8'] = Instance.new("UIPadding", picker['2a6'])
							picker['2a8'].PaddingLeft = UDim.new(0,3)

							--B textbox
							picker['3a6'] = Instance.new("TextBox", picker['a1'])
							picker['3a6'].Size = UDim2.fromOffset(80,20)
							picker['3a6'].Position = UDim2.fromOffset(
								193,300
							)
							picker['3a6'].BackgroundColor3 = themeColours.base
							picker['3a6'].TextColor3 = themeColours.text
							picker['3a6'].TextXAlignment = Enum.TextXAlignment.Left
							picker['3a6'].Text = "255"

							-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer.UICorner
							picker["311b"] = Instance.new("UICorner", picker["3a6"]);
							picker["311b"]["CornerRadius"] = UDim.new(0, 2);

							-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer.UIStroke
							picker["312b"] = Instance.new("UIStroke", picker["3a6"]);
							picker["312b"]["Color"] = themeColours.accent;
							picker["312b"]["Thickness"] = 1;
							picker['312b'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
							picker["312b"].Transparency = 0.4

							picker['3a7'] = Instance.new("TextLabel", picker['3a6'])
							picker['3a7'].AnchorPoint = Vector2.new(0,1)
							picker['3a7'].Position = UDim2.new(0,2,0,-8)	
							picker['3a7'].Text = "B"
							picker['3a7'].TextSize = 8
							picker['3a7'].TextColor3 = themeColours.subText

							picker['3a8'] = Instance.new("UIPadding", picker['3a6'])
							picker['3a8'].PaddingLeft = UDim.new(0,3)
							
							--HEX CODE textbox
							picker['4a6'] = Instance.new("TextBox", picker['a1'])
							picker['4a6'].Size = UDim2.new(1,-34,0,20)
							picker['4a6'].Position = UDim2.fromOffset(
								17,340
							)
							picker['4a6'].BackgroundColor3 = themeColours.base
							picker['4a6'].TextColor3 = themeColours.text
							picker['4a6'].TextXAlignment = Enum.TextXAlignment.Left
							picker['4a6'].Text = "255"
							picker['4a6'].ClearTextOnFocus = false

							-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer.UICorner
							picker["411b"] = Instance.new("UICorner", picker["4a6"]);
							picker["411b"]["CornerRadius"] = UDim.new(0, 2);

							-- Startertextbox.MatLib.MainWindow.ElementsContainer.PageSample.textboxgleSample.pointer.UIStroke
							picker["412b"] = Instance.new("UIStroke", picker["4a6"]);
							picker["412b"]["Color"] = themeColours.accent;
							picker["412b"]["Thickness"] = 1;
							picker['412b'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
							picker["412b"].Transparency = 0.4

							picker['4a7'] = Instance.new("TextLabel", picker['4a6'])
							picker['4a7'].AnchorPoint = Vector2.new(0,1)
							picker['4a7'].Position = UDim2.new(0,2,0,-8)	
							picker['4a7'].Text = "#HEXCODE*"
							picker['4a7'].TextXAlignment = "Left"
							picker['4a7'].TextSize = 8
							picker['4a7'].TextColor3 = themeColours.subText

							picker['4a7'] = Instance.new("UIPadding", picker['4a6'])
							picker['4a7'].PaddingLeft = UDim.new(0,3)
							
						end
						
						do -- create toggle
							local rainbowQueue = nil
							local tog = {
								name = "Rainbow Effect",
								subtext = "Cycle through every colour",
								hover = false,
								state = false,
								callback = function(var)
									if var == true then
										window.requestedrainbows += 1
										rainbowQueue = task.spawn(function()
											while wait(0.1) do
												picker:setColour(window.rainbowColour)
											end
										end)	
									elseif var == false then
										if window.requestedrainbows > 0 then
											window.requestedrainbows -= 1
										end
										if rainbowQueue ~= nil then
											task.cancel(rainbowQueue)
											rainbowQueue = nil
										end
									end
								end,
							}

							do -- render
								-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample
								tog["15"] = Instance.new("Frame", picker["a1"]);
								tog["15"]["ZIndex"] = 2;
								tog["15"]["BorderSizePixel"] = 0;
								tog["15"]["BackgroundColor3"] = themeColours.componentBase;
								tog["15"]["Size"] = UDim2.new(1, -30, 0, 30);
								tog["15"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								tog["15"]["Name"] = [[ToggleSample]];
								tog["15"]["BackgroundTransparency"] = 0.4
								tog["15"]["ClipsDescendants"] = true
								tog["15"].Position = UDim2.fromOffset(
									15,365
								)


								-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample.UICorner
								tog["16"] = Instance.new("UICorner", tog["15"]);
								tog["16"]["CornerRadius"] = UDim.new(0, 3);

								-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample.Heading
								tog["17"] = Instance.new("TextLabel", tog["15"]);
								tog["17"]["TextWrapped"] = true;
								tog["17"]["BorderSizePixel"] = 0;
								tog["17"]["TextScaled"] = true;
								tog["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
								tog["17"]["TextXAlignment"] = Enum.TextXAlignment.Left;
								tog["17"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
								tog["17"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
								tog["17"]["TextSize"] = 14;
								tog["17"]["TextColor3"] = themeColours.text;
								tog["17"]["Size"] = UDim2.new(1, 0, 1, 0);
								tog["17"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								tog["17"]["Text"] = tog.name;
								tog["17"]["Name"] = tog.name;
								tog["17"]["BackgroundTransparency"] = 1;

								-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample.Heading.UIPadding
								tog["18"] = Instance.new("UIPadding", tog["17"]);
								tog["18"]["PaddingBottom"] = UDim.new(0, 15);
								tog["18"]["PaddingLeft"] = UDim.new(0, 5);

								-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label
								tog["3d"] = Instance.new("TextLabel", tog["15"]);
								tog["3d"]["TextWrapped"] = true;
								tog["3d"]["BorderSizePixel"] = 0;
								tog["3d"]["TextScaled"] = true;
								tog["3d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
								tog["3d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
								tog["3d"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
								tog["3d"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
								tog["3d"]["TextSize"] = 14;
								tog["3d"]["TextColor3"] = themeColours.subText;
								tog["3d"]["Size"] = UDim2.new(1, 0, 1, 0);
								tog["3d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
								tog["3d"]["Text"] = tog.subtext;
								tog["3d"]["Name"] = tog.subtext;
								tog["3d"]["BackgroundTransparency"] = 1;

								-- Startertab.MatLib.MainWindow.NavBar.TabContainer.TabSample.Label.UIPadding
								tog["3e"] = Instance.new("UIPadding", tog["3d"]);
								tog["3e"]["PaddingTop"] = UDim.new(0, 15);
								tog["3e"]["PaddingBottom"] = UDim.new(0, 3);
								tog["3e"]["PaddingLeft"] = UDim.new(0, 5);

								-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample.pointer
								tog["19"] = Instance.new("Frame", tog["15"]);
								tog["19"]["Active"] = true;
								tog["19"]["ZIndex"] = 2;
								tog["19"]["AnchorPoint"] = Vector2.new(1, 0.5);
								tog["19"]["BackgroundTransparency"] = 1;
								tog["19"]["LayoutOrder"] = 5;
								tog["19"]["BackgroundColor3"] = themeColours.accent;
								tog["19"]["Size"] = UDim2.new(0, 20, 0, 20);
								tog["19"]["Selectable"] = true;
								tog["19"]["Position"] = UDim2.new(1, -7, 0.5, 0);
								tog["19"]["Name"] = [[pointer]];

								-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample.pointer.UICorner
								tog["1a"] = Instance.new("UICorner", tog["19"]);
								tog["1a"]["CornerRadius"] = UDim.new(0, 2);

								-- Startertog.MatLib.MainWindow.ElementsContainer.PageSample.ToggleSample.pointer.UIStroke
								tog["1b"] = Instance.new("UIStroke", tog["19"]);
								tog["1b"]["Color"] = themeColours.accent;
								tog["1b"]["Thickness"] = 1;

								tog["12b"] = Instance.new("ImageLabel", tog["19"]);
								tog['12b']["Image"] = 'rbxassetid://3926305904';
								tog['12b']["ImageColor3"] = themeColours.componentBase;
								tog['12b']["ImageRectOffset"] = Vector2.new(644,204);
								tog['12b']["ImageRectSize"] = Vector2.new(36,36);
								tog["12b"]["ZIndex"] = 5;
								tog['12b']["Size"] = UDim2.fromScale(1,1);
								tog['12b']["ImageTransparency"] = 1;
								tog['12b']["BackgroundTransparency"] = 1;

							end
							
							-- methods

							function tog:setState(v)
								tog.state = v
								tog.callback(v)

								if v == true then
									library:tween(tog['19'], {BackgroundTransparency = 0})
									library:tween(tog['12b'], {ImageTransparency = 0})
								elseif v == false then
									library:tween(tog['19'], {BackgroundTransparency = 1})
									library:tween(tog['12b'], {ImageTransparency = 1})
								end
							end

							function tog:_changeState()
								tog:setState(not tog.state)
							end

							function tog:setText(txt)
								tog['17'].Text = txt
							end

							function tog:setSubText(txt)
								tog['3d'].Text = txt
							end
							
							do -- logic
								library:rippleEffect(tog['15'], tog)
								tog:setState(tog.state)

								tog['15'].MouseEnter:Connect(function()
									library:tween(tog['15'], {BackgroundTransparency = 0})
									tog.hover = true
								end)

								tog['15'].MouseLeave:Connect(function()
									library:tween(tog['15'], {BackgroundTransparency = 0.4})
									tog.hover = false
								end)

								uis.InputBegan:Connect(function(input, gpe)
									if input.UserInputType == Enum.UserInputType.MouseButton1 and tog.hover == true then
										tog:_changeState()
									end
								end)

							end
							
						end
						
					end						

					--methods
					function picker:setText(txt)
						picker["12"].Text = txt
					end

					function picker:setSubText(txt)
						picker['3d'].Text = txt
					end

					function picker:setCallback(fn)
						options['callback'] = fn
					end
					
					local function RGBToHex(r, g, b)
						-- Ensure RGB values are in the range [0, 255]
						r = math.clamp(r, 0, 255)
						g = math.clamp(g, 0, 255)
						b = math.clamp(b, 0, 255)

						-- Convert RGB to a hex color code
						local hex = string.format("#%02X%02X%02X", r, g, b)
						return hex
					end
					
					local function HexToRGB(hex)
						hex = hex:gsub("#", "")  -- Remove the '#' symbol if it's included
						local r = tonumber(hex:sub(1, 2), 16)
						local g = tonumber(hex:sub(3, 4), 16)
						local b = tonumber(hex:sub(5, 6), 16)
						return r, g, b
					end
					
					local function IsValidHexColor(hex)
						-- Define a pattern to match a valid hex color code
						local pattern = "^#(%x%x%x%x%x%x)$"  -- Matches "#RRGGBB" format

						-- Check if the hex code matches the pattern
						return string.match(hex, pattern) ~= nil
					end						

					function picker:_updateColour(centreOfWheel)
						local colourPickerCentre = Vector2.new(
							picker['a3'].AbsolutePosition.X + (picker['a3'].AbsoluteSize.X/2),
							picker['a3'].AbsolutePosition.Y + (picker['a3'].AbsoluteSize.Y/2)
						)
						local h = (math.pi - math.atan2(colourPickerCentre.Y - centreOfWheel.Y, colourPickerCentre.X - centreOfWheel.X)) / (math.pi * 2)

						local s = (centreOfWheel - colourPickerCentre).Magnitude / (picker['a2'].AbsoluteSize.X/2)

						local v = math.abs((picker['a5'].AbsolutePosition.Y - picker['a4'].AbsolutePosition.Y) / picker['a4'].AbsoluteSize.Y - 1)

						local hsv = Color3.fromHSV(math.clamp(h, 0, 1), math.clamp(s, 0, 1), math.clamp(v, 0, 1))

						picker["19"].BackgroundColor3 = hsv
						picker["a5"].BackgroundColor3 = hsv
						picker['a4'].UIGradient.Color = ColorSequence.new{
							ColorSequenceKeypoint.new(0, Color3.fromHSV(math.clamp(h, 0, 1), math.clamp(s, 0, 1), math.clamp(math.abs((picker['a5'].AbsolutePosition.Y - picker['a5'].AbsolutePosition.Y) / picker['a5'].AbsoluteSize.Y - 1), 0, 1))),
							ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
						}
						picker.current = hsv
						picker['a3'].BackgroundColor3 = picker.current
						
						local r,g,b = 
							math.floor((picker["19"].BackgroundColor3.R*255)+0.5),
							math.floor((picker["19"].BackgroundColor3.G*255)+0.5),
							math.floor((picker["19"].BackgroundColor3.B*255)+0.5)
						
						picker.R = r
						picker.G = g
						picker.B = b
						

						-- Display each RGB value separately
						picker['a6'].Text = r
						picker['2a6'].Text = g
						picker['3a6'].Text = b
						picker['4a6'].Text = RGBToHex(r,g,b)

						options.callback(Color3.fromRGB(r, g, b))
					end
					
					function picker:setColour(color)
						local r, g, b

						if typeof(color) == "Color3" then
							-- Extract RGB values from the Color3 object
							r = color.R
							g = color.G
							b = color.B
						elseif typeof(color) == "string" then
							-- Check if the input is a valid hex color code
							if IsValidHexColor(color) then
								-- Convert the hex color code to RGB
								r, g, b = HexToRGB(color)
								r = r / 255
								g = g / 255
								b = b / 255

							else
								warn("Invalid hex color code: " .. color)
								window:createNotif({
									name = "Invalid hex color code",
									text = "Try a valid hex color code"
								})
								return
							end
						else
							warn("Invalid input: " .. typeof(color))
							window:createNotif({
								name = "Invalid input",
								text = "Try a valid input"
							})
							return
						end

						-- Ensure RGB values are in the range [0, 1]
						r = math.floor(math.clamp(r, 0, 1) * 255 + 0.5)
						g = math.floor(math.clamp(g, 0, 1) * 255 + 0.5)
						b = math.floor(math.clamp(b, 0, 1) * 255 + 0.5)

						-- Update the color picker
						local hsv = Color3.fromRGB(r,g,b)
						picker["19"].BackgroundColor3 = hsv
						picker["a5"].BackgroundColor3 = hsv
						picker['a4'].UIGradient.Color = ColorSequence.new{
							ColorSequenceKeypoint.new(0, hsv),
							ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
						}
						picker.current = hsv
						picker['a3'].BackgroundColor3 = picker.current

						picker.R = r
						picker.G = g
						picker.B = b

						-- Display each RGB value separately
						picker['a6'].Text = r
						picker['2a6'].Text = g
						picker['3a6'].Text = b
						picker['4a6'].Text = RGBToHex(r,g,b)

						options.callback(Color3.fromRGB(r, g, b))
					end
					
					do -- logic
						picker:setColour(options.def)
						
						do -- button logic
							library:rippleEffect(picker['10'], picker)
							
						--should check for page open or not?
						if (string.split(tostring(picker['10'].Parent.Name), ".")[1] == "newTab") then
							picker._detectForPage = true
						end

							picker["f1"].MouseButton1Click:Connect(function()
								picker['a1'].Visible = false
							end)
							
							picker['10'].MouseEnter:Connect(function()
								if window.pageActive == false or picker._detectForPage == false then
									library:tween(picker['10'], {BackgroundTransparency = 0})
									picker.hover = true
								end
							end)

							picker['10'].MouseLeave:Connect(function()
								library:tween(picker['10'], {BackgroundTransparency = 0.4})
								picker.hover = false
							end)

							uis.InputBegan:Connect(function(input, gpe)
								if input.UserInputType == Enum.UserInputType.MouseButton1 and picker.hover == true then
									picker['a1'].Position = UDim2.new(1,20,0,0)
									picker['a1'].Visible = not picker['a1'].Visible
									picker.active = picker['a1'].Visible
								end
							end)
						end
						
						do -- picker logic
							
							picker['a2'].MouseEnter:Connect(function()
								picker.wheelHover = true
							end)
							
							picker['a2'].MouseLeave:Connect(function()
								picker.wheelHover = false
							end)
							
							picker['a4'].MouseEnter:Connect(function()
								picker.sliderHover = true
							end)
							
							picker['a4'].MouseLeave:Connect(function()
								picker.sliderHover = false
							end)
							
							uis.InputBegan:Connect(function(input)
								if picker.active == true and input.UserInputType == Enum.UserInputType.MouseButton1 then
									picker.wheelfunction = uis.InputChanged:Connect(function(input)
										if picker.active == true and input.UserInputType == Enum.UserInputType.MouseMovement then
											picker.wheelMouesDown = true
											
											local mousePos = uis:GetMouseLocation() - Vector2.new(0, game:GetService("GuiService"):GetGuiInset().Y)
											local centreOfWheel = Vector2.new(picker['a2'].AbsolutePosition.X + (picker['a2'].AbsoluteSize.X/2), picker['a2'].AbsolutePosition.Y + (picker['a2'].AbsoluteSize.Y/2))
											local distanceFromWheel = (mousePos - centreOfWheel).Magnitude

											if picker.wheelHover == true and distanceFromWheel <= picker['a2'].AbsoluteSize.X/2 then
												picker['a3'].Position = UDim2.new(0, mousePos.X - picker['a2'].AbsolutePosition.X, 0, mousePos.Y - picker['a2'].AbsolutePosition.Y)
												picker:_updateColour(centreOfWheel)
											elseif picker.sliderHover == true then
												picker['a5'].Position = UDim2.new(picker['a5'].Position.X.Scale, 0, 0, 
													math.clamp(
														mousePos.Y - picker['a4'].AbsolutePosition.Y, 
														0, 
														picker['a4'].AbsoluteSize.Y)
												)	
												picker:_updateColour(centreOfWheel)
											end
											
											
										end
									end)
								end
							end)
							
							uis.InputEnded:Connect(function(input)
								if input.UserInputType == Enum.UserInputType.MouseButton1 then
									picker.wheelMouesDown = false
									if picker.wheelfunction ~= nil then
										picker.wheelfunction:Disconnect()
										picker.wheelfunction = nil
									end
								end
							end)
							
							do -- texbox RGB values
								picker['a6'].FocusLost:Connect(function()
									if tonumber(picker['a6'].Text) ~= nil then
										picker:setColour(Color3.fromRGB(picker['a6'].Text, picker.G, picker.B))
									end
								end)
								
								picker['2a6'].FocusLost:Connect(function()
									if tonumber(picker['2a6'].Text) ~= nil then
										picker:setColour(Color3.fromRGB(picker.R, picker['2a6'].Text, picker.B))
									end
								end)
								
								picker['3a6'].FocusLost:Connect(function()
									if tonumber(picker['3a6'].Text) ~= nil then
										picker:setColour(Color3.fromRGB(picker.R, picker.G, picker['3a6'].Text))
									end
								end)
								
								picker['4a6'].FocusLost:Connect(function()
									if IsValidHexColor(picker['4a6'].Text) == true then
										picker:setColour(tostring(picker['4a6'].Text))
									end
								end)
								
							end
							
						end
						
					end

					return picker
				end					

			end
			
			return tab
		end
		
		function window:createSection(options)
			options = library:validate({
				name = "section name",
			}, options or {} )
			
			local section = {
				
			}
			
			do --render
				
				-- Starterwindow.MatLib.MainWindow.NavBar.TabContainer.Title
				section["37"] = Instance.new("TextLabel", window["34"]);
				section["37"]["BorderSizePixel"] = 0;
				section["37"]["TextYAlignment"] = Enum.TextYAlignment.Bottom;
				section["37"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				section["37"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				section["37"]["FontFace"] = Font.new([[rbxasset://fonts/families/Ubuntu.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				section["37"]["TextSize"] = 14;
				section["37"]["TextColor3"] = themeColours.subText;
				section["37"]["Size"] = UDim2.new(1, 0, 0, 10);
				section["37"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				section["37"]["Text"] = options.name;
				section["37"]["Name"] = options['name'];
				section["37"]["BackgroundTransparency"] = 1;
				
				-- StarterGui.MatLib.MainWindow.NavBar.TabContainer.Title.UIPadding
				section["38"] = Instance.new("UIPadding", section["37"]);
				section["38"]["PaddingLeft"] = UDim.new(0, 3);
				
			end
			
			return section
		end
		
		function window:createNotif(options)
			options = library:validate({
				name = "section name",
				text = "notification description",
				time = 5,
				callback = function() end,
			}, options or {} )
			
			local notif = {
				hover = false,
				timer = nil,
			}
			
			do -- render
				-- StarterGui.Notifs.notifs.Sample
				notif["5"] = Instance.new("Frame", notification["2"]);
				notif["5"]["BorderSizePixel"] = 0;
				notif["5"]["BackgroundColor3"] = themeColours.base;
				notif["5"]["Size"] = UDim2.new(0, 250, 0, 50);
				notif["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				notif["5"]["AutomaticSize"] = Enum.AutomaticSize.XY;
				notif["5"]["Name"] = options.name;

				-- StarterGui.Notifs.notifs.Sample.UICorner
				notif["6"] = Instance.new("UICorner", notif["5"]);
				notif["6"]["CornerRadius"] = UDim.new(0, 2);

				-- StarterGui.Notifs.notifs.Sample.TextLabel
				notif["7"] = Instance.new("TextLabel", notif["5"]);
				notif["7"]["TextWrapped"] = true;
				notif["7"]["BorderSizePixel"] = 0;
				notif["7"]["TextYAlignment"] = Enum.TextYAlignment.Top;
				notif["7"]["BackgroundColor3"] = themeColours.text;
				notif["7"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				notif["7"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				notif["7"]["TextSize"] = 18;
				notif["7"]["TextColor3"] = themeColours.text;
				notif["7"]["AutomaticSize"] = Enum.AutomaticSize.X;
				notif["7"]["Size"] = UDim2.new(1, 0, 0, 20);
				notif["7"]["Text"] = options.name
				notif["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				notif["7"]["BackgroundTransparency"] = 1;

				-- StarterGui.Notifs.notifs.Sample.TextLabel.UIPadding
				notif["8"] = Instance.new("UIPadding", notif["7"]);
				notif["8"]["PaddingTop"] = UDim.new(0, 3);
				notif["8"]["PaddingRight"] = UDim.new(0, 3);
				notif["8"]["PaddingLeft"] = UDim.new(0, 3);

				-- StarterGui.Notifs.notifs.Sample.TextLabel
				notif["9"] = Instance.new("TextLabel", notif["5"]);
				notif["9"]["TextWrapped"] = true;
				notif["9"]["BorderSizePixel"] = 0;
				notif["9"]["TextYAlignment"] = Enum.TextYAlignment.Top;
				notif["9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				notif["9"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				notif["9"]["FontFace"] = Font.new([[rbxassetid://12187373327]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
				notif["9"]["TextSize"] = 14;
				notif["9"]["TextColor3"] = themeColours.subText;
				notif["9"]["AutomaticSize"] = Enum.AutomaticSize.Y;
				notif["9"]["Size"] = UDim2.new(1, 0, 0, 20);
				notif["9"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
				notif["9"]["Text"] = options.text;
				notif["9"]["BackgroundTransparency"] = 1;
				notif["9"]["Position"] = UDim2.new(0, 0, 0, 23);

				-- StarterGui.Notifs.notifs.Sample.TextLabel.UIPadding
				notif["a"] = Instance.new("UIPadding", notif["9"]);
				notif["a"]["PaddingRight"] = UDim.new(0, 3);
				notif["a"]["PaddingBottom"] = UDim.new(0, 3);
				notif["a"]["PaddingLeft"] = UDim.new(0, 3);
			end
			
			do -- logic				
				notif.timer = task.spawn(function()
					notif['5'].BackgroundTransparency = 1
					notif['7'].TextTransparency = 1
					notif['9'].TextTransparency = 1

					library:tween(notif['5'], {BackgroundTransparency = 0})
					library:tween(notif['7'], {TextTransparency = 0})
					library:tween(notif['9'], {TextTransparency = 0})
					task.wait(options.time)
					library:tween(notif['5'], {BackgroundTransparency = 1})
					library:tween(notif['7'], {TextTransparency = 1})
					library:tween(notif['9'], {TextTransparency = 1}, function()
						notif['5']:Destroy()
					end)
				end)				

				notif["5"].MouseEnter:Connect(function()
					notif.hover = true
					library:tween(notif['5'], {BackgroundColor3 = themeColours.background})
				end)
				notif["5"].MouseLeave:Connect(function()
					notif.hover = false
					library:tween(notif['5'], {BackgroundColor3 = themeColours.base})
				end)
				
				uis.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and notif.hover == true then
						notif.hover = false
						options.callback()
						task.cancel(notif.timer)
						library:tween(notif['5'], {BackgroundTransparency = 1})
						library:tween(notif['7'], {TextTransparency = 1})
						library:tween(notif['9'], {TextTransparency = 1}, function()
							notif['5']:Destroy()
						end)
					end
				end)	

			end
			
		end
		
	end
	
	do --logic
		local navdebounce = false

		--navbar button press
		window['8'].MouseButton1Click:Connect(function()
			if window.pageActive == false and window['33'].Visible == false then
				window['33'].Visible = true	
				window.pageActive = true
				library:tween(window['34'], {AnchorPoint = Vector2.new(0,0)})
				library:tween(window['3f'], {AnchorPoint = Vector2.new(0,1)})
				library:tween(window['33'], {BackgroundTransparency = 0.5})
			end
		end)

		--navvar background press
		window['navbarClickOff'].MouseButton1Click:Connect(function()
			library:tween(window['34'], {AnchorPoint = Vector2.new(1,0)})
			library:tween(window['3f'], {AnchorPoint = Vector2.new(1,1)})
			library:tween(window['33'], {BackgroundTransparency = 1}, function()
				window['33'].Visible = false
				window.pageActive = false

			end)		
		end)

		--max/min
		window["f1"].MouseButton1Click:Connect(function()	
			if window.pageActive == false and window['33'].Visible == false then
				window['2'].Visible = false
				window.reOpenWindow = uis.InputBegan:Connect(function(input, gpe)
					if not gpe and input.KeyCode == options.toggleKeybind and window['2'].Visible == false then
						window['2'].Visible = true
						if window.reOpenWindow ~= nil then
							window.reOpenWindow:Disconnect()
							window.reOpenWindow = nil
						end
					end
				end)

				window:createNotif({
					name = options.name.." Minimized",
					text = "Press [".. string.split(tostring(options.toggleKeybind), ".")[3] .."] or Click Here To Re Open The Interface",
					callback = function()
						window['2'].Visible = true
						if window.reOpenWindow ~= nil then
							window.reOpenWindow:Disconnect()
							window.reOpenWindow = nil
						end
					end,
				})	 
			end
		end)
		


		do -- drag script

			local frame = window['2']
			local dragToggle = nil
			local dragSpeed = 0.15
			local dragStart = nil
			local startPos = nil

			local function updateInput(input)
				local delta = input.Position - dragStart
				local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y)
				game:GetService('TweenService'):Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
			end

			local began = frame.InputBegan:Connect(function(input)
				if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and window.tempDisableDrag == false and window.disableDrag == false then 
					dragToggle = true
					dragStart = input.Position
					startPos = frame.Position
					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							dragToggle = false
						end
					end)
				end
			end)

			local changed = uis.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					if dragToggle then
						updateInput(input)
					end
				end
			end)

			frame.Destroying:Once(function()
				changed:Disconnect()
				began:Disconnect()
			end)

		end		
		
		
		
	end
	
	return window
end

return library

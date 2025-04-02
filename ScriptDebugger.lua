local ScriptDebugger = {}

-- Create UI elements
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ScriptBox = Instance.new("TextBox")
local DebugButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local DebugFrame = Instance.new("Frame")
local DebugTitle = Instance.new("TextLabel")
local DebugResults = Instance.new("ScrollingFrame")
local ResultsText = Instance.new("TextLabel")

-- Initialize the debugger
function ScriptDebugger:Initialize()
    -- Configure ScreenGui
    ScreenGui.Name = "ScriptDebuggerGUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Configure MainFrame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    -- Configure Title
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Title.BorderSizePixel = 0
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Advanced Script Debugger"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18.0
    
    -- Configure ScriptBox
    ScriptBox.Name = "ScriptBox"
    ScriptBox.Parent = MainFrame
    ScriptBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ScriptBox.BorderSizePixel = 0
    ScriptBox.Position = UDim2.new(0.05, 0, 0.15, 0)
    ScriptBox.Size = UDim2.new(0.9, 0, 0.6, 0)
    ScriptBox.Font = Enum.Font.SourceSans
    ScriptBox.PlaceholderText = "Enter GitHub loadstring URL or script code here..."
    ScriptBox.Text = ""
    ScriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    ScriptBox.TextSize = 14.0
    ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
    ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
    ScriptBox.ClearTextOnFocus = false
    ScriptBox.MultiLine = true
    
    -- Configure DebugButton
    DebugButton.Name = "DebugButton"
    DebugButton.Parent = MainFrame
    DebugButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    DebugButton.BorderSizePixel = 0
    DebugButton.Position = UDim2.new(0.25, 0, 0.8, 0)
    DebugButton.Size = UDim2.new(0.5, 0, 0.1, 0)
    DebugButton.Font = Enum.Font.SourceSansBold
    DebugButton.Text = "Debug Script"
    DebugButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DebugButton.TextSize = 16.0
    
    -- Configure CloseButton
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = MainFrame
    CloseButton.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(0.9, 0, 0, 0)
    CloseButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18.0
    
    -- Configure DebugFrame (initially hidden)
    DebugFrame.Name = "DebugFrame"
    DebugFrame.Parent = ScreenGui
    DebugFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DebugFrame.BorderSizePixel = 0
    DebugFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    DebugFrame.Size = UDim2.new(0, 500, 0, 400)
    DebugFrame.Visible = false
    DebugFrame.Active = true
    DebugFrame.Draggable = true
    
    -- Configure DebugTitle
    DebugTitle.Name = "DebugTitle"
    DebugTitle.Parent = DebugFrame
    DebugTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DebugTitle.BorderSizePixel = 0
    DebugTitle.Size = UDim2.new(1, 0, 0, 30)
    DebugTitle.Font = Enum.Font.SourceSansBold
    DebugTitle.Text = "Script Analysis Results"
    DebugTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    DebugTitle.TextSize = 18.0
    
    -- Configure DebugResults
    DebugResults.Name = "DebugResults"
    DebugResults.Parent = DebugFrame
    DebugResults.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DebugResults.BorderSizePixel = 0
    DebugResults.Position = UDim2.new(0.05, 0, 0.1, 0)
    DebugResults.Size = UDim2.new(0.9, 0, 0.85, 0)
    DebugResults.CanvasSize = UDim2.new(0, 0, 4, 0)
    DebugResults.ScrollBarThickness = 8
    
    -- Configure ResultsText
    ResultsText.Name = "ResultsText"
    ResultsText.Parent = DebugResults
    ResultsText.BackgroundTransparency = 1
    ResultsText.Position = UDim2.new(0, 5, 0, 5)
    ResultsText.Size = UDim2.new(0.98, 0, 0.98, 0)
    ResultsText.Font = Enum.Font.SourceSans
    ResultsText.Text = "Debugging in progress..."
    ResultsText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ResultsText.TextSize = 14.0
    ResultsText.TextXAlignment = Enum.TextXAlignment.Left
    ResultsText.TextYAlignment = Enum.TextYAlignment.Top
    ResultsText.TextWrapped = true
    
    -- Set up button events
    DebugButton.MouseButton1Click:Connect(function()
        self:DebugScript(ScriptBox.Text)
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Add close button to debug frame
    local DebugCloseButton = CloseButton:Clone()
    DebugCloseButton.Parent = DebugFrame
    DebugCloseButton.MouseButton1Click:Connect(function()
        DebugFrame.Visible = false
        MainFrame.Visible = true
    end)
    
    return self
end

-- Function to fetch script from GitHub if it's a loadstring URL
function ScriptDebugger:FetchScript(input)
    -- Check if input is a GitHub loadstring URL
    if input:match("https://") and input:match("github") then
        local success, result
        
        -- Try to fetch the script content
        success, result = pcall(function()
            local HttpService = game:GetService("HttpService")
            
            -- Convert raw GitHub URL if needed
            local url = input
            if url:match("github.com") and not url:match("raw.githubusercontent.com") then
                url = url:gsub("github.com", "raw.githubusercontent.com")
                url = url:gsub("/blob/", "/")
            end
            
            return HttpService:GetAsync(url)
        end)
        
        if success then
            return result
        else
            return nil, "Failed to fetch script from GitHub: " .. tostring(result)
        end
    else
        -- If it's not a URL, assume it's the script code itself
        return input
    end
end

-- Helper function to get line number and context for a pattern
function ScriptDebugger:FindInScript(script, pattern)
    local results = {}
    local lines = {}
    
    -- Split script into lines
    for line in script:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    
    -- Find pattern in each line
    for lineNum, lineContent in ipairs(lines) do
        if lineContent:match(pattern) then
            local context = {
                lineNumber = lineNum,
                line = lineContent:gsub("^%s+", ""):gsub("%s+$", ""),
                before = lineNum > 1 and lines[lineNum-1]:gsub("^%s+", ""):gsub("%s+$", "") or "",
                after = lineNum < #lines and lines[lineNum+1]:gsub("^%s+", ""):gsub("%s+$", "") or ""
            }
            table.insert(results, context)
        end
    end
    
    return results
end

-- Helper function to split script into lines
function ScriptDebugger:GetScriptLines(script)
    local lines = {}
    for line in script:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    return lines
end

-- Main debugging function
function ScriptDebugger:DebugScript(input)
    -- Hide main frame and show debug frame
    MainFrame.Visible = false
    DebugFrame.Visible = true
    ResultsText.Text = "Analyzing script...\n\n"
    
    -- Fetch script if it's a URL
    local script, fetchError = self:FetchScript(input)
    if not script then
        ResultsText.Text = fetchError
        return
    end
    
    -- Split script into lines for analysis
    local scriptLines = self:GetScriptLines(script)
    
    -- Start analysis
    local issues = {}
    local warnings = {}
    local info = {}
    
    -- Check for syntax errors
    local success, syntaxError = pcall(function()
        loadstring(script)
    end)
    
    if not success then
        -- Extract line number from syntax error message
        local errorLine = syntaxError:match(":(%d+):")
        local errorMsg = syntaxError:match(":%d+:%s*(.*)")
        
        if errorLine then
            local lineNum = tonumber(errorLine)
            
            local contextStart = math.max(1, lineNum - 2)
            local contextEnd = math.min(#scriptLines, lineNum + 2)
            local contextStr = "\nCode context:\n"
            
            for i = contextStart, contextEnd do
                local prefix = i == lineNum and "→ " or "  "
                contextStr = contextStr .. prefix .. i .. ": " .. (scriptLines[i] or "N/A") .. "\n"
            end
            
            table.insert(issues, {
                message = "Syntax Error: " .. errorMsg,
                lineNumber = lineNum,
                context = contextStr
            })
        else
            table.insert(issues, {
                message = "Syntax Error: " .. tostring(syntaxError),
                lineNumber = "Unknown",
                context = "Unable to determine exact location"
            })
        end
    end
    
    -- Check for potentially dangerous functions
    local dangerousFunctions = {
        "getfenv", "setfenv", "loadstring", "pcall", "xpcall",
        "newproxy", "getmetatable", "setmetatable", "getrawmetatable",
        "setreadonly", "make_writeable", "hookfunction", "hookmetamethod"
    }
    
    for _, func in ipairs(dangerousFunctions) do
        local pattern = "[^%w_]" .. func .. "%s*%("
        local occurrences = self:FindInScript(script, pattern)
        
        for _, occurrence in ipairs(occurrences) do
            table.insert(warnings, {
                message = "Potentially unsafe function detected: " .. func .. "()",
                lineNumber = occurrence.lineNumber,
                context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line .. 
                          "\nBefore: " .. occurrence.before .. 
                          "\nAfter: " .. occurrence.after
            })
        end
    end
    
    -- Check for HTTP requests
    local httpPatterns = {"HttpService", "GetAsync", "PostAsync"}
    for _, pattern in ipairs(httpPatterns) do
        local occurrences = self:FindInScript(script, pattern)
        if #occurrences > 0 then
            for _, occurrence in ipairs(occurrences) do
                table.insert(info, {
                    message = "Script makes HTTP requests, which may fail in some environments",
                    lineNumber = occurrence.lineNumber,
                    context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line
                })
            end
            break -- Only report this once
        end
    end
    
    -- Check for infinite loops
    local infiniteLoopPatterns = {"while%s+true", "while%s+1"}
    for _, pattern in ipairs(infiniteLoopPatterns) do
        local occurrences = self:FindInScript(script, pattern)
        for _, occurrence in ipairs(occurrences) do
            -- Check if there's a wait() in the next few lines
            local hasWait = false
            for i = occurrence.lineNumber, math.min(occurrence.lineNumber + 10, #scriptLines) do
                if scriptLines[i] and (scriptLines[i]:match("wait%(") or scriptLines[i]:match("task%.wait")) then
                    hasWait = true
                    break
                end
            end
            
            if not hasWait then
                table.insert(warnings, {
                    message = "Potential infinite loop detected without wait() or task.wait()",
                    lineNumber = occurrence.lineNumber,
                    context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line .. 
                              "\nBefore: " .. occurrence.before .. 
                              "\nAfter: " .. occurrence.after
                })
            end
        end
    end
    
    -- Check for memory leaks
    local tableInserts = self:FindInScript(script, "table%.insert")
    local tableRemoves = self:FindInScript(script, "table%.remove")
    
    if #tableInserts > 0 and #tableRemoves == 0 then
        for _, occurrence in ipairs(tableInserts) do
            table.insert(info, {
                message = "Possible memory leak: table insertions without removals",
                lineNumber = occurrence.lineNumber,
                context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line
            })
            break -- Only report once
        end
    end
    
    -- Check for error handling
    if not script:match("pcall") and not script:match("xpcall") then
        table.insert(info, {
            message = "No error handling (pcall/xpcall) detected",
            lineNumber = "N/A",
            context = "Consider adding error handling to prevent script crashes"
        })
    end
    
    -- Check for deprecated functions
    local deprecatedFunctions = {
        {pattern = "wait%(", name = "wait()"},
        {pattern = "delay%(", name = "delay()"},
        {pattern = "spawn%(", name = "spawn()"},
        {pattern = "game:GetService%(\"Lighting\"%)%.Changed", name = "Lighting.Changed event"},
        {pattern = "Instance%.new%(\"Message\"", name = "Instance.new(\"Message\")"},
        {pattern = "Instance%.new%(\"Hint\"", name = "Instance.new(\"Hint\")"}
    }
    
    for _, func in ipairs(deprecatedFunctions) do
        local occurrences = self:FindInScript(script, func.pattern)
        for _, occurrence in ipairs(occurrences) do
            table.insert(warnings, {
                message = "Deprecated function or method detected: " .. func.name,
                lineNumber = occurrence.lineNumber,
                context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line .. 
                          "\nRecommendation: Use newer alternatives"
            })
        end
    end
    
    -- Check for global variables
    local potentialGlobals = {}
    local assignmentPattern = "([%w_]+)%s*="
    for lineNum, line in ipairs(scriptLines) do
        -- Skip comments and lines with local keyword
        if not line:match("^%s*%-%-") and not line:match("local%s+") then
            local varName = line:match(assignmentPattern)
            if varName and not varName:match("^_") and not varName:match("^self") then
                table.insert(potentialGlobals, {
                    name = varName,
                    lineNumber = lineNum,
                    line = line
                })
            end
        end
    end
    
    if #potentialGlobals > 0 then
        for _, global in ipairs(potentialGlobals) do
            table.insert(warnings, {
                message = "Potential global variable detected: " .. global.name,
                lineNumber = global.lineNumber,
                context = "Line " .. global.lineNumber .. ": " .. global.line .. 
                          "\nRecommendation: Use 'local' keyword to prevent global scope pollution"
            })
        end
    end
    
    -- Generate report
    local report = "Script Analysis Complete\n\n"
    
    if #issues > 0 then
        report = report .. "🛑 CRITICAL ISSUES (" .. #issues .. "):\n"
        for i, issue in ipairs(issues) do
            report = report .. i .. ". " .. issue.message .. " at line " .. issue.lineNumber .. "\n"
            report = report .. issue.context .. "\n\n"
        end
    else
        report = report .. "✅ No critical issues found\n\n"
    end
    
    if #warnings > 0 then
        report = report .. "⚠️ WARNINGS (" .. #warnings .. "):\n"
        for i, warning in ipairs(warnings) do
            report = report .. i .. ". " .. warning.message .. " at line " .. warning.lineNumber .. "\n"
            report = report .. warning.context .. "\n\n"
        end
    else
        report = report .. "✅ No warnings found\n\n"
    end
    
    if #info > 0 then
        report = report .. "ℹ️ INFORMATION (" .. #info .. "):\n"
        for i, infoItem in ipairs(info) do
            report = report .. i .. ". " .. infoItem.message
            if infoItem.lineNumber ~= "N/A" then
                report = report .. " at line " .. infoItem.lineNumber
            end
            report = report .. "\n"
            if infoItem.context then
                report = report .. infoItem.context .. "\n"
            end
            report = report .. "\n"
        end
    end
    
    -- Performance analysis
    report = report .. "📊 PERFORMANCE ANALYSIS:\n"
    
    -- Check script size
    local scriptSize = #script
    if scriptSize > 100000 then
        report = report .. "- Script is very large (" .. scriptSize .. " characters), may cause lag when loading\n"
    elseif scriptSize > 50000 then
        report = report .. "- Script is large (" .. scriptSize .. " characters)\n"
    else
        report = report .. "- Script size is acceptable (" .. scriptSize .. " characters)\n"
    end
    
    -- Check for frequent table operations
    local tableOps = 0
    for _ in script:gmatch("table%.") do
        tableOps = tableOps + 1
    end
    
    if tableOps > 50 then
        report = report .. "- Heavy table operations detected (" .. tableOps .. " occurrences), may impact performance\n"
    end
    
    -- Check for frequent string operations
    local stringOps = 0
    for _ in script:gmatch("string%.") do
        stringOps = stringOps + 1
    end
    
    if stringOps > 50 then
        report = report .. "- Heavy string operations detected (" .. stringOps .. " occurrences), may impact performance\n"
    end
    
    -- Check for frequent loops
    local loops = 0
    for _ in script:gmatch("for%s+") do loops = loops + 1 end
    for _ in script:gmatch("while%s+") do loops = loops + 1 end
    for _ in script:gmatch("repeat%s+") do loops = loops + 1 end
    
    if loops > 20 then
        report = report .. "- High number of loops detected (" .. loops .. " loops), may cause performance issues\n"
    end
    
    -- Final recommendation
    report = report .. "\n🔍 FINAL ASSESSMENT:\n"
    if #issues > 0 then
        report = report .. "This script has critical issues that will prevent it from running correctly."
    elseif #warnings > 3 then
        report = report .. "This script has several warnings that may cause problems during execution."
    elseif #warnings > 0 then
        report = report .. "This script has minor warnings but should run with caution."
    else
        report = report .. "This script appears to be well-formed and should run without major issues."
    end
    
    -- Update the results text
    ResultsText.Text = report
end

-- Create and return the debugger instance
return ScriptDebugger:Initialize()

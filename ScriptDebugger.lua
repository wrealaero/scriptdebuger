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

-- Function to extract script from loadstring format
function ScriptDebugger:ExtractScriptFromLoadstring(input)
    -- Check for loadstring pattern
    local url = input:match('loadstring%(game:HttpGet%("(https://[^"]+)"')
    
    if url then
        return self:FetchScript(url)
    else
        -- Check for other loadstring patterns
        url = input:match('loadstring%(game:HttpGet%([\'"]([^\'")]+)[\'"]')
        if url then
            return self:FetchScript(url)
        end
    end
    
    return input, nil
end

-- Function to fetch script from GitHub if it's a loadstring URL
function ScriptDebugger:FetchScript(input)
    -- First check if input is a loadstring with HttpGet
    local script, error = self:ExtractScriptFromLoadstring(input)
    if error then
        return nil, error
    end
    
    -- Check if input is a GitHub URL
    if input:match("https://") and (input:match("github") or input:match("raw.githubusercontent")) then
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

-- Function to analyze script structure
function ScriptDebugger:AnalyzeStructure(script, scriptLines)
    local info = {}
    
    -- Check for proper module structure
    local hasModuleReturn = script:match("return%s+[%w_]+%s*$") ~= nil
    local hasLocalModule = script:match("local%s+[%w_]+%s*=%s*{") ~= nil
    
    if hasLocalModule and hasModuleReturn then
        table.insert(info, {
            message = "Script appears to be a properly structured module",
            lineNumber = "N/A",
            context = "Good practice: Module has local table and returns it at the end"
        })
    elseif script:match("local%s+module%s*=%s*{}") then
        table.insert(info, {
            message = "Script uses module pattern",
            lineNumber = "N/A",
            context = "Module pattern detected"
        })
    end
    
    -- Check for OOP patterns
    if script:match(":%s*new%s*%(") or script:match("function%s+[%w_]+:") then
        table.insert(info, {
            message = "Object-oriented programming patterns detected",
            lineNumber = "N/A",
            context = "Script uses OOP with methods and/or constructors"
        })
    end
    
    return info
end

-- Function to check for security issues
function ScriptDebugger:CheckSecurity(script, scriptLines)
    local issues = {}
    local warnings = {}
    
    -- Check for potentially malicious code patterns
    local maliciousPatterns = {
        {pattern = "while%s+true%s+do[^;]-end", message = "Potential infinite loop without wait()"},
        {pattern = "game:Shutdown", message = "Script attempts to shut down the game"},
        {pattern = "game:GetService%(\"Players\"%):ClearAllChildren", message = "Script attempts to remove all players"},
        {pattern = "game:GetService%(\"Workspace\"%):ClearAllChildren", message = "Script attempts to clear workspace"},
        {pattern = "game:GetService%(\"CoreGui\"%):ClearAllChildren", message = "Script attempts to clear CoreGui"},
        {pattern = "game:GetService%(\"StarterGui\"%):ClearAllChildren", message = "Script attempts to clear StarterGui"},
        {pattern = "game:GetService%(\"ReplicatedStorage\"%):ClearAllChildren", message = "Script attempts to clear ReplicatedStorage"},
        {pattern = "game:GetService%(\"ServerStorage\"%):ClearAllChildren", message = "Script attempts to clear ServerStorage"},
        {pattern = "game:GetService%(\"ServerScriptService\"%):ClearAllChildren", message = "Script attempts to clear ServerScriptService"},
        {pattern = "game:GetService%(\"Players\"%):ClearAllChildren", message = "Script attempts to clear Players service"},
        {pattern = "game:GetService%(\"Lighting\"%):ClearAllChildren", message = "Script attempts to clear Lighting service"},
        {pattern = "game:GetService%(\"SoundService\"%):ClearAllChildren", message = "Script attempts to clear SoundService"},
        {pattern = "game:GetService%(\"Chat\"%):ClearAllChildren", message = "Script attempts to clear Chat service"},
        {pattern = "game:GetService%(\"JointsService\"%):ClearAllChildren", message = "Script attempts to clear JointsService"},
        {pattern = "game:GetService%(\"InsertService\"%):ClearAllChildren", message = "Script attempts to clear InsertService"},
        {pattern = "game:GetService%(\"NetworkClient\"%):ClearAllChildren", message = "Script attempts to clear NetworkClient"},
        {pattern = "game:GetService%(\"NetworkServer\"%):ClearAllChildren", message = "Script attempts to clear NetworkServer"},
        {pattern = "game:GetService%(\"TeleportService\"%):ClearAllChildren", message = "Script attempts to clear TeleportService"}
    }
    
    for _, pattern in ipairs(maliciousPatterns) do
        local occurrences = self:FindInScript(script, pattern.pattern)
        for _, occurrence in ipairs(occurrences) do
            table.insert(issues, {
                message = "Potentially malicious code: " .. pattern.message,
                lineNumber = occurrence.lineNumber,
                context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line .. "\nBefore: " .. occurrence.before .. "\nAfter: " .. occurrence.after
            })
        end
    end
    
    -- Check for dangerous functions
    local dangerousFunctions = {
        "getfenv", "setfenv", "loadstring", "pcall", "xpcall", "newproxy", 
        "getmetatable", "setmetatable", "getrawmetatable", "setreadonly", 
        "make_writeable", "hookfunction", "hookmetamethod", "decompile", 
        "saveinstance", "dumpstring", "getscripts", "getnilinstances", 
        "getgc", "getinstances", "gethiddenproperty", "sethiddenproperty",
        "firesignal", "fireclickdetector", "fireproximityprompt", "firetouchinterest"
    }
    
    for _, func in ipairs(dangerousFunctions) do
        local pattern = "[^%w_]" .. func .. "%s*%("
        local occurrences = self:FindInScript(script, pattern)
        
        for _, occurrence in ipairs(occurrences) do
            table.insert(warnings, {
                message = "Potentially unsafe function detected: " .. func .. "()",
                lineNumber = occurrence.lineNumber,
                context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line .. "\nBefore: " .. occurrence.before .. "\nAfter: " .. occurrence.after
            })
        end
    end
    
    return issues, warnings
end

-- Function to check for performance issues
function ScriptDebugger:CheckPerformance(script, scriptLines)
    local warnings = {}
    local info = {}
    
    -- Check for inefficient loops
    local loopPatterns = {
        {pattern = "for%s+[%w_]+%s*=%s*1%s*,%s*#[%w_%.]+", message = "Loop iterates through entire array", isWarning = false},
        {pattern = "for%s+[%w_]+%s*,%s*[%w_]+%s+in%s+pairs", message = "Using pairs() for iteration", isWarning = false},
        {pattern = "for%s+[%w_]+%s*,%s*[%w_]+%s+in%s+ipairs", message = "Using ipairs() for iteration", isWarning = false},
        {pattern = "while%s+true", message = "Infinite loop detected", isWarning = true}
    }
    
    for _, pattern in ipairs(loopPatterns) do
        local occurrences = self:FindInScript(script, pattern.pattern)
        
        for _, occurrence in ipairs(occurrences) do
            local item = {
                message = pattern.message,
                lineNumber = occurrence.lineNumber,
                context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line
            }
            
            if pattern.isWarning then
                table.insert(warnings, item)
            else
                table.insert(info, item)
            end
        end
    end
    
    -- Check for table operations in loops
    local tableOpsInLoops = {}
    local loopStarts = {}
    local loopEnds = {}
    
    -- Find all loop start and end positions
    for i, line in ipairs(scriptLines) do
        if line:match("for%s+") or line:match("while%s+") then
            table.insert(loopStarts, i)
        elseif line:match("end") then
            table.insert(loopEnds, i)
        end
    end
    
    -- Check for table operations within loops
    for i, line in ipairs(scriptLines) do
        if line:match("table%.") then
            -- Check if this line is within a loop
            for j, loopStart in ipairs(loopStarts) do
                local loopEnd = loopEnds[j] or #scriptLines
                if i > loopStart and i < loopEnd then
                    table.insert(tableOpsInLoops, {
                        lineNumber = i,
                        line = line:gsub("^%s+", ""):gsub("%s+$", "")
                    })
                    break
                end
            end
        end
    end
    
    if #tableOpsInLoops > 0 then
        table.insert(warnings, {
            message = "Table operations inside loops may impact performance",
            lineNumber = tableOpsInLoops[1].lineNumber,
            context = "Example at line " .. tableOpsInLoops[1].lineNumber .. ": " .. tableOpsInLoops[1].line .. 
                      "\nConsider moving table operations outside loops when possible"
        })
    end
    
    return warnings, info
end

-- Function to check for best practices
function ScriptDebugger:CheckBestPractices(script, scriptLines)
    local warnings = {}
    local info = {}
    
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
    
    -- Check for deprecated functions
    local deprecatedFunctions = {
        {pattern = "wait%(", name = "wait()", alternative = "task.wait()"},
        {pattern = "delay%(", name = "delay()", alternative = "task.delay()"},
        {pattern = "spawn%(", name = "spawn()", alternative = "task.spawn()"},
        {pattern = "game:GetService%(\"Lighting\"%)%.Changed", name = "Lighting.Changed event", alternative = "GetPropertyChangedSignal()"},
        {pattern = "Instance%.new%(\"Message\"", name = "Instance.new(\"Message\")", alternative = "TextLabel with proper UI"},
        {pattern = "Instance%.new%(\"Hint\"", name = "Instance.new(\"Hint\")", alternative = "TextLabel with proper UI"}
    }
    
    for _, func in ipairs(deprecatedFunctions) do
        local occurrences = self:FindInScript(script, func.pattern)
        
        for _, occurrence in ipairs(occurrences) do
            table.insert(warnings, {
                message = "Deprecated function or method detected: " .. func.name,
                lineNumber = occurrence.lineNumber,
                context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line .. 
                          "\nRecommendation: Use " .. func.alternative .. " instead"
            })
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
    
    return warnings, info
end

-- Main debugging function
function ScriptDebugger:DebugScript(input)
    -- Hide main frame and show debug frame
    MainFrame.Visible = false
    DebugFrame.Visible = true
    ResultsText.Text = "Analyzing script...\n\n"
    
    -- Fetch script if it's a URL or loadstring
    local script, fetchError = self:FetchScript(input)
    if not script then
        ResultsText.Text = fetchError or "Failed to process script"
        return
    end
    
    -- Split script into lines for analysis
    local scriptLines = self:GetScriptLines(script)
    
    -- Initialize result containers
    local allIssues = {}
    local allWarnings = {}
    local allInfo = {}
    
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
                local prefix = i == lineNum and "→ " or " "
                contextStr = contextStr .. prefix .. i .. ": " .. (scriptLines[i] or "N/A") .. "\n"
            end
            
            table.insert(allIssues, {
                message = "Syntax Error: " .. errorMsg,
                lineNumber = lineNum,
                context = contextStr
            })
        else
            table.insert(allIssues, {
                message = "Syntax Error: " .. tostring(syntaxError),
                lineNumber = "Unknown",
                context = "Unable to determine exact location"
            })
        end
    end
    
    -- Run security checks
    local securityIssues, securityWarnings = self:CheckSecurity(script, scriptLines)
    for _, issue in ipairs(securityIssues) do
        table.insert(allIssues, issue)
    end
    for _, warning in ipairs(securityWarnings) do
        table.insert(allWarnings, warning)
    end
    
    -- Run performance checks
    local perfWarnings, perfInfo = self:CheckPerformance(script, scriptLines)
    for _, warning in ipairs(perfWarnings) do
        table.insert(allWarnings, warning)
    end
    for _, info in ipairs(perfInfo) do
        table.insert(allInfo, info)
    end
    
    -- Run best practices checks
    local practiceWarnings, practiceInfo = self:CheckBestPractices(script, scriptLines)
    for _, warning in ipairs(practiceWarnings) do
        table.insert(allWarnings, warning)
    end
    for _, info in ipairs(practiceInfo) do
        table.insert(allInfo, info)
    end
    
    -- Add structure analysis
    local structureInfo = self:AnalyzeStructure(script, scriptLines)
    for _, info in ipairs(structureInfo) do
        table.insert(allInfo, info)
    end
    
    -- Check for HTTP requests
    local httpPatterns = {"HttpService", "GetAsync", "PostAsync", "RequestAsync"}
    for _, pattern in ipairs(httpPatterns) do
        local occurrences = self:FindInScript(script, pattern)
        if #occurrences > 0 then
            for _, occurrence in ipairs(occurrences) do
                table.insert(allInfo, {
                    message = "Script makes HTTP requests, which may fail in some environments",
                    lineNumber = occurrence.lineNumber,
                    context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line
                })
            end
            break -- Only report this once
        end
    end
    
    -- Check for memory leaks
    local tableInserts = self:FindInScript(script, "table%.insert")
    local tableRemoves = self:FindInScript(script, "table%.remove")
    if #tableInserts > 0 and #tableRemoves == 0 then
        for _, occurrence in ipairs(tableInserts) do
            table.insert(allInfo, {
                message = "Possible memory leak: table insertions without removals",
                lineNumber = occurrence.lineNumber,
                context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line
            })
            break -- Only report once
        end
    end
    
    -- Generate report
    local report = "Script Analysis Complete\n\n"
    
    if #allIssues > 0 then
        report = report .. "🛑 CRITICAL ISSUES (" .. #allIssues .. "):\n"
        for i, issue in ipairs(allIssues) do
            report = report .. i .. ". " .. issue.message .. " at line " .. issue.lineNumber .. "\n"
            report = report .. issue.context .. "\n\n"
        end
    else
        report = report .. "✅ No critical issues found\n\n"
    end
    
    if #allWarnings > 0 then
        report = report .. "⚠️ WARNINGS (" .. #allWarnings .. "):\n"
        for i, warning in ipairs(allWarnings) do
            report = report .. i .. ". " .. warning.message .. " at line " .. warning.lineNumber .. "\n"
            report = report .. warning.context .. "\n\n"
        end
    else
        report = report .. "✅ No warnings found\n\n"
    end
    
    if #allInfo > 0 then
        report = report .. "ℹ️ INFORMATION (" .. #allInfo .. "):\n"
        for i, infoItem in ipairs(allInfo) do
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
    for _ in script:gmatch("for%s+") do
        loops = loops + 1
    end
    for _ in script:gmatch("while%s+") do
        loops = loops + 1
    end
    for _ in script:gmatch("repeat%s+") do
        loops = loops + 1
    end
    if loops > 20 then
        report = report .. "- High number of loops detected (" .. loops .. " loops), may cause performance issues\n"
    end
    
    -- Check for event connections
    local connections = 0
    for _ in script:gmatch("Connect%(") do
        connections = connections + 1
    end
    if connections > 10 then
        report = report .. "- High number of event connections (" .. connections .. "), ensure they're properly disconnected\n"
    end
    
    -- Check for yield functions
    local yields = 0
    for _ in script:gmatch("wait%(") do yields = yields + 1 end
    for _ in script:gmatch("task%.wait") do yields = yields + 1 end
    for _ in script:gmatch("delay%(") do yields = yields + 1 end
    for _ in script:gmatch("task%.delay") do yields = yields + 1 end
    
    if yields > 20 then
        report = report .. "- Script uses many yield functions (" .. yields .. " occurrences), which may impact performance\n"
    end
    
    -- Check for require statements
    local requires = {}
    for _, line in ipairs(scriptLines) do
        local module = line:match("require%(([^%)]+)%)")
        if module then
            table.insert(requires, module)
        end
    end
    
    if #requires > 0 then
        report = report .. "- Script requires " .. #requires .. " module(s): "
        for i, req in ipairs(requires) do
            report = report .. req .. (i < #requires and ", " or "")
        end
        report = report .. "\n"
    end
    
    -- Analyze script complexity
    local complexity = 0
    complexity = complexity + (loops * 2)
    complexity = complexity + (tableOps * 1.5)
    complexity = complexity + (stringOps * 1.5)
    complexity = complexity + (connections * 3)
    complexity = complexity + (yields * 1)
    complexity = complexity + (#scriptLines / 10)
    
    local complexityRating = "Low"
    if complexity > 100 then
        complexityRating = "Very High"
    elseif complexity > 50 then
        complexityRating = "High"
    elseif complexity > 25 then
        complexityRating = "Medium"
    end
    
    report = report .. "- Script complexity rating: " .. complexityRating .. " (" .. math.floor(complexity) .. ")\n"
    
    -- Final recommendation
    report = report .. "\n🔍 FINAL ASSESSMENT:\n"
    if #allIssues > 0 then
        report = report .. "This script has critical issues that will prevent it from running correctly."
    elseif #allWarnings > 3 then
        report = report .. "This script has several warnings that may cause problems during execution."
    elseif #allWarnings > 0 then
        report = report .. "This script has minor warnings but should run with caution."
    else
        report = report .. "This script appears to be well-formed and should run without major issues."
    end
    
    -- Add loadstring-specific analysis if applicable
    if input:match("loadstring") then
        report = report .. "\n\n📦 LOADSTRING ANALYSIS:\n"
        report = report .. "- Script is loaded via loadstring, which may be flagged by some anti-exploits\n"
        
        -- Check if the loadstring URL is from a trusted domain
        local url = input:match('loadstring%(game:HttpGet%("(https://[^"]+)"')
        if url then
            local domain = url:match("https://([^/]+)")
            if domain and (domain:match("github") or domain:match("githubusercontent")) then
                report = report .. "- Script is loaded from GitHub, which is generally more reliable\n"
            else
                report = report .. "- Script is loaded from " .. (domain or "unknown domain") .. ", verify the source is trustworthy\n"
            end
            
            -- Check if URL uses HTTPS
            if url:match("^https://") then
                report = report .. "- Script URL uses HTTPS, which is secure\n"
            else
                report = report .. "- Script URL does not use HTTPS, which is less secure\n"
            end
        end
    end
    
    -- Update the results text
    ResultsText.Text = report
    
    -- Adjust canvas size based on content
    local textHeight = ResultsText.TextBounds.Y + 20
    DebugResults.CanvasSize = UDim2.new(0, 0, 0, textHeight)
end

-- Create and return the debugger instance
return ScriptDebugger:Initialize()

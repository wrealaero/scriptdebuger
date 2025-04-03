local ScriptDebugger = {}

-- Create UI elements (same as your original code)
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

-- Initialize the debugger (same as your original code)
function ScriptDebugger:Initialize()
    -- ... (UI initialization code remains the same) ...
    return self
end

-- Function to fetch script from GitHub if it's a loadstring URL
function ScriptDebugger:FetchScript(input)
    -- Check if input is a GitHub loadstring URL
    if input:match("https://") and input:match("github") then
        local success, result
        success, result = pcall(function()
            local HttpService = game:GetService("HttpService")
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
        return input -- Assume it's the script code itself
    end
end

-- Helper function to get line number and context for a pattern
function ScriptDebugger:FindInScript(script, pattern)
    local results = {}
    local lines = {}
    for line in script:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    for lineNum, lineContent in ipairs(lines) do
        if lineContent:match(pattern) then
            local context = {
                lineNumber = lineNum,
                line = lineContent:gsub("^%s+", ""):gsub("%s+<span class="math-inline">", ""\),
before \= lineNum \> 1 and lines\[lineNum\-1\]\:gsub\("^%s\+", ""\)\:gsub\("%s\+</span>", "") or "",
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

-- Improved Main debugging function
function ScriptDebugger:DebugScript(input)
    MainFrame.Visible = false
    DebugFrame.Visible = true
    ResultsText.Text = "Analyzing script...\n\n"

    local script, fetchError = self:FetchScript(input)
    if not script then
        ResultsText.Text = fetchError
        return
    end

    local scriptLines = self:GetScriptLines(script)
    local issues = {}
    local warnings = {}
    local info = {}

    -- **Enhanced Analysis for Loadstring Scenarios**

    -- Check for explicit loadstring calls (within the fetched script)
    local loadstringCalls = self:FindInScript(script, "[^%w_]loadstring%s*%(")
    if #loadstringCalls > 0 then
        for _, call in ipairs(loadstringCalls) do
            table.insert(warnings, {
                message = "Potential nested loadstring call detected. This can be a sign of obfuscation or malicious intent.",
                lineNumber = call.lineNumber,
                context = "Line " .. call.lineNumber .. ": " .. call.line
            })
        end
    end

    -- Check for common obfuscation techniques
    local obfuscationPatterns = {
        "string.reverse",
        "string.char",
        "string.byte",
        "\\x%x%x", -- Hexadecimal escapes
        "\\u%x%x%x%x", -- Unicode escapes
        "getfenv%s*%(%s*1%s*%)", -- getfenv(1)
        "setfenv%s*%(",
        "require%s*%(", -- Could be legitimate, but worth noting in injected scripts
        "base64Decode", -- Common in older scripts
        "HttpService:RequestAsync", -- More advanced HTTP requests
    }

    for _, pattern in ipairs(obfuscationPatterns) do
        local occurrences = self:FindInScript(script, pattern)
        if #occurrences > 0 then
            for _, occurrence in ipairs(occurrences) do
                table.insert(warnings, {
                    message = "Potential obfuscation technique detected: '" .. pattern .. "'",
                    lineNumber = occurrence.lineNumber,
                    context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line
                })
            end
        end
    end

    -- Check for common anti-tamper or anti-debug techniques
    local antiDebugPatterns = {
        "debug.getinfo",
        "debug.traceback",
        "task.wait%(-?%d+)", -- wait with a very large or small number
        "game:GetService%(\"Debris\")", -- Often used for cleanup, but can be misused
        "game.Players.LocalPlayer", -- Might indicate client-specific actions
        "UserSettings%:", -- Accessing user settings
    }

    for _, pattern in ipairs(antiDebugPatterns) do
        local occurrences = self:FindInScript(script, pattern)
        if #occurrences > 0 then
            for _, occurrence in ipairs(occurrences) do
                table.insert(info, {
                    message = "Potentially suspicious function or pattern detected: '" .. pattern .. "'. May be used for anti-tamper or anti-debug.",
                    lineNumber = occurrence.lineNumber,
                    context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line
                })
            end
        end
    end

    -- Check for attempts to modify globals or environments
    local environmentModificationPatterns = {
        "_G%.",
        "_ENV%."
    }

    for _, pattern in ipairs(environmentModificationPatterns) do
        local occurrences = self:FindInScript(script, pattern)
        if #occurrences > 0 then
            for _, occurrence in ipairs(occurrences) do
                table.insert(warnings, {
                    message = "Potential attempt to modify global environment detected.",
                    lineNumber = occurrence.lineNumber,
                    context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line
                })
            end
        end
    end

    -- **Standard Script Analysis (same as before, but potentially with adjusted severity)**

    -- Check for syntax errors
    local success, syntaxError = pcall(function()
        loadstring(script)() -- Attempt to load and execute (carefully!)
    end)

    if not success then
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

    -- Check for potentially dangerous functions (increased severity for injected scripts)
    local dangerousFunctions = {
        "getfenv", "setfenv", "loadstring", "pcall", "xpcall",
        "newproxy", "getmetatable", "setmetatable", "getrawmetatable",
        "setreadonly", "make_writeable", "hookfunction", "hookmetamethod",
        "assert", "error", "rawset", "rawget", "unpack", "select" -- Some of these can be misused
    }

    for _, func in ipairs(dangerousFunctions) do
        local pattern = "[^%w_]" .. func .. "%s*%("
        local occurrences = self:FindInScript(script, pattern)
        for _, occurrence in ipairs(occurrences) do
            table.insert(warnings, {
                message = "Potentially dangerous function detected: " .. func .. "()",
                lineNumber = occurrence.lineNumber,
                context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line ..
                          "\nBefore: " .. occurrence.before ..
                          "\nAfter: " .. occurrence.after
            })
        end
    end

    -- Check for HTTP requests (increased severity for injected scripts)
    local httpPatterns = {"HttpService", "GetAsync", "PostAsync", "RequestAsync"}
    for _, pattern in ipairs(httpPatterns) do
        local occurrences = self:FindInScript(script, pattern)
        if #occurrences > 0 then
            for _, occurrence in ipairs(occurrences) do
                table.insert(warnings, {
                    message = "Script makes HTTP requests, which can be used for malicious purposes.",
                    lineNumber = occurrence.lineNumber,
                    context = "Line " .. occurrence.lineNumber .. ": " .. occurrence.line
                })
            end
            break
        end
    end

    -- Check for infinite loops
    local infiniteLoopPatterns = {"while%s+true", "while%s+1"}
    for _, pattern in ipairs(infiniteLoopPatterns) do
        local occurrences = self:FindInScript(script, pattern)
        for _, occurrence in ipairs(occurrences) do
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
            break
        end
    end

    -- Check for error handling (less critical for injected scripts, but still good to note)
    if not script:match("pcall") and not script:match("xpcall") then
        table.insert(info, {
            message = "No explicit error handling (pcall/xpcall) detected",
            lineNumber = "N/A",
            context = "Consider error handling for robustness"
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
            table.insert(info, {
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
            table.insert(info, {
                message = "Potential global variable detected: " .. global.name,
                lineNumber = global.lineNumber,
                context = "Line " .. global.lineNumber .. ": " .. global.line ..
                          "\nRecommendation: Use 'local' keyword"
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

    -- Performance analysis (can be further refined)
    report = report .. "📊 PERFORMANCE ANALYSIS:\n"
    local scriptSize = #script
    report = report .. "- Script size: " .. scriptSize .. " characters\n"

    local tableOps = 0; for _ in script:gmatch("table%.") do tableOps = tableOps + 1 end
    report = report .. "- Table operations: " .. tableOps .. " occurrences\n"

    local stringOps = 0; for _ in script:gmatch("string%.") do stringOps = stringOps + 1 end
    report = report .. "- String operations: " .. stringOps .. " occurrences\n"

    local loops = 0; for _ in script:gmatch("for%s+") do loops = loops + 1 end; for _ in script:gmatch("while%s+") do loops = loops + 1 end; for _ in script:gmatch("repeat%s+") do loops = loops + 1 end
    report = report .. "- Loops: " .. loops .. " occurrences\n"

    -- Final recommendation (tailored for injected scripts)
    report = report .. "\n🔍 FINAL ASSESSMENT:\n"
    if #issues > 0 then
        report = report .. "This script has critical issues and is likely to fail."
    elseif #warnings > 5 then
        report = report .. "This

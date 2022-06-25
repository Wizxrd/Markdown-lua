-- # ***markdown-lua***
--
-- **Author:** Wizard
--
-- **Created:** June 19th, 2021
--
-- **Version:** 0.0.1
--
-- **Description:**
-- Convert lua comments (--) into markdown format, and document functions with (---)
-- following the LuaDoc format.
--
-- ## ***Examples***
-- ---
-- from double lua comment:
-- ```lua
-- -- ## Header
-- -- hello world
-- ```
-- into markdown:
-- ## Header
-- hello world
--
-- ---
-- from tripple lua comment for function documentation
-- ```lua
-- --- the start of documentation, also start of the description.
-- -- you can add multiple lines to the start of the description,
-- -- there is no limit.
-- -- @param exam1 #string <*> [example description]
-- -- @param exam2 #table [example description]
-- -- @return exam3 #table
-- -- @usage
-- -- local exam = example("exam1", {[1] = "hello"})
-- local function example(exam1, exam2) ... end
-- ```
-- into markdown:
-- ## ***example(exam1, exam2)***
-- the start of documentation, also start of the description.
-- you can add multiple lines to the start of the description,
-- there is no limit.
-- Param | Type | Required | Description
-- -|-|-|-
-- exam1 | string | yes | example description
-- exam2 | table | | example description
--
-- Return | Type
-- -|-
-- exam3 | table
--
-- Usage:
-- ```lua
-- local exam = example("exam1", {[1] = "hello"})
-- ```
-- ---
local sourceFilePath = "C:/_gitMaster/markdown-lua/markdown.lua"
local readmeFilePath = "C:/_gitMaster/markdown-lua/README.md"

-- ## ***Functions***
--
--- Get the lines from a file  
-- @return #array lines
local function getLines()
    local lines = {}
    for line in io.lines(sourceFilePath) do
        lines[#lines+1] = line
    end
    return lines
end

--- Get the description from a function  
-- recursiverly goes through lines until the first @param.  
-- also returns a second variable that is the current index.  
-- @param #array lines <*> [the array of lines]  
-- @param #number index <*> [the current line index]  
-- @return #array description  
-- @return #number index  
local function getDescription(lines, index)
    local description = {}
    local function recurse()
        local line = lines[index]
        if line:match("%-%-%-%s") then
            description[#description+1] = line:match("%-%-%-%s(.*)")
            index = index + 1
            recurse()
        elseif line and line:match("%-%-%s") then
            if not line:match("%-%-%s@") then
                description[#description+1] = line:match("%-%-%s(.*)")
                index = index + 1
                recurse()
            end
        end
        return description, index
    end
    return recurse()
end

--- Get the parameters from a function
-- recursively goes through lines and collects comments underneath params.
-- also returns a second variable that is the current index.
-- @param #array lines <*> [the array of lines]
-- @param #number index <*> [the current line index]
-- @return #array params
-- @return #number index
local function getParams(lines, index)
    local params = {}
    local function recurse()
        local line = lines[index]
        if line and line:match("%-%-%s@param") then
            local name = line:match("%s(%a+)")
            local Type = line:match("%#(%a+)")
            local required = line:match("%<%*%>")
            local description = line:match("%[(.*)%]") or ""
            if required then
                required = "**✓**"
            else
                required = ""
            end
            params[#params+1] = name.." | "..Type.." | "..required.." | "..description
            index = index + 1
            recurse()
        elseif line and line:match("%-%-%s%a+") then
            params[#params] = params[#params].." "..line:match("%-%-%s(.*)")
            index = index + 1
            recurse()
        end
        return params, index
    end
    return recurse()
end

--- Get the returns from a function
-- @param #array lines <*> [the array of lines]
-- @param #number index <*> [the current line index]
-- @return #array returns
-- @return #number index
local function getReturns(lines, index)
    local returns = {}
    local function recurse()
        local line = lines[index]
        if line and line:match("%-%-%s@return") then
            local name = line:match("%s(%a+)")
            local Type = line:match("%#(%a+)")
            local description = line:match("%[(.*)%]") or ""
            if name == "none" then Type = "" end
            returns[#returns+1] = name.." | "..Type.." | "..description
            index = index + 1
            recurse()
        elseif line and line:match("%-%-%s%a+") then
            returns[#returns] = returns[#returns].." "..line:match("%-%-%s(.*)")
            index = index + 1
            recurse()
        end
        return returns, index
    end
    return recurse()
end

--- Get the usage examples from a function
-- @param #array lines <*> [the array of lines]
-- @param #number index <*> [the current line index]
-- @return #array usage
-- @return #number index
local function getUsage(lines, index)
    local usage = {}
    local function recurse()
        local line = lines[index]
        if line and line:match("%-%-%s@usage") then
            index = index + 1
            recurse()
        elseif line and line:match("%-%-%s%s") then
            usage[#usage+1] = ""
            index = index + 1
            recurse()
        elseif line and line:match("%-%-%s%a") then
            local comment = line:match("%-%-%s(.*)")
            usage[#usage+1] = comment
            index = index + 1
            recurse()
        end
        return usage, index
    end
    return recurse()
end

--- Get the function sytax
-- @param #array lines <*> [the array of lines]
-- @param #number index <*> [the current line index]
-- @return #string syntax
-- @return #number index
local function getFunction(lines, index)
    local line = lines[index]
    if line:match("function%s") then
        local syntax = line:match("function%s(.*)")
        return syntax, index
    end
end

--- Get a tripple comment block
-- @param #array lines <*> [the array of lines]
-- @param #number index <*> [the current line index]
-- @return #string block
-- @return #number index
local function getBlock(lines, index)
    local block = {}
    block.desc, index = getDescription(lines, index)
    block.params, index = getParams(lines, index)
    block.returns, index = getReturns(lines, index)
    block.usage, index = getUsage(lines, index)
    block.func, index = getFunction(lines, index)
    return block, index
end

--- Write the header which is a functions syntax.
-- @param #file file <*> [the file to be written to]
-- @param #string header <*> [the header to write]
-- @return none
local function writeHeader(file, header)
    file:write("## ***"..header.."***\n")
end

--- Write the description for a function
-- @param #file file <*> [the file to be written to]
-- @param #table description <*> [the description to write]
-- @return none
local function writeDescription(file, description)
    for _, desc in pairs(description) do
        file:write(desc.."  \n")
    end
end

--- Write the parameters for a function
-- @param #file file <*> [the file to be written to]
-- @param #table params <*> [the params to write]
-- @return none
local function writeParams(file, params)
    if #params > 0 then
        file:write("Parameter | Type | Required | Description\n")
        file:write("-|-|-|-\n")
        for _, param in pairs(params) do
            file:write(param.."\n")
        end
        file:write("\n")
    end
end

--- Write the returns for a function
-- @param #file file <*> [the file to be written to]
-- @param #table returns <*> [the returns to write]
-- @return none
local function writeReturns(file, returns)
    if #returns > 0 then
        file:write("Return | Type\n")
        file:write("-|-\n")
        for _, _return in pairs(returns) do
            file:write(_return.."\n")
        end
        file:write("\n")
    end
end

--- Write the usage examples for a function
-- @param #file file <*> [the file to be written to]
-- @param #table usage <*> [the returns to usage]
-- @return none
local function writeUsage(file, usage)
    if #usage > 0 then
        file:write("**Usage:**  \n")
        file:write("```lua\n")
        for _, example in pairs(usage) do
            file:write(example.."\n")
        end
        file:write("```\n")
        file:write("\n")
    end
end

--- Write a tripple comment block
-- @param #file file <*> [the file to be written to]
-- @param #table block <*> [the block table to write out]
-- @return none
local function writeBlock(file, docs)
    if docs.func then
        writeHeader(file, docs.func)
        writeDescription(file, docs.desc)
        writeParams(file, docs.params)
        writeReturns(file, docs.returns)
        writeUsage(file, docs.usage)
    end
end

--- Recursively goes through the lines and writes double comments and extracts information from tripple comment blocks.
local function main()
    local lines = getLines()
    local index = 1
    local file = io.open(readmeFilePath, "w+")
    local function parse()
        local line = lines[index]
        if line:sub(1, 3) == "---" then
            -- start func block
            local block
            block, index = getBlock(lines, index)
            writeBlock(file, block)
        elseif line:match("%-%-%s@fields") then
            file:write("Field | Type | Description\n")
            file:write("-|-|-\n")
        elseif line:match("%-%-%s@field") then
            local field = line:match("@field%s(.*)%s#")
            local Type = line:match("#(%a+)")
            local description = line:match("%[(.*)%]") or ""
            file:write(field.." | "..Type.." | "..description.."\n")
        elseif line:sub(1, 2) == "--" then
            if line:match("%-%-%s") then
                file:write(line:match("%-%-%s(.*)").."  \n")
            else
                file:write("  \n")
            end
        end
        if index and index + 1 <= #lines then
            index = index + 1
            parse()
        end
    end
    parse()
    file:close()
end

main()
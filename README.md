# ***markdown-lua***  
  
**Author:** Wizard  
  
**Created:** June 19th, 2021  
  
**Version:** 0.0.1  
  
**Description:**  
Convert lua comments (--) into markdown format, and document functions with (---)  
following the LuaDoc format.  
  
## ***Examples***  
---  
from double lua comment:  
```lua  
-- ## Header  
-- hello world  
```  
into markdown:  
## Header  
hello world  
  
---  
from tripple lua comment for function documentation  
```lua  
--- the start of documentation, also start of the description.  
-- you can add multiple lines to the start of the description,  
-- there is no limit.  
-- @param exam1 #string <*> [example description]  
-- @param exam2 #table [example description]  
-- @return exam3 #table  
-- @usage  
-- local exam = example("exam1", {[1] = "hello"})  
local function example(exam1, exam2) ... end  
```  
into markdown:  
## ***example(exam1, exam2)***  
the start of documentation, also start of the description.  
you can add multiple lines to the start of the description,  
there is no limit.  
Param | Type | Required | Description  
-|-|-|-  
exam1 | string | yes | example description  
exam2 | table | | example description  
  
Return | Type  
-|-  
exam3 | table  
  
Usage:  
```lua  
local exam = example("exam1", {[1] = "hello"})  
```  
---  
## ***Functions***  
  
## ***getLines()***
Get the lines from a file    
Return | Type
-|-
lines | array | 

## ***getDescription(lines, index)***
Get the description from a function    
recursiverly goes through lines until the first @param.    
also returns a second variable that is the current index.    
Parameter | Type | Required | Description
-|-|-|-
lines | array | **✓** | the array of lines
index | number | **✓** | the current line index

Return | Type
-|-
description | array | 
index | number | 

## ***getParams(lines, index)***
Get the parameters from a function  
recursively goes through lines and collects comments underneath params.  
also returns a second variable that is the current index.  
Parameter | Type | Required | Description
-|-|-|-
lines | array | **✓** | the array of lines
index | number | **✓** | the current line index

Return | Type
-|-
params | array | 
index | number | 

## ***getReturns(lines, index)***
Get the returns from a function  
Parameter | Type | Required | Description
-|-|-|-
lines | array | **✓** | the array of lines
index | number | **✓** | the current line index

Return | Type
-|-
returns | array | 
index | number | 

## ***getUsage(lines, index)***
Get the usage examples from a function  
Parameter | Type | Required | Description
-|-|-|-
lines | array | **✓** | the array of lines
index | number | **✓** | the current line index

Return | Type
-|-
usage | array | 
index | number | 

## ***getFunction(lines, index)***
Get the function sytax  
Parameter | Type | Required | Description
-|-|-|-
lines | array | **✓** | the array of lines
index | number | **✓** | the current line index

Return | Type
-|-
syntax | string | 
index | number | 

## ***getBlock(lines, index)***
Get a tripple comment block  
Parameter | Type | Required | Description
-|-|-|-
lines | array | **✓** | the array of lines
index | number | **✓** | the current line index

Return | Type
-|-
block | string | 
index | number | 

## ***writeHeader(file, header)***
Write the header which is a functions syntax.  
Parameter | Type | Required | Description
-|-|-|-
file | file | **✓** | the file to be written to
header | string | **✓** | the header to write

Return | Type
-|-
none |  | 

## ***writeDescription(file, description)***
Write the description for a function  
Parameter | Type | Required | Description
-|-|-|-
file | file | **✓** | the file to be written to
description | table | **✓** | the description to write

Return | Type
-|-
none |  | 

## ***writeParams(file, params)***
Write the parameters for a function  
Parameter | Type | Required | Description
-|-|-|-
file | file | **✓** | the file to be written to
params | table | **✓** | the params to write

Return | Type
-|-
none |  | 

## ***writeReturns(file, returns)***
Write the returns for a function  
Parameter | Type | Required | Description
-|-|-|-
file | file | **✓** | the file to be written to
returns | table | **✓** | the returns to write

Return | Type
-|-
none |  | 

## ***writeUsage(file, usage)***
Write the usage examples for a function  
Parameter | Type | Required | Description
-|-|-|-
file | file | **✓** | the file to be written to
usage | table | **✓** | the returns to usage

Return | Type
-|-
none |  | 

## ***writeBlock(file, docs)***
Write a tripple comment block  
Parameter | Type | Required | Description
-|-|-|-
file | file | **✓** | the file to be written to
block | table | **✓** | the block table to write out

Return | Type
-|-
none |  | 

## ***main()***
Recursively goes through the lines and writes  
double comments and extracts information from tripple comment blocks.  

local _ = require"glua"
local the=_.options[[   
near : report the mode of the kth nearest neighbors
(c) 2022 Tim Menzies <timm@ieee.org> BSD-2 license

Usage: lua near.lua [OPTIONS]

Options:
 -e  --enough  number of rows to use            = 256
 -f  --file    file with csv data               = ../data/diabetes.csv
 -g  --go      start-up example                 = nothing
 -h  --help    show help                        = false
 -k  --k       number of nearest neighbors      = 3
 -p  --p       distance calculation coefficient = 2
 -s  --seed    random number seed               = 10019
 -w  --wait    wait before classifying          = 20

Install: to the same directory from github.com/burn...
   glua/glua.lua
   near/nearfun.lua
   near/near.lua]]

local csv, lt, map,many = _.csv, _.lt, _.map, _.many
local obj, oo, push ,same,sort,slice = _.obj, _.oo, _.push, _.same,_.sort, _.slice
local COLS,DATA,NUM,SYM=obj"COLS",obj"DATA",obj"NUM",obj"SYM"
----------------------------------------------------------------
-- `SYM`s summarize streams of symbols.
function SYM:new(  n,s) --> SYM; for summarizing list of symbols
  self.n= 0                       -- items seen
  self.at=n or 0                 -- column position
  self.name=s or ""              -- column name
  self.mode, self.most = nil, -1 -- keep most common symbol
  self.has= {} end               -- column name

function SYM:add(x) --> nil; add `x` to `self`, updating mode
  if x~="?" then 
    self.n = self.n+1 
    self.has[x] = 1 + (self.has[x] or 0) 
    if self.has[x] > self.most then
      self.mode, self.most = x, self.has[x] end end end

function SYM:dist(x1,x2) --> SYM; return gap `x1` to `x2`
  return  x1=="?" and x2=="?" and 1 or x1==x2 and 0 or 1 end
-----------------------------------------------------------------
-- `NUM`s summarize streams of numbers.
function NUM:new(  n,s) --> NUM;  for summarizing list of numbers
  self.n    = 0                -- items seen     
  self.at   = n or 0           -- column position
  self.name = s or ""          -- column name
  self.lo   =  math.huge       -- lowest seen
  self.hi   = -math.huge  end  -- highest seen

function NUM:add(x,    pos) --> nil; add `x` to `self`
  if x~="?" then 
    self.n  = self.n + 1
    self.lo = math.min(x, self.lo)
    self.hi = math.max(x, self.hi) end end

function NUM:dist(x1,x2) --> n; return gap between `x1` and `x2`
  if   x1=="?" and x2=="?" then return 1 end
  x1,x2 = self:norm(x1), self:norm(x2)
  if x1=="?" then x1 = x2<.5 and 1 or 0 end 
  if x2=="?" then x2 = x1<.5 and 1 or 0 end
  return math.abs(x1-x2) end 

function NUM:norm(n) --> n; normalized numbers 0..1 
  return n=="?" and n or (n-self.lo)/(self.hi-self.lo + 1E-32) end
------------------------------------------------------------
-- `COLS` is a factory that makes `SYM`s or `NUM`s (controlled by row1 of data)
function COLS:new(sNames) --> COLS; creator of column headers
  self.names=sNames -- all column names
  self.all={}      -- all the columns (including the skipped ones)
  self.klass=nil   -- the single dependent klass column (if it exists)
  self.x={}        -- independent columns (that are not skipped)
  self.y={}        -- dependent columns (that are not skipped)
  for c,s in pairs(sNames) do
    local col = push(self.all, (s:find"^[A-Z]" and NUM or SYM)(c,s))
    if not s:find"X$" then -- some columns are skipped
       push(s:find"[!+-]" and self.y or self.x, col) -- some cols are goal cols
       if s:find"!$" then self.klass=col end end end end
--------------------------------------------------------
-- `DATA` stores rows, summarized in `NUM` or `SYM` columns.
function DATA:new(log,  src) --> DATA; store `rows` summarized (in `cols`). `src`=file name or table
  self.cols = nil -- summaries of data
  self.rows = {}  -- kept data
  self.log  = log or same 
  local function add(row) return self:add(row) end
  if type(src) == "string" then csv(src, add) else map(src or {}, add) end end 

function DATA:add(xs) --> nil; for first row, make `cols`. else add to `rows` and summarize
 if   not self.cols 
 then self.cols = COLS(xs) 
 else self:classify(xs)
      local row= push(self.rows, xs) 
      for _,todo in pairs{self.cols.x, self.cols.y} do
        for _,col in pairs(todo) do 
          col:add(row[col.at]) end end end end

function DATA:dist(row1,row2) --> n; return gap between `row1`, and `row2`.
  local d = 0
  for _,col in pairs(self.cols.x) do 
    d = d + col:dist(row1[col.at], row2[col.at])^the.p end
  return (d/#self.cols.x)^(1/the.p) end

function DATA:around(row1,  rows) --> t; sort `rows` (defaults to `self.rows`) by distance to `row1`
  local function fun(row2) 
     return {row=row2, dist=self:dist(row1,row2)} end
  return sort(map(rows or self.rows, fun),lt"dist") end

function DATA:classify(row1) 
  if #self.rows > the.wait then
    local sym    = SYM()
    local k      = self.cols.klass.at
    local around = self:around(row1, many(self.rows, the.enough))
    map(slice(around,1,the.k), function(pair) sym:add(pair.row[k]) end)
    self.log(sym.mode, row1[k]) end end 
---------------------------------------
return {the=the, DATA=DATA, NUM=NUM, SYM=SYM, COLS=COLS} 

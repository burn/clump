#!/usr/bin/env lua
-- Test engine and examples.
-- (c)2022 Tim Menzies <timm@ieee.org> BSD2
local _  = require"glua"
local cli,oo,rand,rint,rnd = _.cli, _.oo, _.rand, _.rint, _.rnd
local run,sort,srand    = _.run, _.sort, _.srand

local _ = require"4near"
local the,NUM,SYM,DATA = _.the, _.NUM, _.SYM, _.DATA

local eg={}

function eg.the()
  oo(the) end

function eg.sym()
  local sym=SYM()
  for _,x in pairs{"a","a","a","a","b","b","c"} do sym:add(x) end
  return "a" == sym.mode and sym.n == 7  end

function eg.num()
  local num=NUM()
  for x=1,100 do num:add(x) end
  return num.lo==1 and num.hi==100 and num.n==100 end

function eg.dists()
  local data =DATA("../data/auto93.csv")
  local t = data:around(data.rows[1])
  oo(data.cols.names)
  for i=1,#t,50 do  oo(t[i].row) end end
 
function eg.data()
  local yes,n=0,0
  local function keep(got,want) n=n+1; yes=yes+ (got==want and 1 or 0) end
  local data =DATA(the.file,keep)
  print(yes/n)
end

--------------------------------------------------------
the = cli(the)
os.exit(run(the,eg)) 

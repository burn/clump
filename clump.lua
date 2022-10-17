-- Test engine and examples.
-- (c)2022 Tim Menzies <timm@ieee.org> BSD2
local _  = require"clumpfun"
local rand,rint,rnd,sort,srand = _.rand, _.rint, _.rnd, _.sort, _.srand
local cli,run,the              = _.cli,  _.run,  _.the

-- Test suite.
local eg={}

function eg.the()
  for k,v in pairs(the) do print(k,v) end end

-- Start-up
the = cli(the)
os.exit(run(the,eg)) -- return code==number of fails. i.e. success if fails==0

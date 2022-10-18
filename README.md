```css

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

Worked examples: https://tinyurl.com/neareg

Install: download to the same directory from github.com/burn,
         glua/glua.lua, near/4near.lua,  near/near.lua
```

#	4near.lua	

`SYM`s summarize streams of symbols.	

| What | Notes |
|:---|:---|
| <b>SYM:new(  n:`num`?, s:`str`?) &rArr;  SYM</b> |  for summarizing list of symbols |
| <b>SYM:add(x) &rArr;  nil</b> |  add `x` to `self`, updating mode |
| <b>SYM:dist(x1, x2) &rArr;  SYM</b> |  return gap `x1` to `x2` |


`NUM`s summarize streams of numbers.	

| What | Notes |
|:---|:---|
| <b>NUM:new(  n:`num`?, s:`str`?) &rArr;  NUM</b> |   for summarizing list of numbers |
| <b>NUM:add(x) &rArr;  nil</b> |  add `x` to `self` |
| <b>NUM:dist(x1, x2) &rArr;  n</b> |  return gap between `x1` and `x2` |
| <b>NUM:norm(n:`num`) &rArr;  n</b> |  normalized numbers 0..1  |


`COLS` is a factory that makes `SYM`s or `NUM`s (controlled by row1 of data)	

| What | Notes |
|:---|:---|
| <b>COLS:new(sNames:`(str)+`) &rArr;  COLS</b> |  creator of column headers |


`DATA` stores rows, summarized in `NUM` or `SYM` columns.	

| What | Notes |
|:---|:---|
| <b>DATA:new(log,   src:`str`?) &rArr;  DATA</b> |  store `rows` summarized (in `cols`). `src`=file name or table |
| <b>DATA:add(xs:`tab`) &rArr;  nil</b> |  for first row, make `cols`. else add to `rows` and summarize |
| <b>DATA:dist(row1, row2) &rArr;  n</b> |  return gap between `row1`, and `row2`. |
| <b>DATA:around(row1,   rows:`tab`?) &rArr;  t</b> |  sort `rows` (defaults to `self.rows`) by distance to `row1` |



#	4near.lua	

`SYM`s summarize streams of symbols.	

| What | Notes |
|:---|:---|
| <b>SYM:new(  n:`num`?, s:`str`?) &rArr;  SYM</b> |  for summarizing list of symbols |
| <b>SYM:add(x) &rArr;  nil</b> |  add `x` to `self`, updating mode |
| <b>SYM:dist(x1, x2) &rArr;  SYM</b> |  return gap `x1` to `x2` |


`NUM`s summarize streams of numbers.	

| What | Notes |
|:---|:---|
| <b>NUM:new(  n:`num`?, s:`str`?) &rArr;  NUM</b> |   for summarizing list of numbers |
| <b>NUM:add(x) &rArr;  nil</b> |  add `x` to `self` |
| <b>NUM:dist(x1, x2) &rArr;  n</b> |  return gap between `x1` and `x2` |
| <b>NUM:norm(n:`num`) &rArr;  n</b> |  normalized numbers 0..1  |


`COLS` is a factory that makes `SYM`s or `NUM`s (controlled by row1 of data)	

| What | Notes |
|:---|:---|
| <b>COLS:new(sNames:`(str)+`) &rArr;  COLS</b> |  creator of column headers |


`DATA` stores rows, summarized in `NUM` or `SYM` columns.	

| What | Notes |
|:---|:---|
| <b>DATA:new(log,   src:`str`?) &rArr;  DATA</b> |  store `rows` summarized (in `cols`). `src`=file name or table |
| <b>DATA:add(xs:`tab`) &rArr;  nil</b> |  for first row, make `cols`. else add to `rows` and summarize |
| <b>DATA:dist(row1, row2) &rArr;  n</b> |  return gap between `row1`, and `row2`. |
| <b>DATA:around(row1,   rows:`tab`?) &rArr;  t</b> |  sort `rows` (defaults to `self.rows`) by distance to `row1` |



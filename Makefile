-include ../etc/Makefile

README.md: ../readme/readme.lua nearfun.lua ## update readme
	lua $< nearfun.lua > README.md


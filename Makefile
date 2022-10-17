-include ../etc/Makefile

README.md: ../readme/readme.lua clump.lua ## update readme
	lua $< clump.lua > README.md


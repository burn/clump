-include ../etc/Makefile

README.md: ../readme/readme.lua 4near.lua ## update readme
	(echo "\`\`\`css"; lua near.lua -h; echo "\`\`\`") > $@
	lua  $^ 4near.lua  >> $@	

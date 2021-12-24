setup:
	luarocks install --tree lua_modules busted

busted:
	./lua_modules/bin/busted --helper=set_paths
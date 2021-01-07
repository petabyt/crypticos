casm -a compilec.casm > a
casm -a ../demo/hello.casm > c
casm -r a -i "`cat c`" > b
tcc -w -run b
rm a b c

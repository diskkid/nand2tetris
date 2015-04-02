load FullAdder.hdl,
output-file FullAdder.out,
output-list a b c carry sum;

set a %B0,
set b %B0,
set c %B0,
eval, output;
set a %B0,
set b %B0,
set c %B1,
eval, output;
set a %B0,
set b %B1,
set c %B0,
eval, output;
set a %B0,
set b %B1,
set c %B1,
eval, output;
set a %B1,
set b %B0,
set c %B0,
eval, output;
set a %B1,
set b %B0,
set c %B1,
eval, output;
set a %B1,
set b %B1,
set c %B0,
eval, output;
set a %B1,
set b %B1,
set c %B1,
eval, output;

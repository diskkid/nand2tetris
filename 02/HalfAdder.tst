load HalfAdder.hdl,
output-file HalfAdder.out,
output-list a b carry sum;

set a %B0,
set b %B0,
eval, output;
set a %B0,
set b %B1,
eval, output;
set a %B1,
set b %B0,
eval, output;
set a %B1,
set b %B1,
eval, output;

load And16.hdl,
output-file And16.out,
output-list a b out;
set a %B0000000000000000,
set b %B0000000000000000, eval, output;
set a %B0101000000000000,
set b %B0011000000000000, eval, output;
set a %B1111111111111111,
set b %B1111111111111111, eval, output;

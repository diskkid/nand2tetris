load Mux16.hdl,
output-file Mux16.out,
output-list a b sel out;
set a %B1000000000000000,
set b %B0000000000000000,
set sel 0,
eval, output;
set a %B0101000000000000,
set b %B0011000000000000,
set sel 1,
eval, output;

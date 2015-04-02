load Mux4Way16.hdl,
output-file Mux4Way16.out,
output-list a b c d sel out;
set a %B1000000000000000,
set b %B0100000000000000,
set c %B0010000000000000,
set d %B0001000000000000,
set sel %B00,
eval, output;
set a %B1000000000000000,
set b %B0100000000000000,
set c %B0010000000000000,
set d %B0001000000000000,
set sel %B01,
eval, output;
set a %B1000000000000000,
set b %B0100000000000000,
set c %B0010000000000000,
set d %B0001000000000000,
set sel %B10,
eval, output;
set a %B1000000000000000,
set b %B0100000000000000,
set c %B0010000000000000,
set d %B0001000000000000,
set sel %B11,
eval, output;

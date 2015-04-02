load DMux4Way.hdl,
output-file DMux4Way.out,
output-list in sel a b c d;
set in 1, set sel %B00, eval, output;
set in 1, set sel %B01, eval, output;
set in 1, set sel %B10, eval, output;
set in 1, set sel %B11, eval, output;

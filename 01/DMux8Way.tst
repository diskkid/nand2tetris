load DMux8Way.hdl,
output-file DMux8Way.out,
output-list in sel a b c d e f g h;
set in 1, set sel %B000, eval, output;
set in 1, set sel %B001, eval, output;
set in 1, set sel %B010, eval, output;
set in 1, set sel %B011, eval, output;
set in 1, set sel %B100, eval, output;
set in 1, set sel %B101, eval, output;
set in 1, set sel %B110, eval, output;
set in 1, set sel %B111, eval, output;

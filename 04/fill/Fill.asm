// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// Put your code here.
(KBD_LOOP)
  @R0
  M=0
  @KBD
  D=M
  @BLACK_LOOP
  D;JGT
  @WHITE_LOOP
  D;JEQ
  @KBD_LOOP
  0;JMP

(WHITE_LOOP)
  @SCREEN
  D=A
  @R0
  D=D+M
  A=D
  M=0
  @R0
  M=M+1
  D=M
  @8192
  D=D-A
  @WHITE_LOOP
  D;JLE
(WHITE_KBD)
  @R0
  M=0
  @KBD
  D=M
  @BLACK_LOOP
  D;JGT
  @WHITE_KBD
  0;JMP

(BLACK_LOOP)
  @SCREEN
  D=A
  @R0
  D=D+M
  A=D
  M=-1
  @R0
  M=M+1
  D=M
  @8192
  D=D-A
  @BLACK_LOOP
  D;JLE
(BLACK_KBD)
  @R0
  M=0
  @KBD
  D=M
  @WHITE_LOOP
  D;JEQ
  @BLACK_KBD
  0;JMP

@ARG // segment
D=M
@1 // index
A=D+A
D=M // segment[index]
@SP
A=M
M=D
// Increment SP
@SP
M=M+1

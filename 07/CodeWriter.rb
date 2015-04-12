require './Parser.rb'

class CodeWriter
  def initialize
    @comp_id = 0
  end

  def setFileName(file_name)
    @file_name = File.basename(file_name)
  end

  def writeArithmetic(command)
    case command
    when 'add'
      asm = <<-'EOS'
@SP
AM=M-1
D=M
@R13
M=D
@SP
AM=M-1
D=M
@R13
D=D+M
@SP
A=M
M=D
@SP
M=M+1
      EOS
    when 'sub'
      asm = <<-'EOS'
@SP
AM=M-1
D=M
@R13
M=D
@SP
AM=M-1
D=M
@R13
D=D-M
@SP
A=M
M=D
@SP
M=M+1
      EOS
    when 'neg'
      asm = <<-'EOS'
@SP
AM=M-1
M=-M
@SP
M=M+1
      EOS
    when 'eq'
      asm = <<-"EOS"
@SP
AM=M-1
D=M
@R13
M=D
@SP
AM=M-1
D=M
@R13
D=D-M
@#{@file_name}.comp.#{@comp_id}
D;JEQ
@0
D=A
@#{@file_name}.comp.#{@comp_id + 1}
0;JMP
(#{@file_name}.comp.#{@comp_id})
D=-1
(#{@file_name}.comp.#{@comp_id + 1})
@SP
A=M
M=D
@SP
M=M+1
      EOS
      @comp_id = @comp_id + 2
    when 'gt'
      asm = <<-"EOS"
@SP
AM=M-1
D=M
@R13
M=D
@SP
AM=M-1
D=M
@R13
D=D-M
@#{@file_name}.comp.#{@comp_id}
D;JGT
@0
D=A
@#{@file_name}.comp.#{@comp_id + 1}
0;JMP
(#{@file_name}.comp.#{@comp_id})
D=-1
(#{@file_name}.comp.#{@comp_id + 1})
@SP
A=M
M=D
@SP
M=M+1
      EOS
      @comp_id = @comp_id + 2
    when 'lt'
      asm = <<-"EOS"
@SP
AM=M-1
D=M
@R13
M=D
@SP
AM=M-1
D=M
@R13
D=D-M
@#{@file_name}.comp.#{@comp_id}
D;JLT
@0
D=A
@#{@file_name}.comp.#{@comp_id + 1}
0;JMP
(#{@file_name}.comp.#{@comp_id})
D=-1
(#{@file_name}.comp.#{@comp_id + 1})
@SP
A=M
M=D
@SP
M=M+1
      EOS
      @comp_id = @comp_id + 2
    when 'and'
      asm = <<-'EOS'
@SP
AM=M-1
D=M
@R13
M=D
@SP
AM=M-1
D=M
@R13
D=D&M
@SP
A=M
M=D
@SP
M=M+1
      EOS
    when 'or'
      asm = <<-'EOS'
@SP
AM=M-1
D=M
@R13
M=D
@SP
AM=M-1
D=M
@R13
D=D|M
@SP
A=M
M=D
@SP
M=M+1
      EOS
    when 'not'
      asm = <<-'EOS'
@SP
AM=M-1
M=!M
@SP
M=M+1
      EOS
    end
    puts asm
  end

  def writePushPop(command, segment, index)
    case command
    when Command::C_PUSH
      puts push(segment, index)
    when Command::C_POP
      puts pop(segment, index)
    end
  end

  private
  def getSegmentAsm(segment, index)
    case segment
    when 'argument'
      return 'ARG'
    when 'local'
      return 'LCL'
    when 'this'
      return 'THIS'
    when 'that'
      return 'THAT'
    when 'pointer'
      return "#{3 + index}"
    when 'temp'
      return "#{5 + index}"
    end
  end

  def push(segment, index)
    asm = ''
    seg_asm = getSegmentAsm(segment, index)

    case segment
    when 'constant'
      asm += <<-"EOS"
@#{index}
D=A
      EOS
    when 'static'
      asm += <<-"EOS"
@#{@file_name}.#{index}
D=M
      EOS
    when 'pointer', 'temp'
      asm += <<-"EOS"
@#{seg_asm}
D=M
      EOS
    else
      asm += <<-"EOS"
@#{seg_asm}
D=M
@#{index}
A=D+A
D=M
      EOS
    end

    asm += <<-'EOS'
@SP
A=M
M=D
@SP
M=M+1
    EOS
    return asm
  end

  def pop(segment, index)
    asm = ''
    seg_asm = getSegmentAsm(segment, index)

    case segment
    when 'static'
      asm += <<-"EOS"
@#{@file_name}.#{index}
D=A
@R13
M=D
      EOS
    when 'pointer', 'temp'
      asm += <<-"EOS"
@#{seg_asm}
D=A
@R13
M=D
      EOS
    else
      asm += <<-"EOS"
@#{seg_asm}
D=M
@#{index}
D=D+A
@R13
M=D
      EOS
    end

    asm += <<-'EOS'
@SP
AM=M-1
D=M
@R13
A=M
M=D
    EOS
    return asm
  end
end

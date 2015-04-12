require './Parser.rb'

class CodeWriter
  def initialize
    @comp_id = 0   # To generate global unique label for comparison
    @return_id = 0 # To generate global unique label for return
  end

  def setFileName(file_name)
    @file_name = file_name
  end

  def writeInit
    # Initialize SP to 256
    asm = <<-'EOS'
@256
D=A
@SP
M=D
    EOS
    puts asm
    writeCall('Sys.init', 0)
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

  def writeLabel(label)
    asm = <<-"EOS"
(#{label})
    EOS
    puts asm
  end

  def writeGoto(label)
    asm = <<-"EOS"
@#{label}
0;JMP
    EOS
    puts asm
  end

  def writeIf(label)
    asm = <<-"EOS"
@SP
AM=M-1
D=M
@#{label}
D;JNE
    EOS
    puts asm
  end

  def writeCall(function_name, num_args)
    return_address = "#{@file_name}.#{function_name}.return.#{@return_id}"
    asm = <<-"EOS"
@#{return_address}
D=A
@SP
A=M
M=D
@SP
M=M+1
@LCL
D=M
@SP
A=M
M=D
@SP
M=M+1
@ARG
D=M
@SP
A=M
M=D
@SP
M=M+1
@THIS
D=M
@SP
A=M
M=D
@SP
M=M+1
@THAT
D=M
@SP
A=M
M=D
@SP
M=M+1
@SP
D=M
@#{num_args}
D=D-A
@5
D=D-A
@ARG
M=D
@SP
D=M
@LCL
M=D
@#{function_name}
0;JMP
(#{return_address})
    EOS
    @return_id = @return_id + 1
    puts asm
  end

  def writeReturn
    asm = <<-"EOS"
@LCL
D=M
@R13
M=D
@5
A=D-A
D=M
@R14
M=D
@SP
AM=M-1
D=M
@ARG
A=M
M=D
@ARG
D=M+1
@SP
M=D
@R13
A=M-1
D=M
@THAT
M=D
@R13
D=M-1
A=D-1
D=M
@THIS
M=D
@R13
D=M-1
D=D-1
A=D-1
D=M
@ARG
M=D
@R13
D=M-1
D=D-1
D=D-1
A=D-1
D=M
@LCL
M=D
@R14
A=M
0;JMP
    EOS
    puts asm
  end

  def writeFunction(function_name, num_locals)
    asm = "(#{function_name})\n"
    num_locals.times do
      asm += <<-'EOS'
@SP
A=M
M=0
@SP
M=M+1
      EOS
    end
    puts asm
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

    # Set the address of the segment to D Register
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

    # Set the address of the segment to D Register
    case segment
    when 'static'
      asm += <<-"EOS"
@#{@file_name}.#{index}
D=A
      EOS
    when 'pointer', 'temp'
      asm += <<-"EOS"
@#{seg_asm}
D=A
      EOS
    else
      asm += <<-"EOS"
@#{seg_asm}
D=M
@#{index}
D=D+A
      EOS
    end

    asm += <<-'EOS'
@R13
M=D
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

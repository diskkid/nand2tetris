require './Parser.rb'
require './CodeWriter.rb'

class VMTranslator
  def initialize(file_name)
    @p = Parser.new(File.new(file_name))
    @w = CodeWriter.new
    @w.setFileName(file_name)
  end

  def translate
    while(@p.hasMoreCommands)
      type = @p.commandType
      arg1 = @p.arg1
      arg2 = @p.arg2
      if type == Command::C_ARITHMETIC
        @w.writeArithmetic(arg1)
      else
        @w.writePushPop(type, arg1, arg2)
      end

      @p.advance
    end
  end
end

file_name = ARGV[0]
exit unless File.exists?(file_name)

t = VMTranslator.new(file_name)
t.translate

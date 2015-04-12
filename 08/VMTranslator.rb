require './Parser.rb'
require './CodeWriter.rb'

class VMTranslator
  def initialize(files)
    @files = files
  end

  def translate
    w = CodeWriter.new
    w.writeInit()

    @files.each do |file|
      p = Parser.new(File.new(file))
      w.setFileName(File.basename(file))

      function = []
      while(p.hasMoreCommands)
        type = p.commandType
        arg1 = p.arg1
        arg2 = p.arg2
        if function.length == 0
          label = arg1
        else
          label = "#{function[-1]}$#{arg1}"
        end

        case type
        when Command::C_ARITHMETIC
          w.writeArithmetic(arg1)
        when Command::C_PUSH, Command::C_POP
          w.writePushPop(type, arg1, arg2)
        when Command::C_LABEL
          w.writeLabel(label)
        when Command::C_GOTO
          w.writeGoto(label)
        when Command::C_IF
          w.writeIf(label)
        when Command::C_FUNCTION
          w.writeFunction(arg1, arg2)
        when Command::C_RETURN
          w.writeReturn
          function.pop
        when Command::C_CALL
          function << arg1
          w.writeCall(arg1, arg2)
        end

        p.advance
      end
    end
  end
end

path = ARGV[0]
exit unless File.exists?(path)

files = []
if File.directory?(path)
  dir = Dir.new(path)
  dir.each do |entry|
    files << "#{path}/#{entry}" if File.extname(entry) == '.vm'
  end
else
  files << path
end

t = VMTranslator.new(files)
t.translate

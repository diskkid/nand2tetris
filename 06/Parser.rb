class Parser
  def initialize(file)
    @asm = []
    file.each do |line|
      index = line.index('//') || -1
      instruction = line[0...index].strip
      @asm << instruction unless instruction == ""
    end
    @pc = 0
  end

  def hasMoreCommands
    @pc < @asm.length
  end

  def advance
    @pc+=1 if hasMoreCommands
  end

  def commandType
    return 'EOF' if @pc == @asm.length
    if /^@/.match(op)
      return 'A_COMMAND'
    elsif /.+=.+/.match(op) || /.+;.+/.match(op)
      return 'C_COMMAND'
    elsif /^\(.+\)$/.match(op)
      return 'L_COMMAND'
    else
      return 'Unknown'
    end
  end

  def symbol
    case commandType
    when 'A_COMMAND'
      return op[1..-1]
    when 'L_COMMAND'
      return op[1..-2]
    end
  end

  def dest
    if commandType == 'C_COMMAND'
      index = op.index('=')
      return op[0...index] if index
    end
  end

  def comp
    if commandType == 'C_COMMAND'
      startIndex = 0
      endIndex = -1
      startIndex = op.index('=') + 1  if op.index('=')
      endIndex = op.index(';') - 1 if op.index(';')
      return op[startIndex..endIndex]
    end
  end

  def jump
    if commandType == 'C_COMMAND'
      index = op.index(';')
      return op[(index+1)..-1] if index
    end
  end

  private
  def op
    @asm[@pc]
  end
end

path = ARGV[0]
exit unless path && File.exist?(path)
parser = Parser.new(File.new(path))

while(parser.hasMoreCommands)
  print "[#{parser.commandType}] "
  print "[sym: #{parser.symbol}] " if parser.symbol
  print "[comp: #{parser.comp}]" if parser.comp
  print "[jump: #{parser.jump}]" if parser.jump
  puts ''
  parser.advance
end

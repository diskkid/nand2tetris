require './Parser.rb'
require './Code.rb'
require './SymbolTable.rb'

path = ARGV[0]
exit unless path && File.exist?(path)
parser = Parser.new(File.new(path))
sym_table = SymbolTable.new

hack_file = ''

address = 0
while(parser.hasMoreCommands)
  symbol = parser.symbol

  case parser.commandType
  when 'L_COMMAND'
    sym_table.addEntry(symbol, address)
  when 'A_COMMAND', 'C_COMMAND'
    address += 1
  end
  parser.advance
end

parser = Parser.new(File.new(path))
while(parser.hasMoreCommands)
  symbol = parser.symbol
  is_variable = /^\d+$/.match(symbol).nil?

  if !sym_table.contains?(symbol) && is_variable
    sym_table.addEntry(symbol)
  end

  symbol = sym_table.getAddress(symbol) if sym_table.contains?(symbol)
  comp = parser.comp
  dest = parser.dest
  jump = parser.jump

  case parser.commandType
  when 'A_COMMAND'
    hack_file += "%2.16b" % symbol
    hack_file += "\n"
  when 'C_COMMAND'
    hack_file += '111' + Code.comp(comp) + Code.dest(dest) + Code.jump(jump)
    hack_file += "\n"
  end

  parser.advance
end

puts hack_file

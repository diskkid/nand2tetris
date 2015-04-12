require './Parser.rb'

parser = Parser.new(File.new('./ParserTestCode.txt'))

while(parser.hasMoreCommands)
  puts "#{parser.commandType} #{parser.arg1} #{parser.arg2}"
  parser.advance
end

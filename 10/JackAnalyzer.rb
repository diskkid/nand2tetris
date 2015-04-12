require './JackTokenizer.rb'
require './CompilationEngine.rb'

path = ARGV[0]
exit unless File.exists?(path)

files = []
if File.directory?(path)
  dir = Dir.new(path)
  dir.each do |entry|
    files << "#{path}/#{entry}" if File.extname(entry) == '.jack'
  end
else
  files << path
end

files.each do |file|
  ce = CompilationEngine.new(file)
  ce.compileClass
end

class SymbolTable
  def initialize
    @variable_address = 15
    @hash = {
      'SP' => 0,
      'LCL' => 1,
      'ARG' => 2,
      'THIS' => 3,
      'THAT' => 4,
      'SCREEN' => 16384,
      'KBD' => 24576
      }
    16.times do |i|
      @hash["R#{i}"] = i
    end
  end

  def addEntry(symbol, address=nil)
    if address
      @hash[symbol] = address
    else
      @hash[symbol] = @variable_address
      @variable_address += 1
    end
  end

  def contains?(symbol)
    return @hash.keys.include?(symbol)
  end

  def getAddress(symbol)
    return @hash[symbol]
  end

  def dump
    puts @hash
  end
end

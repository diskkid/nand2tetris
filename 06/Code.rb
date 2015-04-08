module Code
  def dest(mnemonic)
    bin = ''
    bin += mnemonic.include?('A') ? '1' : '0'
    bin += mnemonic.include?('D') ? '1' : '0'
    bin += mnemonic.include?('M') ? '1' : '0'
    return bin
  end

  def comp(mnemonic)
    bin = ''
    bin += mnemonic.include?('M') ? '1' : '0'
    case mnemonic
    when '0'
      bin += '101010'
    when '1'
      bin += '111111'
    when '-1'
      bin += '111010'
    when 'D'
      bin += '001100'
    when 'A' || 'M'
      bin += '110000'
    when '!D'
      bin += '001101'
    when '!A' || '!M'
      bin += '110001'
    when '-D'
      bin += '001111'
    when '-A' || '-M'
      bin += '110011'
    when 'D+1'
      bin += '011111'
    when 'A+1' || 'M+1'
      bin += '110111'
    when 'D-1'
      bin += '001110'
    when 'A-1' || 'M-1'
      bin += '110010'
    when 'D+A' || 'D+M'
      bin += '000010'
    when 'D-A' || 'D-M'
      bin += '010011'
    when 'A-D' || 'M-D'
      bin += '000111'
    when 'D&A' || 'D&M'
      bin += '000000'
    when 'D|A' || 'D|M'
      bin += '010101'
    end
  end

  def jump(mnemonic)
    case mnemonic
    when 'JGT'
      return '001'
    when 'JEQ'
      return '010'
    when 'JGE'
      return '011'
    when 'JLT'
      return '100'
    when 'JNE'
      return '101'
    when 'JLE'
      return '110'
    when 'JMP'
      return '111'
    end
  end

  module_function :dest, :comp, :jump
end

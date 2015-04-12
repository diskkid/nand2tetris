module Command
  C_ARITHMETIC = 'C_ARITHMETIC'
  C_PUSH = 'C_PUSH'
  C_POP = 'C_POP'
  C_LABEL = 'C_LABEL'
  C_GOTO = 'C_GOTO'
  C_IF = 'C_IF'
  C_FUNCTION = 'C_FUNCTION'
  C_RETURN = 'C_RETURN'
  C_CALL = 'C_CALL'
end

class Parser
  ARITHMETIC_INSTRUCTION = %w(
    add
    sub
    neg
    eq
    gt
    lt
    and
    or
    not
  )

  def initialize(file)
    @code = []
    file.each do |line|
      index = line.index('//') || -1
      instruction = line[0...index].strip
      @code << instruction unless instruction == ""
    end
    @pc = 0
  end

  def hasMoreCommands
    @pc < @code.length
  end

  def advance
    @pc+=1 if hasMoreCommands
  end

  def commandType
    return if command == 'return'
    return Command::C_ARITHMETIC if ARITHMETIC_INSTRUCTION.include?(command)

    case command
    when 'push'
      return Command::C_PUSH
    when 'pop'
      return Command::C_POP
    when 'label'
      return Command::C_LABEL
    when 'goto'
      return Command::C_GOTO
    when 'if'
      return Command::C_IF
    when 'function'
      return Command::C_FUNCTION
    when 'return'
      return Command::C_RETURN
    when 'call'
      return Command::C_CALL
    end
  end

  def arg1
    if commandType == Command::C_ARITHMETIC
      return command
    end

    return op.split()[1]
  end

  def arg2
    whitelist = %w(push pop function call)
    if whitelist.include?(command)
      return op.split()[2].to_i
    end
  end

  private
  def op
    @code[@pc]
  end

  def command
    op.split()[0]
  end
end

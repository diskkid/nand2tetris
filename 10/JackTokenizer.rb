class JackTokenizer
  KEYWORD = /class|constructor|function|method|field|static|var|int|char|boolean|void|true|false|null|this|let|do|if|else|while|return/
  SYMBOL = /{|}|\(|\)|\[|\]|\.|,|;|\+|-|\*|\/|&|\||<|>|=|~/
  INTEGER_CONSTANT = /\d+/
  STRING_CONSTANT = /"\S+"/
  IDENTIFIER = /([a-zA-Z]|_)(\w|_)*/

  def initialize(file_name)
    source = File.new(file_name).read
    # Omit comments
    source.gsub!(/\/\*.*?\*\//m, '')
    source.gsub!(/\/\/.*$/, '')

    [KEYWORD, SYMBOL].each do |reserved|
      source.gsub!(reserved, ' \0 ')
    end
    @tokens = source.split()
    @pointer = 0
  end

  def hasMoreCommands
    return @pointer < @tokens.length
  end

  def advance
    @pointer += 1
  end

  def tokenType
    case token
    when KEYWORD.match(token).to_a[0]
      return 'KEYWORD'
    when SYMBOL.match(token).to_a[0]
      return 'SYMBOL'
    when IDENTIFIER.match(token).to_a[0]
      return 'IDENTIFIER'
    when INTEGER_CONSTANT.match(token).to_a[0]
      return 'INT_CONST'
    when STRING_CONSTANT.match(token).to_a[0]
      return 'STRING_CONST'
    else
      return 'ERROR'
    end
  end

  def keyWord
    return token.upcase if tokenType == 'KEYWORD'
  end

  def symbol
    return token if tokenType == 'SYMBOL'
  end

  def identifier
    return token if tokenType == 'IDENTIFIER'
  end

  def intVal
    return token if tokenType == 'INT_CONST'
  end

  def stringVal
    return token if tokenType == 'STRING_CONST'
  end

  private
  def token
    @tokens[@pointer]
  end
end

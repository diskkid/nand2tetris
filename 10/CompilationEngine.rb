class CompilationEngine
  def initialize(file)
    @tokenizer = JackTokenizer.new(file)
    @indentation = '';
  end

  def compileClass
    startTag('class')
    xml_keyword        # 'class'
    className
    xml_symbol         # '{'
    compileClassVarDec while ['STATIC', 'FIELD'].include?(@tokenizer.keyWord)
    compileSubroutine while ['CONSTRUCTOR', 'FUNCTION', 'METHOD'].include?(@tokenizer.keyWord)
    xml_symbol         # '}'
    endTag('class')
  end

  def compileClassVarDec
    startTag('classVarDec')
    xml_keyword        # ('static' | 'field')
    type
    varName
    while @tokenizer.symbol != ';'
      xml_symbol       # ','
      varName
    end
    xml_symbol         # ';'
    endTag('classVarDec')
  end

  def compileSubroutine
    startTag('subroutineDec')
    xml_keyword        # ('constructor' | 'function' | 'method')
    if @tokenizer.keyWord
      xml_keyword      # 'void'
    else
      type
    end
    subroutineName
    xml_symbol         # '('
    compileParameterList
    xml_symbol         # ')'
    subroutineBody
    endTag('subroutineDec')
  end

  def compileParameterList
    startTag('parameterList')
    unless @tokenizer.symbol == ')'
      type
      varName
      while @tokenizer.symbol == ','
        xml_symbol
        type
        varName
      end
    end
    endTag('parameterList')
  end

  def compileVarDec
    startTag('varDec')
    xml_keyword    # 'var'
    type
    varName
    while @tokenizer.symbol != ';'
      xml_symbol   # ','
      varName
    end
    xml_symbol     # ';'
    endTag('varDec')
  end

  def compileStatements
    startTag('statements')
    statement while ['DO', 'LET', 'WHILE', 'RETURN', 'IF'].include?(@tokenizer.keyWord)
    endTag('statements')
  end

  def compileDo
    startTag('doStatement')
    xml_keyword # 'do'
    subroutineCall
    xml_symbol # ';'
    endTag('doStatement')
  end

  def compileLet
    startTag('letStatement')
    xml_keyword # 'let'
    varName
    if @tokenizer.symbol == '['
      xml_symbol # '['
      compileExpression
      xml_symbol # ']'
    end
    xml_symbol # '='
    compileExpression
    xml_symbol # ';'
    endTag('letStatement')
  end

  def compileWhile
    startTag('whileStatement')
    xml_keyword # 'while'
    xml_symbol # '('
    compileExpression
    xml_symbol # ')'
    xml_symbol # '{'
    compileStatements
    xml_symbol # '}'
    endTag('whileStatement')
  end

  def compileReturn
    startTag('returnStatement')
    xml_keyword # 'return'
    compileExpression unless @tokenizer.symbol == ';'
    xml_symbol # ';'
    endTag('returnStatement')
  end

  def compileIf
    startTag('ifStatement')
    xml_keyword # 'if'
    xml_symbol # '('
    compileExpression
    xml_symbol # ')'
    xml_symbol # '{'
    compileStatements
    xml_symbol # '}'
    if @tokenizer.keyWord == 'ELSE'
      xml_keyword # 'else'
      xml_symbol # '{'
      compileStatements
      xml_symbol # '}'
    end
    endTag('ifStatement')
  end

  def compileExpression
    startTag('expression')
    compileTerm
    while ['+', '-', '*', '/', '&', '|', '<', '>', '='].include?(@tokenizer.symbol)
      op
      compileTerm
    end
    endTag('expression')
  end

  def compileTerm
    startTag('term')
    case @tokenizer.tokenType
    when 'KEYWORD'
      xml_keyword
    when 'INT_CONST'
      xml_int_const
    when 'STRING_CONST'
      xml_string_const
    when 'IDENTIFIER'
      xml_identifier
      case @tokenizer.symbol
      when '['
        xml_symbol
        compileExpression
        xml_symbol
      when '('
        xml_symbol
        compileExpressionList
        xml_symbol
      when '.'
        xml_symbol
        subroutineName
        xml_symbol
        compileExpressionList
        xml_symbol
      end
    when 'SYMBOL'
      case @tokenizer.symbol
      when '('
        xml_symbol
        compileExpression
        xml_symbol
      when '-', '~'
        compileTerm
      end
    end
    endTag('term')
  end

  def compileExpressionList
    startTag('expressionList')
    if ['KEYWORD', 'INT_CONST', 'STRING_CONST', 'IDENTIFIER'].include?(@tokenizer.tokenType) ||
      ['[', '(', '.'].include?(@tokenizer.symbol)
      compileExpression
      while @tokenizer.symbol == ','
        xml_symbol
        compileExpression
      end
    end
    endTag('expressionList')
  end

  private
  def xml_keyword
    puts "#{@indentation}<keyword> #{@tokenizer.keyWord.downcase} </keyword>"
    @tokenizer.advance
  end

  def xml_symbol
    symbol = @tokenizer.symbol
    symbol = '&lt;' if symbol == '<'
    symbol = '&gt;' if symbol == '>'
    symbol = '&amp;' if symbol == '&'
    puts "#{@indentation}<symbol> #{symbol} </symbol>"
    @tokenizer.advance
  end

  def xml_identifier
    puts "#{@indentation}<identifier> #{@tokenizer.identifier} </identifier>"
    @tokenizer.advance
  end

  def xml_int_const
    puts "#{@indentation}<integerConstant> #{@tokenizer.intVal} </integerConstant>"
    @tokenizer.advance
  end

  def xml_string_const
    puts "#{@indentation}<stringConstant> #{@tokenizer.stringVal} </stringConstant>"
    @tokenizer.advance
  end

  def className
    xml_identifier
  end

  def varName
    xml_identifier
  end

  def type
    if @tokenizer.keyWord
      xml_keyword
    else
      xml_identifier
    end
  end

  def subroutineName
    xml_identifier
  end

  def subroutineBody
    startTag('subroutineBody')
    xml_symbol     # '{'
    compileVarDec while @tokenizer.symbol == 'var'
    compileStatements
    xml_symbol     # '}'
    endTag('subroutineBody')
  end

  def subroutineCall
    xml_identifier
    case @tokenizer.symbol
    when '('
      xml_symbol
      compileExpressionList
      xml_symbol
    when '.'
      xml_symbol
      subroutineName
      xml_symbol
      compileExpressionList
      xml_symbol
    end
  end

  def statement
    case @tokenizer.keyWord
    when 'LET'
      compileLet
    when 'IF'
      compileIf
    when 'WHILE'
      compileWhile
    when 'DO'
      compileDo
    when 'RETURN'
      compileReturn
    end
  end

  def op
    xml_symbol
  end

  def startTag(tag)
    puts "#{@indentation}<#{tag}>"
    @indentation += '  '
  end

  def endTag(tag)
    @indentation.chop!.chop!
    puts "#{@indentation}</#{tag}>"
  end
end

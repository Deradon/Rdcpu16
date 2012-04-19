module DCPU16
  class Assembler
    RE_LINE_EMPTY   = /^\s*$/
    RE_LINE_COMMENT = /^\s*;+.*$/

    #RE_LINE_CLEAN   = /^\s*([^;]*).*$/
    # "asd" | 'asd' | [^"';"]
    RE_LINE_CLEAN   = /^\s*((?:(?:"[^"]*")|(?:'[^']*')|(?:[^;'"]*))*).*$/

    # Parsing the line
    RE_LINE = /\A
      (:\w*)?       # label
      \s*
      (\w*)         # op
      \s*
      (.*?)         # args
      \s*
    \Z/x

    # Parsing the arguments
    # TODO: no comma needed atm, fix this
    RE_ARGS = /([^'",\s]+)|("[^"]+")|('[^']+')/
#    args.scan( RE_ARGS ).flatten.compact


    # Regex against a op: 1: label | 2: OP | 3: A | 4: b
    #RE_OP = /^(:\w*)?\s*(\w*)\s*([^,\s]*),?\s?([^\s]*).*$/
    RE_OP = /^(:\w*)?\s*(\w*)\s*([^,\n]*),?\s?([^\s]*).*$/

    REGISTER = {
      :A => 0x0,
      :B => 0x1,
      :C => 0x2,
      :X => 0x3,
      :Y => 0x4,
      :Z => 0x5,
      :I => 0x6,
      :J => 0x7,
      :POP  => 0x18,
      :PEEK => 0x19,
      :PUSH => 0x1a,
      :SP   => 0x1b,
      :PC   => 0x1c,
      :O    => 0x1d
    }
  end
end


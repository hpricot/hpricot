require 'hpricot/output'

module Hpricot
  module Node
    # Hpricot::Node#display_xml prints the node as XML.
    #
    # The first optional argument, <i>out</i>,
    # specifies output target.
    # It should respond to <tt><<</tt>.
    # If it is not specified, $stdout is used.
    #
    # The second optional argument, <i>encoding</i>,
    # specifies output MIME charset (character encoding).
    # If it is not specified, Hpricot::Encoder.internal_charset is used.
    #
    # Hpricot::Node#display_xml returns <i>out</i>.
    def display_xml(out=$stdout, encoding=Hpricot::Encoder.internal_charset)
      encoder = Hpricot::Encoder.new(encoding)
      self.output(encoder, Hpricot::DefaultContext)
      # don't call finish_with_xmldecl because self already has a xml decl.
      out << encoder.finish
      out
    end
  end
end

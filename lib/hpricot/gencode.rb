require 'hpricot/encoder'
require 'hpricot/output'

# :stopdoc:

module Hpricot
  module Node
    def generate_xml_output_code(outvar='out', contextvar='top_context')
      namespaces = Hpricot::Context::DefaultNamespaces.dup
      namespaces.default = nil
      context = Context.new(namespaces)
      gen = Hpricot::GenCode.new(outvar, contextvar)
      output(gen, context)
      gen.finish
    end
  end

  class GenCode
    def initialize(outvar, contextvar, internal_encoding=Encoder.internal_charset)
      @outvar = outvar
      @contextvar = contextvar
      @state = :none
      @buffer = ''
      @internal_encoding = internal_encoding
      @code = ''
    end
    attr_reader :outvar, :contextvar

    def output_string(str)
      return if str.empty?
      if @state != :string
        flush_buffer
        @state = :string
      end
      @buffer << str
    end

    def output_text(str)
      return if str.empty?
      if /\A[\s\x21-\x7e]+\z/ =~ str && @state == :string
        # Assumption: external charset can represent white spaces and
        # ASCII printable.
        output_string(str)
        return 
      end
      if @state != :text
        flush_buffer
        @state = :text
      end
      @buffer << str
    end

    ChRef = {
      '&' => '&amp;',
      '>' => '&gt;',
      '<' => '&lt;',
      '"' => '&quot;',
    }
    def output_xmlns(namespaces)
      unless namespaces.empty?
        flush_buffer
        namespaces.each {|k, v|
          if k
            ks = k.dump
            aname = "xmlns:#{k}"
          else
            ks = "nil"
            aname = "xmlns"
          end
          @code << "if #{@contextvar}.namespace_uri(#{ks}) != #{v.dump}\n"
          output_string " #{aname}=\""
          output_text v.gsub(/[&<>"]/) {|s| ChRef[s] }
          output_string '"'
          flush_buffer
          @code << "end\n"
        }
      end
    end

    def flush_buffer
      return if @buffer.empty?
      case @state
      when :string
        @code << "#{@outvar}.output_string #{@buffer.dump}\n"
        @buffer = ''
      when :text
        @code << "#{@outvar}.output_text #{@buffer.dump}\n"
        @buffer = ''
      end
    end

    def finish
      flush_buffer
      @code
    end
  end
end

# :startdoc:

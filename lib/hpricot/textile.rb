require 'hpricot/output'

module Hpricot
  TEXTILE_QTAGS = {
    'b' => '**',
    'strong' => '*',
    'city' => '??',
    'del' => '-',
    'i' => '__',
    'em' => '_',
    'span' => '%',
    'ins' => '+',
    'sup' => '^',
    'sub' => '~'
  }

  module Node
    def display_textile(out=$stdout, encoding=Hpricot::Encoder.internal_charset)
      encoder = Hpricot::Encoder.new(encoding)
      self.to_textile(encoder, Hpricot::DefaultContext)
      # don't call finish_with_xmldecl because self already has a xml decl.
      out << encoder.finish
      out
    end
  end
  # :stopdoc:

  class Text

    def to_textile(out, context)
      out.output_text @rcdata.gsub(/[<>]/) {|s| ChRef[s] }
    end

    def to_attvalue_content
      @rcdata.gsub(/[<>"]/) {|s| ChRef[s] }
    end

    def output_attvalue(out, context)
      out.output_string '"'
      out.output_text to_attvalue_content
      out.output_string '"'
    end
  end

  class Name
    def to_textile(out, context)
      # xxx: validate namespace prefix
      if xmlns?
        if @local_name
          out.output_string "xmlns:#{@local_name}"
        else
          out.output_string "xmlns"
        end
      elsif Hpricot::TEXTILE_QTAGS[qualified_name]
        out.output_string Hpricot::TEXTILE_QTAGS[qualified_name]
      else
        out.output_string qualified_name
      end
    end

    def output_attribute(text, out, context)
      to_textile(out, context)
      out.output_string '='
      text.output_attvalue(out, context)
    end
  end

  class Doc
    def to_textile(out, context)
      context = DefaultContext # discard outer context
      xmldecl = false
      doctypedecl = false
      @children.each {|n|
        if n.respond_to? :to_textile_prolog_xmldecl
          n.to_textile_prolog_xmldecl(out, context) unless xmldecl # xxx: encoding?
          xmldecl = true
        elsif n.respond_to? :to_textile_doctypedecl
          n.to_textile_doctypedecl(out, context) unless doctypedecl
          doctypedecl = true
        else
          n.to_textile(out, context)
        end
      }
    end
  end

  class Elem
    def to_textile(out, context)
      if @empty
        @stag.output_emptytag(out, context)
      else
        children_context = @stag.to_textile_stag(out, context)
        @children.each {|n| n.to_textile(out, children_context) }
        @stag.to_textile_etag(out, context)
      end
    end
  end

  class STag
    def output_attributes(out, context)
      @attributes.each {|aname, text|
        next if aname.xmlns?
        out.output_string ' '
        aname.output_attribute(text, out, context)
      }
      @context.to_textile_namespaces(out, context)
    end

    def output_emptytag(out, context)
      out.output_string '<'
      @name.output(out, context)
      children_context = output_attributes(out, context)
      out.output_string "\n/>"
      children_context
    end

    def to_textile_stag(out, context)
      if Hpricot::TEXTILE_QTAGS[@name.qualified_name]
        @name.to_textile(out, context)
      else
        out.output_string '<'
        @name.to_textile(out, context)
        children_context = output_attributes(out, context)
        out.output_string "\n>"
      end
      children_context
    end

    def to_textile_etag(out, context)
      if Hpricot::TEXTILE_QTAGS[@name.qualified_name]
        @name.to_textile(out, context)
      else
        out.output_string '</'
        @name.output(out, context)
        out.output_string "\n>"
      end
    end
  end

  class Context
    alias to_textile_namespaces output_namespaces
  end

  class BogusETag
    alias to_textile output
  end

  class XMLDecl
    alias to_textile output
    alias to_textile_prolog_xmldecl output_prolog_xmldecl
  end

  class DocType
    alias to_textile output
    alias to_textile_doctypedecl output_prolog_doctypedecl
  end

  class ProcIns
    alias to_textile output
  end

  class Comment
    alias to_textile output
  end

  # :startdoc:
end

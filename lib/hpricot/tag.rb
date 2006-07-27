module Hpricot
  # :stopdoc:

  class Doc
    attr_accessor :children
    def initialize(children)
      @children = children ? children.each { |c| c.parent = self }  : []
    end
    def output(out)
      @children.each do |n|
        n.output(out)
      end
      out
    end
  end

  class BaseEle
    attr_accessor :raw_string, :parent
    def html_quote(str)
      "\"" + str.gsub('"', '\\"') + "\""
    end
  end

  class Elem
    attr_accessor :stag, :etag, :children
    def initialize(stag, children=nil, etag=nil)
      @stag, @etag = stag, etag
      @children = children ? children.each { |c| c.parent = self }  : []
    end
    def empty?; @children.empty? end
    [:name, :attributes, :parent].each do |m|
      [m, "#{m}="].each { |m2| define_method(m2) { |*a| @stag.send(m2, *a) } }
    end
    def output(out)
      if empty? and ElementContent[@stag.name] == :EMPTY
        @stag.output(out, :style => :empty)
      else
        @stag.output(out)
        @children.each { |n| n.output(out) }
        @stag.output(out, :style => :end)
      end
      out
    end
  end

  class STag < BaseEle
    def initialize(name, attributes=nil)
      @name = name.downcase
      if attributes
        @attributes = attributes.inject({}) { |hsh,(k,v)| hsh[k.downcase] = v; hsh }
      end
    end
    attr_accessor :name, :attributes
    def attributes_as_html
      if @attributes
        @attributes.map do |aname, aval|
          " #{aname}" +
            (aval ? "=#{html_quote(aval)}" : "")
        end.join
      end
    end
    def output(out, opts = {})
      out <<
        case opts[:style]
        when :end
          "</#{@name}>"
        else
          "<#{@name}#{attributes_as_html}" +
            (opts[:style] == :empty ? " /" : "") +
            ">"
        end
    end
  end

  class ETag < BaseEle
    def initialize(qualified_name)
      @name = qualified_name
    end
    attr_reader :name
  end

  class BogusETag < ETag
    def output(out); end
  end

  class Text < BaseEle
    def initialize(text)
      @content = text
    end
    attr_reader :content
    def output(out)
      out << @content
    end
  end

  class XMLDecl < BaseEle
    def initialize(version, encoding, standalone)
      @version, @encoding, @standalone = version, encoding, standalone
    end
    attr_reader :version, :encoding, :standalone
    def output(out)
      out <<
        "<?xml version=\"#{@version}\"" +
          (@encoding ? " encoding=\"#{encoding}\"" : "") +
          (@standalone != nil ? " standalone=\"#{standalone ? 'yes' : 'no'}\"" : "") +
          "?>"
    end
  end

  class DocType < BaseEle
    def initialize(name, pubid, sysid)
      @name, @public_id, @system_id = name, pubid, sysid
    end
    attr_reader :name, :public_id, :system_id
    def output(out)
      out <<
        "<!DOCTYPE #{@name} " +
          (@public_id ? "PUBLIC \"#{@public_id}\"" : "SYSTEM") +
          (@system_id ? " #{html_quote(@system_id)}" : "") + ">"
    end
  end

  class ProcIns < BaseEle
    def initialize(target, content)
      @target, @content = target, content
    end
    attr_reader :target, :content
    def output(out)
      out << "<?#{@target}" +
        (@content ? " #{@content}" : "") +
        "?>"
    end
  end

  class Comment < BaseEle
    def initialize(content)
      @content = content
    end
    attr_reader :content
    def output(out)
      out << "<!--#{@content}-->"
    end
  end

  # :startdoc:
end

module Hpricot
  # :stopdoc:

  class Doc
    attr_accessor :children
    def initialize(children)
      @children = children ? children.each { |c| c.parent = self }  : []
    end
  end

  class BaseEle
    attr_accessor :raw_string, :parent
  end

  class Elem
    attr_accessor :stag, :etag, :children
    def initialize(stag, children=nil, etag=nil)
      @stag, @etag = stag, etag
      @children = children ? children.each { |c| c.parent = self }  : []
    end
    def empty?; @children.empty? end
    [:name, :attributes, :parent, :parent=].each do |m|
      define_method(m) { |*a| @stag.send(m, *a) }
    end
  end

  class STag < BaseEle
    def initialize(name, attributes=nil)
      @name = name
      @attributes = attributes
    end
    attr_reader :name, :attributes
  end

  class ETag < BaseEle
    def initialize(qualified_name)
      @name = qualified_name
    end
    attr_reader :name
  end

  class BogusETag < ETag; end

  class Text < BaseEle
    def initialize(text)
      @content = text
    end
    attr_reader :content
  end

  class XMLDecl < BaseEle
    def initialize(version, encoding, standalone)
      @version, @encoding, @standalone = version, encoding, standalone
    end
    attr_reader :version, :encoding, :standalone
  end

  class DocType < BaseEle
    def initialize(name, pubid, sysid)
      @name, @public_id, @system_id = name, pubid, sysid
    end
    attr_reader :name, :public_id, :system_id
  end

  class ProcIns < BaseEle
    def initialize(target, content)
      @target, @content = target, content
    end
    attr_reader :target, :content
  end

  class Comment < BaseEle
    def initialize(content)
      @content = content
    end
    attr_reader :content
  end

  # :startdoc:
end

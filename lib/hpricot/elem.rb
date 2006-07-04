require 'hpricot/modules'
require 'hpricot/tag'
require 'hpricot/context'
require 'hpricot/container'

module Hpricot
  class Elem
    # :stopdoc:
    class << self
      alias new! new
    end
    # :startdoc:

    # The first argument _name_ should be an instance of String or Hpricot::Name.
    #
    # The rest of arguments should be a sequence of follows.
    # [Hash object] used as attributes.
    # [String object] specified string is converted to Hpricot::Text.
    # [Hpricot::Node object] used as a child.
    # [Hpricot::Doc object]
    #   used as children.
    #   It is expanded except Hpricot::XMLDecl and Hpricot::DocType objects.
    # [Array of String, Hpricot::Node, Hpricot::Doc] used as children.
    # [Hpricot::Context object]
    #   used as as context which represents XML namespaces.
    #   This should apper once at most.
    #
    # Hpricot::Location object is accepted just as Hpricot::Node.
    #
    # If the rest arguments consists only
    # Hash and Hpricot::Context, empty element is created.
    #
    #   p Hpricot::Elem.new("e").empty_element?     # => true
    #   p Hpricot::Elem.new("e", []).empty_element? # => false
    def Elem.new(name, *args)
      attrs = []
      children = []
      context = nil
      args.each {|arg|
        arg = arg.to_node if Hpricot::Location === arg
        arg.parent = self if Hpricot::Node === arg
        case arg
        when Context
          raise ArgumentError, "multiple context" if context
          context = arg
        when Hash
          arg.each {|k, v| attrs << [k, v] }
        when Array
          arg.each {|a|
            a = a.to_node if Hpricot::Location === a
            a.parent = self if Hpricot::Node === a
            case a
            when Hpricot::Doc
              children.concat(a.children.reject {|c|
                Hpricot::XMLDecl === c || Hpricot::DocType === c
              })
            when Hpricot::Node
              children << a
            when String
              children << Text.new(a)
            else
              raise TypeError, "unexpected argument: #{arg.inspect}"
            end
          }
        when Hpricot::Doc
          children.concat(arg.children.reject {|c|
            Hpricot::XMLDecl === c || Hpricot::DocType === c
          })
        when Hpricot::Node
          children << arg
        when String
          children << Text.new(arg)

        else
          raise TypeError, "unexpected argument: #{arg.inspect}"
        end
      }
      context ||= DefaultContext
      if children.empty? && args.all? {|arg| Hash === arg || Context === arg }
        children = nil
      end
      new!(STag.new(name, attrs, context), children)
    end

    def initialize(stag, children=nil, etag=nil) # :notnew:
      unless stag.class == STag
        raise TypeError, "Hpricot::STag expected: #{stag.inspect}"
      end
      unless !children || children.all? {|c| c.kind_of?(Hpricot::Node) and !c.kind_of?(Hpricot::Doc) }
        unacceptable = children.reject {|c| c.kind_of?(Hpricot::Node) and !c.kind_of?(Hpricot::Doc) }
        unacceptable = unacceptable.map {|uc| uc.inspect }.join(', ')
        raise TypeError, "Unacceptable element child: #{unacceptable}"
      end
      unless !etag || etag.class == ETag
        raise TypeError, "Hpricot::ETag expected: #{etag.inspect}"
      end
      @stag = stag
      @children = (children ? children.dup : []).freeze
      @children.each {|c| c.parent = self} if @children
      @empty = children == nil && etag == nil
      @etag = etag
    end

    def context; @stag.context end

    # +element_name+ returns the name of the element name as a Name object.
    def element_name() @stag.element_name end

    def empty_element?
      @empty
    end

    def each_attribute(&block) # :yields: attr_name, attr_text
      @stag.each_attribute(&block)
    end

    def get_subnode_internal(index) # :nodoc:
      case index
      when String
        name = Name.parse_attribute_name(index, DefaultContext)
        update_attribute_hash[name.universal_name]
      when Name
        update_attribute_hash[index.universal_name]
      when Integer
        if index < 0 || @children.length <= index
          nil
        else
          @children[index]
        end
      else
        raise TypeError, "invalid index: #{index.inspect}"
      end
    end

    # call-seq:
    #   elem.subst_subnode(pairs) -> elem
    #
    # The argument _pairs_ should be a hash or an assocs.
    #
    # The key of pairs should be one of following.
    # [Hpricot::Name or String object] attribute name.
    # [Integer object] child index.
    #
    # The value of pairs should be one of follows.
    # [Hpricot::Node object] specified object is used as is.
    # [String object] specified string is converted to Hpricot::Text
    # [Array of above] specified Hpricot::Node and String is used in that order.
    # [nil] delete corresponding node.
    #
    #   e = Hpricot('<r><a/><b/><c/></r>').root
    #   p e.subst_subnode({0=>Hpricot('<x/>'), 2=>Hpricot('<z/>')})  
    #   p e.subst_subnode([[0, Hpricot('<x/>')], [2,Hpricot('<z/>')]])
    #   # =>
    #   {elem <r> {emptyelem <x>} {emptyelem <b>} {emptyelem <z>}}
    #   {elem <r> {emptyelem <x>} {emptyelem <b>} {emptyelem <z>}}
    #
    def subst_subnode(pairs)
      hash = {}
      pairs.each {|index, value|
        case index
        when Name, Integer
        when String
          index = Name.parse_attribute_name(index, DefaultContext)
        else
          raise TypeError, "invalid index: #{index.inspect}"
        end
        value = value.to_node if Hpricot::Location === value
        case value
        when Node
          value = [value]
        when String
          value = [value]
        when Array
          value = value.dup
        when nil
          value = []
        else
          raise TypeError, "invalid value: #{value.inspect}"
        end
        value.map! {|v|
          v = v.to_node if Hpricot::Location === v
          case v
          when Node
            v
          when String
            Text.new(v)
          else
            raise TypeError, "invalid value: #{v.inspect}"
          end
        }
        if !hash.include?(index)
          hash[index] = []
        end
        hash[index].concat value
      }

      attrs = []
      @stag.attributes.each {|k, v|
        if hash.include? k
          v = hash[k]
          if !v.empty?
            attrs << {k=>Text.concat(*v)}
          end
          hash.delete k
        else
          attrs << {k=>v}
        end
      }
      hash.keys.each {|k|
        if Name === k
          v = hash[k]
          if !v.empty?
            attrs << {k=>Text.concat(*v)}
          end
          hash.delete k
        end
      }

      children_left = []
      children = @children.dup
      children_right = []

      hash.keys.sort.each {|index|
        value = hash[index]
        if index < 0
          children_left << value
        elsif children.length <= index
          children_right << value
        else
          children[index] = value
        end
      }

      children = [children_left, children, children_right].flatten

      if children.empty? && @empty
        Elem.new(
          @stag.element_name,
          @stag.context,
          *attrs)
      else 
        Elem.new(
          @stag.element_name,
          @stag.context,
          children,
          *attrs)
      end
    end
  end 

  module Elem::Trav
    private
    def update_attribute_hash
      if defined?(@attribute_hash)
        @attribute_hash
      else
        h = {}
        each_attribute {|name, text|
          h[name.universal_name] = text
        }
        @attribute_hash = h
      end
    end
  end
end

require 'hpricot/modules'
require 'hpricot/container'

module Hpricot
  class Doc
    # :stopdoc:
    class << self
      alias new! new
    end
    # :startdoc:

    # The arguments should be a sequence of follows.
    # [String object] specified string is converted to Hpricot::Text.
    # [Hpricot::Node object] used as a child.
    # [Hpricot::Doc object]
    #   used as children.
    #   It is expanded except Hpricot::XMLDecl and Hpricot::DocType objects.
    # [Array of String, Hpricot::Node and Hpricot::Doc] used as children.
    #
    def Doc.new(*args)
      children = []
      args.each {|arg|
        arg = arg.to_node if Hpricot::Location === arg
        arg.parent = self if Hpricot::Node === arg
        case arg
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
      new!(children)
    end

    def initialize(children=[]) # :notnew:
      @children = children.dup.freeze
      unless @children.all? {|c| c.kind_of?(Hpricot::Node) and !c.kind_of?(Hpricot::Doc) }
        unacceptable = @children.reject {|c| c.kind_of?(Hpricot::Node) and !c.kind_of?(Hpricot::Doc) }
        unacceptable = unacceptable.map {|uc| uc.inspect }.join(', ')
        raise TypeError, "Unacceptable document child: #{unacceptable}"
      end
      @children.each {|c| c.parent = self}
    end 

    def get_subnode_internal(index) # :nodoc:
      unless Integer === index
        raise TypeError, "invalid index: #{index.inspect}"
      end
      if index < 0 || @children.length <= index
        nil
      else
        @children[index]
      end
    end

    #   doc.subst_subnode(pairs) -> doc
    #
    # The argument _pairs_ should be a hash or an assocs.
    # Its key should be an integer which means an index for children.
    #
    # Its value should be one of follows.
    # [Hpricot::Node object] specified object is used as is.
    # [String object] specified string is converted to Hpricot::Text
    # [Array of above] specified Hpricot::Node and String is used in that order.
    # [nil] delete corresponding node.
    #
    #   d = Hpricot('<a/><b/><c/>')        
    #   p d.subst_subnode({0=>Hpricot('<x/>'), 2=>Hpricot('<z/>')})
    #   p d.subst_subnode([[0,Hpricot('<x/>')], [2,Hpricot('<z/>')]])
    #   # =>
    #   #<Hpricot::Doc {emptyelem <x>} {emptyelem <b>} {emptyelem <z>}>
    #   #<Hpricot::Doc {emptyelem <x>} {emptyelem <b>} {emptyelem <z>}>
    #
    def subst_subnode(pairs)
      hash = {}
      pairs.each {|index, value|
        unless Integer === index
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

      children = [children_left, children, children_right].flatten.compact
      Doc.new(children)
    end
  end 
end

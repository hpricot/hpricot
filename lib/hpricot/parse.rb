require 'hpricot/htmlinfo'

def Hpricot(input, opts = {})
  Hpricot.parse(input, opts)
end

module Hpricot
  # Hpricot.parse parses <i>input</i> and return a document tree.
  # represented by Hpricot::Doc.
  def Hpricot.parse(input, opts = {})
    Doc.new(make(input, opts))
  end

  # :stopdoc:

  def Hpricot.make(input, opts = {})
    opts = {:fixup_tags => false}.merge(opts)
    stack = [[nil, nil, [], [], [], []]]
    Hpricot.scan(input) do |token|
      if stack.last[5] == :CDATA and !(token[0] == :etag and token[1].downcase == stack.last[0])
        token[0] = :text
        token[1] = token[3] if token[3]
      end

      case token[0]
      when :stag
        stagname = token[0] = token[1].downcase
        if ElementContent[stagname] == :EMPTY
          token[0] = :emptytag
          stack.last[2] << token
        else
          if opts[:fixup_tags]
            # obey the tag rules set up by the current element
            if ElementContent.has_key? stagname
              trans = nil
              (stack.length-1).downto(0) do |i|
                untags = stack[i][5]
                break unless untags.include? stagname
                # puts "** ILLEGAL #{stagname} IN #{stack[i][0]}"
                trans = i
              end
              if trans.to_i > 1
                eles = stack.slice!(trans..-1)
                stack.last[2] += eles
                # puts "** TRANSPLANTED #{stagname} TO #{stack.last[0]}"
              end
            end
          end

          # setup tag rules for inside this element
          if ElementContent[stagname] == :CDATA
            uncontainable_tags = :CDATA
          elsif opts[:fixup_tags]
            possible_tags = ElementContent[stagname]
            excluded_tags, included_tags = stack.last[3..4]
            if possible_tags
              excluded_tags = excluded_tags | (ElementExclusions[stagname] || [])
              included_tags = included_tags | (ElementInclusions[stagname] || [])
              containable_tags = (possible_tags | included_tags) - excluded_tags
              uncontainable_tags = ElementContent.keys - containable_tags
            else
              # If the tagname is unknown, it is assumed that any element
              # except excluded can be contained.
              uncontainable_tags = excluded_tags
            end
          end
          stack << [stagname, token, [], excluded_tags, included_tags, uncontainable_tags]
        end
      when :etag
        etagname = token[0] = token[1].downcase
        matched_elem = nil
        (stack.length-1).downto(0) do |i|
          stagname, = stack[i]
          if stagname == etagname
            matched_elem = stack[i]
            stack[i][1] += token
            eles = stack.slice!((i+1)..-1)
            stack.last[2] += eles
            break
          end
        end
        unless matched_elem
          stack.last[2] << [:bogus_etag, token]
        else
          ele = stack.pop
          stack.last[2] << ele
        end
      when :text
        l = stack.last[2].last
        if l and l[0] == :text
          l[1] += token[1]
        else
          stack.last[2] << token
        end
      else
        stack.last[2] << token
      end
    end

    while 1 < stack.length
      ele = stack.pop
      stack.last[2] << ele
    end

    structure_list = stack[0][2]
    structure_list.map {|s| build_node(s) }
  end

  def Hpricot.fix_element(elem, excluded_tags, included_tags)
    tagname, _, attrs, sraw, _, _, _, eraw = elem[1]
    children = elem[2]
    if eraw
      elem[2] = fix_structure_list(children)
      return elem, []
    else
      if ElementContent[tagname] == :EMPTY
        elem[2] = []
        return elem, children
      else
        if ElementContent[tagname] == :CDATA
          possible_tags = []
        else
          possible_tags = ElementContent[tagname]
        end
        if possible_tags
          excluded_tags2 = ElementExclusions[tagname]
          included_tags2 = ElementInclusions[tagname]
          excluded_tags |= excluded_tags2 if excluded_tags2
          included_tags |= included_tags2 if included_tags2
          containable_tags = (possible_tags | included_tags) - excluded_tags
          uncontainable_tags = ElementContent.keys - containable_tags
        else
          # If the tagname is unknown, it is assumed that any element
          # except excluded can be contained.
          uncontainable_tags = excluded_tags
        end
        fixed_children = []
        rest = children
        until rest.empty?
          if String === rest[0][0]
            elem = rest.shift
            elem_tagname = elem[0]
            elem_tagname = elem_tagname.downcase
            if uncontainable_tags.include? elem_tagname
              rest.unshift elem
              break
            else
              fixed_elem, rest2 = fix_element(elem, excluded_tags, included_tags)
              fixed_children << fixed_elem
              rest = rest2 + rest
            end
          else
            fixed_children << rest.shift
          end
        end
        elem[2] = fixed_children
        return elem, rest
      end
    end
  end

  def Hpricot.build_node(structure)
    case structure[0]
    when String
      tagname, _, attrs, sraw, _, _, _, eraw = structure[1]
      children = structure[2]
      etag = eraw && ETag.parse(tagname, eraw)
      stag = STag.parse(tagname, attrs, sraw, true)
      if !children.empty? || etag
        Elem.new(stag,
                  children.map {|c| build_node(c) },
                  etag)
      else
        Elem.new(stag)
      end
    when :text
      Text.parse_pcdata(structure[1])
    when :emptytag
      Elem.new(STag.parse(structure[1], structure[2], structure[3], false))
    when :bogus_etag
      BogusETag.parse(structure[1], structure[2])
    when :xmldecl
      XMLDecl.parse(structure[2], structure[3])
    when :doctype
      DocType.parse(structure[1], structure[2], structure[3])
    when :procins
      ProcIns.parse(structure[1], structure[2], structure[3])
    when :comment
      Comment.parse(structure[1])
    when :cdata_content
      Text.parse_cdata_content(structure[1])
    when :cdata
      Text.parse_cdata_section(structure[1])
    else
      raise Exception, "[bug] unknown structure: #{structure.inspect}"
    end
  end

  def STag.parse(qname, attrs, raw_string, is_stag)
    result = STag.new(qname, attrs)
    result.raw_string = raw_string
    result
  end

  def ETag.parse(qname, raw_string)
    result = self.new(qname)
    result.raw_string = raw_string
    result
  end

  def BogusETag.parse(qname, raw_string)
    result = self.new(qname)
    result.raw_string = raw_string
    result
  end

  def Text.parse_pcdata(raw_string)
    result = Text.new(raw_string)
    result.raw_string = raw_string
    result
  end

  def Text.parse_cdata_content(raw_string)
    result = Text.new(raw_string)
    result.raw_string = raw_string
    result.instance_variable_set( "@cdata", true )
    result
  end

  def Text.parse_cdata_section(content)
    result = Text.new(content)
    result.raw_string = "<![CDATA[" + content + "]]>"
    result
  end

  def XMLDecl.parse(attrs, raw_string)
    attrs ||= {}
    version = attrs['version']
    encoding = attrs['encoding']
    case attrs['standalone']
    when 'yes'
      standalone = true
    when 'no'
      standalone = false
    else
      standalone = nil
    end

    result = XMLDecl.new(version, encoding, standalone)
    result.raw_string = raw_string
    result
  end

  def DocType.parse(root_element_name, attrs, raw_string)
    if attrs
      public_identifier = attrs['public_id']
      system_identifier = attrs['system_id']
    end

    root_element_name = root_element_name.downcase

    result = DocType.new(root_element_name, public_identifier, system_identifier)
    result.raw_string = raw_string
    result
  end

  def ProcIns.parse(target, content, raw_string)
    result = ProcIns.new(target, content)
    result.raw_string = raw_string
    result
  end

  def Comment.parse(content)
    result = Comment.new(content)
    result.raw_string = "<!--" + content + "-->"
    result
  end

  module Pat
    NameChar = /[-A-Za-z0-9._:]/
    Name = /[A-Za-z_:]#{NameChar}*/
    Nmtoken = /#{NameChar}+/
  end

  # :startdoc:
end

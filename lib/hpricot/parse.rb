module Hpricot
  # Hpricot.parse parses <i>input</i> and return a document tree.
  # represented by Hpricot::Doc.
  #
  # <i>input</i> should be a String or
  # an object which respond to read or open method.
  # For example, IO, StringIO, Pathname, URI::HTTP and URI::FTP are acceptable.
  # Note that the URIs need open-uri.
  #
  # Hpricot.parse guesses <i>input</i> is HTML or not and XML or not.
  #
  # If it is guessed as HTML, the default namespace in the result is set to http://www.w3.org/1999/xhtml
  # regardless of <i>input</i> has XML namespace declaration or not nor even it is pre-XML HTML.
  #
  # If it is guessed as HTML and not XML, all element and attribute names are downcaseed. 
  #
  # If opened file or read content has charset method,
  # Hpricot.parse decode it according to $KCODE before parsing.
  # Otherwise Hpricot.parse assumes the character encoding of the content is
  # compatible to $KCODE.
  # Note that the charset method is provided by URI::HTTP with open-uri.
  def Hpricot.parse(input)
    Hpricot.with_frozen_string_hash {
      parse_as(input, false)
    }
  end

  # Hpricot.parse_xml parses <i>input</i> as XML and
  # return a document tree represented by Hpricot::Doc.
  #
  # It behaves almost same as Hpricot.parse but it assumes <i>input</> is XML
  # even if no XML declaration.
  # The assumption causes following differences.
  # * doesn't downcase element name.
  # * The content of <script> and <style> element is PCDATA, not CDATA.
  def Hpricot.parse_xml(input)
    Hpricot.with_frozen_string_hash {
      parse_as(input, true)
    }
  end

  # :stopdoc:

  def Hpricot.parse_as(input, is_xml)
    input_charset = input.charset if input.respond_to? :charset
    if input_charset && input_charset != Encoder.internal_charset
      input = Iconv.conv(Encoder.internal_charset, input_charset, input)
    end

    stack = [[nil, nil, nil, []]]
    is_xml, is_html = false, true
    Hpricot.scan(input) do |token|
      case token[0]
      when :stag
        stagname = token[1]
        stagname = stagname.downcase if !is_xml && is_html
        stagname = Hpricot.frozen_string(stagname)
        stack << [stagname, token[2], token[3], []]
      when :etag
        etagname = token[1]
        etagname = etagname.downcase if !is_xml && is_html
        etagname = Hpricot.frozen_string(etagname)
        matched_elem = nil
        stack.reverse_each {|elem|
          stagname, _, _ = elem
          if stagname == etagname
            matched_elem = elem
            break
          end
        }
        if matched_elem
          until matched_elem.equal? stack.last
            stagname, attrs, stag_raw_string, children = stack.pop
            stack.last[3] << [:elem, stagname, attrs, children, stag_raw_string]
          end
          stagname, attrs, stag_raw_string, children = stack.pop
          stack.last[3] << [:elem, stagname, attrs, children, stag_raw_string, token[3]]
        else
          stack.last[3] << [:bogus_etag, etagname, token[3]]
        end
      else
        stack.last[3] << token
      end
    end

    context = is_html ? HTMLContext: DefaultContext
    elem = nil
    while 1 < stack.length
      stagname, attrs, stag_raw_string, children = stack.pop
      stack.last[3] << [:elem, stagname, attrs, children, stag_raw_string]
    end

    structure_list = fix_structure_list(stack[0][3], is_xml, is_html)
    nodes = structure_list.map {|s| build_node(s, is_xml, is_html, context) }
    Doc.new(nodes)
  end

  def Hpricot.fix_structure_list(structure_list, is_xml, is_html)
    result = []
    rest = structure_list.dup
    until rest.empty?
      structure = rest.shift
      if structure[0] == :elem
        elem, rest2 = fix_element(structure, [], [], is_xml, is_html)
        result << elem
        rest = rest2 + rest
      else
        result << structure
      end
    end
    result
  end

  def Hpricot.fix_element(elem, excluded_tags, included_tags, is_xml, is_html)
    _, tagname, attrs, children, stag_raw_string, etag_raw_string = elem
    if etag_raw_string
      return [:elem, tagname, attrs, fix_structure_list(children, is_xml, is_html), stag_raw_string, etag_raw_string], []
    else
      tagname = tagname.downcase if !is_xml && is_html
      if ElementContent[tagname] == :EMPTY
        return [:elem, tagname, attrs, [], stag_raw_string], children
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
          if rest[0][0] == :elem
            elem = rest.shift
            elem_tagname = elem[1]
            elem_tagname = elem_tagname.downcase if !is_xml && is_html
            if uncontainable_tags.include? elem_tagname
              rest.unshift elem
              break
            else
              fixed_elem, rest2 = fix_element(elem, excluded_tags, included_tags, is_xml, is_html)
              fixed_children << fixed_elem
              rest = rest2 + rest
            end
          else
            fixed_children << rest.shift
          end
        end
        return [:elem, tagname, attrs, fixed_children, stag_raw_string], rest
      end
    end
  end

  def Hpricot.build_node(structure, is_xml, is_html, inherited_context=DefaultContext)
    case structure[0]
    when :text
      Text.parse_pcdata(structure[1])
    when :elem
      _, stagname, attrs, children, stag_rawstring, etag_rawstring = structure
      etag = etag_rawstring && ETag.parse(stagname, etag_rawstring, is_xml, is_html)
      stag = STag.parse(stagname, attrs, stag_rawstring, true, is_xml, is_html, inherited_context)
      if !children.empty? || etag
        Elem.new!(stag,
                  children.map {|c| build_node(c, is_xml, is_html, stag.context) },
                  etag)
      else
        Elem.new!(stag)
      end
    when :emptytag
      Elem.new!(STag.parse(structure[1], structure[2], structure[3], false, is_xml, is_html, inherited_context))
    when :bogus_etag
      BogusETag.parse(structure[1], structure[2], is_xml, is_html)
    when :xmldecl
      XMLDecl.parse(structure[2], structure[3])
    when :doctype
      DocType.parse(structure[1], structure[2], structure[3], is_xml, is_html)
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

  def STag.parse(qname, attrs, raw_string, is_stag, is_xml, is_html, inherited_context=DefaultContext)
    qname = qname.downcase if !is_xml && is_html

    attrs = (attrs || {}).map {|aname, aval|
      if aname
        aname = (!is_xml && is_html) ? aname.downcase : aname
        [aname, Text.parse_pcdata(aval)]
      else
        if val2name = OmittedAttrName[qname]
          aval_downcase = aval.downcase
          aname = val2name.fetch(aval_downcase, aval_downcase)
        else
          aname = aval
        end
        [aname, Text.new(aval)]
      end
    }

    result = STag.new(qname, attrs, inherited_context)
    result.raw_string = raw_string
    result
  end

  def ETag.parse(qname, raw_string, is_xml, is_html)
    qname = qname.downcase if !is_xml && is_html

    result = self.new(qname)
    result.raw_string = raw_string
    result
  end

  def BogusETag.parse(qname, raw_string, is_xml, is_html)
    qname = qname.downcase if !is_xml && is_html

    result = self.new(qname)
    result.raw_string = raw_string
    result
  end

  def Text.parse_pcdata(raw_string)
    raw_string = raw_string.to_s
    fixed = raw_string.gsub(/&(?:(?:#[0-9]+|#x[0-9a-fA-F]+|([A-Za-z][A-Za-z0-9]*));?)?/o) {|s|
      name = $1
      case s
      when /;\z/
        s
      when /\A&#/
        "#{s};"
      when '&'
        '&amp;'
      else 
        if NamedCharactersPattern =~ name
          "&#{name};"
        else
          "&amp;#{name}"
        end
      end
    }
    fixed = raw_string if fixed == raw_string
    result = Text.new_internal(fixed)
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

  def DocType.parse(root_element_name, attrs, raw_string, is_xml, is_html)
    attrs ||= {}
    public_identifier = attrs['public_id']
    system_identifier = attrs['system_id']

    root_element_name = root_element_name.downcase if !is_xml && is_html

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

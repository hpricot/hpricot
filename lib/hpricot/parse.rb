require 'hpricot/htmlinfo'

def Hpricot(input = nil, opts = {}, &blk)
  Hpricot.make(input, opts, &blk)
end

module Hpricot
  # Exception class used for any errors related to deficiencies in the system when
  # handling the character encodings of a document.
  class EncodingError < StandardError; end

  # Hpricot.parse parses <i>input</i> and return a document tree.
  # represented by Hpricot::Doc.
  def Hpricot.parse(input = nil, opts = {}, &blk)
    make(input, opts, &blk)
  end

  # Hpricot::XML parses <i>input</i>, disregarding all the HTML rules
  # and returning a document tree.
  def Hpricot.XML(input = nil, opts = {}, &blk)
    opts.merge! :xml => true
    make(input, opts, &blk)
  end

  # :stopdoc:

  def Hpricot.make(input = nil, opts = {}, &blk)
    if blk
      Hpricot.build(&blk)
    else
      Hpricot.scan(input, opts)
    end
  end

  def Hpricot.build_node(structure, opts = {})
    case structure[0]
    when String
      tagname, _, attrs, sraw, _, _, _, eraw = structure[1]
      children = structure[2]
      etag = eraw && ETag.parse(tagname, eraw)
      stag = STag.parse(tagname, attrs, sraw, true)
      if !children.empty? || etag
        Elem.new(stag,
                  children.map {|c| build_node(c, opts) },
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
      if opts[:xhtml_strict]
        structure[2]['system_id'] = "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
        structure[2]['public_id'] = "-//W3C//DTD XHTML 1.0 Strict//EN"
      end
      DocType.parse(structure[1], structure[2], structure[3])
    when :procins
      ProcIns.parse(structure[1])
    when :comment
      Comment.parse(structure[1])
    when :cdata_content
      Text.parse_cdata_content(structure[1])
    when :cdata
      Text.parse_cdata_section(structure[1])
    else
      raise "[bug] unknown structure: #{structure.inspect}"
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
    result
  end

  def Text.parse_cdata_content(raw_string)
    result = CData.new(raw_string)
    result
  end

  def Text.parse_cdata_section(content)
    result = CData.new(content)
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

  def ProcIns.parse(raw_string)
    _, target, content = *raw_string.match(/\A<\?(\S+)\s+(.+)/m)
    result = ProcIns.new(target, content)
    result
  end

  def Comment.parse(content)
    result = Comment.new(content)
    result
  end

  module Pat
    NameChar = /[-A-Za-z0-9._:]/
    Name = /[A-Za-z_:]#{NameChar}*/
    Nmtoken = /#{NameChar}+/
  end

  # :startdoc:
end

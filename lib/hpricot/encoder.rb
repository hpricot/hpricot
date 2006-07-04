require 'iconv'

module Hpricot
  class Encoder
    # Hpricot::Encoder.internal_charset returns the MIME charset corresponding to $KCODE.
    #
    # - 'ISO-8859-1' when $KCODE=='NONE'
    # - 'UTF-8' when $KCODE=='UTF8'
    # - 'EUC-JP' when $KCODE=='EUC'
    # - 'Shift_JIS' when $KCODE=='SJIS'
    #
    # This mapping ignores EUC-KR and various single byte charset other than ISO-8859-1 at least.
    # This should be fixed when Ruby is m17nized.
    def Encoder.internal_charset
      KcodeCharset[$KCODE]
    end

    def initialize(output_encoding, internal_encoding=Hpricot::Encoder.internal_charset)
      @buf = ''
      @internal_encoding = internal_encoding
      @output_encoding = output_encoding
      @ic = Iconv.new(output_encoding, @internal_encoding)
      @charpat = FirstCharPattern[internal_encoding]

      @subcharset_list = SubCharset[output_encoding] || []
      @subcharset_ic = {}
      @subcharset_list.each {|subcharset|
        @subcharset_ic[subcharset] = Iconv.new(subcharset, @internal_encoding)
      }
    end

    # :stopdoc:
    def output_string(internal_str, external_str=@ic.iconv(internal_str))
      @buf << external_str
      @subcharset_ic.reject! {|subcharset, ic|
        begin
          ic.iconv(internal_str) != external_str
        rescue Iconv::Failure
          true
        end
      }
      nil
    end

    def output_text(string)
      begin
        output_string string, @ic.iconv(string)
      rescue Iconv::IllegalSequence, Iconv::InvalidCharacter => e
        output_string string[0, string.length - e.failed.length], e.success
        unless @charpat =~ e.failed
          # xxx: shoule be configulable?
          #raise ArgumentError, "cannot extract first character: #{e.failed.dump}"
          string = e.failed[1, e.failed.length-1]
          output_string '?'
          retry
        end
        char = $&
        rest = $'
        begin
          ucode = Iconv.conv("UTF-8", @internal_encoding, char).unpack("U")[0]
          char = "&##{ucode};"
        rescue Iconv::IllegalSequence, Iconv::InvalidCharacter
          # xxx: shoule be configulable?
          char = '?'
        end
        output_string char
        string = rest
        retry
      end
    end

    ChRef = {
      '&' => '&amp;',
      '<' => '&lt;',
      '>' => '&gt;',
      '"' => '&quot;',
    }

    def output_dynamic_text(string)
      if string.respond_to? :rcdata
        output_text(string.rcdata.gsub(/[<>]/) { ChRef[$&] })
      else
        output_text(string.to_s.gsub(/[&<>]/) { ChRef[$&] })
      end
    end

    def output_dynamic_attvalue(string)
      if string.respond_to? :rcdata
        output_text(string.rcdata.gsub(/[<>"]/) { ChRef[$&] })
      else
        output_text(string.to_s.gsub(/[&<>"]/) { ChRef[$&] })
      end
    end

    # :startdoc:

    def finish
      external_str = @ic.close
      @buf << external_str
      @subcharset_ic.reject! {|subcharset, ic|
        begin
          ic.close != external_str
        rescue Iconv::Failure
          true
        end
      }
      @buf
    end

    def finish_with_xmldecl
      content = finish
      xmldecl = Iconv.conv(@output_encoding, 'US-ASCII',
        "<?xml version=\"1.0\" encoding=\"#{minimal_charset}\"?>")
      xmldecl + content
    end

    def minimal_charset
      @subcharset_list.each {|subcharset|
        if @subcharset_ic.include? subcharset
          return subcharset
        end
      }
      @output_encoding
    end

    # :stopdoc:

    KcodeCharset = {
      'EUC' => 'EUC-JP',
      'SJIS' => 'Shift_JIS',
      'UTF8' => 'UTF-8',
      'NONE' => 'ISO-8859-1',
    }

    FirstCharPattern = {
      'EUC-JP' => /\A(?:
         [\x00-\x7f]
        |[\xa1-\xfe][\xa1-\xfe]
        |\x8e[\xa1-\xfe]
        |\x8f[\xa1-\xfe][\xa1-\xfe])/nx,
      'Shift_JIS' => /\A(?:
         [\x00-\x7f]
        |[\x81-\x9f][\x40-\x7e\x80-\xfc]
        |[\xa1-\xdf]
        |[\xe0-\xfc][\x40-\x7e\x80-\xfc])/nx,
      'UTF-8' => /\A(?:
         [\x00-\x7f]
        |[\xc0-\xdf][\x80-\xbf]
        |[\xe0-\xef][\x80-\xbf][\x80-\xbf]
        |[\xf0-\xf7][\x80-\xbf][\x80-\xbf][\x80-\xbf]
        |[\xf8-\xfb][\x80-\xbf][\x80-\xbf][\x80-\xbf][\x80-\xbf]
        |[\xfc-\xfd][\x80-\xbf][\x80-\xbf][\x80-\xbf][\x80-\xbf][\x80-\xbf])/nx,
      'ISO-8859-1' => /\A[\x00-\xff]/n
    }

    SubCharset = {
      'ISO-2022-JP-2' => ['US-ASCII', 'ISO-2022-JP'],
      'ISO-2022-JP-3' => ['US-ASCII', 'ISO-2022-JP'],
      'UTF-16BE' => [],
      'UTF-16LE' => [],
      'UTF-16' => [],
    }
    SubCharset.default = ['US-ASCII']

    # :startdoc:
  end
end

/*
 * hpricot_scan.rl
 *
 * $Author: why $
 * $Date: 2006-05-08 22:03:50 -0600 (Mon, 08 May 2006) $
 *
 * Copyright (C) 2006 why the lucky stiff
 */
#include <ruby.h>

static VALUE sym_xmldecl, sym_doctype, sym_xmlprocins, sym_starttag, sym_endtag, sym_starttag, sym_comment,
      sym_cdata, sym_text;

#define ELE(N) rb_yield(rb_ary_new3(3, sym_##N, tag, attr));

#define SET(N, E) \
  if (mark_##N == NULL) \
    N = rb_str_new2(""); \
  else \
    N = rb_str_new(mark_##N, E - mark_##N);

#define CAT(N, E) if (NIL_P(N)) { SET(N, E); } else { rb_str_cat(N, mark_##N, E - mark_##N); }

#define SLIDE(N) if ( mark_##N > tokstart ) mark_##N = buf + (mark_##N - tokstart);

#define ATTR(K, V) \
    if (!NIL_P(K)) { \
      if (NIL_P(attr)) attr = rb_hash_new(); \
      rb_hash_aset(attr, K, V); \
    }

%%{
  machine hpricot_scan;

  action newEle {
    if (text == 1) {
      CAT(tag, p);
      ELE(text);
      text = 0;
    }
    attr = Qnil;
    tag = Qnil;
    mark_tag = NULL;
  }

  action _tag { mark_tag = p; }
  action _aval { mark_aval = p; }
  action _akey { mark_akey = p; }
  action tag { SET(tag, p); }
  action aval { SET(aval, p); }
  action akey { SET(akey, p); }
  action xmlver { SET(aval, p); ATTR(rb_str_new2("version"), aval); }
  action xmlenc { SET(aval, p); ATTR(rb_str_new2("encoding"), aval); }
  action xmlsd  { SET(aval, p); ATTR(rb_str_new2("standalone"), aval); }

  action new_attr { 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }

  action save_attr { 
    ATTR(akey, aval);
  }

  #
  # HTML tokens
  # (a blatant rip from HTree)
  #
  newline = '\n' @{curline += 1;} ;
  NameChar = [\-A-Za-z0-9._:] ;
  Name = [A-Za-z_:] NameChar* ;
  StartComment = "<!--" ;
  EndComment = "-->" ;
  StartCdata = "<![CDATA[" ;
  EndCdata = "]]>" ;

  NameCap = Name >_tag %tag;
  NameAttr = Name >_akey %akey ;
  Q1Attr = [^']* >_aval %aval ;
  Q1Attr2 = [^'<>]* >_aval %aval ;
  Q2Attr = [^"]* >_aval %aval ;
  Q2Attr2 = [^"<>]* >_aval %aval ;
  NameCharAttr = NameChar* >_aval %aval ;
  Nmtoken = NameChar+ >_akey %akey ;
  InvalidAttr = [^\t <>"']* >_aval %aval ;

  ValidAttr =  NameAttr space* "=" space* ('"' Q2Attr '"' | "'" Q1Attr "'" | NameCharAttr ) ;
  InvalidAttr1 = NameAttr space* "=" space* ("'" Q1Attr "'" | '"' Q2Attr '"' | InvalidAttr ) ;
  InvalidAttr1End = NameAttr space* "=" space* ("'" Q1Attr2 | '"' Q2Attr2 ) ;
  ValidStartTag = "<" NameCap (space+ ValidAttr >new_attr %save_attr | space+ Nmtoken >new_attr %save_attr )* space* ">" ;
  InvalidStartTag = "<" NameCap ( [\t ]+ InvalidAttr1 >new_attr %save_attr )? ( [\t ]* InvalidAttr1 >new_attr %save_attr )* 
    ( [\t ]* InvalidAttr1End >new_attr %save_attr )? space* ">" ;
  StartTag = ValidStartTag | InvalidStartTag ;

  ValidEmptyTag = "<" NameCap (space+ ValidAttr >new_attr %save_attr )* space* "/>" ;
  InvalidEmptyTag = "<" NameCap ( [\t ]+ InvalidAttr1 >new_attr %save_attr )? ( [\t ]* InvalidAttr1 >new_attr %save_attr )* 
    ( [\t ]* InvalidAttr1End >new_attr %save_attr )? space* "/>" ;
  PartialTag = "<" NameCap ;
  EmptyTag = ValidEmptyTag | InvalidEmptyTag ;

  EndTag = "</" NameCap space* ">" ;
  XmlVersionNum = [a-zA-Z0-9_.:\-]+ >_aval %xmlver ;
  XmlVersionInfo = space+ "version" space* "=" space* ("'" XmlVersionNum "'" | '"' XmlVersionNum '"' ) ;
  XmlEncName = [A-Za-z] >_aval [A-Za-z0-9._\-]* %xmlenc ;
  XmlEncodingDecl = space+ "encoding" space* "=" space* ("'" XmlEncName "'" | '"' XmlEncName '"' ) ;
  XmlYesNo = ("yes" | "no") >_aval %xmlsd ;
  XmlSDDecl = space+ "standalone" space* "=" space* ("'" XmlYesNo "'" | '"' XmlYesNo '"') ;
  XmlDecl = "<?xml" XmlVersionInfo XmlEncodingDecl? XmlSDDecl? space* "?>" ;

  SystemLiteral = '"' [^"]* '"' | "'" [^']* "'" ;
  PubidLiteral = '"' [\t a-zA-Z0-9\-'()+,./:=?;!*\#@$_%]* '"' | "'" [\t a-zA-Z0-9\-'()+,./:=?;!*\#@$_%]* "'" ;
  ExternalID = ( "SYSTEM" | "PUBLIC" space+ PubidLiteral ) (space+ SystemLiteral)? ;
  DocType = "<!DOCTYPE" space+ Name (space+ ExternalID)? space* ("[" [^\]]* "]" space*)? ">" ;
  StartXmlProcIns = "<?" Name space+ ;
  EndXmlProcIns = "?>" ;

  html_comment := (any | newline )* :>> EndComment >tag @{ ELE(comment); fgoto main; };

  html_cdata := (any | newline )* :>> EndCdata >tag @{ ELE(cdata); fgoto main; };

  main := |*
    XmlDecl >newEle { ELE(xmldecl); };
    DocType >newEle { ELE(doctype); };
    StartXmlProcIns >newEle { mark_tag = p; };
    EndXmlProcIns { ELE(xmlprocins); };
    StartTag >newEle { ELE(starttag); };
    EndTag >newEle { ELE(endtag); };
    EmptyTag >newEle { ELE(starttag); };
    StartComment >newEle { mark_tag = p; fgoto html_comment; };
    StartCdata >newEle { mark_tag = p; fgoto html_cdata; };

    newline;

    any {
      if (text == 0)
      {
        mark_tag = p;
        attr = Qnil;
        tag = Qnil;
        text = 1;
      }
    };
  *|;
}%%

%% write data nofinal;

#define BUFSIZE 1024

VALUE hpricot_scan(VALUE self, VALUE port)
{
  static char buf[BUFSIZE];
  int cs, act, have = 0, curline = 1, text = 0;
  char *tokstart = 0, *tokend = 0;

  VALUE attr = Qnil, tag = Qnil, akey = Qnil, aval = Qnil;
  char *mark_tag = 0, *mark_akey = 0, *mark_aval = 0;
  int done = 0;
  
  %% write init;
  
  while ( !done ) {
    VALUE str;
    char *p = buf + have, *pe;
    int len, space = BUFSIZE - have;

    if ( space == 0 ) {
      /* We've used up the entire buffer storing an already-parsed token
       * prefix that must be preserved. */
      fprintf(stderr, "OUT OF BUFFER SPACE\n" );
      exit(1);
    }

    str = rb_funcall( port, rb_intern("read"), 1, INT2FIX(space) );
    StringValue(str);
    memcpy( p, RSTRING(str)->ptr, RSTRING(str)->len );
    len = RSTRING(str)->len;

    /* If this is the last buffer, tack on an EOF. */
    if ( len < space ) {
      p[len++] = 0;
      done = 1;
    }

    pe = p + len;
    %% write exec;
    
    if ( cs == hpricot_scan_error ) {
      fprintf(stderr, "PARSE ERROR\n" );
      break;
    }
    
    if ( tokstart == 0 )
    {
      have = 0;
      /* text nodes have no tokstart because each byte is parsed alone */
      if ( mark_tag != NULL && text == 1 )
      {
        CAT(tag, p);
      }
      mark_tag = buf;
    }
    else
    {
      have = pe - tokstart;
      memmove( buf, tokstart, have );
      SLIDE(tag);
      SLIDE(akey);
      SLIDE(aval);
      tokend = buf + (tokend - tokstart);
      tokstart = buf;
    }
  }
}

void Init_hpricot_scan()
{
  VALUE mHpricot = rb_define_module("Hpricot");
  rb_define_singleton_method(mHpricot, "scan", hpricot_scan, 1);

  sym_xmldecl = ID2SYM(rb_intern("xmldecl"));
  sym_doctype = ID2SYM(rb_intern("doctype"));
  sym_xmlprocins = ID2SYM(rb_intern("xmlprocins"));
  sym_starttag = ID2SYM(rb_intern("starttag"));
  sym_endtag = ID2SYM(rb_intern("endtag"));
  sym_starttag = ID2SYM(rb_intern("starttag"));
  sym_comment = ID2SYM(rb_intern("comment"));
  sym_cdata = ID2SYM(rb_intern("cdata"));
  sym_text = ID2SYM(rb_intern("text"));
}

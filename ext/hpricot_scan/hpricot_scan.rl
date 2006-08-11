/*
 * hpricot_scan.rl
 *
 * $Author: why $
 * $Date: 2006-05-08 22:03:50 -0600 (Mon, 08 May 2006) $
 *
 * Copyright (C) 2006 why the lucky stiff
 */
#include <ruby.h>

static VALUE sym_xmldecl, sym_doctype, sym_procins, sym_stag, sym_etag, sym_emptytag, sym_comment,
      sym_cdata, sym_text;
static ID s_read, s_to_str;

#define ELE(N) \
  if (tokend > tokstart) { \
    ele_open = 0; \
    rb_yield_tokens(sym_##N, tag, attr, tokstart == 0 ? Qnil : rb_str_new(tokstart, tokend-tokstart), taint); \
  }

#define SET(N, E) \
  if (mark_##N == NULL || E == mark_##N) \
    N = rb_str_new2(""); \
  else if (E > mark_##N) \
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
    ele_open = 1;
  }

  action _tag { mark_tag = p; }
  action _aval { mark_aval = p; }
  action _akey { mark_akey = p; }
  action tag { SET(tag, p); }
  action tagc { SET(tag, p-1); }
  action aval { SET(aval, p); }
  action akey { SET(akey, p); }
  action xmlver { SET(aval, p); ATTR(rb_str_new2("version"), aval); }
  action xmlenc { SET(aval, p); ATTR(rb_str_new2("encoding"), aval); }
  action xmlsd  { SET(aval, p); ATTR(rb_str_new2("standalone"), aval); }
  action pubid  { SET(aval, p); ATTR(rb_str_new2("public_id"), aval); }
  action sysid  { SET(aval, p); ATTR(rb_str_new2("system_id"), aval); }

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
# qtext = '"' ( '\"' | [^\n"] )* '"' | "'" ( "\\'" | [^\n'] )* "'" ; 
  NameChar = [\-A-Za-z0-9._:] ;
  Name = [A-Za-z_:] NameChar* ;
  StartComment = "<!--" ;
  EndComment = "-->" ;
  StartCdata = "<![CDATA[" ;
  EndCdata = "]]>" ;

  NameCap = Name >_tag %tag;
  NameAttr = Name >_akey %akey ;
  Q1Attr = [^']* >_aval %aval ;
  Q2Attr = [^"]* >_aval %aval ;
  UnqAttr = [^ \t\n<>"'] >_aval [^ \t\n<>]* %aval ;
  Nmtoken = NameChar+ >_akey %akey ;

  Attr =  NameAttr space* "=" space* ('"' Q2Attr '"' | "'" Q1Attr "'" | UnqAttr space+ ) space* ;
  AttrEnd = ( NameAttr space* "=" space* UnqAttr | Nmtoken >new_attr %save_attr ) ;
  AttrSet = ( Attr >new_attr %save_attr | Nmtoken >new_attr space+ %save_attr ) ;
  StartTag = "<" NameCap space+ AttrSet* (AttrEnd >new_attr %save_attr)? ">" | "<" NameCap ">";
  EmptyTag = "<" NameCap space+ AttrSet* (AttrEnd >new_attr %save_attr)? "/>" | "<" NameCap "/>" ;

  EndTag = "</" NameCap space* ">" ;
  XmlVersionNum = [a-zA-Z0-9_.:\-]+ >_aval %xmlver ;
  XmlVersionInfo = space+ "version" space* "=" space* ("'" XmlVersionNum "'" | '"' XmlVersionNum '"' ) ;
  XmlEncName = [A-Za-z] >_aval [A-Za-z0-9._\-]* %xmlenc ;
  XmlEncodingDecl = space+ "encoding" space* "=" space* ("'" XmlEncName "'" | '"' XmlEncName '"' ) ;
  XmlYesNo = ("yes" | "no") >_aval %xmlsd ;
  XmlSDDecl = space+ "standalone" space* "=" space* ("'" XmlYesNo "'" | '"' XmlYesNo '"') ;
  XmlDecl = "<?xml" XmlVersionInfo XmlEncodingDecl? XmlSDDecl? space* "?>" ;

  SystemLiteral = '"' [^"]* >_aval %sysid '"' | "'" [^']* >_aval %sysid "'" ;
  PubidLiteral = '"' [\t a-zA-Z0-9\-'()+,./:=?;!*\#@$_%]*  >_aval %pubid '"' |
    "'" [\t a-zA-Z0-9\-'()+,./:=?;!*\#@$_%]* >_aval %pubid "'" ;
  ExternalID = ( "SYSTEM" | "PUBLIC" space+ PubidLiteral ) (space+ SystemLiteral)? ;
  DocType = "<!DOCTYPE" space+ NameCap (space+ ExternalID)? space* ("[" [^\]]* "]" space*)? ">" ;
  StartXmlProcIns = "<?" Name space+ ;
  EndXmlProcIns = "?>" ;

  html_comment := (any | newline )* >_tag :>> EndComment >tagc @{ ELE(comment); fgoto main; };

  html_cdata := (any | newline )* >_tag :>> EndCdata >tagc @{ ELE(cdata); fgoto main; };

  html_procins := (any | newline )* >_tag :>> EndXmlProcIns >tagc @{ ELE(procins); fgoto main; };

  main := |*
    XmlDecl >newEle { ELE(xmldecl); };
    DocType >newEle { ELE(doctype); };
    StartXmlProcIns >newEle { fgoto html_procins; };
    StartTag >newEle { ELE(stag); };
    EndTag >newEle { ELE(etag); };
    EmptyTag >newEle { ELE(emptytag); };
    StartComment >newEle { fgoto html_comment; };
    StartCdata >newEle { fgoto html_cdata; };

    any | newline {
      if (text == 0)
      {
        if (ele_open == 1) {
          ele_open = 0;
          if (tokstart > 0) {
            mark_tag = tokstart;
          }
        } else {
          mark_tag = p;
        }
        attr = Qnil;
        tag = Qnil;
        text = 1;
      }
    };
  *|;
}%%

%% write data nofinal;

#define BUFSIZE 16384

void rb_yield_tokens(VALUE sym, VALUE tag, VALUE attr, VALUE raw, int taint)
{
  VALUE ary;
  if (sym == sym_text) {
    raw = tag;
  }
  ary = rb_ary_new3(4, sym, tag, attr, raw);
  if (taint) { 
    OBJ_TAINT(ary);
    OBJ_TAINT(tag);
    OBJ_TAINT(attr);
    OBJ_TAINT(raw);
  }
  rb_yield(ary);
}

VALUE hpricot_scan(VALUE self, VALUE port)
{
  static char buf[BUFSIZE];
  int cs, act, have = 0, nread = 0, curline = 1, text = 0;
  char *tokstart = 0, *tokend = 0;

  VALUE attr = Qnil, tag = Qnil, akey = Qnil, aval = Qnil;
  char *mark_tag = 0, *mark_akey = 0, *mark_aval = 0;
  int done = 0, ele_open = 0;

  int taint = OBJ_TAINTED( port );
  if ( !rb_respond_to( port, s_read ) )
  {
    if ( rb_respond_to( port, s_to_str ) )
    {
      port = rb_funcall( port, s_to_str, 0 );
      StringValue(port);
    }
    else
    {
      rb_raise( rb_eArgError, "bad argument, String or IO only please." );
    }
  }

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

    if ( rb_respond_to( port, s_read ) )
    {
      str = rb_funcall( port, s_read, 1, INT2FIX(space) );
    }
    else
    {
      str = rb_str_substr( port, nread, space );
    }

    StringValue(str);
    memcpy( p, RSTRING(str)->ptr, RSTRING(str)->len );
    len = RSTRING(str)->len;
    nread += len;

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
    
    if ( done && ele_open )
    {
      ele_open = 0;
      if (tokstart > 0) {
        mark_tag = tokstart;
        tokstart = 0;
        text = 1;
      }
    }

    if ( tokstart == 0 )
    {
      have = 0;
      /* text nodes have no tokstart because each byte is parsed alone */
      if ( mark_tag != NULL && text == 1 )
      {
        if (done)
        {
          if (mark_tag < p-1)
          {
            CAT(tag, p-1);
            ELE(text);
          }
        }
        else
        {
          CAT(tag, p);
        }
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

  s_read = rb_intern("read");
  s_to_str = rb_intern("to_str");
  sym_xmldecl = ID2SYM(rb_intern("xmldecl"));
  sym_doctype = ID2SYM(rb_intern("doctype"));
  sym_procins = ID2SYM(rb_intern("procins"));
  sym_stag = ID2SYM(rb_intern("stag"));
  sym_etag = ID2SYM(rb_intern("etag"));
  sym_emptytag = ID2SYM(rb_intern("emptytag"));
  sym_comment = ID2SYM(rb_intern("comment"));
  sym_cdata = ID2SYM(rb_intern("cdata"));
  sym_text = ID2SYM(rb_intern("text"));
}

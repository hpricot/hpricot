/*
 * hpricot_scan.rl
 *
 * $Author: why $
 * $Date: 2006-05-08 22:03:50 -0600 (Mon, 08 May 2006) $
 *
 * Copyright (C) 2006 why the lucky stiff
 */
#include <ruby.h>

#ifndef RARRAY_LEN
#define RARRAY_LEN(arr)  RARRAY(arr)->len
#define RSTRING_LEN(str) RSTRING(str)->len
#define RSTRING_PTR(str) RSTRING(str)->ptr
#endif

VALUE hpricot_css(VALUE, VALUE, VALUE, VALUE, VALUE);

#define NO_WAY_SERIOUSLY "*** This should not happen, please send a bug report with the HTML you're parsing to why@whytheluckystiff.net.  So sorry!"

static VALUE sym_xmldecl, sym_doctype, sym_procins, sym_stag, sym_etag, sym_emptytag, sym_comment,
      sym_cdata, sym_text, sym_EMPTY, sym_CDATA;
static VALUE mHpricot, rb_eHpricotParseError;
static VALUE cBaseEle, cBogusETag, cCData, cComment, cDoc, cDocType, cElem, cETag, cText,
      cXMLDecl, cProcIns, symAllow, symDeny;
static ID s_ElementContent;
static ID s_downcase, s_new, s_parent, s_read, s_to_str;
static ID iv_parent;
static VALUE reProcInsParse;

typedef struct {
  int name;
  VALUE tag, attr, etag, raw, EC;
  VALUE parent, children;
} hpricot_ele;

#define OPT(opts, key) (!NIL_P(opts) && RTEST(rb_hash_aref(opts, ID2SYM(rb_intern("" # key)))))

#define ELE(N) \
  if (te > ts || text == 1) { \
    char *raw = NULL; \
    int rawlen = 0; \
    ele_open = 0; text = 0; \
    if (ts != 0 && sym_##N != sym_cdata && sym_##N != sym_text && sym_##N != sym_procins && sym_##N != sym_comment) { \
      raw = ts; rawlen = te - ts; \
    } \
    if (rb_block_given_p()) { \
      VALUE raw_string = Qnil; \
      if (raw != NULL) raw_string = rb_str_new(raw, rawlen); \
      rb_yield_tokens(sym_##N, tag, attr, Qnil, taint); \
    } else \
      rb_hpricot_token(S, sym_##N, tag, attr, raw, rawlen, taint); \
  }

#define SET(N, E) \
  if (mark_##N == NULL || E == mark_##N) \
    N = rb_str_new2(""); \
  else if (E > mark_##N) \
    N = rb_str_new(mark_##N, E - mark_##N);

#define CAT(N, E) if (NIL_P(N)) { SET(N, E); } else { rb_str_cat(N, mark_##N, E - mark_##N); }

#define SLIDE(N) if ( mark_##N > ts ) mark_##N = buf + (mark_##N - ts);

#define ATTR(K, V) \
    if (!NIL_P(K)) { \
      if (NIL_P(attr)) attr = rb_hash_new(); \
      rb_hash_aset(attr, K, V); \
    }

#define TEXT_PASS() \
    if (text == 0) \
    { \
      if (ele_open == 1) { \
        ele_open = 0; \
        if (ts > 0) { \
          mark_tag = ts; \
        } \
      } else { \
        mark_tag = p; \
      } \
      attr = Qnil; \
      tag = Qnil; \
      text = 1; \
    }

#define EBLK(N, T) CAT(tag, p - T + 1); ELE(N);

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
  action aunq { 
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
  action akey { SET(akey, p); }
  action xmlver { SET(aval, p); ATTR(ID2SYM(rb_intern("version")), aval); }
  action xmlenc { SET(aval, p); ATTR(ID2SYM(rb_intern("encoding")), aval); }
  action xmlsd  { SET(aval, p); ATTR(ID2SYM(rb_intern("standalone")), aval); }
  action pubid  { SET(aval, p); ATTR(ID2SYM(rb_intern("public_id")), aval); }
  action sysid  { SET(aval, p); ATTR(ID2SYM(rb_intern("system_id")), aval); }

  action new_attr { 
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }

  action save_attr { 
    ATTR(akey, aval);
  }

  include hpricot_common "hpricot_common.rl";

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

static void
rb_hpricot_add(VALUE focus, VALUE ele)
{
  hpricot_ele *he, *he2;
  Data_Get_Struct(focus, hpricot_ele, he);
  Data_Get_Struct(ele, hpricot_ele, he2);
  if (NIL_P(he->children))
    he->children = rb_ary_new();
  rb_ary_push(he->children, ele);
  he2->parent = focus;
}

typedef struct {
  VALUE doc;
  VALUE focus;
  VALUE last;
  VALUE EC;
  unsigned char xml, strict, fixup;
} hpricot_state;

static void
hpricot_ele_mark(hpricot_ele *he)
{
  rb_gc_mark(he->tag);
  rb_gc_mark(he->attr);
  rb_gc_mark(he->etag);
  rb_gc_mark(he->raw);
  rb_gc_mark(he->parent);
  rb_gc_mark(he->children);
}

static void
hpricot_ele_free(hpricot_ele *he)
{
  free(he);
}

#define H_PROP(prop) \
  static VALUE hpricot_ele_set_##prop(VALUE self, VALUE x) { \
    hpricot_ele *he; \
    Data_Get_Struct(self, hpricot_ele, he); \
    he->prop = x; \
    return self; \
  } \
  static VALUE hpricot_ele_get_##prop(VALUE self) { \
    hpricot_ele *he; \
    Data_Get_Struct(self, hpricot_ele, he); \
    return he->prop; \
  }

#define H_ATTR(prop) \
  static VALUE hpricot_ele_set_##prop(VALUE self, VALUE x) { \
    hpricot_ele *he; \
    Data_Get_Struct(self, hpricot_ele, he); \
    rb_hash_aset(he->attr, ID2SYM(rb_intern("" # prop)), x); \
    return self; \
  } \
  static VALUE hpricot_ele_get_##prop(VALUE self) { \
    hpricot_ele *he; \
    Data_Get_Struct(self, hpricot_ele, he); \
    return rb_hash_aref(he->attr, ID2SYM(rb_intern("" # prop))); \
  }

H_PROP(tag);
H_PROP(attr);
H_PROP(etag);
H_PROP(parent);
H_PROP(children);
H_ATTR(encoding);
H_ATTR(version);
H_ATTR(standalone);
H_ATTR(system_id);
H_ATTR(public_id);

static VALUE
hpricot_ele_get_raw(VALUE self, VALUE x) {
  hpricot_ele *he;
  Data_Get_Struct(self, hpricot_ele, he);
  return he->raw;
}

static VALUE
hpricot_ele_clear_raw(VALUE self)
{
  hpricot_ele *he;
  Data_Get_Struct(self, hpricot_ele, he);
  he->raw = Qnil;
  return Qtrue;
}

#define H_ELE(klass) \
  hpricot_ele *he = ALLOC(hpricot_ele); \
  he->name = 0; \
  he->tag = tag; \
  he->attr = attr; \
  he->raw = Qnil; \
  he->EC = ec; \
  he->etag = he->parent = he->children = Qnil; \
  if (raw != NULL && (sym == sym_emptytag || sym == sym_stag || sym == sym_etag || sym == sym_doctype)) { \
    he->raw = rb_str_new(raw, rawlen); \
  } \
  ele = Data_Wrap_Struct(klass, hpricot_ele_mark, hpricot_ele_free, he); \
  S->last = ele

VALUE
hpricot_ele_alloc(VALUE klass)
{
  VALUE ele;
  hpricot_ele *he = ALLOC(hpricot_ele);
  he->name = 0;
  he->tag = he->attr = he->raw = he->EC = Qnil;
  he->etag = he->parent = he->children = Qnil;
  ele = Data_Wrap_Struct(klass, hpricot_ele_mark, hpricot_ele_free, he);
  return ele;
}

//
// the swift, compact parser logic.  most of the complicated stuff is done
// in the lexer.  this step just pairs up the start and end tags.
//
void
rb_hpricot_token(hpricot_state *S, VALUE sym, VALUE tag, VALUE attr, char *raw, int rawlen, int taint)
{
  VALUE ele, ec = Qnil;

  //
  // in html mode, fix up start tags incorrectly formed as empty tags
  //
  if (!S->xml) {
    hpricot_ele *last;
    Data_Get_Struct(S->focus, hpricot_ele, last);
    if (last->EC == sym_CDATA &&
       (sym != sym_procins && sym != sym_comment && sym != sym_cdata && sym != sym_text) &&
      !(sym == sym_etag && rb_str_hash(tag) == last->name))
    {
      sym = sym_text;
      tag = rb_str_new(raw, rawlen);
    }

    if (sym == sym_emptytag || sym == sym_stag || sym == sym_etag) {
      ec = rb_hash_aref(S->EC, tag);
      if (NIL_P(ec)) {
        tag = rb_funcall(tag, s_downcase, 0);
        ec = rb_hash_aref(S->EC, tag);
      }
      if (sym == sym_emptytag) {
        if (ec != sym_EMPTY)
          sym = sym_stag;
      } else if (sym == sym_stag) {
        if (ec == sym_EMPTY)
          sym = sym_emptytag;
      }
    }
  }

  if (sym == sym_emptytag || sym == sym_stag) {
    H_ELE(cElem);
    he->name = rb_str_hash(tag);

    if (!S->xml) {
      VALUE match = Qnil, e = S->focus;
      while (e != S->doc)
      {
        hpricot_ele *hee;
        Data_Get_Struct(e, hpricot_ele, hee);

        if (TYPE(hee->EC) == T_HASH)
        {
          VALUE has = rb_hash_lookup(hee->EC, INT2NUM(he->name));
          if (has != Qnil) {
            if (has == Qtrue) {
              if (match == Qnil)
                match = e;
            } else if (has == symAllow) {
              match = S->focus;
            } else if (has == symDeny) {
              match = Qnil;
            }
          }
        }

        e = hee->parent;
      }

      if (match == Qnil)
        match = S->focus;
      S->focus = match;
    }

    rb_hpricot_add(S->focus, ele);

    //
    // in the case of a start tag that should be empty, just
    // skip the step that focuses the element.  focusing moves
    // us deeper into the document.
    //
    if (sym == sym_stag) {
      if (S->xml || ec != sym_EMPTY) {
        S->focus = ele;
        S->last = Qnil;
      }
    }
  } else if (sym == sym_etag) {
    int name;
    VALUE match = Qnil, e = S->focus;
    if (S->strict) {
      if (NIL_P(rb_hash_aref(S->EC, tag))) {
        tag = rb_str_new2("div");
      }
    }

    //
    // another optimization will be to improve this very simple
    // O(n) tag search, where n is the depth of the focused tag.
    //
    // (see also: the search above for fixups)
    //
    name = rb_str_hash(tag);
    while (e != S->doc)
    {
      hpricot_ele *he;
      Data_Get_Struct(e, hpricot_ele, he);

      if (he->name == name)
      {
        match = e;
        break;
      }

      e = he->parent;
    }

    if (NIL_P(match))
    {
      H_ELE(cBogusETag);
      rb_hpricot_add(S->focus, ele);
    }
    else
    {
      H_ELE(cETag);
      Data_Get_Struct(match, hpricot_ele, he);
      he->etag = ele;
      S->focus = he->parent;
      S->last = Qnil;
    }
  } else if (sym == sym_cdata) {
    H_ELE(cCData);
    rb_hpricot_add(S->focus, ele);
  } else if (sym == sym_comment) {
    H_ELE(cComment);
    rb_hpricot_add(S->focus, ele);
  } else if (sym == sym_doctype) {
    H_ELE(cDocType);
    if (S->strict) {
      rb_hash_aset(attr, ID2SYM(rb_intern("system_id")), rb_str_new2("http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"));
      rb_hash_aset(attr, ID2SYM(rb_intern("public_id")), rb_str_new2("-//W3C//DTD XHTML 1.0 Strict//EN"));
    }
    rb_hpricot_add(S->focus, ele);
  } else if (sym == sym_procins) {
    VALUE match = rb_funcall(tag, rb_intern("match"), 1, reProcInsParse);
    tag = rb_reg_nth_match(1, match);
    attr = rb_reg_nth_match(2, match);
    {
        H_ELE(cProcIns);
        rb_hpricot_add(S->focus, ele);
    }
  } else if (sym == sym_text) {
    // TODO: add raw_string as well?
    if (!NIL_P(S->last) && RBASIC(S->last)->klass == cText) {
      hpricot_ele *he;
      Data_Get_Struct(S->last, hpricot_ele, he);
      rb_str_append(he->tag, tag);
    } else {
      H_ELE(cText);
      rb_hpricot_add(S->focus, ele);
    }
  } else if (sym == sym_xmldecl) {
    H_ELE(cXMLDecl);
    rb_hpricot_add(S->focus, ele);
  }
}

VALUE hpricot_scan(int argc, VALUE *argv, VALUE self)
{
  int cs, act, have = 0, nread = 0, curline = 1, text = 0;
  char *ts = 0, *te = 0, *buf = NULL, *eof = NULL;

  hpricot_state *S = NULL;
  VALUE port, opts;
  VALUE attr = Qnil, tag = Qnil, akey = Qnil, aval = Qnil, bufsize = Qnil;
  char *mark_tag = 0, *mark_akey = 0, *mark_aval = 0;
  int done = 0, ele_open = 0, buffer_size = 0, taint = 0;

  rb_scan_args(argc, argv, "11", &port, &opts);
  taint = OBJ_TAINTED( port );
  if ( !rb_respond_to( port, s_read ) )
  {
    if ( rb_respond_to( port, s_to_str ) )
    {
      port = rb_funcall( port, s_to_str, 0 );
      StringValue(port);
    }
    else
    {
      rb_raise(rb_eArgError, "an Hpricot document must be built from an input source (a String or IO object.)");
    }
  }

  if (TYPE(opts) != T_HASH)
    opts = Qnil;

  if (!rb_block_given_p())
  {
    hpricot_ele *he = ALLOC(hpricot_ele);
    S = ALLOC(hpricot_state);
    MEMZERO(he, hpricot_ele, 1);
    he->tag = he->attr = he->etag = he->parent = he->children = Qnil;
    S->doc = Data_Wrap_Struct(cDoc, hpricot_ele_mark, hpricot_ele_free, he);
    rb_gc_register_address(&S->doc);
    S->focus = S->doc;
    S->last = Qnil;
    S->xml = OPT(opts, xml);
    S->strict = OPT(opts, xhtml_strict);
    S->fixup = OPT(opts, fixup_tags);
    if (S->strict) S->fixup = 1;
    rb_ivar_set(S->doc, rb_intern("@options"), opts);

    S->EC = rb_const_get(mHpricot, s_ElementContent);
  }

  buffer_size = BUFSIZE;
  if (rb_ivar_defined(self, rb_intern("@buffer_size")) == Qtrue) {
    bufsize = rb_ivar_get(self, rb_intern("@buffer_size"));
    if (!NIL_P(bufsize)) {
      buffer_size = NUM2INT(bufsize);
    }
  }
  buf = ALLOC_N(char, buffer_size);

  %% write init;
  
  while ( !done ) {
    VALUE str;
    char *p, *pe;
    int len, space = buffer_size - have, tokstart_diff, tokend_diff, mark_tag_diff, mark_akey_diff, mark_aval_diff;

    if ( space == 0 ) {
      /* We've used up the entire buffer storing an already-parsed token
       * prefix that must be preserved.  Likely caused by super-long attributes.
       * Increase buffer size and continue  */
       tokstart_diff = ts - buf;
       tokend_diff = te - buf;
       mark_tag_diff = mark_tag - buf;
       mark_akey_diff = mark_akey - buf;
       mark_aval_diff = mark_aval - buf;

       buffer_size += BUFSIZE;
       REALLOC_N(buf, char, buffer_size);

       space = buffer_size - have;

       ts= buf + tokstart_diff;
       te = buf + tokend_diff;
       mark_tag = buf + mark_tag_diff;
       mark_akey = buf + mark_akey_diff;
       mark_aval = buf + mark_aval_diff;
    }
    p = buf + have;

    if ( rb_respond_to( port, s_read ) )
    {
      str = rb_funcall(port, s_read, 1, INT2FIX(space));
      len = RSTRING_LEN(str);
      memcpy(p, StringValuePtr(str), len);
    }
    else
    {
      len = RSTRING_LEN(port) - nread;
      if (len > space) len = space;
      memcpy(p, StringValuePtr(port) + nread, len);
    }

    nread += len;

    /* If this is the last buffer, tack on an EOF. */
    if ( len < space ) {
      p[len++] = 0;
      done = 1;
    }

    pe = p + len;
    %% write exec;
    
    if ( cs == hpricot_scan_error ) {
      free(buf);
      if ( !NIL_P(tag) )
      {
        rb_raise(rb_eHpricotParseError, "parse error on element <%s>, starting on line %d.\n" NO_WAY_SERIOUSLY, RSTRING_PTR(tag), curline);
      }
      else
      {
        rb_raise(rb_eHpricotParseError, "parse error on line %d.\n" NO_WAY_SERIOUSLY, curline);
      }
    }
    
    if ( done && ele_open )
    {
      ele_open = 0;
      if (ts > 0) {
        mark_tag = ts;
        ts = 0;
        text = 1;
      }
    }

    if ( ts == 0 )
    {
      have = 0;
      /* text nodes have no ts because each byte is parsed alone */
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
      have = pe - ts;
      memmove( buf, ts, have );
      SLIDE(tag);
      SLIDE(akey);
      SLIDE(aval);
      te = buf + (te - ts);
      ts = buf;
    }
  }
  free(buf);

  if (S != NULL)
  {
    VALUE doc = S->doc;
    rb_gc_unregister_address(&S->doc);
    free(S);
    return doc;
  }

  return Qnil;
}

void Init_hpricot_scan()
{
  mHpricot = rb_define_module("Hpricot");
  rb_define_attr(rb_singleton_class(mHpricot), "buffer_size", 1, 1);
  rb_define_singleton_method(mHpricot, "scan", hpricot_scan, -1);
  rb_define_singleton_method(mHpricot, "css", hpricot_css, 3);
  rb_eHpricotParseError = rb_define_class_under(mHpricot, "ParseError", rb_eStandardError);

  cDoc = rb_define_class_under(mHpricot, "Doc", rb_cObject);
  rb_define_alloc_func(cDoc, hpricot_ele_alloc);
  rb_define_method(cDoc, "children", hpricot_ele_get_children, 0);
  rb_define_method(cDoc, "children=", hpricot_ele_set_children, 1);

  cBaseEle = rb_define_class_under(mHpricot, "BaseEle", rb_cObject);
  rb_define_alloc_func(cBaseEle, hpricot_ele_alloc);
  rb_define_method(cBaseEle, "raw_string", hpricot_ele_get_raw, 0);
  rb_define_method(cBaseEle, "clear_raw", hpricot_ele_clear_raw, 0);
  rb_define_method(cBaseEle, "parent", hpricot_ele_get_parent, 0);
  rb_define_method(cBaseEle, "parent=", hpricot_ele_set_parent, 1);
  cCData = rb_define_class_under(mHpricot, "CData", cBaseEle);
  rb_define_method(cCData, "content", hpricot_ele_get_tag, 0);
  rb_define_method(cCData, "content=", hpricot_ele_set_tag, 1);
  cComment = rb_define_class_under(mHpricot, "Comment", cBaseEle);
  rb_define_method(cComment, "content", hpricot_ele_get_tag, 0);
  rb_define_method(cComment, "content=", hpricot_ele_set_tag, 1);
  cDocType = rb_define_class_under(mHpricot, "DocType", cBaseEle);
  rb_define_method(cDocType, "target", hpricot_ele_get_tag, 0);
  rb_define_method(cDocType, "target=", hpricot_ele_set_tag, 1);
  rb_define_method(cDocType, "public_id", hpricot_ele_get_public_id, 0);
  rb_define_method(cDocType, "public_id=", hpricot_ele_set_public_id, 1);
  rb_define_method(cDocType, "system_id", hpricot_ele_get_system_id, 0);
  rb_define_method(cDocType, "system_id=", hpricot_ele_set_system_id, 1);
  cElem = rb_define_class_under(mHpricot, "Elem", cBaseEle);
  rb_define_method(cElem, "raw_attributes", hpricot_ele_get_attr, 0);
  rb_define_method(cElem, "raw_attributes=", hpricot_ele_set_attr, 1);
  rb_define_method(cElem, "children", hpricot_ele_get_children, 0);
  rb_define_method(cElem, "children=", hpricot_ele_set_children, 1);
  rb_define_method(cElem, "etag", hpricot_ele_get_etag, 0);
  rb_define_method(cElem, "etag=", hpricot_ele_set_etag, 1);
  rb_define_method(cElem, "name", hpricot_ele_get_tag, 0);
  rb_define_method(cElem, "name=", hpricot_ele_set_tag, 1);
  cETag = rb_define_class_under(mHpricot, "ETag", cBaseEle);
  rb_define_method(cETag, "name", hpricot_ele_get_tag, 0);
  rb_define_method(cETag, "name=", hpricot_ele_set_tag, 1);
  cBogusETag = rb_define_class_under(mHpricot, "BogusETag", cETag);
  cText = rb_define_class_under(mHpricot, "Text", cBaseEle);
  rb_define_method(cText, "content", hpricot_ele_get_tag, 0);
  rb_define_method(cText, "content=", hpricot_ele_set_tag, 1);
  cXMLDecl = rb_define_class_under(mHpricot, "XMLDecl", cBaseEle);
  rb_define_method(cXMLDecl, "encoding", hpricot_ele_get_encoding, 0);
  rb_define_method(cXMLDecl, "encoding=", hpricot_ele_set_encoding, 1);
  rb_define_method(cXMLDecl, "standalone", hpricot_ele_get_standalone, 0);
  rb_define_method(cXMLDecl, "standalone=", hpricot_ele_set_standalone, 1);
  rb_define_method(cXMLDecl, "version", hpricot_ele_get_version, 0);
  rb_define_method(cXMLDecl, "version=", hpricot_ele_set_version, 1);
  cProcIns = rb_define_class_under(mHpricot, "ProcIns", cBaseEle);
  rb_define_method(cProcIns, "target", hpricot_ele_get_tag, 0);
  rb_define_method(cProcIns, "target=", hpricot_ele_set_tag, 1);
  rb_define_method(cProcIns, "content", hpricot_ele_get_attr, 0);
  rb_define_method(cProcIns, "content=", hpricot_ele_set_attr, 1);

  s_ElementContent = rb_intern("ElementContent");
  symAllow = ID2SYM(rb_intern("allow"));
  symDeny = ID2SYM(rb_intern("deny"));
  s_downcase = rb_intern("downcase");
  s_new = rb_intern("new");
  s_parent = rb_intern("parent");
  s_read = rb_intern("read");
  s_to_str = rb_intern("to_str");
  iv_parent = rb_intern("parent");
  sym_xmldecl = ID2SYM(rb_intern("xmldecl"));
  sym_doctype = ID2SYM(rb_intern("doctype"));
  sym_procins = ID2SYM(rb_intern("procins"));
  sym_stag = ID2SYM(rb_intern("stag"));
  sym_etag = ID2SYM(rb_intern("etag"));
  sym_emptytag = ID2SYM(rb_intern("emptytag"));
  sym_comment = ID2SYM(rb_intern("comment"));
  sym_cdata = ID2SYM(rb_intern("cdata"));
  sym_text = ID2SYM(rb_intern("text"));
  sym_EMPTY = ID2SYM(rb_intern("EMPTY"));
  sym_CDATA = ID2SYM(rb_intern("CDATA"));

  rb_const_set(mHpricot, rb_intern("ProcInsParse"),
    reProcInsParse = rb_eval_string("/\\A<\\?(\\S+)\\s+(.+)/m"));
}

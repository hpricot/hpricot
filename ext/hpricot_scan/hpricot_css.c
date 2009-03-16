#line 1 "hpricot_css.rl"
/*
 * hpricot_css.rl
 * ragel -C hpricot_css.rl -o hpricot_css.c
 *
 * Copyright (C) 2008 why the lucky stiff
 */
#include <ruby.h>

#define FILTER(id) \
  rb_funcall2(mod, rb_intern("" # id), fargs, fvals); \
  rb_ary_clear(tmpt); \
  fargs = 1
#define FILTERAUTO() \
  char filt[10]; \
  sprintf(filt, "%.*s", te - ts, ts); \
  rb_funcall2(mod, rb_intern(filt), fargs, fvals); \
  rb_ary_clear(tmpt); \
  fargs = 1
#define PUSH(aps, ape) rb_ary_push(tmpt, fvals[fargs++] = rb_str_new(aps, ape - aps))
#define P(id) printf(id ": %.*s\n", te - ts, ts);


#line 25 "hpricot_css.c"
static const int hpricot_css_start = 85;
static const int hpricot_css_error = 0;

static const int hpricot_css_en_main = 85;

#line 87 "hpricot_css.rl"


VALUE hpricot_css(VALUE self, VALUE mod, VALUE str, VALUE node)
{
  int cs, act, eof;
  char *p, *pe, *ts, *te, *aps, *ape, *aps2, *ape2;

  int fargs = 1;
  VALUE fvals[6];
  VALUE focus = rb_ary_new3(1, node);
  VALUE tmpt = rb_ary_new();
  rb_gc_register_address(&focus);
  rb_gc_register_address(&tmpt);
  fvals[0] = focus;

  if (TYPE(str) != T_STRING)
    rb_raise(rb_eArgError, "bad CSS selector, String only please.");
 
  StringValue(str);
  p = RSTRING_PTR(str);
  pe = p + RSTRING_LEN(str);

  
#line 55 "hpricot_css.c"
	{
	cs = hpricot_css_start;
	ts = 0;
	te = 0;
	act = 0;
	}
#line 110 "hpricot_css.rl"
  
#line 64 "hpricot_css.c"
	{
	if ( p == pe )
		goto _test_eof;
	switch ( cs )
	{
tr0:
#line 83 "hpricot_css.rl"
	{{p = ((te))-1;}}
	goto st85;
tr10:
#line 1 "hpricot_css.rl"
	{	switch( act ) {
	case 0:
	{{goto st0;}}
	break;
	case 1:
	{{p = ((te))-1;} FILTER(ID); }
	break;
	case 2:
	{{p = ((te))-1;} FILTER(CLASS); }
	break;
	case 5:
	{{p = ((te))-1;} FILTER(TAG); }
	break;
	case 7:
	{{p = ((te))-1;} FILTER(CHILD); }
	break;
	case 8:
	{{p = ((te))-1;} FILTER(POS); }
	break;
	case 9:
	{{p = ((te))-1;} FILTER(PSUEDO); }
	break;
	}
	}
	goto st85;
tr38:
#line 80 "hpricot_css.rl"
	{{p = ((te))-1;}{ FILTER(PSUEDO); }}
	goto st85;
tr43:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 80 "hpricot_css.rl"
	{te = p+1;{ FILTER(PSUEDO); }}
	goto st85;
tr45:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 80 "hpricot_css.rl"
	{te = p+1;{ FILTER(PSUEDO); }}
	goto st85;
tr62:
#line 79 "hpricot_css.rl"
	{{p = ((te))-1;}{ FILTER(POS); }}
	goto st85;
tr64:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 79 "hpricot_css.rl"
	{te = p+1;{ FILTER(POS); }}
	goto st85;
tr66:
#line 78 "hpricot_css.rl"
	{{p = ((te))-1;}{ FILTER(CHILD); }}
	goto st85;
tr67:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 78 "hpricot_css.rl"
	{te = p+1;{ FILTER(CHILD); }}
	goto st85;
tr71:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 78 "hpricot_css.rl"
	{te = p+1;{ FILTER(CHILD); }}
	goto st85;
tr99:
#line 75 "hpricot_css.rl"
	{te = p+1;{ FILTER(ATTR); }}
	goto st85;
tr104:
#line 75 "hpricot_css.rl"
	{{p = ((te))-1;}{ FILTER(ATTR); }}
	goto st85;
tr126:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 74 "hpricot_css.rl"
	{te = p+1;{ FILTER(NAME); }}
	goto st85;
tr139:
#line 82 "hpricot_css.rl"
	{te = p+1;{ FILTERAUTO(); }}
	goto st85;
tr149:
#line 83 "hpricot_css.rl"
	{te = p;p--;}
	goto st85;
tr150:
#line 81 "hpricot_css.rl"
	{te = p;p--;{ focus = rb_ary_new3(1, node); }}
	goto st85;
tr151:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 72 "hpricot_css.rl"
	{te = p;p--;{ FILTER(ID); }}
	goto st85;
tr155:
#line 77 "hpricot_css.rl"
	{te = p;p--;{ FILTER(MOD); }}
	goto st85;
tr156:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 76 "hpricot_css.rl"
	{te = p;p--;{ FILTER(TAG); }}
	goto st85;
tr162:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 73 "hpricot_css.rl"
	{te = p;p--;{ FILTER(CLASS); }}
	goto st85;
tr166:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 80 "hpricot_css.rl"
	{te = p;p--;{ FILTER(PSUEDO); }}
	goto st85;
tr173:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 79 "hpricot_css.rl"
	{te = p;p--;{ FILTER(POS); }}
	goto st85;
tr188:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 78 "hpricot_css.rl"
	{te = p;p--;{ FILTER(CHILD); }}
	goto st85;
tr196:
#line 75 "hpricot_css.rl"
	{te = p;p--;{ FILTER(ATTR); }}
	goto st85;
st85:
#line 1 "hpricot_css.rl"
	{ts = 0;}
#line 1 "hpricot_css.rl"
	{act = 0;}
	if ( ++p == pe )
		goto _test_eof85;
case 85:
#line 1 "hpricot_css.rl"
	{ts = p;}
#line 267 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto tr133;
		case 35: goto st2;
		case 43: goto st89;
		case 44: goto st87;
		case 45: goto tr136;
		case 46: goto st13;
		case 58: goto st19;
		case 62: goto tr139;
		case 91: goto st52;
		case 92: goto tr142;
		case 95: goto tr140;
		case 101: goto tr143;
		case 110: goto tr136;
		case 111: goto tr144;
		case 126: goto tr139;
		case 4294967236: goto tr145;
	}
	if ( (*p) < 97 ) {
		if ( (*p) < 48 ) {
			if ( 9 <= (*p) && (*p) <= 13 )
				goto tr133;
		} else if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr140;
		} else
			goto tr136;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto tr146;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto tr148;
		} else
			goto tr147;
	} else
		goto tr140;
	goto st0;
st0:
cs = 0;
	goto _out;
tr133:
#line 1 "hpricot_css.rl"
	{te = p+1;}
	goto st86;
st86:
	if ( ++p == pe )
		goto _test_eof86;
case 86:
#line 318 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto st1;
		case 44: goto st87;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st1;
	goto tr149;
st1:
	if ( ++p == pe )
		goto _test_eof1;
case 1:
	switch( (*p) ) {
		case 32: goto st1;
		case 44: goto st87;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st1;
	goto tr0;
st87:
	if ( ++p == pe )
		goto _test_eof87;
case 87:
	if ( (*p) == 32 )
		goto st87;
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st87;
	goto tr150;
st2:
	if ( ++p == pe )
		goto _test_eof2;
case 2:
	switch( (*p) ) {
		case 45: goto tr3;
		case 92: goto tr5;
		case 95: goto tr3;
		case 4294967236: goto tr6;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr3;
		} else if ( (*p) >= 48 )
			goto tr3;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto tr7;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto tr9;
		} else
			goto tr8;
	} else
		goto tr3;
	goto st0;
tr3:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 72 "hpricot_css.rl"
	{act = 1;}
	goto st88;
tr11:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 72 "hpricot_css.rl"
	{act = 1;}
	goto st88;
st88:
	if ( ++p == pe )
		goto _test_eof88;
case 88:
#line 394 "hpricot_css.c"
	switch( (*p) ) {
		case 45: goto tr11;
		case 92: goto st3;
		case 95: goto tr11;
		case 4294967236: goto st4;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr11;
		} else if ( (*p) >= 48 )
			goto tr11;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st5;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st7;
		} else
			goto st6;
	} else
		goto tr11;
	goto tr151;
tr5:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st3;
st3:
	if ( ++p == pe )
		goto _test_eof3;
case 3:
#line 429 "hpricot_css.c"
	if ( (*p) == 46 )
		goto tr11;
	goto tr10;
tr6:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st4;
st4:
	if ( ++p == pe )
		goto _test_eof4;
case 4:
#line 443 "hpricot_css.c"
	if ( 4294967208 <= (*p) && (*p) <= 4294967231 )
		goto tr11;
	goto tr10;
tr7:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st5;
st5:
	if ( ++p == pe )
		goto _test_eof5;
case 5:
#line 457 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto tr11;
	goto tr10;
tr8:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st6;
st6:
	if ( ++p == pe )
		goto _test_eof6;
case 6:
#line 471 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st5;
	goto tr10;
tr9:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st7;
st7:
	if ( ++p == pe )
		goto _test_eof7;
case 7:
#line 485 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st6;
	goto tr10;
tr157:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st89;
st89:
	if ( ++p == pe )
		goto _test_eof89;
case 89:
#line 500 "hpricot_css.c"
	switch( (*p) ) {
		case 43: goto st89;
		case 45: goto st89;
		case 110: goto st89;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto st89;
	goto tr155;
tr158:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st90;
tr136:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st90;
st90:
	if ( ++p == pe )
		goto _test_eof90;
case 90:
#line 529 "hpricot_css.c"
	switch( (*p) ) {
		case 43: goto tr157;
		case 45: goto tr158;
		case 92: goto st8;
		case 95: goto tr14;
		case 110: goto tr158;
		case 4294967236: goto st9;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr14;
		} else if ( (*p) >= 48 )
			goto tr158;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st10;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st12;
		} else
			goto st11;
	} else
		goto tr14;
	goto tr156;
tr14:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st91;
tr140:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st91;
st91:
	if ( ++p == pe )
		goto _test_eof91;
case 91:
#line 576 "hpricot_css.c"
	switch( (*p) ) {
		case 45: goto tr14;
		case 92: goto st8;
		case 95: goto tr14;
		case 4294967236: goto st9;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr14;
		} else if ( (*p) >= 48 )
			goto tr14;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st10;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st12;
		} else
			goto st11;
	} else
		goto tr14;
	goto tr156;
tr142:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st8;
st8:
	if ( ++p == pe )
		goto _test_eof8;
case 8:
#line 611 "hpricot_css.c"
	if ( (*p) == 46 )
		goto tr14;
	goto tr10;
tr145:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st9;
st9:
	if ( ++p == pe )
		goto _test_eof9;
case 9:
#line 625 "hpricot_css.c"
	if ( 4294967208 <= (*p) && (*p) <= 4294967231 )
		goto tr14;
	goto tr10;
tr146:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st10;
st10:
	if ( ++p == pe )
		goto _test_eof10;
case 10:
#line 639 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto tr14;
	goto tr10;
tr147:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st11;
st11:
	if ( ++p == pe )
		goto _test_eof11;
case 11:
#line 653 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st10;
	goto tr10;
tr148:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st12;
st12:
	if ( ++p == pe )
		goto _test_eof12;
case 12:
#line 667 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st11;
	goto tr10;
st13:
	if ( ++p == pe )
		goto _test_eof13;
case 13:
	switch( (*p) ) {
		case 45: goto tr17;
		case 92: goto tr18;
		case 95: goto tr17;
		case 4294967236: goto tr19;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr17;
		} else if ( (*p) >= 48 )
			goto tr17;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto tr20;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto tr22;
		} else
			goto tr21;
	} else
		goto tr17;
	goto st0;
tr17:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 73 "hpricot_css.rl"
	{act = 2;}
	goto st92;
tr23:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 73 "hpricot_css.rl"
	{act = 2;}
	goto st92;
st92:
	if ( ++p == pe )
		goto _test_eof92;
case 92:
#line 719 "hpricot_css.c"
	switch( (*p) ) {
		case 45: goto tr23;
		case 92: goto st14;
		case 95: goto tr23;
		case 4294967236: goto st15;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr23;
		} else if ( (*p) >= 48 )
			goto tr23;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st16;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st18;
		} else
			goto st17;
	} else
		goto tr23;
	goto tr162;
tr18:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st14;
st14:
	if ( ++p == pe )
		goto _test_eof14;
case 14:
#line 754 "hpricot_css.c"
	if ( (*p) == 46 )
		goto tr23;
	goto tr10;
tr19:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st15;
st15:
	if ( ++p == pe )
		goto _test_eof15;
case 15:
#line 768 "hpricot_css.c"
	if ( 4294967208 <= (*p) && (*p) <= 4294967231 )
		goto tr23;
	goto tr10;
tr20:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st16;
st16:
	if ( ++p == pe )
		goto _test_eof16;
case 16:
#line 782 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto tr23;
	goto tr10;
tr21:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st17;
st17:
	if ( ++p == pe )
		goto _test_eof17;
case 17:
#line 796 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st16;
	goto tr10;
tr22:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st18;
st18:
	if ( ++p == pe )
		goto _test_eof18;
case 18:
#line 810 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st17;
	goto tr10;
st19:
	if ( ++p == pe )
		goto _test_eof19;
case 19:
	switch( (*p) ) {
		case 45: goto tr26;
		case 92: goto tr27;
		case 95: goto tr26;
		case 101: goto tr28;
		case 102: goto tr29;
		case 103: goto tr30;
		case 108: goto tr31;
		case 110: goto tr32;
		case 111: goto tr33;
		case 4294967236: goto tr34;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr26;
		} else if ( (*p) >= 48 )
			goto tr26;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto tr35;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto tr37;
		} else
			goto tr36;
	} else
		goto tr26;
	goto st0;
tr26:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st93;
tr59:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st93;
tr175:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st93;
st93:
	if ( ++p == pe )
		goto _test_eof93;
case 93:
#line 879 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr167:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st20;
st20:
	if ( ++p == pe )
		goto _test_eof20;
case 20:
#line 916 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr40;
		case 39: goto tr41;
		case 40: goto tr42;
		case 41: goto tr43;
	}
	goto tr39;
tr39:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st21;
st21:
	if ( ++p == pe )
		goto _test_eof21;
case 21:
#line 934 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr10;
		case 40: goto tr10;
		case 41: goto tr45;
	}
	goto st21;
tr40:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st22;
st22:
	if ( ++p == pe )
		goto _test_eof22;
case 22:
#line 951 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto st24;
		case 40: goto st25;
		case 41: goto tr10;
	}
	goto st23;
st23:
	if ( ++p == pe )
		goto _test_eof23;
case 23:
	if ( (*p) == 34 )
		goto st24;
	if ( 40 <= (*p) && (*p) <= 41 )
		goto tr10;
	goto st23;
st24:
	if ( ++p == pe )
		goto _test_eof24;
case 24:
	if ( (*p) == 41 )
		goto tr45;
	goto tr10;
st25:
	if ( ++p == pe )
		goto _test_eof25;
case 25:
	if ( (*p) == 41 )
		goto tr10;
	goto st26;
st26:
	if ( ++p == pe )
		goto _test_eof26;
case 26:
	if ( (*p) == 41 )
		goto st27;
	goto st26;
st27:
	if ( ++p == pe )
		goto _test_eof27;
case 27:
	switch( (*p) ) {
		case 34: goto st24;
		case 40: goto st25;
	}
	goto tr10;
tr41:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st28;
st28:
	if ( ++p == pe )
		goto _test_eof28;
case 28:
#line 1007 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto st30;
		case 39: goto st21;
		case 40: goto st31;
		case 41: goto tr45;
	}
	goto st29;
st29:
	if ( ++p == pe )
		goto _test_eof29;
case 29:
	switch( (*p) ) {
		case 34: goto st30;
		case 39: goto st21;
		case 40: goto tr10;
		case 41: goto tr45;
	}
	goto st29;
st30:
	if ( ++p == pe )
		goto _test_eof30;
case 30:
	if ( (*p) == 39 )
		goto st24;
	if ( 40 <= (*p) && (*p) <= 41 )
		goto tr10;
	goto st30;
st31:
	if ( ++p == pe )
		goto _test_eof31;
case 31:
	if ( (*p) == 41 )
		goto tr10;
	goto st32;
st32:
	if ( ++p == pe )
		goto _test_eof32;
case 32:
	if ( (*p) == 41 )
		goto st33;
	goto st32;
st33:
	if ( ++p == pe )
		goto _test_eof33;
case 33:
	switch( (*p) ) {
		case 39: goto st24;
		case 40: goto st31;
	}
	goto tr10;
tr42:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st34;
st34:
	if ( ++p == pe )
		goto _test_eof34;
case 34:
#line 1068 "hpricot_css.c"
	if ( (*p) == 41 )
		goto tr10;
	goto st35;
st35:
	if ( ++p == pe )
		goto _test_eof35;
case 35:
	if ( (*p) == 41 )
		goto st36;
	goto st35;
st36:
	if ( ++p == pe )
		goto _test_eof36;
case 36:
	switch( (*p) ) {
		case 40: goto st34;
		case 41: goto tr45;
	}
	goto tr10;
tr27:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st37;
tr176:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st37;
st37:
	if ( ++p == pe )
		goto _test_eof37;
case 37:
#line 1105 "hpricot_css.c"
	if ( (*p) == 46 )
		goto tr59;
	goto tr10;
tr34:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st38;
st38:
	if ( ++p == pe )
		goto _test_eof38;
case 38:
#line 1119 "hpricot_css.c"
	if ( 4294967208 <= (*p) && (*p) <= 4294967231 )
		goto tr59;
	goto tr10;
tr35:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st39;
st39:
	if ( ++p == pe )
		goto _test_eof39;
case 39:
#line 1133 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto tr59;
	goto tr10;
tr36:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st40;
st40:
	if ( ++p == pe )
		goto _test_eof40;
case 40:
#line 1147 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st39;
	goto tr10;
tr37:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st41;
st41:
	if ( ++p == pe )
		goto _test_eof41;
case 41:
#line 1161 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st40;
	goto tr10;
tr28:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st94;
st94:
	if ( ++p == pe )
		goto _test_eof94;
case 94:
#line 1179 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 113: goto tr171;
		case 118: goto tr172;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr171:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 79 "hpricot_css.rl"
	{act = 8;}
	goto st95;
st95:
	if ( ++p == pe )
		goto _test_eof95;
case 95:
#line 1217 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr174;
		case 45: goto tr175;
		case 92: goto tr176;
		case 95: goto tr175;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr175;
		} else if ( (*p) >= 48 )
			goto tr175;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr175;
	goto tr173;
tr174:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st42;
st42:
	if ( ++p == pe )
		goto _test_eof42;
case 42:
#line 1254 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr40;
		case 39: goto tr41;
		case 40: goto tr42;
		case 41: goto tr43;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr63;
	goto tr39;
tr63:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st43;
st43:
	if ( ++p == pe )
		goto _test_eof43;
case 43:
#line 1274 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr62;
		case 40: goto tr62;
		case 41: goto tr64;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto st43;
	goto st21;
tr172:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st96;
st96:
	if ( ++p == pe )
		goto _test_eof96;
case 96:
#line 1293 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 101: goto tr177;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr177:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st97;
st97:
	if ( ++p == pe )
		goto _test_eof97;
case 97:
#line 1330 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 110: goto tr171;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr29:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st98;
st98:
	if ( ++p == pe )
		goto _test_eof98;
case 98:
#line 1371 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 105: goto tr178;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr178:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st99;
st99:
	if ( ++p == pe )
		goto _test_eof99;
case 99:
#line 1408 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 114: goto tr179;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr179:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st100;
st100:
	if ( ++p == pe )
		goto _test_eof100;
case 100:
#line 1445 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 115: goto tr180;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr180:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st101;
st101:
	if ( ++p == pe )
		goto _test_eof101;
case 101:
#line 1482 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 116: goto tr181;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr181:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 79 "hpricot_css.rl"
	{act = 8;}
	goto st102;
st102:
	if ( ++p == pe )
		goto _test_eof102;
case 102:
#line 1519 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr174;
		case 45: goto tr182;
		case 92: goto tr176;
		case 95: goto tr175;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr175;
		} else if ( (*p) >= 48 )
			goto tr175;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr175;
	goto tr173;
tr195:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st103;
tr182:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st103;
st103:
	if ( ++p == pe )
		goto _test_eof103;
case 103:
#line 1566 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 99: goto tr183;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr183:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st104;
st104:
	if ( ++p == pe )
		goto _test_eof104;
case 104:
#line 1603 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 104: goto tr184;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr184:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st105;
st105:
	if ( ++p == pe )
		goto _test_eof105;
case 105:
#line 1640 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 105: goto tr185;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr185:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st106;
st106:
	if ( ++p == pe )
		goto _test_eof106;
case 106:
#line 1677 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 108: goto tr186;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr186:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st107;
st107:
	if ( ++p == pe )
		goto _test_eof107;
case 107:
#line 1714 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 100: goto tr187;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr187:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 78 "hpricot_css.rl"
	{act = 7;}
	goto st108;
st108:
	if ( ++p == pe )
		goto _test_eof108;
case 108:
#line 1751 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr189;
		case 45: goto tr175;
		case 92: goto tr176;
		case 95: goto tr175;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr175;
		} else if ( (*p) >= 48 )
			goto tr175;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr175;
	goto tr188;
tr189:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st44;
st44:
	if ( ++p == pe )
		goto _test_eof44;
case 44:
#line 1788 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr40;
		case 39: goto tr41;
		case 40: goto tr42;
		case 41: goto tr67;
		case 43: goto tr68;
		case 45: goto tr68;
		case 101: goto tr69;
		case 110: goto tr68;
		case 111: goto tr70;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr68;
	goto tr39;
tr68:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st45;
st45:
	if ( ++p == pe )
		goto _test_eof45;
case 45:
#line 1813 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr71;
		case 43: goto st45;
		case 45: goto st45;
		case 110: goto st45;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto st45;
	goto st21;
tr69:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st46;
st46:
	if ( ++p == pe )
		goto _test_eof46;
case 46:
#line 1835 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr45;
		case 118: goto st47;
	}
	goto st21;
st47:
	if ( ++p == pe )
		goto _test_eof47;
case 47:
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr45;
		case 101: goto st48;
	}
	goto st21;
st48:
	if ( ++p == pe )
		goto _test_eof48;
case 48:
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr45;
		case 110: goto st49;
	}
	goto st21;
st49:
	if ( ++p == pe )
		goto _test_eof49;
case 49:
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr71;
	}
	goto st21;
tr70:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st50;
st50:
	if ( ++p == pe )
		goto _test_eof50;
case 50:
#line 1885 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr45;
		case 100: goto st51;
	}
	goto st21;
st51:
	if ( ++p == pe )
		goto _test_eof51;
case 51:
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr45;
		case 100: goto st49;
	}
	goto st21;
tr30:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st109;
st109:
	if ( ++p == pe )
		goto _test_eof109;
case 109:
#line 1918 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 116: goto tr171;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr31:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st110;
st110:
	if ( ++p == pe )
		goto _test_eof110;
case 110:
#line 1959 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 97: goto tr179;
		case 116: goto tr171;
		case 4294967236: goto st38;
	}
	if ( (*p) < 98 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr32:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st111;
st111:
	if ( ++p == pe )
		goto _test_eof111;
case 111:
#line 2001 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 116: goto tr190;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr190:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st112;
st112:
	if ( ++p == pe )
		goto _test_eof112;
case 112:
#line 2038 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 104: goto tr181;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr33:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st113;
st113:
	if ( ++p == pe )
		goto _test_eof113;
case 113:
#line 2079 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 100: goto tr191;
		case 110: goto tr192;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr191:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st114;
st114:
	if ( ++p == pe )
		goto _test_eof114;
case 114:
#line 2117 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 100: goto tr171;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr192:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st115;
st115:
	if ( ++p == pe )
		goto _test_eof115;
case 115:
#line 2154 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 108: goto tr193;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr193:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st116;
st116:
	if ( ++p == pe )
		goto _test_eof116;
case 116:
#line 2191 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr59;
		case 92: goto st37;
		case 95: goto tr59;
		case 121: goto tr194;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
tr194:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st117;
st117:
	if ( ++p == pe )
		goto _test_eof117;
case 117:
#line 2228 "hpricot_css.c"
	switch( (*p) ) {
		case 40: goto tr167;
		case 45: goto tr195;
		case 92: goto st37;
		case 95: goto tr59;
		case 4294967236: goto st38;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr59;
		} else if ( (*p) >= 48 )
			goto tr59;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st39;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st41;
		} else
			goto st40;
	} else
		goto tr59;
	goto tr166;
st52:
	if ( ++p == pe )
		goto _test_eof52;
case 52:
	switch( (*p) ) {
		case 45: goto tr77;
		case 92: goto tr78;
		case 95: goto tr77;
		case 110: goto tr79;
		case 4294967236: goto tr80;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr77;
		} else if ( (*p) >= 48 )
			goto tr77;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto tr81;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto tr83;
		} else
			goto tr82;
	} else
		goto tr77;
	goto st0;
tr77:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st53;
tr86:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st53;
st53:
	if ( ++p == pe )
		goto _test_eof53;
case 53:
#line 2300 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto tr85;
		case 45: goto tr86;
		case 61: goto tr87;
		case 92: goto tr88;
		case 95: goto tr86;
		case 4294967236: goto st67;
	}
	if ( (*p) < 65 ) {
		if ( (*p) < 14 ) {
			if ( (*p) > 8 ) {
				if ( 9 <= (*p) && (*p) <= 13 )
					goto tr85;
			} else
				goto tr84;
		} else if ( (*p) > 47 ) {
			if ( (*p) > 57 ) {
				if ( 58 <= (*p) && (*p) <= 64 )
					goto tr84;
			} else if ( (*p) >= 48 )
				goto tr86;
		} else
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( (*p) < 123 ) {
			if ( (*p) > 96 ) {
				if ( 97 <= (*p) && (*p) <= 122 )
					goto tr86;
			} else if ( (*p) >= 91 )
				goto tr84;
		} else if ( (*p) > 127 ) {
			if ( (*p) < 4294967264 ) {
				if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
					goto st68;
			} else if ( (*p) > 4294967279 ) {
				if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
					goto st70;
			} else
				goto st69;
		} else
			goto tr84;
	} else
		goto tr86;
	goto st0;
tr84:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st54;
st54:
	if ( ++p == pe )
		goto _test_eof54;
case 54:
#line 2356 "hpricot_css.c"
	if ( (*p) == 61 )
		goto st55;
	goto st0;
st55:
	if ( ++p == pe )
		goto _test_eof55;
case 55:
	switch( (*p) ) {
		case 32: goto tr95;
		case 34: goto tr96;
		case 39: goto tr97;
		case 93: goto st0;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto tr95;
	goto tr94;
tr94:
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st56;
st56:
	if ( ++p == pe )
		goto _test_eof56;
case 56:
#line 2385 "hpricot_css.c"
	if ( (*p) == 93 )
		goto tr99;
	goto st56;
tr95:
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st57;
st57:
	if ( ++p == pe )
		goto _test_eof57;
case 57:
#line 2401 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto st57;
		case 34: goto st58;
		case 39: goto st61;
		case 93: goto tr99;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st57;
	goto st56;
tr96:
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st58;
st58:
	if ( ++p == pe )
		goto _test_eof58;
case 58:
#line 2423 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto st56;
		case 93: goto tr103;
	}
	goto st58;
tr103:
#line 1 "hpricot_css.rl"
	{te = p+1;}
	goto st118;
st118:
	if ( ++p == pe )
		goto _test_eof118;
case 118:
#line 2437 "hpricot_css.c"
	if ( (*p) == 34 )
		goto st60;
	goto st59;
st59:
	if ( ++p == pe )
		goto _test_eof59;
case 59:
	if ( (*p) == 34 )
		goto st60;
	goto st59;
st60:
	if ( ++p == pe )
		goto _test_eof60;
case 60:
	if ( (*p) == 93 )
		goto tr99;
	goto tr104;
tr97:
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st61;
st61:
	if ( ++p == pe )
		goto _test_eof61;
case 61:
#line 2467 "hpricot_css.c"
	switch( (*p) ) {
		case 39: goto st56;
		case 93: goto tr107;
	}
	goto st61;
tr107:
#line 1 "hpricot_css.rl"
	{te = p+1;}
	goto st119;
st119:
	if ( ++p == pe )
		goto _test_eof119;
case 119:
#line 2481 "hpricot_css.c"
	if ( (*p) == 39 )
		goto st60;
	goto st62;
st62:
	if ( ++p == pe )
		goto _test_eof62;
case 62:
	if ( (*p) == 39 )
		goto st60;
	goto st62;
tr85:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st63;
st63:
	if ( ++p == pe )
		goto _test_eof63;
case 63:
#line 2503 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto st63;
		case 61: goto st64;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st63;
	goto st54;
tr87:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st64;
st64:
	if ( ++p == pe )
		goto _test_eof64;
case 64:
#line 2522 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto tr95;
		case 34: goto tr96;
		case 39: goto tr97;
		case 61: goto tr112;
		case 93: goto st0;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto tr95;
	goto tr94;
tr112:
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st65;
st65:
	if ( ++p == pe )
		goto _test_eof65;
case 65:
#line 2545 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto tr95;
		case 34: goto tr96;
		case 39: goto tr97;
		case 93: goto tr99;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto tr95;
	goto tr94;
tr88:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st66;
st66:
	if ( ++p == pe )
		goto _test_eof66;
case 66:
#line 2566 "hpricot_css.c"
	switch( (*p) ) {
		case 46: goto st53;
		case 61: goto st55;
	}
	goto st0;
tr80:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st67;
st67:
	if ( ++p == pe )
		goto _test_eof67;
case 67:
#line 2582 "hpricot_css.c"
	if ( 4294967208 <= (*p) && (*p) <= 4294967231 )
		goto st53;
	goto st0;
tr81:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st68;
st68:
	if ( ++p == pe )
		goto _test_eof68;
case 68:
#line 2596 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st53;
	goto st0;
tr82:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st69;
st69:
	if ( ++p == pe )
		goto _test_eof69;
case 69:
#line 2610 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st68;
	goto st0;
tr83:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st70;
st70:
	if ( ++p == pe )
		goto _test_eof70;
case 70:
#line 2624 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st69;
	goto st0;
tr78:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st71;
st71:
	if ( ++p == pe )
		goto _test_eof71;
case 71:
#line 2638 "hpricot_css.c"
	if ( (*p) == 46 )
		goto st53;
	goto st0;
tr79:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st72;
st72:
	if ( ++p == pe )
		goto _test_eof72;
case 72:
#line 2652 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto tr85;
		case 45: goto tr86;
		case 61: goto tr87;
		case 92: goto tr88;
		case 95: goto tr86;
		case 97: goto tr114;
		case 4294967236: goto st67;
	}
	if ( (*p) < 65 ) {
		if ( (*p) < 14 ) {
			if ( (*p) > 8 ) {
				if ( 9 <= (*p) && (*p) <= 13 )
					goto tr85;
			} else
				goto tr84;
		} else if ( (*p) > 47 ) {
			if ( (*p) > 57 ) {
				if ( 58 <= (*p) && (*p) <= 64 )
					goto tr84;
			} else if ( (*p) >= 48 )
				goto tr86;
		} else
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( (*p) < 123 ) {
			if ( (*p) > 96 ) {
				if ( 98 <= (*p) && (*p) <= 122 )
					goto tr86;
			} else if ( (*p) >= 91 )
				goto tr84;
		} else if ( (*p) > 127 ) {
			if ( (*p) < 4294967264 ) {
				if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
					goto st68;
			} else if ( (*p) > 4294967279 ) {
				if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
					goto st70;
			} else
				goto st69;
		} else
			goto tr84;
	} else
		goto tr86;
	goto st0;
tr114:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st73;
st73:
	if ( ++p == pe )
		goto _test_eof73;
case 73:
#line 2709 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto tr85;
		case 45: goto tr86;
		case 61: goto tr87;
		case 92: goto tr88;
		case 95: goto tr86;
		case 109: goto tr115;
		case 4294967236: goto st67;
	}
	if ( (*p) < 65 ) {
		if ( (*p) < 14 ) {
			if ( (*p) > 8 ) {
				if ( 9 <= (*p) && (*p) <= 13 )
					goto tr85;
			} else
				goto tr84;
		} else if ( (*p) > 47 ) {
			if ( (*p) > 57 ) {
				if ( 58 <= (*p) && (*p) <= 64 )
					goto tr84;
			} else if ( (*p) >= 48 )
				goto tr86;
		} else
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( (*p) < 123 ) {
			if ( (*p) > 96 ) {
				if ( 97 <= (*p) && (*p) <= 122 )
					goto tr86;
			} else if ( (*p) >= 91 )
				goto tr84;
		} else if ( (*p) > 127 ) {
			if ( (*p) < 4294967264 ) {
				if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
					goto st68;
			} else if ( (*p) > 4294967279 ) {
				if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
					goto st70;
			} else
				goto st69;
		} else
			goto tr84;
	} else
		goto tr86;
	goto st0;
tr115:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st74;
st74:
	if ( ++p == pe )
		goto _test_eof74;
case 74:
#line 2766 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto tr85;
		case 45: goto tr86;
		case 61: goto tr87;
		case 92: goto tr88;
		case 95: goto tr86;
		case 101: goto tr116;
		case 4294967236: goto st67;
	}
	if ( (*p) < 65 ) {
		if ( (*p) < 14 ) {
			if ( (*p) > 8 ) {
				if ( 9 <= (*p) && (*p) <= 13 )
					goto tr85;
			} else
				goto tr84;
		} else if ( (*p) > 47 ) {
			if ( (*p) > 57 ) {
				if ( 58 <= (*p) && (*p) <= 64 )
					goto tr84;
			} else if ( (*p) >= 48 )
				goto tr86;
		} else
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( (*p) < 123 ) {
			if ( (*p) > 96 ) {
				if ( 97 <= (*p) && (*p) <= 122 )
					goto tr86;
			} else if ( (*p) >= 91 )
				goto tr84;
		} else if ( (*p) > 127 ) {
			if ( (*p) < 4294967264 ) {
				if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
					goto st68;
			} else if ( (*p) > 4294967279 ) {
				if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
					goto st70;
			} else
				goto st69;
		} else
			goto tr84;
	} else
		goto tr86;
	goto st0;
tr116:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st75;
st75:
	if ( ++p == pe )
		goto _test_eof75;
case 75:
#line 2823 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto tr85;
		case 45: goto tr86;
		case 61: goto tr117;
		case 92: goto tr88;
		case 95: goto tr86;
		case 4294967236: goto st67;
	}
	if ( (*p) < 65 ) {
		if ( (*p) < 14 ) {
			if ( (*p) > 8 ) {
				if ( 9 <= (*p) && (*p) <= 13 )
					goto tr85;
			} else
				goto tr84;
		} else if ( (*p) > 47 ) {
			if ( (*p) > 57 ) {
				if ( 58 <= (*p) && (*p) <= 64 )
					goto tr84;
			} else if ( (*p) >= 48 )
				goto tr86;
		} else
			goto tr84;
	} else if ( (*p) > 90 ) {
		if ( (*p) < 123 ) {
			if ( (*p) > 96 ) {
				if ( 97 <= (*p) && (*p) <= 122 )
					goto tr86;
			} else if ( (*p) >= 91 )
				goto tr84;
		} else if ( (*p) > 127 ) {
			if ( (*p) < 4294967264 ) {
				if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
					goto st68;
			} else if ( (*p) > 4294967279 ) {
				if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
					goto st70;
			} else
				goto st69;
		} else
			goto tr84;
	} else
		goto tr86;
	goto st0;
tr117:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st76;
st76:
	if ( ++p == pe )
		goto _test_eof76;
case 76:
#line 2879 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto tr95;
		case 34: goto tr96;
		case 39: goto tr97;
		case 45: goto tr118;
		case 61: goto tr112;
		case 91: goto tr94;
		case 92: goto tr119;
		case 95: goto tr118;
		case 4294967236: goto tr120;
	}
	if ( (*p) < 65 ) {
		if ( (*p) < 14 ) {
			if ( (*p) > 8 ) {
				if ( 9 <= (*p) && (*p) <= 13 )
					goto tr95;
			} else
				goto tr94;
		} else if ( (*p) > 47 ) {
			if ( (*p) > 57 ) {
				if ( 58 <= (*p) && (*p) <= 64 )
					goto tr94;
			} else if ( (*p) >= 48 )
				goto tr118;
		} else
			goto tr94;
	} else if ( (*p) > 90 ) {
		if ( (*p) < 123 ) {
			if ( (*p) > 96 ) {
				if ( 97 <= (*p) && (*p) <= 122 )
					goto tr118;
			} else if ( (*p) >= 94 )
				goto tr94;
		} else if ( (*p) > 127 ) {
			if ( (*p) < 4294967264 ) {
				if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
					goto tr121;
			} else if ( (*p) > 4294967279 ) {
				if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
					goto tr123;
			} else
				goto tr122;
		} else
			goto tr94;
	} else
		goto tr118;
	goto st0;
tr118:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st77;
st77:
	if ( ++p == pe )
		goto _test_eof77;
case 77:
#line 2943 "hpricot_css.c"
	switch( (*p) ) {
		case 45: goto st77;
		case 91: goto st56;
		case 92: goto st78;
		case 93: goto tr126;
		case 94: goto st56;
		case 96: goto st56;
		case 4294967236: goto st79;
	}
	if ( (*p) < 65 ) {
		if ( (*p) < 48 ) {
			if ( (*p) <= 47 )
				goto st56;
		} else if ( (*p) > 57 ) {
			if ( 58 <= (*p) && (*p) <= 64 )
				goto st56;
		} else
			goto st77;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967237 ) {
			if ( 123 <= (*p) )
				goto st56;
		} else if ( (*p) > 4294967263 ) {
			if ( (*p) > 4294967279 ) {
				if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
					goto st84;
			} else if ( (*p) >= 4294967264 )
				goto st83;
		} else
			goto st82;
	} else
		goto st77;
	goto st0;
tr119:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st78;
st78:
	if ( ++p == pe )
		goto _test_eof78;
case 78:
#line 2993 "hpricot_css.c"
	switch( (*p) ) {
		case 46: goto st77;
		case 93: goto tr99;
	}
	goto st56;
tr120:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st79;
st79:
	if ( ++p == pe )
		goto _test_eof79;
case 79:
#line 3009 "hpricot_css.c"
	if ( 4294967208 <= (*p) && (*p) <= 4294967231 )
		goto st80;
	goto st0;
st80:
	if ( ++p == pe )
		goto _test_eof80;
case 80:
	switch( (*p) ) {
		case 45: goto st80;
		case 92: goto st81;
		case 93: goto tr126;
		case 95: goto st80;
		case 4294967236: goto st79;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto st80;
		} else if ( (*p) >= 48 )
			goto st80;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st82;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st84;
		} else
			goto st83;
	} else
		goto st80;
	goto st0;
st81:
	if ( ++p == pe )
		goto _test_eof81;
case 81:
	if ( (*p) == 46 )
		goto st80;
	goto st0;
tr121:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st82;
st82:
	if ( ++p == pe )
		goto _test_eof82;
case 82:
#line 3059 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st80;
	goto st0;
tr122:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st83;
st83:
	if ( ++p == pe )
		goto _test_eof83;
case 83:
#line 3073 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st82;
	goto st0;
tr123:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st84;
st84:
	if ( ++p == pe )
		goto _test_eof84;
case 84:
#line 3087 "hpricot_css.c"
	if ( 4294967168 <= (*p) && (*p) <= 4294967231 )
		goto st83;
	goto st0;
tr143:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st120;
st120:
	if ( ++p == pe )
		goto _test_eof120;
case 120:
#line 3105 "hpricot_css.c"
	switch( (*p) ) {
		case 45: goto tr14;
		case 92: goto st8;
		case 95: goto tr14;
		case 118: goto tr197;
		case 4294967236: goto st9;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr14;
		} else if ( (*p) >= 48 )
			goto tr14;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st10;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st12;
		} else
			goto st11;
	} else
		goto tr14;
	goto tr156;
tr197:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st121;
st121:
	if ( ++p == pe )
		goto _test_eof121;
case 121:
#line 3141 "hpricot_css.c"
	switch( (*p) ) {
		case 45: goto tr14;
		case 92: goto st8;
		case 95: goto tr14;
		case 101: goto tr198;
		case 4294967236: goto st9;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr14;
		} else if ( (*p) >= 48 )
			goto tr14;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st10;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st12;
		} else
			goto st11;
	} else
		goto tr14;
	goto tr156;
tr198:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st122;
st122:
	if ( ++p == pe )
		goto _test_eof122;
case 122:
#line 3177 "hpricot_css.c"
	switch( (*p) ) {
		case 45: goto tr14;
		case 92: goto st8;
		case 95: goto tr14;
		case 4294967236: goto st9;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr14;
		} else if ( (*p) >= 48 )
			goto tr14;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st10;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st12;
		} else
			goto st11;
	} else
		goto tr14;
	goto tr156;
tr144:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st123;
st123:
	if ( ++p == pe )
		goto _test_eof123;
case 123:
#line 3216 "hpricot_css.c"
	switch( (*p) ) {
		case 45: goto tr14;
		case 92: goto st8;
		case 95: goto tr14;
		case 100: goto tr199;
		case 4294967236: goto st9;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr14;
		} else if ( (*p) >= 48 )
			goto tr14;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st10;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st12;
		} else
			goto st11;
	} else
		goto tr14;
	goto tr156;
tr199:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st124;
st124:
	if ( ++p == pe )
		goto _test_eof124;
case 124:
#line 3252 "hpricot_css.c"
	switch( (*p) ) {
		case 45: goto tr14;
		case 92: goto st8;
		case 95: goto tr14;
		case 4294967236: goto st9;
	}
	if ( (*p) < 97 ) {
		if ( (*p) > 57 ) {
			if ( 65 <= (*p) && (*p) <= 90 )
				goto tr14;
		} else if ( (*p) >= 48 )
			goto tr14;
	} else if ( (*p) > 122 ) {
		if ( (*p) < 4294967264 ) {
			if ( 4294967237 <= (*p) && (*p) <= 4294967263 )
				goto st10;
		} else if ( (*p) > 4294967279 ) {
			if ( 4294967280 <= (*p) && (*p) <= 4294967284 )
				goto st12;
		} else
			goto st11;
	} else
		goto tr14;
	goto tr156;
	}
	_test_eof85: cs = 85; goto _test_eof; 
	_test_eof86: cs = 86; goto _test_eof; 
	_test_eof1: cs = 1; goto _test_eof; 
	_test_eof87: cs = 87; goto _test_eof; 
	_test_eof2: cs = 2; goto _test_eof; 
	_test_eof88: cs = 88; goto _test_eof; 
	_test_eof3: cs = 3; goto _test_eof; 
	_test_eof4: cs = 4; goto _test_eof; 
	_test_eof5: cs = 5; goto _test_eof; 
	_test_eof6: cs = 6; goto _test_eof; 
	_test_eof7: cs = 7; goto _test_eof; 
	_test_eof89: cs = 89; goto _test_eof; 
	_test_eof90: cs = 90; goto _test_eof; 
	_test_eof91: cs = 91; goto _test_eof; 
	_test_eof8: cs = 8; goto _test_eof; 
	_test_eof9: cs = 9; goto _test_eof; 
	_test_eof10: cs = 10; goto _test_eof; 
	_test_eof11: cs = 11; goto _test_eof; 
	_test_eof12: cs = 12; goto _test_eof; 
	_test_eof13: cs = 13; goto _test_eof; 
	_test_eof92: cs = 92; goto _test_eof; 
	_test_eof14: cs = 14; goto _test_eof; 
	_test_eof15: cs = 15; goto _test_eof; 
	_test_eof16: cs = 16; goto _test_eof; 
	_test_eof17: cs = 17; goto _test_eof; 
	_test_eof18: cs = 18; goto _test_eof; 
	_test_eof19: cs = 19; goto _test_eof; 
	_test_eof93: cs = 93; goto _test_eof; 
	_test_eof20: cs = 20; goto _test_eof; 
	_test_eof21: cs = 21; goto _test_eof; 
	_test_eof22: cs = 22; goto _test_eof; 
	_test_eof23: cs = 23; goto _test_eof; 
	_test_eof24: cs = 24; goto _test_eof; 
	_test_eof25: cs = 25; goto _test_eof; 
	_test_eof26: cs = 26; goto _test_eof; 
	_test_eof27: cs = 27; goto _test_eof; 
	_test_eof28: cs = 28; goto _test_eof; 
	_test_eof29: cs = 29; goto _test_eof; 
	_test_eof30: cs = 30; goto _test_eof; 
	_test_eof31: cs = 31; goto _test_eof; 
	_test_eof32: cs = 32; goto _test_eof; 
	_test_eof33: cs = 33; goto _test_eof; 
	_test_eof34: cs = 34; goto _test_eof; 
	_test_eof35: cs = 35; goto _test_eof; 
	_test_eof36: cs = 36; goto _test_eof; 
	_test_eof37: cs = 37; goto _test_eof; 
	_test_eof38: cs = 38; goto _test_eof; 
	_test_eof39: cs = 39; goto _test_eof; 
	_test_eof40: cs = 40; goto _test_eof; 
	_test_eof41: cs = 41; goto _test_eof; 
	_test_eof94: cs = 94; goto _test_eof; 
	_test_eof95: cs = 95; goto _test_eof; 
	_test_eof42: cs = 42; goto _test_eof; 
	_test_eof43: cs = 43; goto _test_eof; 
	_test_eof96: cs = 96; goto _test_eof; 
	_test_eof97: cs = 97; goto _test_eof; 
	_test_eof98: cs = 98; goto _test_eof; 
	_test_eof99: cs = 99; goto _test_eof; 
	_test_eof100: cs = 100; goto _test_eof; 
	_test_eof101: cs = 101; goto _test_eof; 
	_test_eof102: cs = 102; goto _test_eof; 
	_test_eof103: cs = 103; goto _test_eof; 
	_test_eof104: cs = 104; goto _test_eof; 
	_test_eof105: cs = 105; goto _test_eof; 
	_test_eof106: cs = 106; goto _test_eof; 
	_test_eof107: cs = 107; goto _test_eof; 
	_test_eof108: cs = 108; goto _test_eof; 
	_test_eof44: cs = 44; goto _test_eof; 
	_test_eof45: cs = 45; goto _test_eof; 
	_test_eof46: cs = 46; goto _test_eof; 
	_test_eof47: cs = 47; goto _test_eof; 
	_test_eof48: cs = 48; goto _test_eof; 
	_test_eof49: cs = 49; goto _test_eof; 
	_test_eof50: cs = 50; goto _test_eof; 
	_test_eof51: cs = 51; goto _test_eof; 
	_test_eof109: cs = 109; goto _test_eof; 
	_test_eof110: cs = 110; goto _test_eof; 
	_test_eof111: cs = 111; goto _test_eof; 
	_test_eof112: cs = 112; goto _test_eof; 
	_test_eof113: cs = 113; goto _test_eof; 
	_test_eof114: cs = 114; goto _test_eof; 
	_test_eof115: cs = 115; goto _test_eof; 
	_test_eof116: cs = 116; goto _test_eof; 
	_test_eof117: cs = 117; goto _test_eof; 
	_test_eof52: cs = 52; goto _test_eof; 
	_test_eof53: cs = 53; goto _test_eof; 
	_test_eof54: cs = 54; goto _test_eof; 
	_test_eof55: cs = 55; goto _test_eof; 
	_test_eof56: cs = 56; goto _test_eof; 
	_test_eof57: cs = 57; goto _test_eof; 
	_test_eof58: cs = 58; goto _test_eof; 
	_test_eof118: cs = 118; goto _test_eof; 
	_test_eof59: cs = 59; goto _test_eof; 
	_test_eof60: cs = 60; goto _test_eof; 
	_test_eof61: cs = 61; goto _test_eof; 
	_test_eof119: cs = 119; goto _test_eof; 
	_test_eof62: cs = 62; goto _test_eof; 
	_test_eof63: cs = 63; goto _test_eof; 
	_test_eof64: cs = 64; goto _test_eof; 
	_test_eof65: cs = 65; goto _test_eof; 
	_test_eof66: cs = 66; goto _test_eof; 
	_test_eof67: cs = 67; goto _test_eof; 
	_test_eof68: cs = 68; goto _test_eof; 
	_test_eof69: cs = 69; goto _test_eof; 
	_test_eof70: cs = 70; goto _test_eof; 
	_test_eof71: cs = 71; goto _test_eof; 
	_test_eof72: cs = 72; goto _test_eof; 
	_test_eof73: cs = 73; goto _test_eof; 
	_test_eof74: cs = 74; goto _test_eof; 
	_test_eof75: cs = 75; goto _test_eof; 
	_test_eof76: cs = 76; goto _test_eof; 
	_test_eof77: cs = 77; goto _test_eof; 
	_test_eof78: cs = 78; goto _test_eof; 
	_test_eof79: cs = 79; goto _test_eof; 
	_test_eof80: cs = 80; goto _test_eof; 
	_test_eof81: cs = 81; goto _test_eof; 
	_test_eof82: cs = 82; goto _test_eof; 
	_test_eof83: cs = 83; goto _test_eof; 
	_test_eof84: cs = 84; goto _test_eof; 
	_test_eof120: cs = 120; goto _test_eof; 
	_test_eof121: cs = 121; goto _test_eof; 
	_test_eof122: cs = 122; goto _test_eof; 
	_test_eof123: cs = 123; goto _test_eof; 
	_test_eof124: cs = 124; goto _test_eof; 

	_test_eof: {}
	if ( p == eof )
	{
	switch ( cs ) {
	case 86: goto tr149;
	case 1: goto tr0;
	case 87: goto tr150;
	case 88: goto tr151;
	case 3: goto tr10;
	case 4: goto tr10;
	case 5: goto tr10;
	case 6: goto tr10;
	case 7: goto tr10;
	case 89: goto tr155;
	case 90: goto tr156;
	case 91: goto tr156;
	case 8: goto tr10;
	case 9: goto tr10;
	case 10: goto tr10;
	case 11: goto tr10;
	case 12: goto tr10;
	case 92: goto tr162;
	case 14: goto tr10;
	case 15: goto tr10;
	case 16: goto tr10;
	case 17: goto tr10;
	case 18: goto tr10;
	case 93: goto tr166;
	case 20: goto tr38;
	case 21: goto tr10;
	case 22: goto tr10;
	case 23: goto tr10;
	case 24: goto tr10;
	case 25: goto tr10;
	case 26: goto tr10;
	case 27: goto tr10;
	case 28: goto tr10;
	case 29: goto tr10;
	case 30: goto tr10;
	case 31: goto tr10;
	case 32: goto tr10;
	case 33: goto tr10;
	case 34: goto tr10;
	case 35: goto tr10;
	case 36: goto tr10;
	case 37: goto tr10;
	case 38: goto tr10;
	case 39: goto tr10;
	case 40: goto tr10;
	case 41: goto tr10;
	case 94: goto tr166;
	case 95: goto tr173;
	case 42: goto tr62;
	case 43: goto tr62;
	case 96: goto tr166;
	case 97: goto tr166;
	case 98: goto tr166;
	case 99: goto tr166;
	case 100: goto tr166;
	case 101: goto tr166;
	case 102: goto tr173;
	case 103: goto tr166;
	case 104: goto tr166;
	case 105: goto tr166;
	case 106: goto tr166;
	case 107: goto tr166;
	case 108: goto tr188;
	case 44: goto tr66;
	case 45: goto tr66;
	case 46: goto tr66;
	case 47: goto tr66;
	case 48: goto tr66;
	case 49: goto tr66;
	case 50: goto tr66;
	case 51: goto tr66;
	case 109: goto tr166;
	case 110: goto tr166;
	case 111: goto tr166;
	case 112: goto tr166;
	case 113: goto tr166;
	case 114: goto tr166;
	case 115: goto tr166;
	case 116: goto tr166;
	case 117: goto tr166;
	case 118: goto tr196;
	case 59: goto tr104;
	case 60: goto tr104;
	case 119: goto tr196;
	case 62: goto tr104;
	case 120: goto tr156;
	case 121: goto tr156;
	case 122: goto tr156;
	case 123: goto tr156;
	case 124: goto tr156;
	}
	}

	_out: {}
	}
#line 111 "hpricot_css.rl"
  
  rb_gc_unregister_address(&focus);
  rb_gc_unregister_address(&tmpt);
  return focus;
}

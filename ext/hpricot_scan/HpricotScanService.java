
// line 1 "hpricot_scan.java.rl"

import java.io.IOException;

import org.jruby.Ruby;
import org.jruby.RubyArray;
import org.jruby.RubyClass;
import org.jruby.RubyHash;
import org.jruby.RubyModule;
import org.jruby.RubyNumeric;
import org.jruby.RubyObject;
import org.jruby.RubyObjectAdapter;
import org.jruby.RubyRegexp;
import org.jruby.RubyString;
import org.jruby.anno.JRubyMethod;
import org.jruby.exceptions.RaiseException;
import org.jruby.javasupport.JavaEmbedUtils;
import org.jruby.runtime.Arity;
import org.jruby.runtime.Block;
import org.jruby.runtime.ObjectAllocator;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.runtime.callback.Callback;
import org.jruby.exceptions.RaiseException;
import org.jruby.runtime.load.BasicLibraryService;
import org.jruby.util.ByteList;

public class HpricotScanService implements BasicLibraryService {
    public static byte[] realloc(byte[] input, int size) {
        byte[] newArray = new byte[size];
        System.arraycopy(input, 0, newArray, 0, input.length);
        return newArray;
    }

    // hpricot_state
    public static class State {
        public IRubyObject doc;
        public IRubyObject focus;
        public IRubyObject last;
        public IRubyObject EC;
        public boolean xml, strict, fixup;
    }

    static boolean OPT(IRubyObject opts, String key) {
        Ruby runtime = opts.getRuntime();
        return !opts.isNil() && ((RubyHash)opts).op_aref(runtime.getCurrentContext(), runtime.newSymbol(key)).isTrue();
    }

    // H_PROP(name, H_ELE_TAG)
    public static IRubyObject hpricot_ele_set_name(IRubyObject self, IRubyObject x) {
        H_ELE_SET(self, H_ELE_TAG, x);
        return self;
    }

    public static IRubyObject hpricot_ele_clear_name(IRubyObject self) {
        H_ELE_SET(self, H_ELE_TAG, self.getRuntime().getNil());
        return self.getRuntime().getTrue();
    }

    public static IRubyObject hpricot_ele_get_name(IRubyObject self) {
        return H_ELE_GET(self, H_ELE_TAG);
    }

    // H_PROP(raw, H_ELE_RAW)
    public static IRubyObject hpricot_ele_set_raw(IRubyObject self, IRubyObject x) {
        H_ELE_SET(self, H_ELE_RAW, x);
        return self;
    }

    public static IRubyObject hpricot_ele_clear_raw(IRubyObject self) {
        H_ELE_SET(self, H_ELE_RAW, self.getRuntime().getNil());
        return self.getRuntime().getTrue();
    }

    public static IRubyObject hpricot_ele_get_raw(IRubyObject self) {
        return H_ELE_GET(self, H_ELE_RAW);
    }

    // H_PROP(parent, H_ELE_PARENT)
    public static IRubyObject hpricot_ele_set_parent(IRubyObject self, IRubyObject x) {
        H_ELE_SET(self, H_ELE_PARENT, x);
        return self;
    }

    public static IRubyObject hpricot_ele_clear_parent(IRubyObject self) {
        H_ELE_SET(self, H_ELE_PARENT, self.getRuntime().getNil());
        return self.getRuntime().getTrue();
    }

    public static IRubyObject hpricot_ele_get_parent(IRubyObject self) {
        return H_ELE_GET(self, H_ELE_PARENT);
    }

    // H_PROP(attr, H_ELE_ATTR)
    public static IRubyObject hpricot_ele_set_attr(IRubyObject self, IRubyObject x) {
        H_ELE_SET(self, H_ELE_ATTR, x);
        return self;
    }

    public static IRubyObject hpricot_ele_clear_attr(IRubyObject self) {
        H_ELE_SET(self, H_ELE_ATTR, self.getRuntime().getNil());
        return self.getRuntime().getTrue();
    }

    public static IRubyObject hpricot_ele_get_attr(IRubyObject self) {
        return H_ELE_GET(self, H_ELE_ATTR);
    }

    // H_PROP(etag, H_ELE_ETAG)
    public static IRubyObject hpricot_ele_set_etag(IRubyObject self, IRubyObject x) {
        H_ELE_SET(self, H_ELE_ETAG, x);
        return self;
    }

    public static IRubyObject hpricot_ele_clear_etag(IRubyObject self) {
        H_ELE_SET(self, H_ELE_ETAG, self.getRuntime().getNil());
        return self.getRuntime().getTrue();
    }

    public static IRubyObject hpricot_ele_get_etag(IRubyObject self) {
        return H_ELE_GET(self, H_ELE_ETAG);
    }

    // H_PROP(children, H_ELE_CHILDREN)
    public static IRubyObject hpricot_ele_set_children(IRubyObject self, IRubyObject x) {
        H_ELE_SET(self, H_ELE_CHILDREN, x);
        return self;
    }

    public static IRubyObject hpricot_ele_clear_children(IRubyObject self) {
        H_ELE_SET(self, H_ELE_CHILDREN, self.getRuntime().getNil());
        return self.getRuntime().getTrue();
    }

    public static IRubyObject hpricot_ele_get_children(IRubyObject self) {
        return H_ELE_GET(self, H_ELE_CHILDREN);
    }

    // H_ATTR(target)
    public static IRubyObject hpricot_ele_set_target(IRubyObject self, IRubyObject x) {
        H_ELE_GET_asHash(self, H_ELE_ATTR).fastASet(self.getRuntime().newSymbol("target"), x);
        return self;
    }

    public static IRubyObject hpricot_ele_get_target(IRubyObject self) {
        return H_ELE_GET_asHash(self, H_ELE_ATTR).op_aref(self.getRuntime().getCurrentContext(), self.getRuntime().newSymbol("target"));
    }

    // H_ATTR(encoding)
    public static IRubyObject hpricot_ele_set_encoding(IRubyObject self, IRubyObject x) {
        ((RubyHash)H_ELE_GET_asHash(self, H_ELE_ATTR)).fastASet(self.getRuntime().newSymbol("encoding"), x);
        return self;
    }

    public static IRubyObject hpricot_ele_get_encoding(IRubyObject self) {
        return ((RubyHash)H_ELE_GET_asHash(self, H_ELE_ATTR)).op_aref(self.getRuntime().getCurrentContext(), self.getRuntime().newSymbol("encoding"));
    }

    // H_ATTR(version)
    public static IRubyObject hpricot_ele_set_version(IRubyObject self, IRubyObject x) {
        ((RubyHash)H_ELE_GET_asHash(self, H_ELE_ATTR)).fastASet(self.getRuntime().newSymbol("version"), x);
        return self;
    }

    public static IRubyObject hpricot_ele_get_version(IRubyObject self) {
        return ((RubyHash)H_ELE_GET_asHash(self, H_ELE_ATTR)).op_aref(self.getRuntime().getCurrentContext(), self.getRuntime().newSymbol("version"));
    }

    // H_ATTR(standalone)
    public static IRubyObject hpricot_ele_set_standalone(IRubyObject self, IRubyObject x) {
        ((RubyHash)H_ELE_GET_asHash(self, H_ELE_ATTR)).fastASet(self.getRuntime().newSymbol("standalone"), x);
        return self;
    }

    public static IRubyObject hpricot_ele_get_standalone(IRubyObject self) {
        return ((RubyHash)H_ELE_GET_asHash(self, H_ELE_ATTR)).op_aref(self.getRuntime().getCurrentContext(), self.getRuntime().newSymbol("standalone"));
    }

    // H_ATTR(system_id)
    public static IRubyObject hpricot_ele_set_system_id(IRubyObject self, IRubyObject x) {
        ((RubyHash)H_ELE_GET_asHash(self, H_ELE_ATTR)).fastASet(self.getRuntime().newSymbol("system_id"), x);
        return self;
    }

    public static IRubyObject hpricot_ele_get_system_id(IRubyObject self) {
        return ((RubyHash)H_ELE_GET_asHash(self, H_ELE_ATTR)).op_aref(self.getRuntime().getCurrentContext(), self.getRuntime().newSymbol("system_id"));
    }

    // H_ATTR(public_id)
    public static IRubyObject hpricot_ele_set_public_id(IRubyObject self, IRubyObject x) {
        ((RubyHash)H_ELE_GET_asHash(self, H_ELE_ATTR)).fastASet(self.getRuntime().newSymbol("public_id"), x);
        return self;
    }

    public static IRubyObject hpricot_ele_get_public_id(IRubyObject self) {
        return ((RubyHash)H_ELE_GET_asHash(self, H_ELE_ATTR)).op_aref(self.getRuntime().getCurrentContext(), self.getRuntime().newSymbol("public_id"));
    }

    public static class Scanner {
        public IRubyObject SET(int mark, int E, IRubyObject org) {
            if(mark == -1 || E == mark) {
                return runtime.newString("");
            } else if(E > mark) {
                return RubyString.newString(runtime, data, mark, E-mark);
            } else {
                return org;
            }
        }

        public int SLIDE(int N) {
            if(N > ts) {
                return N - ts;
            } else {
                return N;
            }
        }

        public IRubyObject CAT(IRubyObject N, int mark, int E) {
            if(N.isNil()) {
                return SET(mark, E, N);
            } else {
                ((RubyString)N).cat(data, mark, E-mark);
                return N;
            }
        }

        public void ATTR(IRubyObject K, IRubyObject V) {
            if(!K.isNil()) {
                if(attr.isNil()) {
                    attr = RubyHash.newHash(runtime);
                }
                ((RubyHash)attr).fastASet(K, V);
            }
        }

        public void TEXT_PASS() {
            if(!text) {
                if(ele_open) {
                    ele_open = false;
                    if(ts != -1) {
                        mark_tag = ts;
                    }
                } else {
                    mark_tag = p;
                }
                attr = runtime.getNil();
                tag = runtime.getNil();
                text = true;
            }
        }

        public void ELE(IRubyObject N) {
            if(te > ts || text) {
                int raw = -1;
                int rawlen = 0;
                ele_open = false;
                text = false;

                if(ts != -1 && N != x.sym_cdata && N != x.sym_text && N != x.sym_procins && N != x.sym_comment) {
                    raw = ts;
                    rawlen = te - ts;
                }

                if(block.isGiven()) {
                    IRubyObject raw_string = runtime.getNil();
                    if(raw != -1) {
                        raw_string = RubyString.newString(runtime, data, raw, rawlen);
                    }
                    yieldTokens(N, tag, attr, runtime.getNil(), taint);
                } else {
                    hpricotToken(S, N, tag, attr, raw, rawlen, taint);
                }
            }
        }


        public void EBLK(IRubyObject N, int T) {
            tag = CAT(tag, mark_tag, p - T + 1);
            ELE(N);
        }

        public void hpricotAdd(IRubyObject focus, IRubyObject ele) {
            IRubyObject children = H_ELE_GET(focus, H_ELE_CHILDREN);
            if(children.isNil()) {
                H_ELE_SET(focus, H_ELE_CHILDREN, children = RubyArray.newArray(runtime, 1));
            }
            ((RubyArray)children).append(ele);
            H_ELE_SET(ele, H_ELE_PARENT, focus);
        }

        private static class TokenInfo {
            public IRubyObject sym;
            public IRubyObject tag;
            public IRubyObject attr;
            public int raw;
            public int rawlen;
            public IRubyObject ec;
            public IRubyObject ele;
            public Extra x;
            public Ruby runtime;
            public Scanner scanner;
            public State S;

            public void H_ELE(RubyClass klass) {
                ele = klass.allocate();
                if(klass == x.cElem) {
                    H_ELE_SET(ele, H_ELE_TAG, tag);
                    H_ELE_SET(ele, H_ELE_ATTR, attr);
                    H_ELE_SET(ele, H_ELE_EC, ec);
                    if(raw != -1 && (sym == x.sym_emptytag || sym == x.sym_stag || sym == x.sym_doctype)) {
                        H_ELE_SET(ele, H_ELE_RAW, RubyString.newString(runtime, scanner.data, raw, rawlen));
                    }
                } else if(klass == x.cDocType || klass == x.cProcIns || klass == x.cXMLDecl || klass == x.cBogusETag) {
                    if(klass == x.cBogusETag) {
                        H_ELE_SET(ele, H_ELE_TAG, tag);
                        if(raw != -1) {
                            H_ELE_SET(ele, H_ELE_ATTR, RubyString.newString(runtime, scanner.data, raw, rawlen));
                        }
                    } else {
                        if(klass == x.cDocType) {
                            scanner.ATTR(runtime.newSymbol("target"), tag);
                        }
                        H_ELE_SET(ele, H_ELE_ATTR, attr);
                        if(klass != x.cProcIns) {
                            tag = runtime.getNil();
                            if(raw != -1) {
                                tag = RubyString.newString(runtime, scanner.data, raw, rawlen);
                            }
                        }
                        H_ELE_SET(ele, H_ELE_TAG, tag);
                    }
                } else {
                    H_ELE_SET(ele, H_ELE_TAG, tag);
                }
                S.last = ele;
            }

            public void hpricotToken(boolean taint) {
                //
                // in html mode, fix up start tags incorrectly formed as empty tags
                //
                if(!S.xml) {
                    if(sym == x.sym_emptytag || sym == x.sym_stag || sym == x.sym_etag) {
                        ec = ((RubyHash)S.EC).op_aref(scanner.ctx, tag);
                        if(ec.isNil()) {
                            tag = tag.callMethod(scanner.ctx, "downcase");
                            ec = ((RubyHash)S.EC).op_aref(scanner.ctx, tag);
                        }
                    }

                    if(H_ELE_GET(S.focus, H_ELE_EC) == x.sym_CDATA &&
                       (sym != x.sym_procins && sym != x.sym_comment && sym != x.sym_cdata && sym != x.sym_text) &&
                       !(sym == x.sym_etag && runtime.newFixnum(tag.hashCode()).equals(H_ELE_GET(S.focus, H_ELE_HASH)))) {
                        sym = x.sym_text;
                        tag = RubyString.newString(runtime, scanner.data, raw, rawlen);
                    }

                    if(!ec.isNil()) {
                        if(sym == x.sym_emptytag) {
                            if(ec != x.sym_EMPTY) {
                                sym = x.sym_stag;
                            }
                        } else if(sym == x.sym_stag) {
                            if(ec == x.sym_EMPTY) {
                                sym = x.sym_emptytag;
                            }
                        }
                    }
                }

                if(sym == x.sym_emptytag || sym == x.sym_stag) {
                    IRubyObject name = runtime.newFixnum(tag.hashCode());
                    H_ELE(x.cElem);
                    H_ELE_SET(ele, H_ELE_HASH, name);

                    if(!S.xml) {
                        IRubyObject match = runtime.getNil(), e = S.focus;
                        while(e != S.doc) {
                            if (ec.isNil()) {
                                // Anything can contain an unknown element
                                if(match.isNil()) {
                                    match = e;
                                }
                            } else {
                                IRubyObject hEC = H_ELE_GET(e, H_ELE_EC);
                                if(hEC instanceof RubyHash) {
                                    IRubyObject has = ((RubyHash)hEC).op_aref(scanner.ctx, name);
                                    if(!has.isNil()) {
                                        if(has == runtime.getTrue()) {
                                            if(match.isNil()) {
                                                match = e;
                                            }
                                        } else if(has == x.symAllow) {
                                            match = S.focus;
                                        } else if(has == x.symDeny) {
                                            match = runtime.getNil();
                                        }
                                    }
                                } else {
                                    // Unknown elements can contain anything
                                    if(match.isNil()) {
                                        match = e;
                                    }
                                }
                            }
                            e = H_ELE_GET(e, H_ELE_PARENT);
                        }

                        if(match.isNil()) {
                            match = S.focus;
                        }
                        S.focus = match;
                    }

                    scanner.hpricotAdd(S.focus, ele);

                    //
                    // in the case of a start tag that should be empty, just
                    // skip the step that focuses the element.  focusing moves
                    // us deeper into the document.
                    //
                    if(sym == x.sym_stag) {
                        if(S.xml || ec != x.sym_EMPTY) {
                            S.focus = ele;
                            S.last = runtime.getNil();
                        }
                    }
                } else if(sym == x.sym_etag) {
                    IRubyObject name, match = runtime.getNil(), e = S.focus;
                    if(S.strict) {
                        if(((RubyHash)S.EC).op_aref(scanner.ctx, tag).isNil()) {
                            tag = runtime.newString("div");
                        }
                    }

                    name = runtime.newFixnum(tag.hashCode());
                    while(e != S.doc) {
                        if(H_ELE_GET(e, H_ELE_HASH).equals(name)) {
                            match = e;
                            break;
                        }
                        e = H_ELE_GET(e, H_ELE_PARENT);

                    }
                    if(match.isNil()) {
                        H_ELE(x.cBogusETag);
                        scanner.hpricotAdd(S.focus, ele);
                    } else {
                        ele = runtime.getNil();
                        if(raw != -1) {
                            ele = RubyString.newString(runtime, scanner.data, raw, rawlen);
                        }
                        H_ELE_SET(match, H_ELE_ETAG, ele);
                        S.focus = H_ELE_GET(match, H_ELE_PARENT);
                        S.last = runtime.getNil();

                    }
                } else if(sym == x.sym_cdata) {
                    H_ELE(x.cCData);
                    scanner.hpricotAdd(S.focus, ele);
                } else if(sym == x.sym_comment) {
                    H_ELE(x.cComment);
                    scanner.hpricotAdd(S.focus, ele);
                } else if(sym == x.sym_doctype) {
                    H_ELE(x.cDocType);
                    if(S.strict) {
                        RubyHash h = (RubyHash)attr;
                        h.fastASet(runtime.newSymbol("system_id"), runtime.newString("http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"));
                        h.fastASet(runtime.newSymbol("public_id"), runtime.newString("-//W3C//DTD XHTML 1.0 Strict//EN"));
                    }
                    scanner.hpricotAdd(S.focus, ele);
                } else if(sym == x.sym_procins) {
                    IRubyObject match = tag.callMethod(scanner.ctx, "match", x.reProcInsParse);
                    tag = RubyRegexp.nth_match(1, match);
                    attr = RubyRegexp.nth_match(2, match);
                    H_ELE(x.cProcIns);
                    scanner.hpricotAdd(S.focus, ele);
                } else if(sym == x.sym_text) {
                    if(!S.last.isNil() && S.last.getType() == x.cText) {
                        ((RubyString)H_ELE_GET(S.last, H_ELE_TAG)).append(tag);
                    } else {
                        H_ELE(x.cText);
                        scanner.hpricotAdd(S.focus, ele);
                    }
                } else if(sym == x.sym_xmldecl) {
                    H_ELE(x.cXMLDecl);
                    scanner.hpricotAdd(S.focus, ele);
                }
            }
        }

        public void hpricotToken(State S, IRubyObject _sym, IRubyObject _tag, IRubyObject _attr, int _raw, int _rawlen, boolean taint) {
            TokenInfo t = new TokenInfo();
            t.sym = _sym;
            t.tag = _tag;
            t.attr = _attr;
            t.raw = _raw;
            t.rawlen = _rawlen;
            t.ec = runtime.getNil();
            t.ele = runtime.getNil();
            t.x = x;
            t.runtime = runtime;
            t.scanner = this;
            t.S = S;

            t.hpricotToken(taint);
        }

        public void yieldTokens(IRubyObject sym, IRubyObject tag, IRubyObject attr, IRubyObject raw, boolean taint) {
            if(sym == x.sym_text) {
                raw = tag;
            }
            IRubyObject ary = RubyArray.newArrayNoCopy(runtime, new IRubyObject[]{sym, tag, attr, raw});
            if(taint) {
                ary.setTaint(true);
                tag.setTaint(true);
                attr.setTaint(true);
                raw.setTaint(true);
            }

            block.yield(ctx, ary);
        }


// line 573 "hpricot_scan.java.rl"



// line 531 "HpricotScanService.java"
private static byte[] init__hpricot_scan_actions_0()
{
	return new byte [] {
	    0,    1,    1,    1,    2,    1,    4,    1,    5,    1,    6,    1,
	    7,    1,    8,    1,    9,    1,   10,    1,   11,    1,   12,    1,
	   14,    1,   16,    1,   20,    1,   21,    1,   22,    1,   24,    1,
	   25,    1,   26,    1,   28,    1,   29,    1,   30,    1,   32,    1,
	   33,    1,   38,    1,   39,    1,   40,    1,   41,    1,   42,    1,
	   43,    1,   44,    1,   45,    1,   46,    1,   47,    1,   48,    1,
	   49,    1,   50,    1,   51,    2,    2,    5,    2,    2,    6,    2,
	    2,   11,    2,    2,   12,    2,    2,   14,    2,    4,   39,    2,
	    4,   40,    2,    4,   41,    2,    5,    2,    2,    6,   14,    2,
	    7,    6,    2,    7,   14,    2,   11,   12,    2,   13,    3,    2,
	   14,    6,    2,   14,   40,    2,   15,   24,    2,   15,   28,    2,
	   15,   32,    2,   15,   45,    2,   17,   23,    2,   18,   27,    2,
	   19,   31,    2,   22,   34,    2,   22,   36,    3,    2,    6,   14,
	    3,    2,   14,    6,    3,    6,    7,   14,    3,    6,   14,   40,
	    3,    7,   14,   40,    3,   11,    2,   12,    3,   14,    6,   40,
	    3,   14,   13,    3,    3,   22,    0,   37,    3,   22,    2,   34,
	    3,   22,   14,   35,    4,    2,   14,   13,    3,    4,    6,    7,
	   14,   40,    4,   22,    2,   14,   35,    4,   22,    6,   14,   35,
	    4,   22,    7,   14,   35,    4,   22,   14,    6,   35,    5,   22,
	    2,    6,   14,   35,    5,   22,    2,   14,    6,   35,    5,   22,
	    6,    7,   14,   35
	};
}

private static final byte _hpricot_scan_actions[] = init__hpricot_scan_actions_0();


private static short[] init__hpricot_scan_key_offsets_0()
{
	return new short [] {
	    0,    3,    4,    5,    6,    7,    8,    9,   10,   13,   22,   37,
	   44,   45,   46,   47,   48,   49,   52,   57,   69,   81,   86,   93,
	   94,   95,  100,  101,  105,  106,  107,  121,  135,  152,  169,  186,
	  203,  210,  212,  214,  220,  222,  227,  232,  238,  240,  245,  251,
	  265,  266,  267,  268,  269,  270,  271,  272,  273,  274,  275,  276,
	  282,  296,  300,  313,  326,  340,  354,  355,  366,  375,  388,  405,
	  423,  441,  450,  461,  480,  499,  509,  519,  533,  534,  549,  564,
	  566,  577,  588,  607,  626,  644,  662,  681,  700,  710,  721,  732,
	  743,  758,  760,  774,  775,  790,  805,  807,  818,  828,  846,  865,
	  884,  894,  905,  924,  943,  954,  973,  993, 1009, 1025, 1028, 1039,
	 1050, 1069, 1088, 1107, 1118, 1137, 1152, 1167, 1178, 1198, 1216, 1218,
	 1232, 1243, 1257, 1259, 1269, 1270, 1271, 1282, 1289, 1302, 1316, 1330,
	 1343, 1344, 1345, 1346, 1347, 1348, 1349, 1353, 1358, 1367, 1377, 1382,
	 1389, 1390, 1391, 1392, 1393, 1394, 1395, 1396, 1397, 1401, 1406, 1410,
	 1420, 1425, 1431, 1432, 1433, 1434, 1435, 1436, 1437, 1438, 1439, 1440,
	 1444, 1449, 1451, 1452, 1453, 1458, 1459, 1460, 1462, 1463, 1464, 1465,
	 1466, 1470, 1480, 1489, 1499, 1500, 1501, 1503, 1512, 1513, 1514, 1515,
	 1516, 1517, 1519, 1522, 1526, 1528, 1529, 1531, 1532, 1535
	};
}

private static final short _hpricot_scan_key_offsets[] = init__hpricot_scan_key_offsets_0();


private static char[] init__hpricot_scan_trans_keys_0()
{
	return new char [] {
	   45,   68,   91,   45,   79,   67,   84,   89,   80,   69,   32,    9,
	   13,   32,   58,   95,    9,   13,   65,   90,   97,  122,   32,   62,
	   63,   91,   95,    9,   13,   45,   46,   48,   58,   65,   90,   97,
	  122,   32,   62,   80,   83,   91,    9,   13,   85,   66,   76,   73,
	   67,   32,    9,   13,   32,   34,   39,    9,   13,    9,   34,   61,
	   95,   32,   37,   39,   59,   63,   90,   97,  122,    9,   34,   61,
	   95,   32,   37,   39,   59,   63,   90,   97,  122,   32,   62,   91,
	    9,   13,   32,   34,   39,   62,   91,    9,   13,   34,   34,   32,
	   62,   91,    9,   13,   93,   32,   62,    9,   13,   39,   39,    9,
	   39,   61,   95,   32,   33,   35,   37,   40,   59,   63,   90,   97,
	  122,    9,   39,   61,   95,   32,   33,   35,   37,   40,   59,   63,
	   90,   97,  122,    9,   32,   33,   39,   62,   91,   95,   10,   13,
	   35,   37,   40,   59,   61,   90,   97,  122,    9,   32,   34,   39,
	   62,   91,   95,   10,   13,   33,   37,   40,   59,   61,   90,   97,
	  122,    9,   32,   33,   39,   62,   91,   95,   10,   13,   35,   37,
	   40,   59,   61,   90,   97,  122,    9,   32,   34,   39,   62,   91,
	   95,   10,   13,   33,   37,   40,   59,   61,   90,   97,  122,   32,
	   34,   39,   62,   91,    9,   13,   34,   39,   34,   39,   32,   39,
	   62,   91,    9,   13,   39,   93,   32,   62,   93,    9,   13,   32,
	   39,   62,    9,   13,   32,   34,   62,   91,    9,   13,   34,   93,
	   32,   34,   62,    9,   13,   32,   39,   62,   91,    9,   13,    9,
	   39,   61,   95,   32,   33,   35,   37,   40,   59,   63,   90,   97,
	  122,   89,   83,   84,   69,   77,   67,   68,   65,   84,   65,   91,
	   58,   95,   65,   90,   97,  122,   32,   62,   63,   95,    9,   13,
	   45,   46,   48,   58,   65,   90,   97,  122,   32,   62,    9,   13,
	   32,   47,   62,   63,   95,    9,   13,   45,   58,   65,   90,   97,
	  122,   32,   47,   62,   63,   95,    9,   13,   45,   58,   65,   90,
	   97,  122,   32,   47,   61,   62,   63,   95,    9,   13,   45,   58,
	   65,   90,   97,  122,   32,   47,   61,   62,   63,   95,    9,   13,
	   45,   58,   65,   90,   97,  122,   62,   13,   32,   34,   39,   47,
	   60,   62,    9,   10,   11,   12,   13,   32,   47,   60,   62,    9,
	   10,   11,   12,   32,   47,   62,   63,   95,    9,   13,   45,   58,
	   65,   90,   97,  122,   13,   32,   47,   60,   62,   63,   95,    9,
	   10,   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,   47,
	   60,   61,   62,   63,   95,    9,   10,   11,   12,   45,   58,   65,
	   90,   97,  122,   13,   32,   47,   60,   61,   62,   63,   95,    9,
	   10,   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,   47,
	   60,   62,    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,
	   62,    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,   62,
	   63,   95,    9,   10,   11,   12,   45,   58,   65,   90,   97,  122,
	   13,   32,   34,   39,   47,   60,   62,   63,   95,    9,   10,   11,
	   12,   45,   58,   65,   90,   97,  122,   13,   32,   34,   47,   60,
	   62,    9,   10,   11,   12,   13,   32,   34,   47,   60,   62,    9,
	   10,   11,   12,   32,   34,   47,   62,   63,   95,    9,   13,   45,
	   58,   65,   90,   97,  122,   34,   32,   34,   47,   61,   62,   63,
	   95,    9,   13,   45,   58,   65,   90,   97,  122,   32,   34,   47,
	   61,   62,   63,   95,    9,   13,   45,   58,   65,   90,   97,  122,
	   34,   62,   13,   32,   34,   39,   47,   60,   62,    9,   10,   11,
	   12,   13,   32,   34,   39,   47,   60,   62,    9,   10,   11,   12,
	   13,   32,   34,   39,   47,   60,   62,   63,   95,    9,   10,   11,
	   12,   45,   58,   65,   90,   97,  122,   13,   32,   34,   39,   47,
	   60,   62,   63,   95,    9,   10,   11,   12,   45,   58,   65,   90,
	   97,  122,   13,   32,   34,   47,   60,   62,   63,   95,    9,   10,
	   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,   34,   47,
	   60,   62,   63,   95,    9,   10,   11,   12,   45,   58,   65,   90,
	   97,  122,   13,   32,   34,   47,   60,   61,   62,   63,   95,    9,
	   10,   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,   34,
	   47,   60,   61,   62,   63,   95,    9,   10,   11,   12,   45,   58,
	   65,   90,   97,  122,   13,   32,   34,   47,   60,   62,    9,   10,
	   11,   12,   13,   32,   34,   39,   47,   60,   62,    9,   10,   11,
	   12,   13,   32,   34,   39,   47,   60,   62,    9,   10,   11,   12,
	   13,   32,   34,   39,   47,   60,   62,    9,   10,   11,   12,   32,
	   34,   39,   47,   62,   63,   95,    9,   13,   45,   58,   65,   90,
	   97,  122,   34,   39,   32,   39,   47,   62,   63,   95,    9,   13,
	   45,   58,   65,   90,   97,  122,   39,   32,   39,   47,   61,   62,
	   63,   95,    9,   13,   45,   58,   65,   90,   97,  122,   32,   39,
	   47,   61,   62,   63,   95,    9,   13,   45,   58,   65,   90,   97,
	  122,   39,   62,   13,   32,   34,   39,   47,   60,   62,    9,   10,
	   11,   12,   13,   32,   39,   47,   60,   62,    9,   10,   11,   12,
	   13,   32,   39,   47,   60,   62,   63,   95,    9,   10,   11,   12,
	   45,   58,   65,   90,   97,  122,   13,   32,   39,   47,   60,   61,
	   62,   63,   95,    9,   10,   11,   12,   45,   58,   65,   90,   97,
	  122,   13,   32,   39,   47,   60,   61,   62,   63,   95,    9,   10,
	   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,   39,   47,
	   60,   62,    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,
	   62,    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,   62,
	   63,   95,    9,   10,   11,   12,   45,   58,   65,   90,   97,  122,
	   13,   32,   34,   39,   47,   60,   62,   63,   95,    9,   10,   11,
	   12,   45,   58,   65,   90,   97,  122,   13,   32,   34,   39,   47,
	   60,   62,    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,
	   62,   63,   95,    9,   10,   11,   12,   45,   58,   65,   90,   97,
	  122,   13,   32,   34,   39,   47,   60,   61,   62,   63,   95,    9,
	   10,   11,   12,   45,   58,   65,   90,   97,  122,   32,   34,   39,
	   47,   61,   62,   63,   95,    9,   13,   45,   58,   65,   90,   97,
	  122,   32,   34,   39,   47,   61,   62,   63,   95,    9,   13,   45,
	   58,   65,   90,   97,  122,   34,   39,   62,   13,   32,   34,   39,
	   47,   60,   62,    9,   10,   11,   12,   13,   32,   34,   39,   47,
	   60,   62,    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,
	   62,   63,   95,    9,   10,   11,   12,   45,   58,   65,   90,   97,
	  122,   13,   32,   34,   39,   47,   60,   62,   63,   95,    9,   10,
	   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,   34,   39,
	   47,   60,   62,   63,   95,    9,   10,   11,   12,   45,   58,   65,
	   90,   97,  122,   13,   32,   34,   39,   47,   60,   62,    9,   10,
	   11,   12,   13,   32,   34,   39,   47,   60,   62,   63,   95,    9,
	   10,   11,   12,   45,   58,   65,   90,   97,  122,   32,   34,   39,
	   47,   62,   63,   95,    9,   13,   45,   58,   65,   90,   97,  122,
	   32,   34,   39,   47,   62,   63,   95,    9,   13,   45,   58,   65,
	   90,   97,  122,   13,   32,   34,   39,   47,   60,   62,    9,   10,
	   11,   12,   13,   32,   34,   39,   47,   60,   61,   62,   63,   95,
	    9,   10,   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,
	   39,   47,   60,   62,   63,   95,    9,   10,   11,   12,   45,   58,
	   65,   90,   97,  122,   34,   39,   32,   39,   47,   62,   63,   95,
	    9,   13,   45,   58,   65,   90,   97,  122,   13,   32,   34,   39,
	   47,   60,   62,    9,   10,   11,   12,   32,   34,   47,   62,   63,
	   95,    9,   13,   45,   58,   65,   90,   97,  122,   34,   39,   13,
	   32,   39,   47,   60,   62,    9,   10,   11,   12,   34,   39,   13,
	   32,   34,   39,   47,   60,   62,    9,   10,   11,   12,   58,   95,
	  120,   65,   90,   97,  122,   32,   63,   95,    9,   13,   45,   46,
	   48,   58,   65,   90,   97,  122,   32,   63,   95,  109,    9,   13,
	   45,   46,   48,   58,   65,   90,   97,  122,   32,   63,   95,  108,
	    9,   13,   45,   46,   48,   58,   65,   90,   97,  122,   32,   63,
	   95,    9,   13,   45,   46,   48,   58,   65,   90,   97,  122,  101,
	  114,  115,  105,  111,  110,   32,   61,    9,   13,   32,   34,   39,
	    9,   13,   95,   45,   46,   48,   58,   65,   90,   97,  122,   34,
	   95,   45,   46,   48,   58,   65,   90,   97,  122,   32,   62,   63,
	    9,   13,   32,   62,   63,  101,  115,    9,   13,   62,  110,   99,
	  111,  100,  105,  110,  103,   32,   61,    9,   13,   32,   34,   39,
	    9,   13,   65,   90,   97,  122,   34,   95,   45,   46,   48,   57,
	   65,   90,   97,  122,   32,   62,   63,    9,   13,   32,   62,   63,
	  115,    9,   13,  116,   97,  110,  100,   97,  108,  111,  110,  101,
	   32,   61,    9,   13,   32,   34,   39,    9,   13,  110,  121,  111,
	   34,   32,   62,   63,    9,   13,  101,  115,  110,  121,  111,   39,
	  101,  115,   65,   90,   97,  122,   39,   95,   45,   46,   48,   57,
	   65,   90,   97,  122,   95,   45,   46,   48,   58,   65,   90,   97,
	  122,   39,   95,   45,   46,   48,   58,   65,   90,   97,  122,   62,
	   62,   10,   60,   33,   47,   58,   63,   95,   65,   90,   97,  122,
	   39,   93,   34,   34,   39,   34,   39,   32,    9,   13,   32,  118,
	    9,   13,   10,   45,   45,   10,   93,   93,   10,   62,   63,   62,
	    0
	};
}

private static final char _hpricot_scan_trans_keys[] = init__hpricot_scan_trans_keys_0();


private static byte[] init__hpricot_scan_single_lengths_0()
{
	return new byte [] {
	    3,    1,    1,    1,    1,    1,    1,    1,    1,    3,    5,    5,
	    1,    1,    1,    1,    1,    1,    3,    4,    4,    3,    5,    1,
	    1,    3,    1,    2,    1,    1,    4,    4,    7,    7,    7,    7,
	    5,    2,    2,    4,    2,    3,    3,    4,    2,    3,    4,    4,
	    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    2,
	    4,    2,    5,    5,    6,    6,    1,    7,    5,    5,    7,    8,
	    8,    5,    7,    9,    9,    6,    6,    6,    1,    7,    7,    2,
	    7,    7,    9,    9,    8,    8,    9,    9,    6,    7,    7,    7,
	    7,    2,    6,    1,    7,    7,    2,    7,    6,    8,    9,    9,
	    6,    7,    9,    9,    7,    9,   10,    8,    8,    3,    7,    7,
	    9,    9,    9,    7,    9,    7,    7,    7,   10,    8,    2,    6,
	    7,    6,    2,    6,    1,    1,    7,    3,    3,    4,    4,    3,
	    1,    1,    1,    1,    1,    1,    2,    3,    1,    2,    3,    5,
	    1,    1,    1,    1,    1,    1,    1,    1,    2,    3,    0,    2,
	    3,    4,    1,    1,    1,    1,    1,    1,    1,    1,    1,    2,
	    3,    2,    1,    1,    3,    1,    1,    2,    1,    1,    1,    1,
	    0,    2,    1,    2,    1,    1,    2,    5,    1,    1,    1,    1,
	    1,    2,    1,    2,    2,    1,    2,    1,    3,    1
	};
}

private static final byte _hpricot_scan_single_lengths[] = init__hpricot_scan_single_lengths_0();


private static byte[] init__hpricot_scan_range_lengths_0()
{
	return new byte [] {
	    0,    0,    0,    0,    0,    0,    0,    0,    1,    3,    5,    1,
	    0,    0,    0,    0,    0,    1,    1,    4,    4,    1,    1,    0,
	    0,    1,    0,    1,    0,    0,    5,    5,    5,    5,    5,    5,
	    1,    0,    0,    1,    0,    1,    1,    1,    0,    1,    1,    5,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    2,
	    5,    1,    4,    4,    4,    4,    0,    2,    2,    4,    5,    5,
	    5,    2,    2,    5,    5,    2,    2,    4,    0,    4,    4,    0,
	    2,    2,    5,    5,    5,    5,    5,    5,    2,    2,    2,    2,
	    4,    0,    4,    0,    4,    4,    0,    2,    2,    5,    5,    5,
	    2,    2,    5,    5,    2,    5,    5,    4,    4,    0,    2,    2,
	    5,    5,    5,    2,    5,    4,    4,    2,    5,    5,    0,    4,
	    2,    4,    0,    2,    0,    0,    2,    2,    5,    5,    5,    5,
	    0,    0,    0,    0,    0,    0,    1,    1,    4,    4,    1,    1,
	    0,    0,    0,    0,    0,    0,    0,    0,    1,    1,    2,    4,
	    1,    1,    0,    0,    0,    0,    0,    0,    0,    0,    0,    1,
	    1,    0,    0,    0,    1,    0,    0,    0,    0,    0,    0,    0,
	    2,    4,    4,    4,    0,    0,    0,    2,    0,    0,    0,    0,
	    0,    0,    1,    1,    0,    0,    0,    0,    0,    0
	};
}

private static final byte _hpricot_scan_range_lengths[] = init__hpricot_scan_range_lengths_0();


private static short[] init__hpricot_scan_index_offsets_0()
{
	return new short [] {
	    0,    4,    6,    8,   10,   12,   14,   16,   18,   21,   28,   39,
	   46,   48,   50,   52,   54,   56,   59,   64,   73,   82,   87,   94,
	   96,   98,  103,  105,  109,  111,  113,  123,  133,  146,  159,  172,
	  185,  192,  195,  198,  204,  207,  212,  217,  223,  226,  231,  237,
	  247,  249,  251,  253,  255,  257,  259,  261,  263,  265,  267,  269,
	  274,  284,  288,  298,  308,  319,  330,  332,  342,  350,  360,  373,
	  387,  401,  409,  419,  434,  449,  458,  467,  478,  480,  492,  504,
	  507,  517,  527,  542,  557,  571,  585,  600,  615,  624,  634,  644,
	  654,  666,  669,  680,  682,  694,  706,  709,  719,  728,  742,  757,
	  772,  781,  791,  806,  821,  831,  846,  862,  875,  888,  892,  902,
	  912,  927,  942,  957,  967,  982,  994, 1006, 1016, 1032, 1046, 1049,
	 1060, 1070, 1081, 1084, 1093, 1095, 1097, 1107, 1113, 1122, 1132, 1142,
	 1151, 1153, 1155, 1157, 1159, 1161, 1163, 1167, 1172, 1178, 1185, 1190,
	 1197, 1199, 1201, 1203, 1205, 1207, 1209, 1211, 1213, 1217, 1222, 1225,
	 1232, 1237, 1243, 1245, 1247, 1249, 1251, 1253, 1255, 1257, 1259, 1261,
	 1265, 1270, 1273, 1275, 1277, 1282, 1284, 1286, 1289, 1291, 1293, 1295,
	 1297, 1300, 1307, 1313, 1320, 1322, 1324, 1327, 1335, 1337, 1339, 1341,
	 1343, 1345, 1348, 1351, 1355, 1358, 1360, 1363, 1365, 1369
	};
}

private static final short _hpricot_scan_index_offsets[] = init__hpricot_scan_index_offsets_0();


private static short[] init__hpricot_scan_indicies_0()
{
	return new short [] {
	    1,    2,    3,    0,    4,    0,    5,    0,    6,    0,    7,    0,
	    8,    0,    9,    0,   10,    0,   11,   11,    0,   11,   12,   12,
	   11,   12,   12,    0,   13,   15,   14,   16,   14,   13,   14,   14,
	   14,   14,    0,   17,   18,   19,   20,   21,   17,    0,   22,    0,
	   23,    0,   24,    0,   25,    0,   26,    0,   27,   27,    0,   27,
	   28,   29,   27,    0,   30,   31,   30,   30,   30,   30,   30,   30,
	    0,   32,   33,   32,   32,   32,   32,   32,   32,    0,   34,   18,
	   21,   34,    0,   34,   35,   36,   18,   21,   34,    0,   38,   37,
	   41,   40,   42,   18,   21,   42,   39,   43,   21,   43,   18,   43,
	   39,   38,   44,   41,   45,   46,   47,   46,   46,   46,   46,   46,
	   46,   46,    0,   48,   49,   48,   48,   48,   48,   48,   48,   48,
	    0,   50,   50,   48,   49,   18,   21,   48,   34,   48,   48,   48,
	   48,    0,   50,   50,   35,   51,   18,   21,   48,   34,   48,   48,
	   48,   48,    0,   52,   52,   54,   55,   56,   57,   54,   53,   54,
	   54,   54,   54,   44,   58,   58,   61,   62,   63,   64,   60,   59,
	   60,   60,   60,   60,   45,   59,   61,   65,   63,   64,   59,   45,
	   67,   68,   66,   70,   71,   69,   72,   41,   63,   64,   72,   45,
	   73,   74,   64,   75,   76,   43,   75,   21,   74,   41,   63,   74,
	   45,   77,   41,   78,   79,   77,   40,   73,   80,   79,   80,   41,
	   78,   80,   40,   81,   38,   56,   57,   81,   44,   60,   82,   60,
	   60,   60,   60,   60,   60,   60,   45,   83,    0,   84,    0,   85,
	    0,   86,    0,   87,    0,   88,    0,   89,    0,   90,    0,   91,
	    0,   92,    0,   93,    0,   94,   94,   94,   94,    0,   95,   97,
	   96,   96,   95,   96,   96,   96,   96,    0,   98,   99,   98,    0,
	  100,  102,  103,  101,  101,  100,  101,  101,  101,    0,  104,  106,
	  107,  105,  105,  104,  105,  105,  105,    0,  108,  110,  111,  112,
	  109,  109,  108,  109,  109,  109,   39,  113,  115,  116,  117,  114,
	  114,  113,  114,  114,  114,   39,  118,   39,  120,  120,  122,  123,
	  124,   39,  117,  120,  121,  119,  126,  126,  128,   39,  129,  126,
	  127,  125,  130,  115,  117,  114,  114,  130,  114,  114,  114,   39,
	  126,  126,  132,   39,  133,  131,  131,  126,  127,  131,  131,  131,
	  125,  134,  134,  137,   39,  138,  139,  136,  136,  134,  135,  136,
	  136,  136,  125,  140,  140,  132,   39,  142,  133,  131,  131,  140,
	  141,  131,  131,  131,  125,  126,  126,  128,   39,  129,  126,  127,
	  125,  143,  143,  145,  146,  147,   39,  129,  143,  144,  119,  148,
	  148,  122,  123,  124,   39,  117,  150,  150,  148,  149,  150,  150,
	  150,  119,  143,  143,  145,  146,  151,   39,  133,  150,  150,  143,
	  144,  150,  150,  150,  119,  153,  153,  155,  156,  157,  158,  153,
	  154,  152,  160,  160,  162,  163,  164,  165,  160,  161,  159,  166,
	  167,  169,  170,  168,  168,  166,  168,  168,  168,  164,  167,  164,
	  171,  167,  173,  174,  175,  172,  172,  171,  172,  172,  172,  164,
	  176,  167,  169,  177,  170,  168,  168,  176,  168,  168,  168,  164,
	  167,  178,  164,  179,  179,  181,  182,  183,  164,  170,  179,  180,
	  152,  184,  184,  181,  182,  183,  164,  170,  184,  185,  152,  184,
	  184,  181,  182,  183,  164,  170,  186,  186,  184,  185,  186,  186,
	  186,  152,  187,  187,  189,  190,  191,  164,  192,  186,  186,  187,
	  188,  186,  186,  186,  152,  153,  153,  155,  191,  157,  193,  186,
	  186,  153,  154,  186,  186,  186,  152,  160,  160,  162,  195,  164,
	  192,  194,  194,  160,  161,  194,  194,  194,  159,  196,  196,  162,
	  199,  164,  200,  201,  198,  198,  196,  197,  198,  198,  198,  159,
	  202,  202,  162,  195,  164,  204,  192,  194,  194,  202,  203,  194,
	  194,  194,  159,  160,  160,  162,  163,  164,  165,  160,  161,  159,
	  187,  187,  189,  190,  156,  164,  165,  187,  188,  152,  206,  206,
	  208,  209,  210,  211,  212,  206,  207,  205,  214,  214,  216,  217,
	  218,  219,  220,  214,  215,  213,  221,  222,  223,  225,  226,  224,
	  224,  221,  224,  224,  224,  219,  222,  223,  219,  228,  167,  230,
	  231,  229,  229,  228,  229,  229,  229,  227,  167,  227,  232,  167,
	  234,  235,  236,  233,  233,  232,  233,  233,  233,  227,  237,  167,
	  230,  238,  231,  229,  229,  237,  229,  229,  229,  227,  167,  239,
	  227,  241,  241,  243,  244,  245,  227,  231,  241,  242,  240,  247,
	  247,  162,  249,  227,  250,  247,  248,  246,  247,  247,  162,  252,
	  227,  253,  251,  251,  247,  248,  251,  251,  251,  246,  254,  254,
	  162,  257,  227,  258,  259,  256,  256,  254,  255,  256,  256,  256,
	  246,  260,  260,  162,  252,  227,  262,  253,  251,  251,  260,  261,
	  251,  251,  251,  246,  247,  247,  162,  249,  227,  250,  247,  248,
	  246,  263,  263,  265,  266,  267,  227,  250,  263,  264,  240,  268,
	  268,  243,  244,  245,  227,  231,  270,  270,  268,  269,  270,  270,
	  270,  240,  263,  263,  265,  266,  271,  227,  253,  270,  270,  263,
	  264,  270,  270,  270,  240,  206,  206,  272,  209,  210,  211,  212,
	  206,  207,  205,  214,  214,  216,  217,  274,  219,  275,  273,  273,
	  214,  215,  273,  273,  273,  213,  276,  276,  216,  217,  279,  219,
	  280,  281,  278,  278,  276,  277,  278,  278,  278,  213,  282,  222,
	  223,  225,  283,  226,  224,  224,  282,  224,  224,  224,  219,  284,
	  222,  223,  286,  287,  288,  285,  285,  284,  285,  285,  285,  219,
	  222,  223,  289,  219,  290,  290,  292,  293,  294,  219,  226,  290,
	  291,  205,  295,  295,  292,  293,  294,  219,  226,  295,  296,  205,
	  295,  295,  292,  293,  294,  219,  226,  297,  297,  295,  296,  297,
	  297,  297,  205,  298,  298,  300,  301,  302,  219,  275,  297,  297,
	  298,  299,  297,  297,  297,  205,  206,  206,  272,  209,  302,  211,
	  303,  297,  297,  206,  207,  297,  297,  297,  205,  214,  214,  216,
	  217,  218,  219,  220,  214,  215,  213,  206,  206,  208,  209,  302,
	  211,  303,  297,  297,  206,  207,  297,  297,  297,  205,  304,  305,
	  306,  308,  309,  307,  307,  304,  307,  307,  307,  211,  304,  310,
	  306,  308,  309,  307,  307,  304,  307,  307,  307,  211,  298,  298,
	  300,  301,  210,  219,  220,  298,  299,  205,  311,  311,  216,  217,
	  274,  219,  313,  275,  273,  273,  311,  312,  273,  273,  273,  213,
	  314,  314,  155,  271,  316,  317,  270,  270,  314,  315,  270,  270,
	  270,  240,  305,  306,  211,  318,  319,  321,  322,  320,  320,  318,
	  320,  320,  320,  316,  268,  268,  243,  244,  245,  227,  231,  268,
	  269,  240,  323,  319,  325,  326,  324,  324,  323,  324,  324,  324,
	  157,  310,  306,  211,  314,  314,  155,  267,  316,  327,  314,  315,
	  240,  319,  157,  319,  316,  148,  148,  122,  123,  124,   39,  117,
	  148,  149,  119,  328,  328,  329,  328,  328,    0,  330,  331,  331,
	  330,  331,  331,  331,  331,    0,  330,  331,  331,  332,  330,  331,
	  331,  331,  331,    0,  330,  331,  331,  333,  330,  331,  331,  331,
	  331,    0,  334,  331,  331,  334,  331,  331,  331,  331,    0,  336,
	  335,  337,  335,  338,  335,  339,  335,  340,  335,  341,  335,  341,
	  342,  341,  335,  342,  343,  344,  342,  335,  345,  345,  345,  345,
	  345,  335,  346,  347,  347,  347,  347,  347,  335,  348,  349,  350,
	  348,  335,  348,  349,  350,  351,  352,  348,  335,  349,  335,  353,
	  335,  354,  335,  355,  335,  356,  335,  357,  335,  358,  335,  359,
	  335,  359,  360,  359,  335,  360,  361,  362,  360,  335,  363,  363,
	  335,  364,  365,  365,  365,  365,  365,  335,  366,  349,  350,  366,
	  335,  366,  349,  350,  352,  366,  335,  367,  335,  368,  335,  369,
	  335,  370,  335,  371,  335,  372,  335,  373,  335,  374,  335,  375,
	  335,  375,  376,  375,  335,  376,  377,  378,  376,  335,  379,  380,
	  335,  381,  335,  382,  335,  383,  349,  350,  383,  335,  384,  335,
	  381,  335,  385,  386,  335,  387,  335,  382,  335,  388,  335,  387,
	  335,  389,  389,  335,  364,  390,  390,  390,  390,  390,  335,  391,
	  391,  391,  391,  391,  335,  346,  392,  392,  392,  392,  392,  335,
	  394,  393,  396,  395,  398,  399,  397,  401,  402,  403,  404,  403,
	  403,  403,  400,   41,   45,   43,   21,   41,   40,  167,  164,  167,
	  227,  222,  223,  219,  330,  330,  406,  334,  407,  334,  406,  409,
	  410,  408,  412,  411,  414,  415,  413,  417,  416,  419,  420,  421,
	  418,  420,  422,    0
	};
}

private static final short _hpricot_scan_indicies[] = init__hpricot_scan_indicies_0();


private static short[] init__hpricot_scan_trans_targs_0()
{
	return new short [] {
	  198,    1,    2,   53,  198,    3,    4,    5,    6,    7,    8,    9,
	   10,   11,   10,  198,   26,   11,  198,   12,   48,   26,   13,   14,
	   15,   16,   17,   18,   19,   30,   20,   21,   20,   21,   22,   23,
	   28,   24,   25,  198,   24,   25,   25,   27,   29,   29,   31,   32,
	   31,   32,   33,   34,   35,   36,   47,   32,  200,   40,   35,   36,
	   47,   37,   34,  200,   40,   46,   38,   39,   43,   38,   39,   43,
	   39,   41,   42,   41,  201,   43,  202,   44,   45,   39,   32,   49,
	   50,   51,   52,   21,   54,   55,   56,   57,   58,  198,   60,   61,
	   60,  198,   61,  198,   63,   62,   66,  198,   63,   64,   66,  198,
	   65,   64,   66,   67,  198,   65,   64,   66,   67,  198,  198,   68,
	  138,   74,  136,  137,   73,   68,   69,   70,   73,  198,   69,   71,
	   73,  198,   65,   72,   71,   73,   74,  198,   65,   72,   74,   75,
	   76,   77,  135,   73,   75,   76,   71,   73,   78,   79,   89,   70,
	   92,   80,  203,   78,   79,   89,   70,   92,   80,  203,   79,   69,
	   81,   83,  203,   82,   81,   83,   84,  203,   82,   84,  203,   85,
	   93,  133,  134,   92,   86,   87,   90,   86,   87,   88,   94,   92,
	  203,  203,   90,   92,   82,   91,   90,   92,   93,  203,   82,   91,
	   93,   95,   96,  113,  105,   89,  123,   97,  205,   95,   96,  113,
	  105,   89,  123,   97,  205,   96,   98,   79,  116,  117,  205,   99,
	   98,  100,  102,  204,  101,  100,  102,  103,  204,  101,  103,  204,
	  104,  132,  109,  130,  131,  108,  104,   98,  105,  108,  204,  106,
	  108,  204,  101,  107,  106,  108,  109,  204,  101,  107,  109,  110,
	  111,  112,  129,  108,  110,  111,  106,  108,  105,  114,  123,  205,
	  115,  128,  114,  123,  127,  205,  115,  118,  115,  116,  117,  118,
	  205,  205,  119,  127,  125,  126,  123,  120,  121,  114,  120,  121,
	  122,  124,  123,  205,   96,   98,   79,  116,  117,  205,   98,  115,
	  128,  127,   98,  105,   99,  204,   98,   69,  100,  102,  204,   79,
	   81,   83,  203,  204,  140,  141,  206,  140,  142,  143,  207,  198,
	  145,  146,  147,  148,  149,  150,  151,  152,  194,  153,  154,  153,
	  155,  198,  156,  157,  170,  158,  159,  160,  161,  162,  163,  164,
	  165,  166,  192,  167,  168,  167,  169,  171,  172,  173,  174,  175,
	  176,  177,  178,  179,  180,  181,  187,  182,  185,  183,  184,  184,
	  186,  188,  190,  189,  191,  193,  193,  195,  195,  208,  208,  210,
	  210,  198,  198,  199,  198,    0,   59,   62,  139,  198,  198,  144,
	  208,  208,  209,  208,  196,  210,  210,  211,  210,  197,  212,  212,
	  212,  213,  212
	};
}

private static final short _hpricot_scan_trans_targs[] = init__hpricot_scan_trans_targs_0();


private static short[] init__hpricot_scan_trans_actions_0()
{
	return new short [] {
	   73,    0,    0,    0,   59,    0,    0,    0,    0,    0,    0,    0,
	    1,    5,    0,   92,    5,    0,   51,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    3,   83,    0,   19,    0,    0,
	    0,    3,   86,   75,    0,   21,    0,    0,    3,    0,    3,   83,
	    0,   19,    0,   19,    3,    3,    3,  172,  188,    3,    0,    0,
	    0,    0,  113,  146,    0,   21,    3,   86,   86,    0,   21,   21,
	    0,   21,    0,    0,  146,    0,  146,    0,    0,    3,  113,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,   61,    1,    5,
	    0,   98,    0,   55,    5,    0,    5,   95,    0,  116,    0,   53,
	   11,    0,  110,   11,  168,    0,  180,   23,    0,  122,   57,    3,
	    3,    3,    0,    0,   89,    0,    9,    9,  104,  164,    0,  180,
	  119,  176,  107,  107,    0,  160,   11,  201,    9,    9,    0,   80,
	   80,    0,    0,  152,    3,    3,  196,  156,    3,   80,   80,   77,
	  152,    3,  226,    0,    9,    9,    7,  104,    0,  211,    0,    7,
	  180,   23,  192,   11,    0,  110,   11,  216,    0,    0,  149,    3,
	    3,    7,    0,   89,    3,    3,  196,   80,   80,    7,    0,  156,
	  221,  232,  180,  119,  107,  107,    0,  160,   11,  238,    9,    9,
	    0,    3,   80,   80,  101,   77,  152,    3,  226,    0,    9,    9,
	    7,    7,  104,    0,  211,    0,    7,    7,  180,   23,  192,    0,
	    0,  180,   23,  192,   11,    0,  110,   11,  216,    0,    0,  149,
	    3,    3,    3,    0,    7,   89,    0,    9,    9,  104,  211,  180,
	  119,  221,  107,  107,    0,  160,   11,  238,    9,    9,    0,   80,
	   80,    0,    7,  152,    3,    3,  196,  156,   77,  180,  119,  221,
	  107,  107,    0,  160,   11,  238,    0,    0,   11,    0,  110,   11,
	  216,  149,    3,    3,    7,    7,   89,    3,    3,  196,   80,   80,
	    7,    7,  156,  232,    3,   77,   77,  196,   89,  206,  101,    9,
	    9,    0,   80,   80,    3,  232,    3,   77,  196,   89,  206,    3,
	  196,   89,  206,  226,   25,   25,    0,    0,    0,    0,   31,   71,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    3,   13,    0,
	    0,   49,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    3,   15,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    3,    3,    0,   17,    0,
	    0,    3,    3,    0,    0,    3,    0,    3,    0,   37,  137,   43,
	  140,   63,  134,  184,   69,    0,    0,    1,    0,   65,   67,    0,
	   33,  125,   31,   35,    0,   39,  128,   31,   41,    0,   45,  131,
	  143,    0,   47
	};
}

private static final short _hpricot_scan_trans_actions[] = init__hpricot_scan_trans_actions_0();


private static short[] init__hpricot_scan_to_state_actions_0()
{
	return new short [] {
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,   27,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,   27,    0,   27,    0,   27,    0
	};
}

private static final short _hpricot_scan_to_state_actions[] = init__hpricot_scan_to_state_actions_0();


private static short[] init__hpricot_scan_from_state_actions_0()
{
	return new short [] {
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,   29,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,   29,    0,   29,    0,   29,    0
	};
}

private static final short _hpricot_scan_from_state_actions[] = init__hpricot_scan_from_state_actions_0();


private static short[] init__hpricot_scan_eof_trans_0()
{
	return new short [] {
	    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
	    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
	   40,   40,   40,   40,    1,   40,    1,    1,    1,    1,    1,    1,
	    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
	    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
	    1,    1,    1,    1,   40,   40,   40,   40,   40,   40,   40,   40,
	   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,
	   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,
	   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,
	   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,
	   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,
	   40,   40,   40,   40,   40,   40,   40,    1,    1,    1,    1,    1,
	  336,  336,  336,  336,  336,  336,  336,  336,  336,  336,  336,  336,
	  336,  336,  336,  336,  336,  336,  336,  336,  336,  336,  336,  336,
	  336,  336,  336,  336,  336,  336,  336,  336,  336,  336,  336,  336,
	  336,  336,  336,  336,  336,  336,  336,  336,  336,  336,  336,  336,
	  336,  336,  336,  336,  394,  396,    0,  401,  406,  406,  406,   40,
	   40,   40,  407,  407,    0,  412,    0,  417,    0,  423
	};
}

private static final short _hpricot_scan_eof_trans[] = init__hpricot_scan_eof_trans_0();


static final int hpricot_scan_start = 198;
static final int hpricot_scan_error = -1;

static final int hpricot_scan_en_html_comment = 208;
static final int hpricot_scan_en_html_cdata = 210;
static final int hpricot_scan_en_html_procins = 212;
static final int hpricot_scan_en_main = 198;


// line 576 "hpricot_scan.java.rl"

        public final static int BUFSIZE = 16384;


        private int cs, act, have = 0, nread = 0, curline = 1;
        private int ts = 0, te = 0, eof = -1, p = -1, pe = -1, buf = 0;
        private byte[] data;
        private State S = null;
        private IRubyObject port, opts, attr, tag, akey, aval, bufsize;
        private int mark_tag = -1, mark_akey = -1, mark_aval = -1;
        private boolean done = false, ele_open = false, taint = false, io = false, text = false;
        private int buffer_size = 0;

        private Extra x;

        private IRubyObject self;
        private Ruby runtime;
        private ThreadContext ctx;
        private Block block;

        private IRubyObject xmldecl, doctype, stag, etag, emptytag, comment, cdata, procins;

        private RaiseException newRaiseException(RubyClass exceptionClass, String message) {
            return new RaiseException(runtime, exceptionClass, message, true);
        }

        public Scanner(IRubyObject self, IRubyObject[] args, Block block) {
            this.self = self;
            this.runtime = self.getRuntime();
            this.ctx = runtime.getCurrentContext();
            this.block = block;
            attr = runtime.getNil();
            tag = runtime.getNil();
            akey = runtime.getNil();
            aval = runtime.getNil();
            bufsize = runtime.getNil();

            this.x = (Extra)this.runtime.getModule("Hpricot").dataGetStruct();

            this.xmldecl = x.sym_xmldecl;
            this.doctype = x.sym_doctype;
            this.stag = x.sym_stag;
            this.etag = x.sym_etag;
            this.emptytag = x.sym_emptytag;
            this.comment = x.sym_comment;
            this.cdata = x.sym_cdata;
            this.procins = x.sym_procins;

            port = args[0];
            if(args.length == 2) {
                opts = args[1];
            } else {
                opts = runtime.getNil();
            }

            taint = port.isTaint();
            io = port.respondsTo("read");
            if(!io) {
                if(port.respondsTo("to_str")) {
                    port = port.callMethod(ctx, "to_str");
                    port = port.convertToString();
                } else {
                    throw runtime.newArgumentError("an Hpricot document must be built from an input source (a String or IO object.)");
                }
            }

            if(!(opts instanceof RubyHash)) {
                opts = runtime.getNil();
            }

            if(!block.isGiven()) {
                S = new State();
                S.doc = x.cDoc.allocate();
                S.focus = S.doc;
                S.last = runtime.getNil();
                S.xml = OPT(opts, "xml");
                S.strict = OPT(opts, "xhtml_strict");
                S.fixup = OPT(opts, "fixup_tags");
                if(S.strict) {
                    S.fixup = true;
                }
                S.doc.getInstanceVariables().fastSetInstanceVariable("@options", opts);
                S.EC = x.mHpricot.getConstant("ElementContent");
            }

            buffer_size = BUFSIZE;
            if(self.getInstanceVariables().fastHasInstanceVariable("@buffer_size")) {
                bufsize = self.getInstanceVariables().fastGetInstanceVariable("@buffer_size");
                if(!bufsize.isNil()) {
                    buffer_size = RubyNumeric.fix2int(bufsize);
                }
            }

            if(io) {
                buf = 0;
                data = new byte[buffer_size];
            }
        }

        private int len, space;
        // hpricot_scan
        public IRubyObject scan() {

// line 1216 "HpricotScanService.java"
	{
	cs = hpricot_scan_start;
	ts = -1;
	te = -1;
	act = 0;
	}

// line 679 "hpricot_scan.java.rl"
            while(!done) {
                p = pe = len = buf;
                space = buffer_size - have;

                if(io) {
                    if(space == 0) {
                        /* We've used up the entire buffer storing an already-parsed token
                         * prefix that must be preserved.  Likely caused by super-long attributes.
                         * Increase buffer size and continue  */
                        buffer_size += BUFSIZE;
                        data = realloc(data, buffer_size);
                        space = buffer_size - have;
                    }

                    p = have;
                    IRubyObject str = port.callMethod(ctx, "read", runtime.newFixnum(space));
                    ByteList bl = str.convertToString().getByteList();
                    len = bl.realSize;
                    System.arraycopy(bl.bytes, bl.begin, data, p, len);
                } else {
                    ByteList bl = port.convertToString().getByteList();
                    data = bl.bytes;
                    buf = bl.begin;
                    p = bl.begin;
                    len = bl.realSize + 1;
                    if(p + len >= data.length) {
                        data = new byte[len];
                        System.arraycopy(bl.bytes, bl.begin, data, 0, bl.realSize);
                        p = 0;
                        buf = 0;
                    }
                    done = true;
                    eof = p + len;
                }

                nread += len;

                /* If this is the last buffer, tack on an EOF. */
                if(io && len < space) {
                    data[p + len++] = 0;
                    eof = p + len;
                    done = true;
                }

                pe = p + len;

                
// line 1272 "HpricotScanService.java"
	{
	int _klen;
	int _trans = 0;
	int _acts;
	int _nacts;
	int _keys;
	int _goto_targ = 0;

	_goto: while (true) {
	switch ( _goto_targ ) {
	case 0:
	if ( p == pe ) {
		_goto_targ = 4;
		continue _goto;
	}
case 1:
	_acts = _hpricot_scan_from_state_actions[cs];
	_nacts = (int) _hpricot_scan_actions[_acts++];
	while ( _nacts-- > 0 ) {
		switch ( _hpricot_scan_actions[_acts++] ) {
	case 21:
// line 1 "NONE"
	{ts = p;}
	break;
// line 1297 "HpricotScanService.java"
		}
	}

	_match: do {
	_keys = _hpricot_scan_key_offsets[cs];
	_trans = _hpricot_scan_index_offsets[cs];
	_klen = _hpricot_scan_single_lengths[cs];
	if ( _klen > 0 ) {
		int _lower = _keys;
		int _mid;
		int _upper = _keys + _klen - 1;
		while (true) {
			if ( _upper < _lower )
				break;

			_mid = _lower + ((_upper-_lower) >> 1);
			if ( data[p] < _hpricot_scan_trans_keys[_mid] )
				_upper = _mid - 1;
			else if ( data[p] > _hpricot_scan_trans_keys[_mid] )
				_lower = _mid + 1;
			else {
				_trans += (_mid - _keys);
				break _match;
			}
		}
		_keys += _klen;
		_trans += _klen;
	}

	_klen = _hpricot_scan_range_lengths[cs];
	if ( _klen > 0 ) {
		int _lower = _keys;
		int _mid;
		int _upper = _keys + (_klen<<1) - 2;
		while (true) {
			if ( _upper < _lower )
				break;

			_mid = _lower + (((_upper-_lower) >> 1) & ~1);
			if ( data[p] < _hpricot_scan_trans_keys[_mid] )
				_upper = _mid - 2;
			else if ( data[p] > _hpricot_scan_trans_keys[_mid+1] )
				_lower = _mid + 2;
			else {
				_trans += ((_mid - _keys)>>1);
				break _match;
			}
		}
		_trans += _klen;
	}
	} while (false);

	_trans = _hpricot_scan_indicies[_trans];
case 3:
	cs = _hpricot_scan_trans_targs[_trans];

	if ( _hpricot_scan_trans_actions[_trans] != 0 ) {
		_acts = _hpricot_scan_trans_actions[_trans];
		_nacts = (int) _hpricot_scan_actions[_acts++];
		while ( _nacts-- > 0 )
	{
			switch ( _hpricot_scan_actions[_acts++] )
			{
	case 0:
// line 526 "hpricot_scan.java.rl"
	{
    if(text) {
        tag = CAT(tag, mark_tag, p);
        ELE(x.sym_text);
        text = false;
    }
    attr = runtime.getNil();
    tag = runtime.getNil();
    mark_tag = -1;
    ele_open = true;
  }
	break;
	case 1:
// line 538 "hpricot_scan.java.rl"
	{ mark_tag = p; }
	break;
	case 2:
// line 539 "hpricot_scan.java.rl"
	{ mark_aval = p; }
	break;
	case 3:
// line 540 "hpricot_scan.java.rl"
	{ mark_akey = p; }
	break;
	case 4:
// line 541 "hpricot_scan.java.rl"
	{ tag = SET(mark_tag, p, tag); }
	break;
	case 5:
// line 543 "hpricot_scan.java.rl"
	{ aval = SET(mark_aval, p, aval); }
	break;
	case 6:
// line 544 "hpricot_scan.java.rl"
	{
      if(data[p-1] == '"' || data[p-1] == '\'') {
          aval = SET(mark_aval, p-1, aval);
      } else {
          aval = SET(mark_aval, p, aval);
      }
  }
	break;
	case 7:
// line 551 "hpricot_scan.java.rl"
	{   akey = SET(mark_akey, p, akey); }
	break;
	case 8:
// line 552 "hpricot_scan.java.rl"
	{ aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("version"), aval); }
	break;
	case 9:
// line 553 "hpricot_scan.java.rl"
	{ aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("encoding"), aval); }
	break;
	case 10:
// line 554 "hpricot_scan.java.rl"
	{ aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("standalone"), aval); }
	break;
	case 11:
// line 555 "hpricot_scan.java.rl"
	{ aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("public_id"), aval); }
	break;
	case 12:
// line 556 "hpricot_scan.java.rl"
	{ aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("system_id"), aval); }
	break;
	case 13:
// line 558 "hpricot_scan.java.rl"
	{
      akey = runtime.getNil();
      aval = runtime.getNil();
      mark_akey = -1;
      mark_aval = -1;
  }
	break;
	case 14:
// line 565 "hpricot_scan.java.rl"
	{
      if(!S.xml && !akey.isNil()) {
          akey = akey.callMethod(runtime.getCurrentContext(), "downcase");
      }
      ATTR(akey, aval);
  }
	break;
	case 15:
// line 9 "hpricot_common.rl"
	{curline += 1;}
	break;
	case 16:
// line 46 "hpricot_common.rl"
	{ TEXT_PASS(); }
	break;
	case 17:
// line 50 "hpricot_common.rl"
	{ EBLK(comment, 3); {cs = 198; _goto_targ = 2; if (true) continue _goto;} }
	break;
	case 18:
// line 55 "hpricot_common.rl"
	{ EBLK(cdata, 3); {cs = 198; _goto_targ = 2; if (true) continue _goto;} }
	break;
	case 19:
// line 60 "hpricot_common.rl"
	{ EBLK(procins, 2); {cs = 198; _goto_targ = 2; if (true) continue _goto;} }
	break;
	case 22:
// line 1 "NONE"
	{te = p+1;}
	break;
	case 23:
// line 50 "hpricot_common.rl"
	{te = p+1;}
	break;
	case 24:
// line 51 "hpricot_common.rl"
	{te = p+1;{ TEXT_PASS(); }}
	break;
	case 25:
// line 51 "hpricot_common.rl"
	{te = p;p--;{ TEXT_PASS(); }}
	break;
	case 26:
// line 51 "hpricot_common.rl"
	{{p = ((te))-1;}{ TEXT_PASS(); }}
	break;
	case 27:
// line 55 "hpricot_common.rl"
	{te = p+1;}
	break;
	case 28:
// line 56 "hpricot_common.rl"
	{te = p+1;{ TEXT_PASS(); }}
	break;
	case 29:
// line 56 "hpricot_common.rl"
	{te = p;p--;{ TEXT_PASS(); }}
	break;
	case 30:
// line 56 "hpricot_common.rl"
	{{p = ((te))-1;}{ TEXT_PASS(); }}
	break;
	case 31:
// line 60 "hpricot_common.rl"
	{te = p+1;}
	break;
	case 32:
// line 61 "hpricot_common.rl"
	{te = p+1;{ TEXT_PASS(); }}
	break;
	case 33:
// line 61 "hpricot_common.rl"
	{te = p;p--;{ TEXT_PASS(); }}
	break;
	case 34:
// line 66 "hpricot_common.rl"
	{act = 8;}
	break;
	case 35:
// line 68 "hpricot_common.rl"
	{act = 10;}
	break;
	case 36:
// line 70 "hpricot_common.rl"
	{act = 12;}
	break;
	case 37:
// line 73 "hpricot_common.rl"
	{act = 15;}
	break;
	case 38:
// line 65 "hpricot_common.rl"
	{te = p+1;{ ELE(xmldecl); }}
	break;
	case 39:
// line 66 "hpricot_common.rl"
	{te = p+1;{ ELE(doctype); }}
	break;
	case 40:
// line 68 "hpricot_common.rl"
	{te = p+1;{ ELE(stag); }}
	break;
	case 41:
// line 69 "hpricot_common.rl"
	{te = p+1;{ ELE(etag); }}
	break;
	case 42:
// line 70 "hpricot_common.rl"
	{te = p+1;{ ELE(emptytag); }}
	break;
	case 43:
// line 71 "hpricot_common.rl"
	{te = p+1;{ {cs = 208; _goto_targ = 2; if (true) continue _goto;} }}
	break;
	case 44:
// line 72 "hpricot_common.rl"
	{te = p+1;{ {cs = 210; _goto_targ = 2; if (true) continue _goto;} }}
	break;
	case 45:
// line 73 "hpricot_common.rl"
	{te = p+1;{ TEXT_PASS(); }}
	break;
	case 46:
// line 66 "hpricot_common.rl"
	{te = p;p--;{ ELE(doctype); }}
	break;
	case 47:
// line 67 "hpricot_common.rl"
	{te = p;p--;{ {cs = 212; _goto_targ = 2; if (true) continue _goto;} }}
	break;
	case 48:
// line 73 "hpricot_common.rl"
	{te = p;p--;{ TEXT_PASS(); }}
	break;
	case 49:
// line 67 "hpricot_common.rl"
	{{p = ((te))-1;}{ {cs = 212; _goto_targ = 2; if (true) continue _goto;} }}
	break;
	case 50:
// line 73 "hpricot_common.rl"
	{{p = ((te))-1;}{ TEXT_PASS(); }}
	break;
	case 51:
// line 1 "NONE"
	{	switch( act ) {
	case 8:
	{{p = ((te))-1;} ELE(doctype); }
	break;
	case 10:
	{{p = ((te))-1;} ELE(stag); }
	break;
	case 12:
	{{p = ((te))-1;} ELE(emptytag); }
	break;
	case 15:
	{{p = ((te))-1;} TEXT_PASS(); }
	break;
	}
	}
	break;
// line 1601 "HpricotScanService.java"
			}
		}
	}

case 2:
	_acts = _hpricot_scan_to_state_actions[cs];
	_nacts = (int) _hpricot_scan_actions[_acts++];
	while ( _nacts-- > 0 ) {
		switch ( _hpricot_scan_actions[_acts++] ) {
	case 20:
// line 1 "NONE"
	{ts = -1;}
	break;
// line 1615 "HpricotScanService.java"
		}
	}

	if ( ++p != pe ) {
		_goto_targ = 1;
		continue _goto;
	}
case 4:
	if ( p == eof )
	{
	if ( _hpricot_scan_eof_trans[cs] > 0 ) {
		_trans = _hpricot_scan_eof_trans[cs] - 1;
		_goto_targ = 3;
		continue _goto;
	}
	}

case 5:
	}
	break; }
	}

// line 726 "hpricot_scan.java.rl"

                if(cs == hpricot_scan_error) {
                    if(!tag.isNil()) {
                        throw newRaiseException(x.rb_eHpricotParseError, "parse error on element <" + tag + ">, starting on line " + curline + ".\n" + NO_WAY_SERIOUSLY);
                    } else {
                        throw newRaiseException(x.rb_eHpricotParseError, "parse error on line " + curline + ".\n" + NO_WAY_SERIOUSLY);
                    }
                }

                if(done && ele_open) {
                    ele_open = false;
                    if(ts > 0) {
                        mark_tag = ts;
                        ts = 0;
                        text = true;
                    }
                }

                if(ts == -1) {
                    have = 0;
                    if(mark_tag != -1 && text) {
                        if(done) {
                            if(mark_tag < p - 1) {
                                tag = CAT(tag, mark_tag, p-1);
                                ELE(x.sym_text);
                            }
                        } else {
                            tag = CAT(tag, mark_tag, p);
                        }
                    }
                    if(io) {
                        mark_tag = 0;
                    } else {
                        mark_tag = ((RubyString)port).getByteList().begin;
                    }
                } else if(io) {
                    have = pe - ts;
                    System.arraycopy(data, ts, data, buf, have);
                    mark_tag = SLIDE(mark_tag);
                    mark_akey = SLIDE(mark_akey);
                    mark_aval = SLIDE(mark_aval);
                    te -= ts;
                    ts = 0;
                }
            }

            if(S != null) {
                return S.doc;
            }

            return runtime.getNil();
        }
    }

    public static class HpricotModule {
        // hpricot_scan
        @JRubyMethod(module = true, optional = 1, required = 1, frame = true)
        public static IRubyObject scan(IRubyObject self, IRubyObject[] args, Block block) {
            return new Scanner(self, args, block).scan();
        }

        // hpricot_css
        @JRubyMethod(module = true)
        public static IRubyObject css(IRubyObject self, IRubyObject mod, IRubyObject str, IRubyObject node) {
            return new HpricotCss(self, mod, str, node).scan();
        }
    }

    public static class CData {
        @JRubyMethod
        public static IRubyObject content(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod(name = "content=")
        public static IRubyObject content_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_name(self, value);
        }
    }

    public static class Comment {
        @JRubyMethod
        public static IRubyObject content(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod(name = "content=")
        public static IRubyObject content_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_name(self, value);
        }
    }

    public static class DocType {
        @JRubyMethod
        public static IRubyObject raw_string(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod
        public static IRubyObject clear_raw(IRubyObject self) {
            return hpricot_ele_clear_name(self);
        }

        @JRubyMethod
        public static IRubyObject target(IRubyObject self) {
            return hpricot_ele_get_target(self);
        }

        @JRubyMethod(name = "target=")
        public static IRubyObject target_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_target(self, value);
        }

        @JRubyMethod
        public static IRubyObject public_id(IRubyObject self) {
            return hpricot_ele_get_public_id(self);
        }

        @JRubyMethod(name = "public_id=")
        public static IRubyObject public_id_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_public_id(self, value);
        }

        @JRubyMethod
        public static IRubyObject system_id(IRubyObject self) {
            return hpricot_ele_get_system_id(self);
        }

        @JRubyMethod(name = "system_id=")
        public static IRubyObject system_id_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_system_id(self, value);
        }
    }

    public static class Elem {
        @JRubyMethod
        public static IRubyObject clear_raw(IRubyObject self) {
            return hpricot_ele_clear_raw(self);
        }
    }

    public static class BogusETag {
        @JRubyMethod
        public static IRubyObject raw_string(IRubyObject self) {
            return hpricot_ele_get_attr(self);
        }

        @JRubyMethod
        public static IRubyObject clear_raw(IRubyObject self) {
            return hpricot_ele_clear_attr(self);
        }
    }

    public static class Text {
        @JRubyMethod
        public static IRubyObject raw_string(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod
        public static IRubyObject clear_raw(IRubyObject self) {
            return hpricot_ele_clear_name(self);
        }

        @JRubyMethod
        public static IRubyObject content(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod(name = "content=")
        public static IRubyObject content_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_name(self, value);
        }
    }

    public static class XMLDecl {
        @JRubyMethod
        public static IRubyObject raw_string(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod
        public static IRubyObject clear_raw(IRubyObject self) {
            return hpricot_ele_clear_name(self);
        }

        @JRubyMethod
        public static IRubyObject encoding(IRubyObject self) {
            return hpricot_ele_get_encoding(self);
        }

        @JRubyMethod(name = "encoding=")
        public static IRubyObject encoding_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_encoding(self, value);
        }

        @JRubyMethod
        public static IRubyObject standalone(IRubyObject self) {
            return hpricot_ele_get_standalone(self);
        }

        @JRubyMethod(name = "standalone=")
        public static IRubyObject standalone_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_standalone(self, value);
        }

        @JRubyMethod
        public static IRubyObject version(IRubyObject self) {
            return hpricot_ele_get_version(self);
        }

        @JRubyMethod(name = "version=")
        public static IRubyObject version_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_version(self, value);
        }
    }

    public static class ProcIns {
        @JRubyMethod
        public static IRubyObject target(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod(name = "target=")
        public static IRubyObject target_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_name(self, value);
        }

        @JRubyMethod
        public static IRubyObject content(IRubyObject self) {
            return hpricot_ele_get_attr(self);
        }

        @JRubyMethod(name = "content=")
        public static IRubyObject content_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_attr(self, value);
        }
    }

    public final static String NO_WAY_SERIOUSLY = "*** This should not happen, please file a bug report with the HTML you're parsing at http://github.com/hpricot/hpricot/issues.  So sorry!";

    public final static int H_ELE_TAG = 0;
    public final static int H_ELE_PARENT = 1;
    public final static int H_ELE_ATTR = 2;
    public final static int H_ELE_ETAG = 3;
    public final static int H_ELE_RAW = 4;
    public final static int H_ELE_EC = 5;
    public final static int H_ELE_HASH = 6;
    public final static int H_ELE_CHILDREN = 7;

    public static IRubyObject H_ELE_GET(IRubyObject recv, int n) {
        return ((IRubyObject[])recv.dataGetStruct())[n];
    }

    public static RubyHash H_ELE_GET_asHash(IRubyObject recv, int n) {
        IRubyObject obj = ((IRubyObject[])recv.dataGetStruct())[n];
        if(obj.isNil()) {
            obj = RubyHash.newHash(recv.getRuntime());
            ((IRubyObject[])recv.dataGetStruct())[n] = obj;
        }
        return (RubyHash)obj;
    }

    public static IRubyObject H_ELE_SET(IRubyObject recv, int n, IRubyObject value) {
        ((IRubyObject[])recv.dataGetStruct())[n] = value;
        return value;
    }

    private static class RefCallback implements Callback {
        private final int n;
        public RefCallback(int n) { this.n = n; }

        public IRubyObject execute(IRubyObject recv, IRubyObject[] args, Block block) {
            return H_ELE_GET(recv, n);
        }

        public Arity getArity() {
            return Arity.NO_ARGUMENTS;
        }
    }

    private static class SetCallback implements Callback {
        private final int n;
        public SetCallback(int n) { this.n = n; }

        public IRubyObject execute(IRubyObject recv, IRubyObject[] args, Block block) {
            return H_ELE_SET(recv, n, args[0]);
        }

        public Arity getArity() {
            return Arity.ONE_ARGUMENT;
        }
    }

    private final static Callback[] ref_func = new Callback[]{
        new RefCallback(0),
        new RefCallback(1),
        new RefCallback(2),
        new RefCallback(3),
        new RefCallback(4),
        new RefCallback(5),
        new RefCallback(6),
        new RefCallback(7),
        new RefCallback(8),
        new RefCallback(9)};

    private final static Callback[] set_func = new Callback[]{
        new SetCallback(0),
        new SetCallback(1),
        new SetCallback(2),
        new SetCallback(3),
        new SetCallback(4),
        new SetCallback(5),
        new SetCallback(6),
        new SetCallback(7),
        new SetCallback(8),
        new SetCallback(9)};

    public final static ObjectAllocator alloc_hpricot_struct = new ObjectAllocator() {
            // alloc_hpricot_struct
            public IRubyObject allocate(Ruby runtime, RubyClass klass) {
                RubyClass kurrent = klass;
                Object sz = kurrent.fastGetInternalVariable("__size__");
                while(sz == null && kurrent != null) {
                    kurrent = kurrent.getSuperClass();
                    sz = kurrent.fastGetInternalVariable("__size__");
                }
                int size = RubyNumeric.fix2int((RubyObject)sz);
                RubyObject obj = new RubyObject(runtime, klass);
                IRubyObject[] all = new IRubyObject[size];
                java.util.Arrays.fill(all, runtime.getNil());
                obj.dataWrapStruct(all);
                return obj;
            }
        };

    public static RubyClass makeHpricotStruct(Ruby runtime, IRubyObject[] members) {
        RubyClass klass = RubyClass.newClass(runtime, runtime.getObject());
        klass.fastSetInternalVariable("__size__", runtime.newFixnum(members.length));
        klass.setAllocator(alloc_hpricot_struct);

        for(int i = 0; i < members.length; i++) {
            String id = members[i].toString();
            klass.defineMethod(id, ref_func[i]);
            klass.defineMethod(id + "=", set_func[i]);
        }

        return klass;
    }

    public boolean basicLoad(final Ruby runtime) throws IOException {
        Init_hpricot_scan(runtime);
        return true;
    }

    public static class Extra {
        IRubyObject symAllow, symDeny, sym_xmldecl, sym_doctype,
            sym_procins, sym_stag, sym_etag, sym_emptytag,
            sym_allowed, sym_children, sym_comment,
            sym_cdata, sym_name, sym_parent,
            sym_raw_attributes, sym_raw_string, sym_tagno,
            sym_text, sym_EMPTY, sym_CDATA;

        public RubyModule mHpricot;
        public RubyClass structElem;
        public RubyClass structAttr;
        public RubyClass structBasic;
        public RubyClass cDoc;
        public RubyClass cCData;
        public RubyClass cComment;
        public RubyClass cDocType;
        public RubyClass cElem;
        public RubyClass cBogusETag;
        public RubyClass cText;
        public RubyClass cXMLDecl;
        public RubyClass cProcIns;
        public RubyClass rb_eHpricotParseError;
        public IRubyObject reProcInsParse;

        public Extra(Ruby runtime) {
            symAllow = runtime.newSymbol("allow");
            symDeny = runtime.newSymbol("deny");
            sym_xmldecl = runtime.newSymbol("xmldecl");
            sym_doctype = runtime.newSymbol("doctype");
            sym_procins = runtime.newSymbol("procins");
            sym_stag = runtime.newSymbol("stag");
            sym_etag = runtime.newSymbol("etag");
            sym_emptytag = runtime.newSymbol("emptytag");
            sym_allowed = runtime.newSymbol("allowed");
            sym_children = runtime.newSymbol("children");
            sym_comment = runtime.newSymbol("comment");
            sym_cdata = runtime.newSymbol("cdata");
            sym_name = runtime.newSymbol("name");
            sym_parent = runtime.newSymbol("parent");
            sym_raw_attributes = runtime.newSymbol("raw_attributes");
            sym_raw_string = runtime.newSymbol("raw_string");
            sym_tagno = runtime.newSymbol("tagno");
            sym_text = runtime.newSymbol("text");
            sym_EMPTY = runtime.newSymbol("EMPTY");
            sym_CDATA = runtime.newSymbol("CDATA");
        }
    }

    public static void Init_hpricot_scan(Ruby runtime) {
        Extra x = new Extra(runtime);

        x.mHpricot = runtime.defineModule("Hpricot");
        x.mHpricot.dataWrapStruct(x);

        x.mHpricot.getSingletonClass().attr_accessor(runtime.getCurrentContext(),new  IRubyObject[]{runtime.newSymbol("buffer_size")});
        x.mHpricot.defineAnnotatedMethods(HpricotModule.class);

        x.rb_eHpricotParseError = x.mHpricot.defineClassUnder("ParseError",runtime.getClass("StandardError"),runtime.getClass("StandardError").getAllocator());

        x.structElem = makeHpricotStruct(runtime, new IRubyObject[] {x.sym_name, x.sym_parent, x.sym_raw_attributes, x.sym_etag, x.sym_raw_string, x.sym_allowed, x.sym_tagno, x.sym_children});
        x.structAttr = makeHpricotStruct(runtime, new IRubyObject[] {x.sym_name, x.sym_parent, x.sym_raw_attributes});
        x.structBasic= makeHpricotStruct(runtime, new IRubyObject[] {x.sym_name, x.sym_parent});

        x.cDoc = x.mHpricot.defineClassUnder("Doc", x.structElem, x.structElem.getAllocator());

        x.cCData = x.mHpricot.defineClassUnder("CData", x.structBasic, x.structBasic.getAllocator());
        x.cCData.defineAnnotatedMethods(CData.class);

        x.cComment = x.mHpricot.defineClassUnder("Comment", x.structBasic, x.structBasic.getAllocator());
        x.cComment.defineAnnotatedMethods(Comment.class);

        x.cDocType = x.mHpricot.defineClassUnder("DocType", x.structAttr, x.structAttr.getAllocator());
        x.cDocType.defineAnnotatedMethods(DocType.class);

        x.cElem = x.mHpricot.defineClassUnder("Elem", x.structElem, x.structElem.getAllocator());
        x.cElem.defineAnnotatedMethods(Elem.class);

        x.cBogusETag = x.mHpricot.defineClassUnder("BogusETag", x.structAttr, x.structAttr.getAllocator());
        x.cBogusETag.defineAnnotatedMethods(BogusETag.class);

        x.cText = x.mHpricot.defineClassUnder("Text", x.structBasic, x.structBasic.getAllocator());
        x.cText.defineAnnotatedMethods(Text.class);

        x.cXMLDecl = x.mHpricot.defineClassUnder("XMLDecl", x.structAttr, x.structAttr.getAllocator());
        x.cXMLDecl.defineAnnotatedMethods(XMLDecl.class);

        x.cProcIns = x.mHpricot.defineClassUnder("ProcIns", x.structAttr, x.structAttr.getAllocator());
        x.cProcIns.defineAnnotatedMethods(ProcIns.class);

        x.reProcInsParse = runtime.evalScriptlet("/\\A<\\?(\\S+)\\s+(.+)/m");
        x.mHpricot.setConstant("ProcInsParse", x.reProcInsParse);
    }
}

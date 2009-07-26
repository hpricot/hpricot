
import java.io.IOException;

import org.jruby.Ruby;
import org.jruby.RubyArray;
import org.jruby.RubyClass;
import org.jruby.RubyHash;
import org.jruby.RubyModule;
import org.jruby.RubyNumeric;
import org.jruby.RubyObjectAdapter;
import org.jruby.RubyString;
import org.jruby.anno.JRubyMethod;
import org.jruby.javasupport.JavaEmbedUtils;
import org.jruby.runtime.Block;
import org.jruby.runtime.CallbackFactory;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.exceptions.RaiseException;
import org.jruby.runtime.load.BasicLibraryService;

public class HpricotScanService implements BasicLibraryService {
    public static class Extra {
        IRubyObject symAllow, symDeny, sym_xmldecl, sym_doctype, 
            sym_procins, sym_stag, sym_etag, sym_emptytag, 
            sym_allowed, sym_children, sym_comment, 
            sym_cdata, sym_name, sym_parent, 
            sym_raw_attributes, sym_raw_string, sym_tagno, 
            sym_text, sym_EMPTY, sym_CDATA;

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

    public static class HpricotModule {
        // hpricot_scan
        @JRubyMethod(module = true)
        public static IRubyObject scan(IRubyObject self, IRubyObject[] args) {
            // TODO: implement
            return null;
        }

        // hpricot_css
        @JRubyMethod(module = true)
        public static IRubyObject css(IRubyObject self, IRubyObject one, IRubyObject two, IRubyObject three) {
            // TODO: implement
            return null;
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

    public final static ObjectAllocator alloc_hpricot_struct = new ObjectAllocator() {};

    public static RubyClass makeHpricotStruct(Ruby runtime, IRubyObject[] members) {
        RubyClass klass = RubyClass.newClass(runtime, runtime.getObject());
        klass.fastSetInstanceVariable("__size__", runtime.newFixnum(members.length));
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

    public static void Init_hpricot_scan(Ruby runtime) {
        Extra x = new Extra(runtime);

        RubyModule mHpricot = runtime.defineModule("Hpricot");

        mHpricot.getSingletonClass().attr_accessor(runtime.getCurrentContext(),new  IRubyObject[]{runtime.newSymbol("buffer_size")});
        mHpricot.defineAnnotatedMethods(HpricotModule.class);

        mHpricot.defineClassUnder("ParseError",runtime.getClass("StandardError"),runtime.getClass("StandardError").getAllocator());

        RubyClass structElem = makeHpricotStruct(runtime, new IRubyObject[] {x.sym_name, x.sym_parent, x.sym_raw_attributes, x.sym_etag, x.sym_raw_string, x.sym_allowed, x.sym_tagno, x.sym_children});
        RubyClass structAttr = makeHpricotStruct(runtime, new IRubyObject[] {x.sym_name, x.sym_parent, x.sym_raw_attributes});
        RubyClass structBasic= makeHpricotStruct(runtime, new IRubyObject[] {x.sym_name, x.sym_parent});

        RubyClass cDoc = mHpricot.defineClassUnder("Doc", structElem, structElem.getAllocator());

        RubyClass cCData = mHpricot.defineClassUnder("CData", structBasic, structBasic.getAllocator());
        cCData.defineAnnotatedMethods(CData.class);

        RubyClass cComment = mHpricot.defineClassUnder("Comment", structBasic, structBasic.getAllocator());
        cComment.defineAnnotatedMethods(Comment.class);

        RubyClass cDocType = mHpricot.defineClassUnder("DocType", structAttr, structAttr.getAllocator());
        cDocType.defineAnnotatedMethods(DocType.class);

        RubyClass cElem = mHpricot.defineClassUnder("Elem", structElem, structElem.getAllocator());
        cElem.defineAnnotatedMethods(Elem.class);

        RubyClass cBogusETag = mHpricot.defineClassUnder("BogusETag", structAttr, structAttr.getAllocator());
        cBogusETag.defineAnnotatedMethods(BogusETag.class);

        RubyClass cText = mHpricot.defineClassUnder("Text", structBasic, structBasic.getAllocator());
        cText.defineAnnotatedMethods(Text.class);

        RubyClass cXMLDecl = mHpricot.defineClassUnder("XMLDecl", structAttr, structAttr.getAllocator());
        cXMLDecl.defineAnnotatedMethods(XMLDecl.class);

        RubyClass cProcIns = mHpricot.defineClassUnder("ProcIns", structAttr, structAttr.getAllocator());
        cProcIns.defineAnnotatedMethods(ProcIns.class);

        IRubyObject reProcInsParse = runtime.evalScriptlet("/\\A<\\?(\\S+)\\s+(.+)/m");
        mHpricot.setConstant("ProcInsParse", reProcInsParse);
    }
}

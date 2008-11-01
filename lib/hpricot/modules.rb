module Hpricot
  class Name; include Hpricot end
  class Context; include Hpricot end

  # :stopdoc:
  module Tag; include Hpricot end
    class STag; include Tag end
    class ETag; include Tag end
  # :startdoc:

  module Node; include Hpricot end
    module Container; include Node end
      class Doc; include Container end
      class Elem; include Container end

      class XDoc; include Container end
      class XElement; include Container end
    module Leaf; include Node end
      class Text; include Leaf end
      class XMLDecl; include Leaf end
      class DocType; include Leaf end
      class ProcIns; include Leaf end
      class Comment; include Leaf end
      class BogusETag; include Leaf end
    
      class XText; include Leaf end
      class XXMLDecl; include Leaf end
      class XDocType; include Leaf end
      class XProcIns; include Leaf end
      class XComment; include Leaf end
      class XBogusETag; include Leaf end

  module Traverse end
  module Container::Trav; include Traverse end
  module Leaf::Trav; include Traverse end
  class Doc;       module Trav; include Container::Trav end; include Trav end
  class Elem;      module Trav; include Container::Trav end; include Trav end
  class Text;      module Trav; include Leaf::Trav      end; include Trav end
  class XMLDecl;   module Trav; include Leaf::Trav      end; include Trav end
  class DocType;   module Trav; include Leaf::Trav      end; include Trav end
  class ProcIns;   module Trav; include Leaf::Trav      end; include Trav end
  class Comment;   module Trav; include Leaf::Trav      end; include Trav end
  class BogusETag; module Trav; include Leaf::Trav      end; include Trav end

  class XDoc;       module Trav; include Container::Trav end; include Doc::Trav end
  class XElement;   module Trav; include Container::Trav end; include Elem::Trav end
  class XText;      module Trav; include Leaf::Trav      end; include XText::Trav end
  class XXMLDecl;   module Trav; include Leaf::Trav      end; include XMLDecl::Trav end
  class XDocType;   module Trav; include Leaf::Trav      end; include DocType::Trav end
  class XProcIns;   module Trav; include Leaf::Trav      end; include ProcIns::Trav end
  class XComment;   module Trav; include Leaf::Trav      end; include Comment::Trav end
  class XBogusETag; module Trav; include Leaf::Trav      end; include BogusETag::Trav end

  class Error < StandardError; end
end


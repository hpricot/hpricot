module Hpricot
  class Elements < Array
    def search(*expr,&blk)
      map { |x| x.search(*expr,&blk) }.flatten.uniq
    end
    alias_method :/, :search

    def at(expr, &blk)
      search(expr, &blk).first
    end
    alias_method :%, :at

    def to_html
      map { |x| x.output("") }.join
    end
    alias_method :to_s, :to_html

    def inner_html(*str)
      if str.empty?
        map { |x| x.inner_html }.join
      else
        x = self.inner_html = str.pop || x
      end
    end
    alias_method :text, :inner_html
    alias_method :html, :inner_html
    alias_method :innerHTML, :inner_html

    def inner_html=(str)
      each { |x| x.inner_html = str }
    end
    alias_method :html=, :inner_html=
    alias_method :innerHTML=, :inner_html=

    def filter(expr)
        nodes, = Elements.filter(self, expr)
        nodes
    end

    def remove
      each { |x| x.parent.children.delete(x) }
    end

    def empty
      each { |x| x.inner_html = nil }
    end

    def append(str)
      each { |x| x.inner_html += str }
    end

    def prepend(str)
      each { |x| x.inner_html = str + x.inner_html }
    end

    def before(str)
      each { |x| x.parent.insert_before Hpricot.make(str), x }
    end

    def after(str)
      each { |x| x.parent.insert_after Hpricot.make(str), x }
    end

    def wrap(str)
      each do |x|
        wrap = Hpricot.make(str)
        nest = wrap.detect { |w| w.respond_to? :children }
        unless nest
          raise Exception, "No wrapping element found."
        end
        x.parent.replace_child(x, wrap)
        nest = nest.children.first until nest.empty?
        nest.children << x
      end
    end

    def not(expr)
        if expr.is_a? Container::Trav
            nodes = self - [expr]
        else
            nodes, = Elements.filter(self, expr, false)
        end
        nodes
    end

    def set(k, v = nil)
      case k
      when Hash
        each do |node|
          k.each { |a,b| node.set_attribute(a, b) }
        end
      else
        each do |node|
          node.set_attribute(k, v)
        end
      end
    end

    ATTR_RE = %r!\[ *(@)([a-zA-Z0-9\(\)_-]+) *([~\!\|\*$\^=]*) *'?"?([^'"]*)'?"? *\]!i
    BRACK_RE = %r!(\[) *([^\]]*) *\]!i
    FUNC_RE = %r!(:)([a-zA-Z0-9\*_-]*)\( *[\"']?([^ \)'\"]*)['\"]? *\)!
    CATCH_RE = %r!([:\.#]*)([a-zA-Z0-9\*_-]+)!

    def self.filter(nodes, expr, truth = true)
        until expr.empty?
            _, *m = *expr.match(/^(?:#{ATTR_RE}|#{BRACK_RE}|#{FUNC_RE}|#{CATCH_RE})/)
            break unless _

            expr = $'
            m.compact!
            if m[0] == '@'
                m[0] = "@#{m.slice!(2,1)}"
            end

            if m[0] == ":" && m[1] == "not"
                nodes, = Elements.filter(nodes, m[2], false)
            else
                meth = "filter[#{m[0]}]"
                if Container::Trav.method_defined? meth
                    args = m[1..-1]
                else
                    meth = "filter[#{m[0]}#{m[1]}]"
                    if Container::Trav.method_defined? meth
                        args = m[2..-1]
                    end
                end
                i = -1
                nodes = Elements[*nodes.find_all do |x| 
                                      i += 1
                                      x.send(meth, *([*args] + [i])) ? truth : !truth
                                  end]
            end
        end
        [nodes, expr]
    end

    def inspect; "#<#{self.class}#{super}>" end

    private
    def copy_node(node, l)
        l.instance_variables.each do |iv|
            node.instance_variable_set(iv, l.instance_variable_get(iv))
        end
    end

  end

  module Container::Trav
    def self.filter(tok, &blk)
      define_method("filter[#{tok.is_a?(String) ? tok : tok.inspect}]", &blk)
    end

    filter '' do |name,i|
      name == '*' || self.name.downcase == name.downcase
    end

    filter '#' do |id,i|
      get_attribute('id').to_s == id
    end

    filter '.' do |name,i|
      classes.include? name
    end

    filter :lt do |num,i|
      parent.containers.index(self) < num.to_i
    end

    filter :gt do |num,i|
      parent.containers.index(self) > num.to_i
    end

    nth = proc { |num,i| parent.containers.index(self) == num.to_i }

    filter :nth, &nth
    filter :eq, &nth

    filter :first do |num,i|
      parent.containers.index(self) == 0
    end

    filter :last do |i|
      self == parent.containers.last
    end

    filter :even do |num,i|
      parent.containers.index(self) % 2 == 0
    end

    filter :odd do |num,i|
      parent.containers.index(self) % 2 == 1
    end

    filter ':first-child' do |i|
      self == parent.containers.first
    end

    filter ':nth-child' do |arg,i|
      case arg 
      when 'even'; parent.containers.index(self) % 2 == 0
      when 'odd';  parent.containers.index(self) % 2 == 1
      else         self == parent.containers[arg.to_i]
      end
    end

    filter ":last-child" do |i|
      self == parent.containers.first
    end
    
    filter ":nth-last-child" do |arg,i|
      self == parent.containers[-1-arg.to_i]
    end

    filter ":first-of-type" do |i|
      self == parent.containers.detect { |x| x.name == arg }
    end

    filter ":nth-of-type" do |arg,i|
      self == parent.containers.find_all { |x| x.name == arg }[arg.to_i]
    end

    filter ":last-of-type" do |i|
      self == parent.containers.find_all { |x| x.name == self.name }.last
    end

    filter :"nth-last-of-type" do |arg,i|
      self == parent.containers.find_all { |x| x.name == arg }[-1-arg.to_i]
    end

    filter ":only-of-type" do |arg,i|
      of_type = parent.containers.find_all { |x| x.name == arg }
      of_type.length == 1
    end

    filter ":only-child" do |arg,i|
      parent.containers.length == 1
    end

    filter :parent do
      childNodes.length > 0
    end

    filter :empty do
      childNodes.length == 0
    end

    filter :root do
      self.is_a? Hpricot::Doc
    end
    
    filter :contains do |arg,|
      html.include? arg
    end

    filter '@=' do |attr,val,i|
      get_attribute(attr).to_s == val
    end

    filter '@!=' do |attr,val,i|
      get_attribute(attr).to_s != val
    end

    filter '@~=' do |attr,val,i|
      get_attribute(attr).to_s.split(/\s+/).include? val
    end

    filter '@|=' do |attr,val,i|
      get_attribute(attr).to_s =~ /^#{Regexp::quote val}(-|$)/
    end

    filter '@^=' do |attr,val,i|
      get_attribute(attr).to_s.index(val) == 0
    end

    filter '@$=' do |attr,val,i|
      get_attribute(attr).to_s =~ /#{Regexp::quote val}$/
    end

    filter '@*=' do |attr,val,i|
      get_attribute(attr).to_s.index(val) >= 0
    end

    filter '@' do |attr,val,i|
      has_attribute? attr
    end

    filter '[' do |val,i|
      search(val).length > 0
    end

  end
end

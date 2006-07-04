require 'hpricot/modules'

module Hpricot::Container
  # +children+ returns children nodes as an array.
  def children
    @children.dup
  end
end

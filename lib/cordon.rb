here = File.dirname(__FILE__)
require here + '/cordon/sanitaire'
require here + '/cordon/macros'
require here + '/cordon/violation'

# Protect ALL the things!
class Object
  include Cordon::Sanitaire
end

module Cordon
  extend Macros
  Blacklist = Hash.new { |hash, key| hash[key] = Hash.new }
  ObjectsPermittedOneCallToAnyBlacklistedMethod = []
end

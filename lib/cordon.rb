here = File.dirname(__FILE__)
require here + '/cordon/blacklist'
require here + '/cordon/macros'
require here + '/cordon/sanitaire'
require here + '/cordon/violation'
require here + '/cordon/whitelist'

# Protect ALL the things!
class Object
  include Cordon::Sanitaire
end

module Cordon
  extend Macros
end

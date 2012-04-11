require 'dcpu16'

# Don't run broken specs
RSpec.configure do |c|
  c.filter_run_excluding :broken => true
end


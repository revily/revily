require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/casettes'
  c.hook_into :webmock
end

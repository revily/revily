module Support
  module TestDoubles
    include RSpec::Fire
    extend RSpec::Fire

    def stub_class_double(*args)
      stub_const(args.first, class_double(*args).as_stubbed_const(transfer_nested_constants: true))
    end
  end
end

  # RSpec.configure do |config|
  #   config.extend TestDoubles
  # end

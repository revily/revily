require 'spec_helper'

module Reveille
  module Event
    describe Matcher do
      describe '.initialize' do
        let(:matcher) { Matcher.new }

        it 'default attributes' do
          expect(matcher.patterns).to eq(nil)
          expect(matcher.list).to eq(Reveille::Event.events)
        end

        it 'setting attributes' do
          matcher = Matcher.new(%w[ incident.triggered ], %w[ incident.triggered incident.acknowledged ])
          expect(matcher.list).to match_array %w[ incident.triggered incident.acknowledged ]
          expect(matcher.patterns).to eq(%w[ incident.triggered ])
        end
      end

      # describe '#regex' do
      #   let(:matcher) { Matcher.new }

      #   it 'specific event' do
      #     matcher.patterns = %w[ incident.triggered ]
      #     expect(matcher.regexp).to eq(/^(incident.triggered)$/)
      #   end

      #   context 'wildcards' do
      #     it 'all' do
      #       matcher.patterns = %w[ * ]
      #       expect(matcher.regexp).to eq(/^(.*)$/)
      #     end

      #     it 'single namespace' do
      #       matcher.patterns = %w[ incident.* ]
      #       expect(matcher.regexp).to eq(/^(incident.*)$/)
      #     end

      #     it 'multiple namespaces' do
      #       matcher.patterns = %w[ incident.* service.* ]
      #       expect(matcher.regexp).to eq(/^(incident.*|service.*)$/)
      #     end

      #     it 'mixed exact and namespaces' do
      #       matcher.patterns = %w[ incident.triggered service.* policy.updated ]
      #       expect(matcher.regexp).to eq(/^(incident.triggered|service.*|policy.updated)$/)
      #     end
      #   end
      # end

      describe '#matched' do
        let(:matcher) { Matcher.new }
        let(:matched) { matcher.matched }

        it 'matches single events' do
          matcher.patterns = %w[ incident.triggered ]
          expect(matched).to eq(%w[ incident.triggered ])
        end

        it 'matches all events' do
          matcher.patterns = %w[ * ]
          expect(matched).to eq(Reveille::Event.events)
        end

        it 'matches single namespace' do
          matcher.patterns = %w[ incident.* ]
          expect(matched).to include('incident.triggered')
          expect(matched).to include('incident.acknowledged')
          expect(matched).not_to include('service.created')
          expect(matched).not_to include('policy.updated')
        end

        it 'does not match nonexistent events' do
          matcher.patterns = %w[ bogus.event ]
          expect(matched).not_to include('bogus.event')
          expect(matched).to be_empty
        end

        it 'matches multiple namespaces' do
          matcher.patterns = %w[ incident.* service.* ]
          expect(matched).to include('incident.triggered')
          expect(matched).to include('incident.acknowledged')
          expect(matched).to include('service.created')
          expect(matched).to include('service.updated')
          expect(matched).not_to include('policy.updated')
        end

        it 'matches mix of specific and namespace events' do
          matcher.patterns = %w[ incident.* service.created ]
          expect(matched).to include('incident.triggered')
          expect(matched).to include('incident.acknowledged')
          expect(matched).to include('service.created')
          expect(matched).not_to include('service.updated')
          expect(matched).not_to include('policy.updated')
        end
      end

      describe '#matches?' do
        let(:matcher) { Matcher.new }

        it 'matches supported event' do
          matcher.patterns = %w[ incident.triggered incident.resolved ]
          expect(matcher).to match_event('incident.triggered')
        end

        it 'does not match unsupported event' do
          matcher.patterns = %w[ incident.triggered incident.resolved ]
          matcher.list = %w[ incident.* ]
          expect(matcher).not_to match_event('service.created')
        end

        it 'matches all (*)' do
          matcher.patterns = %w[ * ]
          expect(matcher).to match_event('incident.triggered')
          expect(matcher).to match_event('service.created')
          expect(matcher).to match_event('policy.updated')
          expect(matcher).to match_event('incident.*')
          expect(matcher).to match_event('service.*')
          expect(matcher).to match_event('*')
          expect(matcher).not_to match_event('bogus.event')
        end

        it 'matches single namespace' do
          matcher.patterns = %w[ incident.* ]
          matcher.list = %w[ incident.* ]
          expect(matcher).to match_event('incident.*')
          expect(matcher).to match_event('incident.triggered')
          expect(matcher).to match_event('incident.acknowledged')
          expect(matcher).not_to match_event('service.created')
          expect(matcher).not_to match_event('policy.updated')
        end

        it 'does not match nonexistent events' do
          matcher.patterns = %w[ incident.* ]
          expect(matcher).not_to match_event('incident.foobar')
        end

        it 'matches multiple namespaces' do
          matcher.patterns = %w[ incident.* service.* ]
          matcher.list = %w[ incident.* service.* ]
          expect(matcher).to match_event('incident.*')
          expect(matcher).to match_event('incident.triggered')
          expect(matcher).to match_event('service.*')
          expect(matcher).to match_event('service.created')
          expect(matcher).not_to match_event('policy.updated')
        end

        it 'matches mix of specific and namespace events' do
          matcher.patterns = %w[ incident.* service.created ]
          matcher.list = %w[ incident.* service.* ]
          expect(matcher).to match_event('incident.*')
          expect(matcher).to match_event('incident.triggered')
          expect(matcher).to match_event('service.created')
          expect(matcher).to match_event('service.updated')
          expect(matcher).not_to match_event('policy.updated')
        end
      end
    end
  end
end

require 'spec_helper'

module Revily
  module Event
    describe Matcher do
      describe '.initialize' do
        let(:matcher) { Matcher.new }

        it 'default attributes' do
          expect(matcher.patterns).to eq(nil)
          expect(matcher.list).to eq(Revily::Event.events)
        end

        it 'setting attributes' do
          matcher = Matcher.new(%w[ incident.trigger ], %w[ incident.trigger incident.acknowledge ])
          expect(matcher.list).to match_array %w[ incident.trigger incident.acknowledge ]
          expect(matcher.patterns).to eq(%w[ incident.trigger ])
        end
      end

      # describe '#regex' do
      #   let(:matcher) { Matcher.new }

      #   it 'specific event' do
      #     matcher.patterns = %w[ incident.trigger ]
      #     expect(matcher.regexp).to eq(/^(incident.trigger)$/)
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
      #       matcher.patterns = %w[ incident.trigger service.* policy.update ]
      #       expect(matcher.regexp).to eq(/^(incident.trigger|service.*|policy.update)$/)
      #     end
      #   end
      # end

      describe '#matched' do
        let(:matcher) { Matcher.new }
        let(:matched) { matcher.matched }

        it 'matches single events' do
          matcher.patterns = %w[ incident.trigger ]
          expect(matched).to eq(%w[ incident.trigger ])
        end

        it 'matches all events' do
          matcher.patterns = %w[ * ]
          expect(matched).to eq(Revily::Event.events)
        end

        it 'matches single namespace' do
          matcher.patterns = %w[ incident.* ]
          expect(matched).to include('incident.trigger')
          expect(matched).to include('incident.acknowledge')
          expect(matched).not_to include('service.create')
          expect(matched).not_to include('policy.update')
        end

        it 'does not match nonexistent events' do
          matcher.patterns = %w[ bogus.event ]
          expect(matched).not_to include('bogus.event')
          expect(matched).to be_empty
        end

        it 'matches multiple namespaces' do
          matcher.patterns = %w[ incident.* service.* ]
          expect(matched).to include('incident.trigger')
          expect(matched).to include('incident.acknowledge')
          expect(matched).to include('service.create')
          expect(matched).to include('service.update')
          expect(matched).not_to include('policy.update')
        end

        it 'matches mix of specific and namespace events' do
          matcher.patterns = %w[ incident.* service.create ]
          expect(matched).to include('incident.trigger')
          expect(matched).to include('incident.acknowledge')
          expect(matched).to include('service.create')
          expect(matched).not_to include('service.update')
          expect(matched).not_to include('policy.update')
        end
      end

      describe '#matches?' do
        let(:matcher) { Matcher.new }

        it 'matches supported event' do
          matcher.patterns = %w[ incident.trigger incident.resolve ]
          expect(matcher).to match_event('incident.trigger')
        end

        it 'does not match unsupported event' do
          matcher.patterns = %w[ incident.trigger incident.resolve ]
          matcher.list = %w[ incident.* ]
          expect(matcher).not_to match_event('service.create')
        end

        it 'matches all (*)' do
          matcher.patterns = %w[ * ]
          expect(matcher).to match_event('incident.trigger')
          expect(matcher).to match_event('service.create')
          expect(matcher).to match_event('policy.update')
          expect(matcher).to match_event('incident.*')
          expect(matcher).to match_event('service.*')
          expect(matcher).to match_event('*')
          expect(matcher).not_to match_event('bogus.event')
        end

        it 'matches single namespace' do
          matcher.patterns = %w[ incident.* ]
          matcher.list = %w[ incident.* ]
          expect(matcher).to match_event('incident.*')
          expect(matcher).to match_event('incident.trigger')
          expect(matcher).to match_event('incident.acknowledge')
          expect(matcher).not_to match_event('service.create')
          expect(matcher).not_to match_event('policy.update')
        end

        it 'does not match nonexistent events' do
          matcher.patterns = %w[ incident.* ]
          expect(matcher).not_to match_event('incident.foobar')
        end

        it 'matches multiple namespaces' do
          matcher.patterns = %w[ incident.* service.* ]
          matcher.list = %w[ incident.* service.* ]
          expect(matcher).to match_event('incident.*')
          expect(matcher).to match_event('incident.trigger')
          expect(matcher).to match_event('service.*')
          expect(matcher).to match_event('service.create')
          expect(matcher).not_to match_event('policy.update')
        end

        it 'matches mix of specific and namespace events' do
          matcher.patterns = %w[ incident.* service.create ]
          matcher.list = %w[ incident.* service.* ]
          expect(matcher).to match_event('incident.*')
          expect(matcher).to match_event('incident.trigger')
          expect(matcher).to match_event('service.create')
          expect(matcher).to match_event('service.update')
          expect(matcher).not_to match_event('policy.update')
        end
      end
    end
  end
end

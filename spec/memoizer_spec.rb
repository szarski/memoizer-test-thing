require './spec/spec_helper'

context "When Interactors::ImportantThing#call sums arguments and has a side effect" do
  before(:all) do
    module Interactors
      class Base
        include Memoizer
      end

      class ImportantThing < Base
        def initialize(*args)
          # does whatever
        end

        def side_effect
          # some undesired computation-heavy side effect
        end

        def call(*args)
          side_effect
          # Let's add the arguments up,
          # Array#sum is not implemented in pure ruby
          args.inject(0) { |result, argument| result + argument }
        end
      end
    end
  end

  subject { Interactors::ImportantThing.new }

  context "When there is no memoization" do
    context "When different arguments are passed" do
      it "returns different values" do
        expect(subject.call(1,2,3)).to eq(6)
        expect(subject.call(4,5,6)).to eq(15)
      end
    end

    context "when the same arguments are passed" do
      it "runs the side effect every time" do
        expect(subject).to receive(:side_effect).twice
        subject.call(1,2,3)
        subject.call(1,2,3)
      end
    end
  end

  context "When memoization is present" do
    context "When different arguments are passed" do
      it "returns different values" do
        expect(subject.call(1,2,3)).to eq(6)
        expect(subject.call(4,5,6)).to eq(15)
      end
    end

    context "when the same arguments are passed" do
      it "runs the side effect only once" do
        expect(subject).to receive(:side_effect).once
        subject.call(1,2,3)
        subject.call(1,2,3)
      end
    end
  end
end

require './lib/entity_rb/base'

describe Entity::Base do
  describe '.field' do
    before do
      class Test < Entity::Base
      end
    end

    subject { Test.new }

    context 'when key is passed' do
      context 'and is a Symbol' do
        before { Test.field :test_field }

        it 'defines an attribute reader for it' do
          expect(subject).to respond_to(:test_field)
        end

        it 'defines an attribute writer for it' do
          expect(subject).to respond_to(:test_field=)
        end
      end

      context 'and is a String' do
        before { Test.field 'test_field' }

        it 'defines an attribute reader for it' do
          expect(subject).to respond_to(:test_field)
        end

        it 'defines an attribute writer for it' do
          expect(subject).to respond_to(:test_field=)
        end
      end

      context 'and is an Fixnum' do
        it 'raises an ArgumentError' do
          expect{Test.field 1}.to raise_error(ArgumentError)
        end
      end

      context ', key is an Array' do
        context 'and all elements are supported' do
          before { Test.field ['field1', 'field2'] }

          it 'creates an attribute reader for each attribute in array' do
            expect(subject).to respond_to(:field1)
            expect(subject).to respond_to(:field2)
          end

          it 'creates an attribute writer for each attribute in array' do
            expect(subject).to respond_to(:field1=)
            expect(subject).to respond_to(:field2=)
          end
        end

        context 'and some elements are not supported' do
          before { Test.field [1, 'field1', 2, 'field2'] }

          it 'creates an attribute reader for the valid attributes' do
            expect(subject).to respond_to(:field1)
            expect(subject).to respond_to(:field2)
          end

          it 'does not create an attribute reader for the invalid attributes' do
            expect(subject).not_to respond_to(:'1')
            expect(subject).not_to respond_to(:'2')
          end

          it 'creates an attribute writer for the valid attributes' do
            expect(subject).to respond_to(:field1=)
            expect(subject).to respond_to(:field2=)
          end

          it 'does not create an attribute writer for the invalid attributes' do
            expect(subject).not_to respond_to(:'1=')
            expect(subject).not_to respond_to(:'2=')
          end
        end
      end

      context 'and is a Hash' do
        it 'raises an ArgumentError' do
          expect{Test.field({})}.to raise_error(ArgumentError)
        end
      end
    end

    context 'when key is not passed' do
      it 'raises an ArgumentError' do
        expect{Test.field}.to raise_error(ArgumentError)
      end
    end
  end

  describe '.new' do
    before do
      class Test < Entity::Base
        field :field1
        field :field2
      end
    end

    context 'when all fields exists' do
      subject { Test.new(field1: 'field1', field2: 'field2') }

      it 'sets field1 value' do
        expect(subject.field1).to eq 'field1'
      end

      it 'sets field2 value' do
        expect(subject.field2).to eq 'field2'
      end
    end

    context 'when some fields does not exist' do
      subject { Test.new(field1: 'field1', field2: 'field2', field3: 'field3', field4: 'field4') }

      it 'sets field1 value' do
        expect(subject.field1).to eq 'field1'
      end

      it 'sets field2 value' do
        expect(subject.field2).to eq 'field2'
      end

      it 'does not sets field3 value' do
        expect{subject.field3}.to raise_error(NoMethodError)
      end

      it 'does not sets field4 value' do
        expect{subject.field4}.to raise_error(NoMethodError)
      end
    end

    context 'when some existing fields are not initialized' do
      subject { Test.new(field1: 'field1') }

      it 'sets field1 value' do
        expect(subject.field1).to eq 'field1'
      end

      it 'sets field2 value' do
        expect(subject.field2).to be_nil
      end
    end
  end

  describe '#attributes' do
    let(:hash) { { field1: 'field1', field2: 'field2', field3: 'field3', field4: 'field4' } }

    before do
      class TestClass < Entity::Base
        field :field1
        field :field2
        field :field3
        field :field4
      end
    end

    subject { TestClass.new(hash) }

    it "returns a hash with all fields and it's values" do
      expect(subject.attributes).to eq hash
    end
  end

  describe '.fields' do
    before do
      class TestClass < Entity::Base
        field :field1
        field :field2
        field :field3
        field :field4
      end
    end

    subject { TestClass.fields }

    it "returns a hash with all fields and it's values" do
      expect(subject).to eq [:field1, :field2, :field3, :field4]
    end
  end

  describe '#fields' do
    before do
      class TestClass < Entity::Base
        field :field1
        field :field1
        field :field2
        field :field2
        field :field3
        field :field3
        field :field4
        field :field4
      end
    end

    subject { TestClass.new.fields }

    it "returns a hash with all fields and it's values" do
      expect(TestClass).to receive(:fields)
      
      subject
    end
  end
end

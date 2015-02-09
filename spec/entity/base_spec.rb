require './lib/entity/base'

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
end

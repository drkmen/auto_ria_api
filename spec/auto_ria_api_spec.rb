RSpec.describe AutoRiaApi::Base do
  let(:api) { AutoRiaApi::Base.new(api_key: ENV['AUTO_RIA_API_KEY']) }

  it 'has a version number' do
    expect(AutoRiaApi::VERSION).not_to be nil
  end

  it 'should raise ArgumentError unless :api_key provided' do
    expect do
      AutoRiaApi::Base.new
    end.to raise_error ArgumentError
  end

  describe 'endpoints' do
    context 'endpoint methods should be implemented' do
      endpoints = %i[types carcasses marks models regions gearboxes driver_types
      cities fuels colors options average_price search info]

      endpoints.each do |method|
        it "##{method}" do
          expect(api).to respond_to method
        end
      end
    end

    describe '#types' do
      subject { api.types }
      it_behaves_like 'success responses'
    end

    describe '#carcasses' do
      it 'should raise ArgumentError unless :type provided' do
        expect do
          api.carcasses nil
        end.to raise_error ArgumentError
      end

      context 'success grouped response' do
        subject { api.carcasses 2, grouped: true }
        it_behaves_like 'success responses'
      end

      context 'success response' do
        subject { api.carcasses 1 }
        it_behaves_like 'success responses'
      end

      context 'success ALL response' do
        subject { api.carcasses 1, all: true }
        it_behaves_like 'success responses'
      end
    end

    describe '#marks' do
      it 'should raise ArgumentError unless :carcasse provided' do
        expect do
          api.marks nil
        end.to raise_error ArgumentError
      end

      subject { api.marks 1 }
      it_behaves_like 'success responses'
    end

    describe '#models' do
      it 'should raise ArgumentError unless :carcasse provided' do
        expect do
          api.models nil, nil
        end.to raise_error ArgumentError
      end

      context 'success grouped response' do
        subject { api.models 2, 9, grouped: true }
        it_behaves_like 'success responses'
      end

      context 'success response' do
        subject { api.models 2, 9 }
        it_behaves_like 'success responses'
      end

      context 'success ALL response' do
        subject { api.models 2, 9, all: true }
        it_behaves_like 'success responses'
      end
    end

    describe '#regions' do
      subject { api.regions }
      it_behaves_like 'success responses'
    end

    describe '#cities' do
      it 'should raise ArgumentError unless :region provided' do
        expect do
          api.cities nil
        end.to raise_error ArgumentError
      end

      subject { api.cities 1 }
      it_behaves_like 'success responses'
    end

    describe '#gearboxes' do
      it 'should raise ArgumentError unless :carcasse provided' do
        expect do
          api.gearboxes nil
        end.to raise_error ArgumentError
      end

      subject { api.gearboxes 1 }
      it_behaves_like 'success responses'
    end

    describe '#fuels' do
      subject { api.fuels }
      it_behaves_like 'success responses'
    end

    describe '#colors' do
      subject { api.colors }
      it_behaves_like 'success responses'
    end

    describe '#options' do
      it 'should raise ArgumentError unless :carcasse provided' do
        expect do
          api.options nil
        end.to raise_error ArgumentError
      end

      subject { api.options 1 }
      it_behaves_like 'success responses'
    end

  end
end

# frozen_string_literal: true

RSpec.describe AutoRiaApi::Base do
  let(:api_key) { 'api_key' }
  let(:path) { nil }
  let(:params) { { api_key: api_key } }
  let(:request_uri) { URI(described_class::DEFAULT_URL + path + uri_params) }
  let(:uri_params) { '?' + URI.encode_www_form(params.merge(api_key: api_key)) }
  let(:http_client) { Net::HTTP }
  let(:stubbed_response) { double(body: { stub: 'mock' }.to_json) }
  let(:parsed_response) { JSON.parse(stubbed_response.body) }

  subject(:client) { described_class.new(api_key: api_key) }

  before do
    allow(http_client).to receive(:get_response).and_return(stubbed_response)
  end

  it 'has a version number' do
    expect(AutoRiaApi::VERSION).not_to be nil
  end

  describe '#initialize' do
    context 'when `api_key` is missing' do
      let(:api_key) { nil }

      it 'raises an error' do
        expect { subject }.to raise_error ArgumentError, 'API key should not be empty'
      end
    end
  end

  describe 'methods' do
    context 'endpoint methods should be implemented' do
      endpoints = %i[types carcasses marks models regions gearboxes driver_types
                     cities fuels colors options average_price search info]

      endpoints.each do |method|
        it "##{method}" do
          expect(subject).to respond_to method
        end
      end
    end

    context 'when server responds with error' do
      let(:failed_response) { double(body: { 'error' => { 'message' => 'stub' } }.to_json) }
      let(:parsed_error) { JSON.parse(failed_response.body)['error'].to_s }

      before do
        allow(http_client).to receive(:get_response).and_return(failed_response)
      end

      it 'raises an error' do
        expect { subject.types }.to raise_error AutoRiaApi::ResponseError, parsed_error
      end
    end

    describe '#types' do
      let(:path) { '/auto/categories' }

      subject { client.types }
      after { subject }

      it 'fetch categories' do
        expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
      end

      it { is_expected.to eq parsed_response }
    end

    describe '#carcasses' do
      let(:path) { "/auto/categories/#{type}/bodystyles" }
      let(:type) { 'type' }
      let(:grouped) { nil }
      let(:all) { false }

      subject { client.carcasses(type: type, options: { grouped: grouped, all: all }) }

      after { |example| subject unless example.metadata[:skip_after] }

      it 'fetch carcasses' do
        expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
      end

      context 'when `type` is missing', :skip_after do
        let(:type) { nil }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError, '`type` should not be empty'
        end
      end

      context 'when `grouped` param provided' do
        let(:path) { super() + '/_group' }
        let(:grouped) { true }

        it 'fetch grouped' do
          expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
        end

        it { is_expected.to eq parsed_response }
      end

      context 'when `all` param provided' do
        let(:path) { '/auto/bodystyles' }
        let(:all) { true }

        it 'fetch all' do
          expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
        end

        it { is_expected.to eq parsed_response }
      end
    end

    describe '#marks' do
      let(:path) { "/auto/categories/#{type}/marks" }
      let(:type) { 'type' }

      subject { client.marks(type: type) }

      after { |example| subject unless example.metadata[:skip_after] }

      it 'fetch marks' do
        expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
      end

      it { is_expected.to eq parsed_response }

      context 'when `type` is missing', :skip_after do
        let(:type) { nil }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError, '`type` should not be empty'
        end
      end
    end

    describe '#models' do
      let(:path) { "/auto/categories/#{type}/marks/#{mark}/models" }

      let(:type) { 'type' }
      let(:mark) { 'mark' }
      let(:grouped) { nil }
      let(:all) { nil }

      subject { client.models(type: type, mark: mark, options: { grouped: grouped, all: all }) }

      after { |example| subject unless example.metadata[:skip_after] }

      it 'fetch models' do
        expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
      end

      it { is_expected.to eq parsed_response }

      context 'when `options` provided' do
        context 'and `grouped` provided' do
          let(:grouped) { true }
          let(:path) { super() + '/_group' }

          it 'fetch grouped models' do
            expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
          end

          it { is_expected.to eq parsed_response }
        end

        context 'and `all` provided' do
          let(:all) { true }
          let(:path) { '/auto/models' }

          it 'fetch grouped models' do
            expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
          end

          it { is_expected.to eq parsed_response }
        end
      end

      context 'when `type` is missing', :skip_after do
        let(:type) { nil }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError, '`type` should not be empty'
        end
      end

      context 'when `mark` is missing', :skip_after do
        let(:mark) { nil }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError, '`mark` should not be empty'
        end
      end
    end

    describe '#regions' do
      let(:path) { '/auto/states' }

      subject { client.regions }
      after { subject }

      it 'fetch regions' do
        expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
      end

      it { is_expected.to eq parsed_response }
    end

    describe '#cities' do
      let(:path) { "/auto/states/#{region}/cities" }
      let(:region) { 'region' }

      subject { client.cities region: region }
      after { |example| subject unless example.metadata[:skip_after] }

      it 'fetch regions' do
        expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
      end

      it { is_expected.to eq parsed_response }

      context 'when `region` is missing', :skip_after do
        let(:region) { nil }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError, '`region` should not be empty'
        end
      end
    end

    describe '#gearboxes' do
      let(:path) { "/auto/categories/#{type}/gearboxes" }
      let(:type) { 'type' }

      subject { client.gearboxes type: type }
      after { |example| subject unless example.metadata[:skip_after] }

      it 'fetch gearboxes' do
        expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
      end

      it { is_expected.to eq parsed_response }

      context 'when `type` is missing', :skip_after do
        let(:type) { nil }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError, '`type` should not be empty'
        end
      end
    end

    describe '#driver_types' do
      it 'fetch driver_types'
    end

    describe '#fuels' do
      let(:path) { '/auto/type' }

      subject { client.fuels }
      after { subject }

      it 'fetch fuels' do
        expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
      end

      it { is_expected.to eq parsed_response }
    end

    describe '#colors' do
      let(:path) { '/auto/colors' }

      subject { client.colors }
      after { subject  }

      it 'fetch fuels' do
        expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
      end

      it { is_expected.to eq parsed_response }
    end

    describe '#options' do
      let(:path) { "/auto/categories/#{type}/auto_options" }
      let(:type) { 'type' }

      subject { client.options type: type }
      after { |example| subject unless example.metadata[:skip_after] }

      it 'fetch options' do
        expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
      end

      it { is_expected.to eq parsed_response }

      context 'when `type` is missing', :skip_after do
        let(:type) { nil }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError, '`type` should not be empty'
        end
      end
    end

    describe '#average_price' do
      it 'fetch average_prices'
    end

    describe '#search' do
      it 'search cars'
    end

    describe '#info' do
      let(:path) { '/auto/info' }
      let(:car_id) { 1 }
      let(:params) { { auto_id: car_id }.merge(super()) }

      subject { client.info car_id: car_id }
      after { |example| subject unless example.metadata[:skip_after] }

      it 'fetch car' do
        expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
      end

      it { is_expected.to eq parsed_response }

      context 'when `car_id` is missing', :skip_after do
        let(:car_id) { nil }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError, '`car_id` should not be empty'
        end
      end
    end

    describe '#photos' do
      let(:path) { "/auto/fotos/#{car_id}" }
      let(:car_id) { 1 }
      let(:params) { { auto_id: car_id }.merge(super()) }

      subject { client.photos car_id: car_id }
      after { |example| subject unless example.metadata[:skip_after] }

      it 'fetch car photos' do
        expect(http_client).to receive(:get_response).with(request_uri).and_return(stubbed_response)
      end

      it { is_expected.to eq parsed_response }

      context 'when `car_id` is missing', :skip_after do
        let(:car_id) { nil }

        it 'raises an error' do
          expect { subject }.to raise_error ArgumentError, '`car_id` should not be empty'
        end
      end
    end
  end
end

require 'auto_ria_api/version'
require 'net/http'
require 'json'

module AutoRiaApi
  class Base
    attr_accessor :api_key
    attr_reader :default_url

    DEFAULT_URL = 'https://developers.ria.com'.freeze

    def initialize(api_key:, url: nil)
      raise ArgumentError, 'API key should not be empty' if blank?(api_key)

      @api_key = api_key
      @default_url = url || DEFAULT_URL
    end

    def types
      request '/auto/categories'
    end

    def carcasses(type:, options: {})
      raise ArgumentError, '`type` should not be empty' if blank?(type)
      return request '/auto/bodystyles' if options[:all]

      group = '/_group' if options[:grouped]
      request "/auto/categories/#{type}/bodystyles#{group}"
    end

    def marks(type:)
      raise ArgumentError, '`type` should not be empty' if blank?(type)

      request "/auto/categories/#{type}/marks"
    end

    def models(type:, mark:, options: {})
      raise ArgumentError, '`type` should not be empty' if blank?(type)
      raise ArgumentError, '`mark` should not be empty' if blank?(mark)
      return request '/auto/models' if options[:all]

      group = options[:grouped] ? '/_group' : ''
      request "/auto/categories/#{type}/marks/#{mark}/models" + group
    end

    def regions
      request '/auto/states'
    end

    def cities(region:)
      raise ArgumentError, '`region` should not be empty' if blank?(region)

      request "/auto/states/#{region}/cities"
    end

    def gearboxes(type:)
      raise ArgumentError, '`type` should not be empty' if blank?(type)

      request "/auto/categories/#{type}/gearboxes"
    end

    def driver_types(type:)
      raise ArgumentError, '`type` should not be empty' if blank?(type)

      request "/auto/categories/#{type}/driverTypes"
    end

    def fuels
      request '/auto/type'
    end

    def colors
      request '/auto/colors'
    end

    def options(type:)
      raise ArgumentError, '`type` should not be empty' if blank?(type)

      request "/auto/categories/#{type}/auto_options"
    end

    def average_price(*args)
      # raise NotImplementedError
      # TODO real data
      request "/auto/average_price", { marka_id: 9, model_id: 31612, gear_id: 1, gear_id: 2 }
    end

    def search(*args)
      raise NotImplementedError
    end

    def info(car_id:)
      raise ArgumentError, '`car_id` should not be empty' if blank?(car_id)

      request '/auto/info', auto_id: car_id
    end

    def photos(car_id:)
      raise ArgumentError, '`car_id` should not be empty' if blank?(car_id)

      request "/auto/fotos/#{car_id}", auto_id: car_id
    end

    private

    def request(url, params = {}, method = :get_response)
      uri = URI(default_url + url)
      uri.query = URI.encode_www_form(params.merge(api_key: api_key))
      response = Net::HTTP.public_send(method, uri)
      parsed response
    end

    def parsed(response)
      res = JSON.parse(response.body)
      raise ResponseError, res.dig('error').to_s if res.is_a?(Hash) && res.has_key?('error')

      yield res if block_given?
      res
    end

    def blank?(arg)
      respond_to?(:empty?) ? arg.empty? : !arg
    end
  end

  class ResponseError < StandardError; end
end

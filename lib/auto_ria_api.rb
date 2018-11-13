require 'auto_ria_api/version'
require 'net/http'
require 'json'

module AutoRiaApi
  class Base
    def initialize(api_key:, url: nil)
      raise ArgumentError, 'API key should not be empty.' if blank?(api_key)
      @api_key = api_key
      @default_url = url || 'https://developers.ria.com/'
    end

    def types
      request '/auto/categories'
    end

    def carcasses(type:, grouped: false, all: false)
      raise ArgumentError, 'Type should not be empty.' if blank?(type)
      return request '/auto/bodystyles' if all
      group = '_group' if grouped
      request "/auto/categories/#{type}/bodystyles/#{group}"
    end

    def marks(carcasse:)
      raise ArgumentError, 'Carcass should not be empty.' if blank?(carcasse)
      request "/auto/categories/#{carcasse}/marks"
    end

    def models(carcasse:, mark:, grouped: false, all: false)
      raise ArgumentError, 'Carcass should not be empty.' if blank?(carcasse)
      raise ArgumentError, 'Mark should not be empty.' if blank?(mark)
      return request '/auto/models' if all
      group = '_group' if grouped
      request "/auto/categories/#{carcasse}/marks/#{mark}/models/#{group}"
    end

    def regions
      request '/auto/states'
    end

    def cities(region:)
      raise ArgumentError, 'Region should not be empty.' if blank?(region)
      request "/auto/states/#{region}/cities"
    end

    def gearboxes(carcasse:)
      raise ArgumentError, 'Carcasse should not be empty.' if blank?(carcasse)
      request "/auto/categories/#{carcasse}/gearboxes"
    end

    def driver_types
      raise 'Not implemented'
    end

    def fuels
      request '/auto/type'
    end

    def colors
      request '/auto/colors'
    end

    def options(type:)
      raise ArgumentError, 'Type should not be empty.' if blank?(type)
      request "/auto/categories/#{type}/auto_options"
    end

    def average_price(*args)
      raise 'Not implemented'
    end

    def search(*args)
      raise 'Not implemented'
    end

    def info(car_id:)
      raise ArgumentError, 'car_id should not be empty.' if blank?(car_id)
      request '/auto/info', auto_id: car_id
    end

    def photos(car_id:)
      raise ArgumentError, 'car_id should not be empty.' if blank?(car_id)
      request "/auto/fotos/#{car_id}", auto_id: car_id
    end

    private

    def request(url, params = {}, method = :get_response)
      uri = URI(@default_url + url)
      uri.query = URI.encode_www_form(params.merge(api_key: @api_key))
      response = Net::HTTP.public_send(method, uri)
      parsed response
    end

    def parsed(response)
      res = JSON.parse(response.body)
      yield res if block_given?
      res
    rescue => e
      e
    end

    def blank?(arg)
      respond_to?(:empty?) ? arg.empty? : !arg
    end
  end

  class Error < StandardError; end
end

require 'net/http'
require 'uri'
require 'rubygems'
require 'json'

BASE_URL = 'https://vericoindice.com/api'


class VericoindiceError < Exception; end


class VericoindiceClient
  def initialize(api)
    @api = api
  end

  def get_balance
    uri = URI.parse "#{BASE_URL}/getbalance?api=#{@api}"

    self.make_response(Net::HTTP.get uri)
  end

  def roll(amount, chance = nil)
    uri = URI.parse "#{BASE_URL}/roll"

    data = {:api => @api, :amount => amount}
    if not chance.nil?
      data[:chance] = chance
    end

    self.make_response(Net::HTTP.post_form(uri, data).body)
  end

  def make_response(data)
    data = JSON.parse data
    if data.has_key?('error')
      throw VericoindiceError.new data['error']
    end
    data
  end
end

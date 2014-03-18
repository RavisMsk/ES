require "net/http"
require "json"
require "singleton"

class NeoREST
	include Singleton
  def initialize
  end
  def self.performCypherQuery(query="", params={})
    req = Net::HTTP::Post.new('http://localhost:7474/db/data/cypher')
    req.content_type = 'application/json'
    req.body = { :query => query, :params => params }.to_json
    res = Net::HTTP.start('127.0.0.1', 7474) do |http|
      http.request(req)
    end
    case res
    when Net::HTTPSuccess
      JSON.parse(res.body)
    else
      Shoes.warn res.body
      res.value
    end
  end
end
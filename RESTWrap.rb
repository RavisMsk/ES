# The MIT License (MIT)
# 
# Copyright (c) 2014 Anisimov Nikita <ravis.bmstu(at)gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require "net/http"
require "json"
require "singleton"

class NeoREST
  CLEAR = "match (n)-[r]-()
          optional match (m)
          delete n,r,m;"
  CREATE = "create (n:Person { name : { name }})
            RETURN n;"
  ROOT="match (root{type:'Root'})
        return root;"
  ROOT_ID = "match (root{type:'Root'})
            return id(root);"
	include Singleton
  attr_accessor :rID
  def initialize
    @rID = nil
  end
  def self.rootID
    if !self.instance.rID
      # Lazy load
      self.instance.rID = self.performCypherQuery(self::ROOT_ID)['data'][0][0]
      info "Lazy loaded rID = #{self.instance.rID}"
    end

    self.instance.rID
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
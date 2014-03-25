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

# Magic comments
#!/bin/env ruby
# encoding: utf-8

# Includes
require 'net/http'
require 'json'
require 'singleton'

class Cyphers1
  CLEAR = "start n = node(*) 
          match n-[r]-() 
          where (id(n)>0 and id(n)<10000) 
          delete n, r;"
  ROOT="start root=node(0) 
        return root;"
  ROOT_ID = "start root=node(0) 
            return id(root);"

end

class Cyphers2
  CLEAR = "match (n)-[r]-()
          optional match (m)
          delete n,r,m;"
  CREATE = "create (n:Person { name : { name }})
            RETURN n;"
  ROOT="match (root{type:'Root'})
        return root;"
  ROOT_ID = "match (root{type:'Root'})
            return id(root);"
end

# Check Neo4j version before working
checkVersion = Proc.new {
  uri = URI('http://localhost:7474/db/data/')
  req = Net::HTTP::Get.new(uri)
  req.content_type = 'application/json'
  res = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(req)
  end
  case res
  when Net::HTTPSuccess
    pRes = JSON.parse(res.body)
    # Now check 'neo4j_version'
    raise "Neo4j version should be 2.x. Your is #{pRes['neo4j_version']}." if pRes['neo4j_version']!='2.0.1'
  else
    res.value
  end
}
checkVersion.call

# Functions for REST API
def createNode(opts={}, succLog=nil, failLog=nil)
  uri = URI('http://localhost:7474/db/data/node')
  req = Net::HTTP::Post.new(uri)
  req.content_type = 'application/json'
  req.body = opts.to_json
  res = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(req)
  end
  case res
  when Net::HTTPSuccess
    Setups.log succLog if succLog != nil
    JSON.parse(res.body)
  else
    Setups.log failLog if failLog != nil
    res.value
  end
end

def createRel(from, to, type, opts, succLog=nil, failLog=nil)
  req = Net::HTTP::Post.new(from)
  req.content_type = 'application/json'
  req.body = { :to => to, :type => type, :data => opts }.to_json
  res = Net::HTTP.start(from.hostname, from.port) do |http|
    http.request(req)
  end
  case res
  when Net::HTTPSuccess
    Setups.log succLog if succLog != nil
    res.body
  else
    Setups.log failLog if failLog != nil
    res.value
  end
end

def nodeURIById(id)
  URI("http://localhost:7474/db/data/node/#{id}")
end

def createRelURIById(id)
  URI("http://localhost:7474/db/data/node/#{id}/relationships")
end

def cypherURI
  URI('http://localhost:7474/db/data/cypher')
end

def performCypherQuery(query="", params={})
  uri = cypherURI
  req = Net::HTTP::Post.new(uri)
  req.content_type = 'application/json'
  req.body = { :query => query, :params => params }.to_json
  res = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(req)
  end
  case res
  when Net::HTTPSuccess
    JSON.parse(res.body)
  else
    res.value
  end
end

# DSL setups
class Setups
  include Singleton
  attr_accessor :debug, :localStorage, :chaining, :root
  def initialize
    @localStorage = {}
    @debug = false
    @chaining = false
    @root = nil
  end
  def self.root
    self.instance.root
  end
  def self.log(text)
    puts text if Setups.instance.debug
  end
  def self.chaining(boolaen)
    self.instance.chaining = boolaen
  end
  def self.chaining?
    self.instance.chaining
  end
end

# Classes for DSL
class Subject
  def initialize
    @title = ''
    @criterions = {}
    @link = nil
  end

  def title(name)
    @title = name
  end

  def link(url)
    @link = url
  end

  def criterion(cName, cVal)
    # Get root id first
    rID = performCypherQuery(Cyphers2::ROOT_ID)
    # Validate criterion and variant
    if cVal.is_a? String
      cypher = "start root=node(#{rID['data'][0][0]}) 
                match (root)-[:coherence]-(criterion)-[:can_be]-(variant) 
                where criterion.name = '#{cName}' and variant.title = '#{cVal}' 
                return id(criterion) as CRIT, id(variant) as VAR;";
    elsif cVal.is_a? Numeric
      # Validate only criterion, variant is obvious
      cypher = "start root=node(#{rID['data'][0][0]}) 
                match (root)-[:coherence]-(criterion)-[:can_be]-(variant) 
                where criterion.name = '#{cName}' and variant.interval = 'true' 
                return id(criterion) as CRIT, id(variant) as VAR;";
    end

    res = performCypherQuery(cypher)

    found = res['data']

    raise "Invalid criterion '#{cName}' or variant'#{cVal}'." if found.empty?

    critNodeId = found[0][0]
    varNodeId = found[0][1]

    # Set it now
    @criterions[cName] = { :value => cVal, :cId => critNodeId, :vId => varNodeId }

  end

  def criterions(crits)
    crits.each do |cName, cVal|
      self.criterion cName, cVal
    end
  end

  def save
    raise 'Title must be specified.' if @title == ''

    Setups.log 'Creating subject node...'
    data = { :type => 'Subject', :title => @title }
    data[:link] = @link if @link
    res = createNode(data, 'Created subject node.')
    from = URI(res['create_relationship'])

    Setups.log "Working with criterions: #{@criterions.keys}"
    @criterions.each do |cName, data|
      Setups.log "Creating relationship to variant '#{data[:value]}' of criterion '#{cName}'"

      to = nodeURIById(data[:vId])
      payload = { value: data[:value], interval: 'true' } if data[:value]
      createRel(from, to, 'has_criterion', payload||{}, 'Created rel from subject to variant.')

    end
    
    'OK'
  end

end

class Criterion
  def initialize(cName)
    @name = cName
    @variants = []
    @isInterval = false
  end

  def interval
    raise "Already created some variants." if not @variants.empty?

    @isInterval = true
  end

  def variant(var)
    raise "Already set to interval." if @isInterval

    @variants << var
  end

  def save
    raise 'Name must be specified.' if @name == ''
    raise 'At least two variants must be specified.' if !@isInterval and @variants.count < 2

    Setups.log 'Creating criterion node...'
    res = createNode({ :type => 'Criterion', :name => @name }, 'Criterion node created.', 'Error creating criterion.')
    critNode = res['self']
    fromNodeURI = URI(res['create_relationship'])

    if @isInterval
      Setups.log "Creating interval variant node..."
      iRes = createNode({ :type => 'Variant', :interval => 'true', :title => 'Interval'})
      
      Setups.log "Creating relationship to interval node..."
      createRel(fromNodeURI, iRes['self'], 'can_be', nil, 'Created rel to interval variant.')
    end

    @variants.each do |variant|
      Setups.log "Creating variant \'#{variant}\' node..."
      iRes = createNode({ :type => 'Variant', :title => variant }, "Variant #{variant} created.", "Couldnt create #{variant} node.")
      to = iRes['self']

      Setups.log "Creating relationship to variant..."
      createRel(fromNodeURI, to, 'can_be', nil, 'Created rel to variant.', 'Error creating rel to variant.')
    end

    Setups.log 'Creating relationship for coherence from root to criterion...'
    root = (performCypherQuery(Cyphers2::ROOT))['data'][0][0]
    fromRoot = URI(root['create_relationship'])
    createRel(fromRoot, critNode, 'coherence', nil, 'Created rel to criterion.', 'Error rel from root to criterion.')

    'OK'
  end

end

class Question
  def initialize
    @q = ''
    @ans = []
    @cat = nil
    @chained = nil
    @isInterval = false
  end

  def text(q = "Пьет ли рыба воду?")
    @q = q
  end

  def criterion(cat)
    Setups.log "Validating given criterion '#{cat}'..."
    # Validate criterion
    rID = performCypherQuery(Cyphers2::ROOT_ID)
    cypher = "start root=node(#{rID['data'][0][0]}) 
              match (root)-[:coherence]-(criterion) 
              where criterion.name = '#{cat}'
              return id(criterion) as CRIT, criterion.name as CNAME;";
    res = performCypherQuery(cypher)

    found = res['data']

    raise "Invalid criterion '#{cat}'." if found.empty?

    critNodeId = found[0][0]
    critNodeName = found[0][1]

    @cat = { :name => cat, :cId => critNodeId, :cName => critNodeName }
  end

  def interval
    raise "Answers already specified." if not @ans.empty?

    @isInterval = true
  end

  def answer(answ, move)
    raise "Interval specified already." if @isInterval
    raise "Answer should be specified with chain symbol or criterion variant." if move == nil

    @ans << [answ, move]
  end

  def chained(tag)
    # Means this question goes after some other question
    # Validate there is such chain in cache
    raise 'No such chain.' if Setups.instance.localStorage[tag] == nil

    @chained = tag
  end

  def save
    raise 'Question must be specified with \'text\'.' if @q == ''
    raise 'Category must be specified by its name with \'criterion\'.' if @cat == nil
    raise 'At least one answer must be specified with \'answer\'.' if @ans.empty? and !@isInterval

    rID = performCypherQuery(Cyphers2::ROOT_ID)

    Setups.log 'Creating question node...'
    qNode = createNode({ :type => 'Question', :text => @q }, 'Question node created.')

    # Process chaining
    if @chained == nil
      Setups.log 'Creating rel from criterion to this question...'
      createRel(createRelURIById(@cat[:cId]), qNode['self'], 'chain', {}, 'Created chain from criterion to question.')
    else
      # Look into cache and find out answer
      ans = Setups.instance.localStorage[@chained]
      createRel(URI(ans), qNode['self'], 'chain', {}, 'Created chain from previous answer to current question.')
    end

    if @isInterval
      cypher = "match ({type:'Root'})-[]-({name:'Test Interval'})-[]-(int {interval:'true'})
                return int;"
      iID = performCypherQuery(cypher)
      Setups.log 'Creating chain to interval node...'
      createRel(URI(qNode['create_relationship']), iID['data'][0][0]['self'], 'chain', {}, 'Created chain from question to interval node.')
    end

    Setups.log 'Processing answers...' if not @isInterval
    @ans.each do |answer|
      Setups.log "Creating answer '#{answer}' node..."
      aNode = createNode({ :type => 'Answer', :text => answer[0] }, 'Created answer.')
      createRel(URI(qNode['create_relationship']), aNode['self'], 'answ_as', {}, 'Created rel from question to answer.')
      # Now process answer chaining
      # Analyze answer[1], so if it is a valid variant of some criterion, then chain to it
      # Else chain to next question, specified by answer[1]
      cypher = "start root=node(#{rID['data'][0][0]}) 
                match (root)-[:coherence]-(criterion)-[:can_be]-(variant) 
                where variant.title = '#{answer[1]}' and criterion.name = '#{@cat[:cName]}'
                return id(variant) as VAR;"
      res = performCypherQuery(cypher)
      if (res['data'].empty?)
        # Variant not found
        # Add this chain-tag to cache
        # So when next question tagged by it comes we will spawn chain
        Setups.instance.localStorage[answer[1]] = aNode['create_relationship']
      else
        # Variant found!
        createRel(URI(aNode['create_relationship']), nodeURIById(res['data'][0][0]), 'chain', {}, 'Created rel from answer to variant.')
      end

    end

    'OK'
  end

end

# DSL methods
def setDebug
  s = Setups.instance
  s.debug = true
  'Debug mode ON.'
end

def clearDB
  uri = URI('http://localhost:7474/db/data/cypher')
  req = Net::HTTP::Post.new(uri)
  req.content_type = 'application/json'
  req.body = { :query => Cyphers2::CLEAR, :params => {} }.to_json
  res = Net::HTTP.start(uri.hostname, uri.port) do |http|
    http.request(req)
  end
  case res
  when Net::HTTPSuccess
    # 'OK'
  else
    res.value
  end
  # Now create new root node and store it
  nr = createNode({ :type=>'Root', :title=>'By Nikita Anisimov'}, 'Root node created.')
  Setups.instance.root = nr
  'OK'
end

def addSubject(&block)
  subj = Subject.new
  subj.instance_eval(&block)
  subj.save
end

def addCriterion(cName, &block)
  criterion = Criterion.new(cName)
  criterion.instance_eval(&block)
  criterion.save
end

def addQuestion(&block)
  question = Question.new
  question.instance_eval(&block)
  question.save
end

def startQuestionChain
  Setups.chaining(true)
end

def endQuestionChain
  Setups.instance.localStorage = {}
  Setups.chaining(false)
end

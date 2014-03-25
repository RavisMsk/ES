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

require "singleton"
require "./RESTWrap.rb"

class Model

  def initialize
    @esState = {
      criteria: {},
      questions: {},
      results: [],
      q: nil
    }
    @events = { 
      onCriteria: [],
      onQuestion: [],
      onResult: [],
      onFinish: []
    }
    @qFetched = false
    @criterionInWork = nil
  end

  private
  def fetchQuestions
    # Should be called only once
    raise 'Fetch questions may be called only once.' if @qFetched

    cypher = "start root=node(#{NeoREST.rootID})
              match (root)-[:coherence]-(criterion)-[:chain]-(question)-[:answ_as]-(answer)
              return criterion.name as C, question.text as Q, answer.text as A;"
    res = NeoREST.performCypherQuery(cypher)
    questions = res['data']
    questions.each do |question|
      if @esState[:questions][question[0]] == nil
        @esState[:questions][question[0]] = { q: question[1], a: []} 
      end
      @esState[:questions][question[0]][:a] << question[2]
    end
    # Now choose question
    picked = false
    @esState[:questions].each do |q, data|
      if @esState[:criteria][q][:variant] == nil
        # Take this question
        callOnQuestion data
        @criterionInWork = q
        picked = true
        break
      else
        # Pass this question
      end
    end
    if picked == false
      callOnFinish
    end
    @qFetched = true
  end
  def pickNextQuestion
    picked = false
    @esState[:questions].each do |q, data|
      if @esState[:criteria][q][:variant] == nil
        # Take this question
        callOnQuestion data
        @criterionInWork = q
        picked = true
        break
      else
        # Pass this question
      end
    end

    if picked == false
      # No more questions
      callOnFinish
    end

  end
  def refreshResults
    @esState[:results].clear
    firstInfest = false
    @esState[:criteria].each do |criterion, data|
      res = data[:res]
      if res.empty?
        # Not yet filled/answered
      else
        if @esState[:results].empty? && !firstInfest
          info "Infesting: #{res}"
          @esState[:results] = @esState[:results] | res
          firstInfest = true
        else
          info "Intersecting: #{res}"
          @esState[:results] = @esState[:results] & res
        end
      end
    end
    info "Total result: #{@esState[:results]}"
    callOnResult
  end
  def refreshResultsWith(criterion, variant)
    cypher = "start root=node(#{NeoREST.rootID})
              match (root)-[:coherence]-(criterion)-[:can_be]-(variant)-[:has_criterion]-(subject)
              where criterion.name = '#{criterion}' and variant.title = '#{variant}'
              return subject as ST;"
    res = NeoREST.performCypherQuery(cypher)
    found = res['data']
    @esState[:criteria][criterion][:res].clear
    found.each { |result| 
      resData = { title: result[0]['data']['title'], link:result[0]['data']['link'] }
      @esState[:criteria][criterion][:res] << resData
    }
    # Form @esState[:results]
    refreshResults
    # If there is 2 or less results then finish this bullshit!
    callOnFinish if @esState[:results].count <= 2
  end
  # Observer pattern
  def callOnCriteria
    @events[:onCriteria].each do |savedProc|
      savedProc.call @esState[:criteria]
    end
  end
  def callOnQuestion(q)
    @events[:onQuestion].each do |savedProc|
      savedProc.call q
    end
  end
  def callOnResult
    @events[:onResult].each do |savedProc|
      savedProc.call @esState[:results]
    end
  end
  def callOnFinish
    @events[:onFinish].each do |savedProc|
      savedProc.call
    end
  end
  public
  def start
    # Work with ES DB
    # Fetch all criteria and create local storage
    cypher = "start root=node(#{NeoREST.rootID}) 
              match (root)-[:coherence]-(criterion)
              return criterion.name as CRIT;"
    res = NeoREST.performCypherQuery(cypher)
    found = res['data']
    found.each do |criterion|
      @esState[:criteria][criterion[0]] = { variant: nil, res: [] }
    end
    # Calling observers
    callOnCriteria
    # Now fetch question
    fetchQuestions
  end
  def handleAnswer(q)
    # Thats in case of solo question
    cypher = "start root=node(#{NeoREST.rootID})
              match (root)-[:coherence]-(criterion)-[:chain]-(question)-[:answ_as]-(answer)-[:chain]-(future)
              where question.text = '#{q[:q]}' and answer.text = '#{q[:a]}' and criterion.name = '#{@criterionInWork}'
              return criterion.name as C, future.type as FT, future as F, id(future) as FID limit 1;"
    res = NeoREST.performCypherQuery(cypher)
    found = res['data'][0]
    if !found
      # Thats pattern for chained questions
      cypher = "start root=node(#{NeoREST.rootID})
                match (root)-[:coherence]-(criterion)-[:chain]-()-[:answ_as]-()-[:chain]-(question)-[:answ_as]-(answer)-[:chain]-(future)
                where question.type = 'Question' and question.text = '#{q[:q]}' and answer.text = '#{q[:a]}' and criterion.name = '#{@criterionInWork}'
                return criterion.name as C, future.type as FT, future as F, id(future) as FID limit 1;"
      res = NeoREST.performCypherQuery(cypher)
      found = res['data'][0]
    end
    if found[1] == 'Variant'
      # Handle it like end of this criteria
      @esState[:criteria][found[0]][:variant] = found[2]['data']['title']
      # Refresh criteria list
      callOnCriteria
      # Now fetch next question
      pickNextQuestion
      # Refresh our results list
      refreshResultsWith found[0], found[2]['data']['title']
    else
      # Move to chained question
      cypher = "start q=node(#{found[3]})
                match (q)-[:answ_as]-(answer)
                return answer.text as AT;"
      res = NeoREST.performCypherQuery(cypher)
      nFound = res['data']
      reStruct = []
      nFound.each do |nf|
        reStruct << nf[0]
      end
      callOnQuestion q: found[2]['data']['text'], a: reStruct
    end
  end
  def pickQuestionForCriterion(c)
    raise "Question for #{c} not found" if @esState[:questions][c] == nil

    callOnQuestion @esState[:questions][c]
    @criterionInWork = c
  end
  def resetCriterion(c)
    @esState[:criteria][c][:variant] = nil
    @esState[:criteria][c][:res].clear
    refreshResults
    callOnCriteria
  end
  # Observer pattern
  def onCriteria(&block)
    saviour = Proc.new block
    @events[:onCriteria] << saviour
  end
  def onQuestion(&block)
    saviour = Proc.new block
    @events[:onQuestion] << saviour
  end
  def onResult(&block)
    saviour = Proc.new block
    @events[:onResult] << saviour
  end
  def onFinish(&block)
    saviour = Proc.new block
    @events[:onFinish] << saviour
  end
end

config = {
  title: "Экспертный предсказатель",
  width: 850,
  height: 450,
  resizable: false
}

Shoes.setup {
  # gem 'launchy'
}

Shoes.app config do

  @model = Model.new

  stack width: 450, height: 450 do
    border black, strokewidth: 1
    para "Критерии:"
    @cElements = []
    @criteriaLayer = stack width: 430, height: 415, margin_left: 20, scroll: true do
      p = para "Загружаю критерии..."
      @cElements << p
    end

    @model.onCriteria do |criteria|
      # Remove all previous elements
      @cElements.each do |el|
        el.remove
      end
      # Fill with criteria
      criteria.each do |criterion, data|
        @criteriaLayer.append do
          s1 = stack width: 430 do 
            para criterion
            flow width: 400, margin_left: 30 do
              para data[:variant]||'не определен'
              button 'Re-pick' do
                @model.pickQuestionForCriterion criterion
              end
              button 'Reset' do
                @model.resetCriterion criterion
              end
            end
          end
          @cElements << s1
        end
      end
    end

  end

  stack width: 400, height: 450 do
    stack width: 400, height: 300 do
      border black, strokewidth: 1
      para "Текущий вопрос:"
      @questionLayer = stack width: 400, height: 270 do

      end
      @elements = []

      @model.onQuestion do |question|
        @elements.each do |el|
          el.remove
        end
        @questionLayer.append do
          p = para question[:q]
          @elements << p
          answers = []
          f = flow do 
            stack width: 250, margin_left: 50 do
              question[:a].each do |answer|
                flow do 
                  rad = radio :qAnsGroup
                  para answer
                  answers << [rad, answer]
                end
              end
            end
            stack width: 150 do
              button "Далее" do
                answers.each do |answer|
                  rad = answer[0]
                  if rad.checked?
                    @model.handleAnswer q: question[:q], a: answer[1]
                  end
                end
              end
            end
          end
          @elements << f
        end
      end

      @model.onFinish do 
        @elements.each do |el|
          el.remove
        end
        @questionLayer.append do
          @elements << (caption "Вопросов больше нет.")
          @elements << (caption "Результаты можно посмотреть внизу.")
        end
      end

    end

    stack width: 400, height: 150 do
      border black, strokewidth: 1
      @rTitle = para "Промежуточые результаты:"
      @resultLayer = flow width: 400, height: 150 do

      end
      @rElements = []

      @model.onResult do |results|
        @rElements.each do |el|
          el.remove
        end
        @resultLayer.append do
          results.each do |result|
            if result[:link]
              paras = para(
                link(result[:title]).click do
                  `open #{result[:link]}`
                end
              )
            else
              paras = para result[:title]
            end
            @rElements << paras
          end
        end
      end

      @model.onFinish do
        @rTitle.text = 'Результат:'
      end

    end
  end

  @model.start
end
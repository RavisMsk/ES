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

    cypher = "start root=node(0)
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
      if @esState[:criteria][q] == nil
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
      if @esState[:criteria][q] == nil
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
  def refreshResultsWith(criterion, variant)
    cypher = "start root=node(0)
              match (root)-[:coherence]-(criterion)-[:can_be]-(variant)-[:has_criterion]-(subject)
              where criterion.name = '#{criterion}' and variant.title = '#{variant}'
              return subject.title as ST;"
    res = NeoREST.performCypherQuery(cypher)
    found = res['data']
    info "Found: #{found}"
    if @esState[:results].empty?
      # Means no results yet
      # Add all we got now
      found.each { |result| @esState[:results] << result[0] }
    else
      # Save only intersection of 2 arrays
      # Have to refactor returned array, because each damn string is in additional array, have to uncover it
      reStruct = [] 
      found.each { |result| reStruct << result[0] }
      @esState[:results] = reStruct & @esState[:results]
    end
    callOnResult
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
    cypher = "start root=node(0) 
              match (root)-[:coherence]-(criterion)
              return criterion.name as CRIT;"
    res = NeoREST.performCypherQuery(cypher)
    found = res['data']
    found.each do |criterion|
      @esState[:criteria][criterion[0]] = nil
    end
    # Calling observers
    callOnCriteria
    # Now fetch question
    fetchQuestions
  end
  def handleAnswer(q)
    cypher = "start root=node(0)
              match (root)-[:coherence]-(criterion)-[:chain]-(question)-[:answ_as]-(answer)-[:chain]-(future)
              where question.text = '#{q[:q]}' and answer.text = '#{q[:a]}' and criterion.name = '#{@criterionInWork}'
              return criterion.name as C, future.type as FT, future as F, id(future) as FID limit 1;"
    res = NeoREST.performCypherQuery(cypher)
    found = res['data'][0]
    if !found
      cypher = "start root=node(0)
                match (root)-[:coherence]-(criterion)-[:chain]-()-[:answ_as]-()-[:chain]-(question)-[:answ_as]-(answer)-[:chain]-(future)
                where question.text = '#{q[:q]}' and answer.text = '#{q[:a]}' and criterion.name = '#{@criterionInWork}'
                return criterion.name as C, future.type as FT, future as F, id(future) as FID limit 1;"
      res = NeoREST.performCypherQuery(cypher)
      found = res['data'][0]
    end
    if found[1] == 'Variant'
      # Handle it like end of this criteria
      @esState[:criteria][found[0]] = found[2]['data']['title']
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
      criteria.each do |criterion, variant|
        @criteriaLayer.append do
          s1 = stack width: 430 do 
            para criterion
            flow width: 400, margin_left: 30 do
              para variant||'не определен'
              button 'Re-pick' do
                
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
          caption "Вопросов больше нет."
          caption "Результаты можно посмотреть внизу."
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
            @rElements << (para result)
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
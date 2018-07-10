#!/usr/bin/env ruby

# file: alexa_skillresponse.rb


require 'rscript'


class AlexaSkillResponse

  def initialize(package, debug: false)
    @rscript = RScript.new(type: 'response', debug: debug)
    @package, @debug = package, debug
    puts '@package: ' + @package.inspect if @debug
  end

  def run(h)

    req = h[:request]
    id = req[:type] == 'IntentRequest' ? req[:intent][:name] : 'welcome'
    puts 'id: ' + id.inspect if @debug

    code, _, attr = @rscript.read ['//response:' + id, @package]
    text, mimetype = eval(code)

    return out if mimetype == 'application/json'

    output text, attr[:attentive]
  end

  def output(s='I hear you', attentive)

    h = { 
      version: "1.0",
      response: {
        outputSpeech: {
          type: "PlainText",
          text: ""
        }
      }
    }

    h[:response][:outputSpeech][:text] = s
    puts 'attentive: ' + attentive.inspect if @debug
    h[:response][:shouldEndSession] = (attentive == 'true') ? false : true

    h
  end

end

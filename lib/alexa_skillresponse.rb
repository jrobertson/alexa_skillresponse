#!/usr/bin/env ruby

# file: alexa_skillresponse.rb


require 'rscript'


class AlexaSkillResponse

  def initialize(package, debug: false, rsc: nil, 
                 whitelist: {users: nil, devices: nil})
    
    @rscript = RScript.new(type: 'response', debug: debug)
    @package, @debug, @rsc = package, debug, rsc
    puts '@package: ' + @package.inspect if @debug
    
    @user_list, @device_list = whitelist[:users], whitelist[:devices]
    puts '@user_list: ' + @user_list.inspect if @debug
    
  end
  
  def reset()
    @rscript.reset
  end
  
  alias reload reset

  def run(h)
    
    userid = h[:session][:user][:userId]
    deviceid = h[:context][:System][:device][:deviceId]
    puts 'userid: ' + userid.inspect if @debug

    if @user_list and not @user_list.include? userid then
      return output('Sorry, unauthorized user.') 
    end
    
    if @device_list and not @device_list.include? deviceid then
      return output('Sorry, unauthorized device.') 
    end    
    
    req = h[:request]
    
    id = req[:type] == 'IntentRequest' ? req[:intent][:name] : 'welcome'
    puts 'id: ' + id.inspect if @debug

    code, _, attr = @rscript.read ['//response:' + id, @package]
    rsc = @rsc if @rsc
    puts 'code:'  + code.inspect if @debug
    text, mimetype = eval(code)

    return out if mimetype == 'application/json'

    output text, attentive: attr[:attentive]
    
  end
  
  private

  def output(s='I hear you', attentive: false)

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

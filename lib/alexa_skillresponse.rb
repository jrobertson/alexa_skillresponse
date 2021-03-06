#!/usr/bin/env ruby

# file: alexa_skillresponse.rb


require 'rscript'


class AlexaSkillResponse
  using ColouredText

  def initialize(package, debug: false, rsc: nil, 
                 whitelist: {users: nil, devices: nil})
    
    @rscript = RScript.new(type: 'response', debug: debug)
    @package, @debug, @rsc = package, debug, rsc
    puts '@package: ' + @package.inspect if @debug
    
    @users, @devices = whitelist[:users], whitelist[:devices]
    puts '@user_list: ' + @user_list.inspect if @debug
    
  end
  
  def reset()
    @rscript.reset
  end
  
  alias reload reset

  def run(h)
    
    puts 'inside run: '.info if @debug

    userid = h[:session][:user][:userId]
    puts ('userid: ' + userid.inspect).debug if @debug
    
    deviceid = h[:context][:System][:device][:deviceId]
    puts ('deviceid: ' + userid.inspect).debug if @debug

    if @users and not @users.include? userid then
      return output('Sorry, unauthorized user.') 
    else
      user = @users[userid]
      puts ('user: ' + user.inspect).debug if @debug
    end
    
    if @devices and not @devices.include? deviceid then
      return output('Sorry, unauthorized device.') 
    else
      device = @devices[deviceid]
      puts ('device: ' + device.inspect).debug if @debug
    end

    req = h[:request]
    
    id = req[:type] == 'IntentRequest' ? req[:intent][:name] : 'welcome'
    puts 'id: ' + id.inspect if @debug

    code, _, attr = @rscript.read ['//response:' + id, @package]
    
    if @rsc then
      
      rsc = @rsc
      puts 'rsc found'.info if @debug
      
      if rsc.registry and user and device then
        
        e = rsc.registry.get_key 'hkey_apps/alexa/accounts'
        euserid = e.xpath('*/id').find {|x| x.text.to_s == userid}        

        if euserid then
          puts ('sending to the registry').info if @debug
          rsc.registry.set_key("hkey_apps/alexa/accounts/" + 
                  euserid.parent.name + "/lastsession/device", device)
        end
      end
    end
    
    puts 'code:'  + code.inspect if @debug
    text, mimetype = eval(code)
    
    return ssml_output text if text =~ /<speak/

    case mimetype
    when 'application/json'
      txt_output text
    when 'application/ssml'
      ssml_output text
    else      
      txt_output text, attentive: attr[:attentive]
    end

      
  end
  
  private
  
  def output(s)

    h = { 
      version: "1.0",
      response: {
        outputSpeech: {
          type: "PlainText",
          text: "#{s}"
        }
      }
    }
    
  end
  
  def ssml_output(s)
    
    h = { 
      version: "1.0",
      response: {
        outputSpeech: {
          type: "SSML",
          ssml: ""
        }
      }
    }    
    
    h[:response][:outputSpeech][:ssml] = s
    
    h
  end

  def txt_output(s='I hear you', attentive: false)

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

class AlexaSkillResponseCollection
  
  def initialize(skills={}, debug: false, rsc: nil, 
                 whitelist: {users: nil, devices: nil})
    
    @debug = debug
    @skills = skills.inject({}) do |r, x|
      
      package_name, rsf_package = x
      asr = AlexaSkillResponse.new(rsf_package, debug: debug, rsc: rsc, 
                                   whitelist: whitelist)
      r.merge(package_name => asr)
          
    end
    
  end
  
  def run(skill, h)
    
    puts 'skill: ' + skill.inspect if @debug
    puts '@skills: ' + @skills.inspect if @debug
    @skills[skill].run h

  end
  
end

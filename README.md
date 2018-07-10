# Introduing the Alexa_skillresponse gem


    require 'alexa_skillresponse'

    req =  {"version"=>"1.0", "session"=>{"new"=>true, "sessionId"=>"amzn1.echo-api.session.1", "application"=>{"applicationId"=>"amzn1.ask.skill.0"}, "user"=>{"userId"=>"amzn1.ask.account.I"}}, "context"=>{"System"=>{"application"=>{"applicationId"=>"amzn1.ask.skill.0"}, "user"=>{"userId"=>"amzn1.ask.account.I"}, "device"=>{"deviceId"=>"amzn1.ask.device.A", "supportedInterfaces"=>{}}, "apiEndpoint"=>"https://api.eu.amazonalexa.com", "apiAccessToken"=>"A"}}, "request"=>{"type"=>"LaunchRequest", "requestId"=>"amzn1.echo-api.request.a", "timestamp"=>"2018-07-10T19:42:52Z", "locale"=>"en-GB", "shouldLinkResultBeReturned"=>false}}

    h = JSON.parse req.to_json, symbolize_names: true
    asr = AlexaSkillResponse.new(package='/home/james/tmp/icecream.rsf', debug: true)
    asr.run(h)


file: icecream.rsf

<pre>
&lt;skill&gt;
  &lt;response id='welcome' attentive='false'&gt;
    &lt;script&gt;
    'How can I help you?'
    &lt;/script&gt;
  &lt;/response&gt;
  &lt;response id='IcecreamAsk' attentive='true'&gt;
    &lt;script&gt;
    'Would you like a cone or a tub?'
    &lt;/script&gt;
  &lt;/response&gt;
&lt;/skill&gt;
</pre>


Output:

<pre>
=&gt; {:version=&gt;"1.0", :response=&gt;{:outputSpeech=&gt;{:type=&gt;"PlainText", :text=&gt;"How can I help you?"}, :shouldEndSession=&gt;false}}
</pre>

The Alexa_skillresponse gem can be used with any web framework to process a request from an Alexa Skill. It relies upon the logical responses to be found from a kind of XML file known as an RSF file.

## Resources

* alexa_skillresponse https://rubygems.org/gems/alexa_skillresponse

alexa amazon response skill gem request

Gem::Specification.new do |s|
  s.name = 'alexa_skillresponse'
  s.version = '0.2.2'
  s.summary = 'Responds to an Alexa Skill request using Ruby scripts ' + 
      'embedded in a kind of XML format'
  s.authors = ['James Robertson']
  s.files = Dir['lib/alexa_skillresponse.rb']
  s.add_runtime_dependency('rscript', '~> 0.7', '>=0.7.1')
  s.signing_key = '../privatekeys/alexa_skillresponse.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/alexa_skillresponse'
end

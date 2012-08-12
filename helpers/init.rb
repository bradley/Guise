# encoding: utf-8
Dir.glob(File.dirname(__FILE__) + "/**/*.rb").each { |r| require r }

# From nicebytes.rb
App.helpers NiceBytes

# From conjure.rb
App.helpers Conjure
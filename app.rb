require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'views/index'
require 'views/done'


Index.new
Done.new
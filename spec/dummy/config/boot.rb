ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
$:.unshift File.expand_path('../../../../lib', __FILE__)

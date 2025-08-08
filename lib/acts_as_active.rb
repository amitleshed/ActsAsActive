# frozen_string_literal: true

require_relative "acts_as_active/version"
require "acts_as_active/activable"
require "acts_as_active/railtie" if defined?(Rails)

module ActsAsActive
  class Error < StandardError; end
  # Your code goes here...
end

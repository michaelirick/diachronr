# frozen_string_literal: true

require 'yaml'

module Diachronr
  # a set of rules, categories, and rewrites applicable to words
  class RuleSet
    attr_accessor :rules, :categories, :rewrites, :options

    def initialize(rules, categories, rewrites, options = {})
      @rules = rules
      @categories = categories
      @rewrites = rewrites
      @options = options
    end # initialize

    def self.load(filename)
      options = YAML.load_file filename
      rules = options['rules'].map { |a| Diachronr::Rule.new(a) }
      categories = options['categories'].map { |a| Diachronr::Category.new(a) }
      rewrites = options['rewrites'].map { |a| Diachronr::Rewrite.new(a) }
      RuleSet.new rules, categories, rewrites, options
    end

    def apply(target)
      @rewrites.each do |rewrite|
        target = rewrite.apply target
      end # each

      @rules.each do |rule|
        target = rule.apply target, categories: @categories
      end # each

      @rewrites.each do |rewrite|
        target = rewrite.reverse target
      end # each
      target
    end # apply
  end # class
end # module

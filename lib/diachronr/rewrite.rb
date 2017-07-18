# frozen_string_literal: true

module Diachronr
  # rules for rewriting character variations and digraphs
  class Rewrite
    attr_accessor :from, :to

    def initialize(rewrite)
      @from, @to = rewrite.split '|'
    end # initialize

    def apply(target)
      target.gsub @from, @to
    end # apply

    def reverse(target)
      target.gsub @to, @from
    end
  end # class
end # module

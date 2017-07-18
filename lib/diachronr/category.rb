# frozen_string_literal: true

module Diachronr
  # rules for groups of sounds
  class Category
    attr_accessor :sign, :contents

    def initialize(category)
      @sign, @contents = category.split '='
    end # initialize
  end # class
end # module

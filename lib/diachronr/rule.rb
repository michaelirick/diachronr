# frozen_string_literal: true

module Diachronr
  # rule for applying a single sound change
  class Rule
    attr_accessor :from
    attr_accessor :to
    attr_accessor :condition

    def initialize(rule)
      @from, @to, @condition = rule.split '/'
    end # initialize

    def to_s
      "'#{@from}' > '#{@to}' / '#{@condition}'"
    end # to_s

    def category?(categories)
      categories?(from, categories) || categories?(condition, categories)
    end

    def categories?(value, categories)
      !get_categories(value, categories).empty?
    end

    def get_categories(value, categories)
      categories.select { |c| value && value.include?(c.sign) }
    end

    def new_to(categories, category_index, index)
      t = get_categories(to, categories)[category_index]
      return to if t.nil?
      contents = t.contents.chars.include?(',') ? t.contents.split(',') : t.contents.chars
      contents[index]
    end # new_to

    def new_from(category, char)
      from.gsub category.sign, char
    end

    def category_rules(categories)
      rules = []
      get_categories(from, categories).each_with_index do |cat, i|
        contents = cat.contents.chars.include?(',') ? cat.contents.split(',') : cat.contents.chars
        contents.each.with_index do |f, fi|
          rules << Rule.new(
            "#{new_from(cat, f)}/#{new_to(categories, i, fi)}/#{condition}"
          )
        end
      end
      rules
    end

    def condition_rules(categories)
      rules = []
      get_categories(condition, categories).each do |cat|
        cat.contents.each_char do |c|
          new_condition = condition.gsub cat.sign, c
          rules << Rule.new("#{from}/#{to}/#{new_condition}")
        end
      end
      rules
    end

    def merge_matches(target, matches)
      new_target = target.dup
      matches.each do |match|
        match.each_char.with_index do |m, i|
          new_target[i] = m if target[i] != m
        end
      end
      new_target
    end

    def apply_categories(target, categories)
      # parse categories, apply each exploded rule to the original target
      # merge the changes together
      rules = category_rules(categories) + condition_rules(categories)
      matches = rules.map { |r| r.apply target, categories: categories }
      matches.uniq!
      matches.delete target

      matches.count == 1 ? matches.first : merge_matches(target, matches)
    end

    def apply(target, options = {})
      categories = options[:categories] || []
      return apply_categories target, categories if category? categories

      # construct regex from condition
      from_condition = @condition.gsub '_', @from
      to_condition = @condition.gsub '_', @to

      # change word boundaries to regex
      from_condition = Regexp.new from_condition.gsub('#', '\b')
      to_condition.delete! '#'

      # split on from_condition and join with to_condition
      # if you need a limit higher than 10.... nope
      split_target = target.split from_condition, 10
      split_target.join to_condition
    end # apply
  end # class
end # module

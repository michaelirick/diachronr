require_relative 'test_helper.rb'
require 'minitest/autorun'
require 'diachronr'

class DiachronrTest < Minitest::Test
  def test_should_create_a_rule
    r = Diachronr::Rule.new 'a//_'
    assert_equal r.to_s, "'a' > '' / '_'"
  end

  def test_apply_simple_rule
    r = Diachronr::Rule.new 'a//_'
    assert_equal r.apply('taco'), 'tco'
  end

  def test_apply_condition
    r = Diachronr::Rule.new 'a/b/d_e'
    assert_equal r.apply('daetat'), 'dbetat'
  end

  def test_apply_word_boundry
    r = Diachronr::Rule.new 'a/e/_#'
    assert_equal r.apply('data'), 'date'
  end

  def test_apply_rewrite
    r = Diachronr::Rewrite.new 'dh|ð'
    assert_equal r.apply('edhel'), 'eðel'
  end

  def test_apply_ruleset
    r = Diachronr::RuleSet.load 'test/fixtures/seonic_to_varag.yml'
    r.options['seonic'].each do |seonic, varag|
      assert_equal varag, r.apply(seonic)
    end
  end

  def test_apply_ruleset_multi_category
    r = Diachronr::RuleSet.load 'test/fixtures/multi-char.yml'
    r.options['test'].each do |from, to|
      assert_equal to, r.apply(from)
    end
  end

end

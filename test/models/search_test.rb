require "test_helper"

class SearchTest < ActiveSupport::TestCase
  context "#entries" do
    should "return empty array with no query" do
      assert_equal Search.new(query: nil).entries, Entry.none
    end

    should "return entry query with a query" do
      assert_equal Search.new(query: "cult").entries, Entry.by_name.containing("cult")
    end

    should "ignore punctuation when matching" do
      entry = Entry.create(name: "Example", description: "Match: a colon")
      assert_includes Search.new(query: "matching a colon").entries, entry
    end

    should "unaccent special characters in entry description when matching" do
      entry = Entry.create(name: "Example", description: "A Mörk Borg entry")
      assert_includes Search.new(query: "mörk borg").entries, entry
    end

    should "unaccent special characters in entry name when matching" do
      entry = Entry.create(name: "Mörk Borg Entry", description: "An entry")
      assert_includes Search.new(query: "mörk borg").entries, entry
    end
  end

  context "#tags" do
    should "return empty array with no query" do
      assert_equal Search.new(query: nil).tags, Tag.none
    end

    should "return tag query with a query" do
      assert_equal Search.new(query: "cult").tags, Tag.by_name.containing("cult")
    end

    should "unaccent special characters in tag name when matching" do
      assert_includes Search.new(query: "mörk borg").tags, tags(:mork_borg_cult)
    end
  end
end

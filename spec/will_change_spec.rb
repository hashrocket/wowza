require 'spec_helper'

describe Wowza::WillChange do
  it 'a newly instantiated object is unchanged' do
     person = Person.new("Uncle Bob")
     expect(person.changed?).to be(false)
  end

  it 'changing a tracked attribute makes object changed' do
     person = Person.new("Uncle Bob")
     person.name = "Uncle Billy"
     expect(person.changed?).to be(true)
  end

  it 'clearing changes makes object unchanged' do
     person = Person.new("Uncle Bob")
     person.name = "Uncle Billy"
     person.reload!
     expect(person.changed?).to be(false)
  end

  it 'applying changes makes object unchanged' do
     person = Person.new("Uncle Bob")
     person.name = "Uncle Billy"
     person.save
     expect(person.changed?).to be(false)
  end

  it 'changes contain a hash of from and to values' do
     person = Person.new("Uncle Bob")
     person.name = "Uncle Billy"
     expect(person.changes).to eq({ name: ["Uncle Bob", "Uncle Billy"] })
  end
end

class Person
  include Wowza::WillChange

  track_changes :name

  def initialize(name)
    @name = name
  end

  def name
    @name
  end

  def name=(val)
    will_change!(:name) unless val == @name
    @name = val
  end

  def save
    changes_applied
  end

  def reload!
    clear_changes_information
  end

  def rollback!
    restore_attributes
  end
end

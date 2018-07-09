class Api::PeopleController < Api::BaseController
  respond_to :json

  def index
    respond_with people
  end

  def letter_frequency
    respond_with character_count
  end

  def potential_duplicates
    respond_with people_with_potential_duplicates
  end

  private

  def people
    @people = Person.all.select('email', 'full_name', 'title')
  end

  def character_count
    Person.email_address_character_count
  end

  def people_with_potential_duplicates
    PeopleWithPotentialDuplicates.new.to_builder
  end
end

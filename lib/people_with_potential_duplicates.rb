class PeopleWithPotentialDuplicates
  def to_builder
    Jbuilder.new do |json|
      json.data do
        json.array! people do |person|
          json.display_name person.full_name
          json.email_address person.email
          json.job_title person.title
          json.potential_duplicates person.similar_email_addresses
        end
      end
    end.target!
  end

  private

  def people
    @people ||= Person.all.limit(10)
  end
end

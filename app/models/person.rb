class Person < ApplicationRecord

  def similar_email_addresses
    all_email_addresses = self.class.all.pluck(:email)

    FuzzyStringComparison.new(email, all_email_addresses).find_potential_matches
  end

  def self.email_address_character_count
    email_addresses = self.all.pluck(:email)

    results = email_addresses.each_with_object({}) do |email, collection|
      email.split('').each do |letter|
        collection[letter] = 0 unless collection[letter].present?
        collection[letter] += 1
      end
    end

    Hash[results.sort_by{ |_k, v| -v }]
  end
end

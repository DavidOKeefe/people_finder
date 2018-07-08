require 'rails_helper'

describe Person do
  describe '#similar_email_addresses' do
    # Pending FactoryGirl setup
    let(:person_1) { Person.where(sales_loft_id: 123).first_or_create }
    let(:person_2) { Person.where(sales_loft_id: 456).first_or_create }
    let(:email_1) { 'test_user@gmail.com' }
    let(:email_2) { 'test_use@gmail.com' }

    before do
      person_1.update(email: email_1)
      person_2.update(email: email_2)
    end

    it 'returns potential matches' do
      expect(person_1.similar_email_addresses).to eq([email_2])
    end
  end

  describe '.email_address_character_count' do
    let(:email_1) { 'test@test.com' }
    let(:email_2) { 'another_address@gmail.com' }
    let(:email_addresses) { [email_1, email_2] }
    let(:expected_results) do
      {
        't' => 5,
        'e' => 4,
        's' => 4,
        'a' => 3,
        'o' => 3,
        'm' => 3,
        'c' => 2,
        '@' => 2,
        'r' => 2,
        'd' => 2,
        '.' => 2,
        'g' => 1,
        '_' => 1,
        'l' => 1,
        'i' => 1,
        'n' => 1,
        'h' => 1
      }
    end

    before do
      allow(described_class)
        .to receive_message_chain(:all, :pluck)
        .and_return(email_addresses)
    end

    it 'returns character frequency counts' do
      expect(described_class.email_address_character_count).to eq(expected_results)
    end
  end
end

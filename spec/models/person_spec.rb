require 'rails_helper'

describe Person do
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

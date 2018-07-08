require 'rails_helper'

describe FuzzyStringComparison do
  let(:word) { 'test_user@gmail.com' }
  let(:comp_word_1) { 'test_use@gmail.com' }
  let(:comp_word_2) { 'test_user@hotmail.com' }
  let(:comp_word_3) { 'something_different@gmail.com' }
  let(:comp_words) { [comp_word_1, comp_word_2, comp_word_3] }

  subject { described_class.new(word, comp_words) }

  describe '#find_potential_matches' do
    it 'finds potential matches' do
      expect(subject.find_potential_matches).to include(comp_word_1)
      expect(subject.find_potential_matches).not_to include(comp_word_2)
      expect(subject.find_potential_matches).not_to include(comp_word_3)
    end
  end

  describe '#tokenize_string' do
    let(:word) { 'test@gmail.com' }
    let(:tokenized_string) { subject.tokenize_string(word) }
    let(:expected_results) do
      ['te', 'es', 'st', 't@', '@g', 'gm', 'ma', 'ai', 'il', 'l.', '.c', 'co', 'om']
    end

    it 'generates character pairs for a word' do
      expect(tokenized_string).to eq(expected_results)
    end
  end
end

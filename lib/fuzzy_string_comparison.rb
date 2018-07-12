class FuzzyStringComparison
  attr_reader :word, :tokenized_word, :comp_words

  PRECISION = 0.85

  def initialize(word, comp_words)
    @word = word
    @tokenized_word = tokenize_string(word)
    @comp_words = comp_words
  end

  # Counts similar tokens between two words.
  # e.g. 'test' and 'team' share one common token. (['te', 'es', 'st'] & ['te', 'ea', 'am']) = ['te']
  # Compares token count to the word lengths to normalize for short and long words.
  # Considers a potential match if within precision.
  def find_potential_matches
    comp_words.each_with_object([]) do |comp_word, collection|
      next if comp_word == word

      tokenized_comp_word = tokenize_string(comp_word)
      common_token_count = (tokenized_word & tokenized_comp_word).count
      similarity = (2 * common_token_count) / (word.length + comp_word.length).to_f
      collection << comp_word if similarity > PRECISION
    end
  end

  # Generates character pairs for a string.
  # e.g 'example' => ['ex', 'xa', 'am', 'mp', 'pl', 'le']
  def tokenize_string(str)
    (0..(str.length - 2)).map { |num| str[num..num+1] }
  end
end

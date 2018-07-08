class FuzzyStringComparison
  attr_reader :word, :tokenized_word, :comp_words

  PRECISION = 0.85

  def initialize(word, comp_words)
    @word = word
    @tokenized_word = tokenize_string(word)
    @comp_words = comp_words
  end

  def find_potential_matches
    comp_words.each_with_object([]) do |comp_word, collection|
      next if comp_word == word

      tokenized_comp_word = tokenize_string(comp_word)

      # Count of similar tokens between two words.
      # e.g. 'test' and 'team' share one common token.
      # (['te', 'es', 'st'] & ['te', 'ea', 'am']) = ['te']
      common_token_count = (tokenized_word & tokenized_comp_word).count

      # Compare similar tokens to the word lengths to normalize for short and long words.
      similarity = (2 * common_token_count) / (word.length + comp_word.length).to_f

      # Consider a potential match if within precision.
      collection << comp_word if similarity > PRECISION
    end
  end

  def tokenize_string(str)
    # Generates character pairs for a string.
    # e.g { 'example' => ['ex', 'xa', 'am', 'mp', 'pl', 'le'] }
    (0..(str.length - 2)).map { |num| str[num..num+1] }
  end
end

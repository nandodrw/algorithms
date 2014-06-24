require_relative 'predictor'

class ComplexPredictor < Predictor
  # Public: Trains the predictor on books in our dataset. This method is called
  # before the predict() method is called.
  #
  # Returns nothing.
  def train!
    
# @data looks like:
    #
    # {
    #   philosophy: {
    #     words: 1000,
    #     books: 10,
    #   },
    #   archeology: {
    #     words: {:w1 => 1 , w2 => 3}
    #     books: 5,
    #   }
    # }

    @data = {}

    @all_books.each do |category, books|
      @data[category] = {
        keywords: {},
        books: 0

      }
      books.each do |filename, tokens|
        # @data[category][:words] = {}
        total_sum = 0
        tokens.each do |word|
           if @data[category][:keywords][word].nil? && good_token?(word) == true
             @data[category][:keywords][word] = 1
             total_sum += 1
           elsif good_token?(word) == true
             @data[category][:keywords][word] += 1
             total_sum += 1
          end
        end
        @data[category][:keywords]['total_sum'] = total_sum
        
        @data[category][:books] += 1

      end
    end
  end

  # Public: Predicts category.
  #
  # tokens - A list of tokens (words).
  #
  # Returns a category.
  def predict(tokens)
    # Always predict astronomy, for now.
    # :astronomy

    book_hash = {}
    result = {}
    total_sum = 0
    tokens.each do |word|
      if book_hash[word].nil? && good_token?(word) == true
        book_hash[word] = 1
        total_sum += 1
      elsif good_token?(word) == true
        book_hash[word] += 1
        total_sum += 1
      end
    end


    book_hash['total_sum'] = total_sum

    @data.each do |category, value|
      result[category] = 0
      book_hash.each do |word|
        # puts category
        # puts value[:keywords]
        # puts word
        # puts word.class
        # puts '***********'
        if value[:keywords].include?(word[0])
          # puts word
          result[category] += 1
        end
      end
    end
    puts "===================="
    puts result.max
    puts "===================="  
    max = 0
    max_key = nil
    result.each do |k,v|
       if v > max 
        max = v
        max_key = k
      end
    end
    max_key
  end
end


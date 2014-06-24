# This class is complete. You do not need to alter this
class Card
  # Rank is the rank of the card, 2-10, J, Q, K, A
  # Value is the numeric value of the card, so J = 11, A = 14
  # Suit is the suit of the card, Spades, Diamonds, Clubs or Hearts
    attr_reader :value, :rank, :suit

  def initialize(rank, value, suit)
    @rank = rank
    @value = value
    @suit = suit
  end
end

# TODO: You will need to complete the methods in this class
class Deck
  attr_accessor :deck, :cards

  

  def initialize
    @cards = [] # Determine the best way to hold the cards
    
  end

  # Given a card, insert it on the bottom your deck
  def add_card(card)
    @cards << card
  end

  # Mix around the order of the cards in your deck
  def shuffle # You can't use .shuffle!
    52.times do |i|

      num = 1 + rand(52)
      aux =  @cards[i]
      @cards[i] = @cards[num]
      @cards[num] = aux

    end
    
  end

  # Remove the top card from your deck and return it
  def deal_card
    aux = @cards[0] 
    @cards.shift
    return aux
  end

  # Reset this deck with 52 cards
  def create_52_card_deck
    13.times do |i|


      if i == 1 || i >=11 
        case i
        when 1
          name = "A"
        when 11
          name = "J"
        when 12
          name = "Q"
        when 13
          name = "K"
        end

        val = i==1 ? 14 : i
      else
        name = i.to_s
        val = i
      end

      c1 = Card.new(name,val,"Spades")
      c2 = Card.new(name,val,"Diamonds")
      c3 = Card.new(name,val,"Clubs")
      c4 = Card.new(name,val,"Hearts")
      @cards << c1
      @cards << c2
      @cards << c3
      @cards << c4
    end
  end

end

# You may or may not need to alter this class
class Player
  attr_accessor :hand
  def initialize(name)
    @name = name
    @hand = Deck.new
  end
end


class War
  def initialize(player1, player2)
    @deck = Deck.new
    @player1 = Player.new(player1)
    @player2 = Player.new(player2)
    @deck.create_52_card_deck
    @deck.shuffle
    [1..26].times do |i|
      @player1.hand << @deck.cards[i]
    end

    [27..52].times do |j|
      @player2.hand << @deck.cards[j]
    end

    # You will need to shuffle and pass out the cards to each player
  end

  # You will need to play the entire game in this method using the WarAPI
  

  def play_game
    counter = 0
    while true
      


      c1 = @player1.deal_card
      c2 = @player2.deal_card

      response = WarAPI.play_turn(@player1,c1,@player2,c2)

      response.[@player1].each do |c| 
        @player1.add_card(c)
        puts "Player1 gets: #{c.rank} #{c.value} #{c.suit}"
      end

      response.[@player2].each do |c| 
        @player2.add_card(c)
        puts "Player2 gets: #{c.rank} #{c.value} #{c.suit}"
      end

      if @player1.hand.size == 52 || @player2.hand.size == 52
        puts "Game finished! in #{counter} times"
        break
      end     
    end

      
    end
    # WarAPI.play_turn()
  end
end


module WarAPI
  # This method will take a card from each player and
  # return a hash with the cards that each player should receive
  def self.play_turn(player1, card1, player2, card2)


    if card1.value > card2.value
      {player1 => [card1, card2], player2 => []}
    elsif card2.value > card1.value || Rand(100).even?
      {player1 => [], player2 => [card2, card1]}
    else
      {player1 => [card1, card2], player2 => []}
    end
  end
end

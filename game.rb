# frozen_string_literal: true

# Tic-Tac-Toe game
class Game
  WINNING_COMBINATIONS = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], # Rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], # Columns
    [0, 4, 8], [2, 4, 6]             # Diagonals
  ].freeze

  def initialize(difficulty = 'hard', game_type = 'human_vs_computer')
    @board = Array.new(9, &:to_s)
    @current_player = 'X'
    @players = { 'X' => 'Player 1', 'O' => 'Player 2' }
    @difficulty = difficulty
    @game_type = game_type
  end

  def start_game
    display_welcome_message

    loop do
      display_board

      until game_over?
        if human_turn?
          pick_human_spot
        else
          make_computer_move
        end

        display_board
        break if game_over?

        @current_player = @current_player == 'X' ? 'O' : 'X'
      end

      display_game_result
      break unless play_again?

      reset_game
    end

    display_goodbye_message
  end

  private

  def display_welcome_message
    puts 'Welcome to Tic-Tac-Toe!'
  end

  def display_goodbye_message
    puts 'Thank you for playing Tic-Tac-Toe. Goodbye!'
  end

  def display_board
    puts "\n"
    (0..6).step(3) do |spot|
      puts " #{@board[spot]} | #{@board[spot + 1]} | #{@board[spot + 2]} "
      puts '---+---+---' unless spot == 6
    end
    puts "\n"
  end

  def display_game_result
    if game_won?
      puts "#{@players[@current_player]} wins!"
    else
      puts "It's a tie!"
    end
  end

  def pick_human_spot
    loop do
      p 'Enter your move (0-8): '
      spot = gets.chomp.to_i

      if valid_move?(spot)
        @board[spot] = @current_player
        break
      else
        puts 'Invalid move. Please try again.'
      end
    end
  end

  def valid_move?(spot)
    spot.between?(0, 8) && @board[spot] != 'X' && @board[spot] != 'O'
  end

  def human_turn?
    @game_type == 'human_vs_human' || (@game_type == 'human_vs_computer' && @current_player == 'O')
  end

  def make_computer_move
    spot = if @difficulty == 'easy'
             pick_random_move
           else
             pick_best_move
           end

    @board[spot] = @current_player
  end

  def pick_random_move
    available_spots = pick_available_spots
    available_spots.sample
  end

  def pick_best_move
    available_spots = pick_available_spots

    available_spots.each do |spot|
      @board[spot] = @current_player
      return spot if game_won?

      @board[spot] = spot.to_s
    end

    pick_random_move
  end

  def pick_available_spots
    @board.each_index.select { |spot| @board[spot] != 'X' && @board[spot] != 'O' }
  end

  def game_over?
    game_won? || game_tied?
  end

  def game_won?
    WINNING_COMBINATIONS.any? do |combination|
      combination.all? { |spot| @board[spot] == @current_player }
    end
  end

  def game_tied?
    @board.all? { |spot| %w[X O].include?(spot) }
  end

  def play_again?
    p 'Do you want to play again? (yes/no): '
    choice = gets.chomp.downcase
    choice == 'yes'
  end

  def reset_game
    @board = Array.new(9, &:to_s)
    @current_player = 'X'
  end
end

p 'Choose difficulty (easy/hard): '
difficulty = gets.chomp.downcase
p 'Choose game type (human_vs_human/human_vs_computer/computer_vc_computer): '
game_type = gets.chomp.downcase
game = Game.new(difficulty, game_type)
game.start_game

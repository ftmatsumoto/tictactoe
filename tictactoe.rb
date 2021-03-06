module TicTacToe

	W_CONDITION = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]

	class Game
		attr_accessor :board
		attr_accessor :free_position
		attr_accessor :player1_type
		attr_accessor :player2_type
		
		def initialize
			create_board
			start_game
		end

		def create_board
			@board = Array.new(10)
		end

		def start_game
			@player1_type = player1_type
			@player2_type = player2_type

			puts "Welcome to Tic Tac Toe"
			loop do
				print "Player 1 ('X'): Human (h) or Computer (c)"
				@player1_type = gets.chomp
				break if 	@player1_type == "h" || @player1_type == "c"
			end
			loop do
				print "Player 2 ('O'): Human (h) or Computer (c)"
				@player2_type = gets.chomp
				break if 	@player2_type == "h" || @player2_type == "c"
			end
			@player1_type == "c" ? @p1 = ComputerPlayer.new(self, "Player 1", "X") : @p1 = HumanPlayer.new(self, "Player 1", "X")
			@player2_type == "c" ? @p2 = ComputerPlayer.new(self, "Player 2", "O") : @p2 = HumanPlayer.new(self, "Player 2", "O")
			@players = [@p1, @p2]

			define_first
			play
		end

		def define_first
			@first_player, @next_player = @players.shuffle
		end

		def play
			loop do
				if full_board?
					print_board
					puts "Empate!"
					break
				end
				@first_player.select_position
				if winning_condition?
					print_board
					puts "#{@first_player.player} ganhou!"
					break 
				end
				switch
			end
		end

		def switch
			@first_player, @next_player = @next_player, @first_player
		end

		def winning_condition?
			condition = false
			player_set = (1..9).select { |i| @board[i] == @first_player.marker }
			W_CONDITION.each do |set|
				intersect = set & player_set
				if intersect.length == 3
					condition = true
					break
				else
					condition = false
				end
			end
			condition
		end

		def full_board?
			@free_position = (1..9).select { |i| @board[i].nil? }
			@free_position.empty?
		end

		def print_board
			col_separator, row_separator = " | ", "--+---+--"
			label_for_position = lambda{ |position| @board[position] ? @board[position] : position }

			row_for_display = lambda{ |row| row.map(&label_for_position).join(col_separator) }
			row_positions = [[1,2,3], [4,5,6], [7,8,9]]
			rows_for_display = row_positions.map(&row_for_display)
			puts rows_for_display.join("\n" + row_separator + "\n")
		end
	end

	class Player
		attr_accessor :player
		attr_accessor :marker

		def initialize(game, player, marker)
			@game = game
			@player = player
			@marker = marker
		end

		def valid_input?
			@game.free_position.index(@cell) != nil && @cell > 0 && @cell <= 9 ? true : false
		end
	end

	class HumanPlayer < Player
		attr_accessor :cell

		def select_position
			@game.print_board

			loop do
				print "#{@player}: Marque o #{@marker} em uma posição disponível #{@game.free_position}:"
				@cell = gets.to_i
				if valid_input?
					@game.board[@cell] = @marker
					break
				else
					puts "Escolha outra posição!"
				end
			end
		end
	end

	class ComputerPlayer < Player
		def select_position
			@cell = @game.free_position.sample
			@game.board[@cell] = @marker
			puts "#{@player} marcou o #{@marker} no #{@cell}!"
		end
	end

end
	
include TicTacToe
Game.new
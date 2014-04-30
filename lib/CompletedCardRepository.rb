require_relative './CompletedCardFactory'
require_relative './CardRepository'

module AgileTrello
	class CompletedCardRepository
		def initialize(trello, parameters)
			trello_board = trello.get_board(parameters[:board_id])
			all_lists_on_board = trello_board.lists.map do |list|
				list.name
			end
			@card_repository = CardRepository.new(trello, parameters)
			@completed_card_factory = CompletedCardFactory.new(
				start_list: parameters[:start_list], 
				end_list: parameters[:end_list],
				all_lists: all_lists_on_board
			)
		end

		def get
			completed_cards = @card_repository.get_cards_after
			completed_cards.map do |card|
				@completed_card_factory.create(card)
			end
		end
	end
end
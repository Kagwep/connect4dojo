use starknet::ContractAddress;
use contracts::models::player::Color;

#[derive(Component, Copy, Drop, Serde, SerdeLen)]
struct Game {
    #[key]
    game_id: u32,
    player_one: ContractAddress,
    player_two: ContractAddress,
    next_to_move: Color,
    num_discs: u8,
    minimum_moves: u8,
    winner: ContractAddress,
}

#[generate_trait]
impl GameImpl of GameTrait {
    fn is_minimum_moves_met(self: Game, move_count: u8) -> bool{
        self.minimum_moves < move
    }
}
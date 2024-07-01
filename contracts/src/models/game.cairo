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
    winner: ContractAddress,
}
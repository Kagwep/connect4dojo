use connect4_dojo::models::player::Color;
use starknet::ContractAddress;
 
#[derive(Model, Drop, Serde)]
struct Piece {
    #[key]
    game_id: u32,
    #[key]
    position: Vec2,
    color: Color,
    piece_id: u8,
}
 
#[derive(Copy, Drop, Serde, Introspect)]
struct Vec2 {
    x: u32,
    y: u32
}
 

trait PieceTrait {
fn is_out_of_board(next_position: Vec2) -> bool;
}

 
impl PieceImpl of PieceTrait {
    fn is_out_of_board(next_position: Vec2) -> bool {
        next_position.x > 7 || next_position.y > 6
    }
 
}
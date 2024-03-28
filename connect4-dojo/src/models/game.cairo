use connect4_dojo::models::player::Color;
use starknet::ContractAddress;
 
#[derive(Model, Drop, Serde)]
struct Game {
    #[key]
    game_id: u32,
    winner: Color,
    yellow: ContractAddress,
    red: ContractAddress
}
 
#[derive(Model, Drop, Serde)]
struct GameTurn {
    #[key]
    game_id: u32,
    player_color: Color
}

// code for game.cairo file
trait GameTurnTrait {
    fn next_turn(self: @GameTurn) -> Color;
}
impl GameTurnImpl of GameTurnTrait {
    fn next_turn(self: @GameTurn) -> Color {
        match self.player_color {
            Color::Yellow => Color::Red,
            Color::Red => Color::Yellow,
            Color::None => panic(array!['Illegal turn'])
        }
    }
}
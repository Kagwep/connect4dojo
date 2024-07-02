use contracts::models::player::Color;
use starknet::ContractAddress;

#[dojo::model]
#[derive(Drop, Serde)]
struct Disc {
    #[key]
    game_id: u32,
    #[key]
    position: Vec2,
    color: Color,
    disc_number: u8,
}


#[derive(Copy, Drop, Serde, Introspect)]
struct Vec2 {
    x: u8,
    y: u8
}


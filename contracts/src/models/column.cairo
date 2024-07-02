use contracts::models::player::Color;
use contracts::models::disc::Vec2;

#[derive(Copy,Drop,Serde)]
#[dojo::model]
struct Column {
    #[key]
    game_id: u32,
    #[key]
    position: u8,
    last_slot_filled: Vec2,

}


use contracts::models::player::Color;
use contracts::models::disc::Disc;

#[derive(Copy,Drop,Serde)]
#[dojo::model]
struct Slot {
    #[key]
    game_id: u32,
    #[key]
    x: u8,
    #[key]
    y: u8,
    disc: Disc,

}



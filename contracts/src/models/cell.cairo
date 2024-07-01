use contracts::models::player::Color;

#[derive(Copy,Drop,Serde)]
#[dojo::model]
struct Cell {
    #[key]
    x: u16,
    #[key]
    y: u16,
    color: Color,

}



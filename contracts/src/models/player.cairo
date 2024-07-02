

#[derive(Serde, Drop, Copy, PartialEq, Introspect)]
enum Color {
    Red,
    Yellow,
    None,
}

#[derive(Copy,Drop,Serde)]
#[dojo::model]
struct Player {
    #[key]
    game_id: u32,
    #[key]
    address: starknet::ContractAddress,
    last_action:u64,
    color: Color
    
}

 

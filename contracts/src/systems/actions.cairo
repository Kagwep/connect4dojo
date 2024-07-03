
// define the interface
#[dojo::interface]
trait IActions {
    fn spawn();
    fn join(game_id: u32); 
    fn move(game_id: u32, selected_col: u16);
}


#[dojo::contract]
mod actions {
    use super::{IActions};
    use starknet::{ContractAddress, get_caller_address, get_block_timestamp, Zeroable};
    use contracts::models::{slot::{Slot}, player::{Player,Color}, disc::{Disc,Vec2}, game::{Game}, column::{Column}};
    use contracts::constants::{MAX_DISCS,CONNECT_VALUE,ROW_COUNT};

    #[abi(embed_v0)]
    impl ActionsImpl of IActions<ContractState> {

        fn spawn(world: IWorldDispatcher, color: Color) {
            // Get the address of the current caller, possibly the player's address.
            let address = get_caller_address();
            // Retrieve the player's current position from the world.
            let game_id = world.uuid();

            let  existing_player = get!(world, (address), Player);

            assert(existing_player.last_action == 0, 'ACTIONS: player already exists');

            let seed = starknet::get_tx_info().unbox().transaction_hash;

            let next_to_move = select_starting_player(seed);

            let last_action = get_block_timestamp();

            let minimum_moves = 2 * CONNECT_VALUE - 1;

            // #[key]
            // game_id: u32,
            // #[key]
            // address: starknet::ContractAddress,
            // last_action:u64,
            // color: Color

            // set Players
            set!(world, Player { game_id, address,last_action, color });

            // #[key]
            // game_id: u32,
            // #[key]
            // position: u8,
            // last_slot_filled: Vec2,

            let  last_slot_filled = Vec2{x:0,y:0};


            set!(world,Column {game_id,position: 1,last_slot_filled})


            set!(world,Column {game_id,position: 2,last_slot_filled})

      
            set!(world,Column {game_id,position: 3,last_slot_filled})


            set!(world,Column {game_id,position: 4,last_slot_filled})


            set!(world,Column {game_id,position: 5,last_slot_filled})

 
            set!(world,Column {game_id,position: 6,last_slot_filled})

    
            set!(world,Column {game_id,position: 7,last_slot_filled})

            // game_id: u32,
            // player_one: ContractAddress,
            // player_two: ContractAddress,
            // next_to_move: Color,
            // num_discs: u8,
            // winner: ContractAddress,

            set!(world, Game {game_id, player_one: address, player_two: Zeroable::zero(), next_to_move,num_discs: Zeroable::zero(),minimum_moves, winner: Zeroable::zero()});

            
        }

        fn join(world: IWorldDispatcher, game_id: u32) {

            let address = get_caller_address();

            let mut game = get!(world, game_id, (Game));

            assert(game.player_one != player_id, 'cannot join own game');
            assert(game.player_two.is_zero(), 'game is full');

            let last_action = get_block_timestamp();
    
            // update game entity
            game.player_two = address;

            set!(world, (game));

            let mut player_one = get!(world, (game_id, game.player_one), Player);
            

            let color = if player_one.color == Color::Red {
                Color::Yellow
            } else {
                Color::Red
            };
    
            // create player entity
            set!(world, Player { game_id, address,last_action, color });
    
        }

        fn move(world: IWorldDispatcher,game_id: u32, selected_col: u8){


            assert!(is_out_of_board(selected_col), 'Should be inside board');

            let mut col = get!(world, (game_id, selected_col), Player);

            assert(col.last_slot_filled.x == 6 , 'Invalid Poistion, Col full')

            let position_x = col.last_slot_filled.x + 1;

            let position_y = selected_col;

            let position = Vec2 {position_x, position_y};

            let address = get_caller_address();

            let mut game = get!(world, game_id, Game);

            assert(game.num_discs <= MAX_DISCS, 'Maximum number of discs reached.');

            let disc_number = game.num_discs + 1;

            let mut player = get!(world, (game_id, address), Player);

            assert(player.address == address, 'ACTIONS: not Player');

            assert(game.next_to_move == player.color, 'not your turn');

            player.last_action = get_block_timestamp();


            // #[key]
            // game_id: u32,
            // #[key]
            // position: Vec2,
            // color: Color,
            // disc_number: u8,

            // create player entity

            let disc = Disc { game_id, position,color: player.color, disc_number: disc_number };

            set!(world, disc);

            col.last_slot_filled = position;
            
            set!(world, (player));

            // #[key]
            // game_id: u32,
            // #[key]
            // x: u8,
            // #[key]
            // y: u8,
            // disc: Disc,


            set!(world, Slot{game_id,position_x,position_y,disc});

            game.num_discs = disc_number

            set!(world,(game))

        }

        fn select_starting_player(seed: felt252) -> Color {
            let seed: u256 = seed.into();
            let result: u128 = seed.low % 100;
            let chance: u8 = 50;
    
            if result <= chance.into() {
                Color::Red
            } else {
                Color::Yellow
            }

        }

        fn is_out_of_board(col: u8) -> bool {
            col < 1 || col > 7
        }

        fn check_win(world: IWorldDispatcher, address: ContractAddress, game_id: u32) -> bool {

            let mut game = get!(world, game_id, Game);


        }
    }
}


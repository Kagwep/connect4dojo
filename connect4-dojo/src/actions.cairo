    use starknet::ContractAddress;
    use connect4_dojo::models::piece::Vec2;
    #[starknet::interface]
    trait IActions<ContractState> {
        fn move(
            self: @ContractState,
            curr_position: Vec2,
            next_position: Vec2,
            caller: ContractAddress, //player
            game_id: u32
        );
        fn spawn(
            self: @ContractState, white_address: ContractAddress, black_address: ContractAddress
        ) -> u32;
    }

    #[dojo::contract]
    mod actions {
        use connect4_dojo::models::player::{Player, Color, PlayerTrait};
        use connect4_dojo::models::piece::{Piece, PieceTrait};
        use connect4_dojo::models::game::{Game, GameTurn, GameTurnTrait};
        use super::{ContractAddress, IActions, Vec2};

            #[abi(embed_v0)]
    impl IActionsImpl of IActions<ContractState> {
        fn spawn(
            self: @ContractState, white_address: ContractAddress, black_address: ContractAddress
        ) -> u32 {
            let world = self.world_dispatcher.read();
            let game_id = world.uuid();
 
            // set Players
            set!(
                world,
                (
                    Player { game_id, address: red_address, color: Color::Red },
                    Player { game_id, address: yellow_address, color: Color::Yellow },
                )
            );
 
            // set Game and GameTurn
            set!(
                world,
                (
                    Game {
                        game_id, winner: Color::None, yellow: yellow_address, red: red_address
                    },
                    GameTurn { game_id, player_color: Color::Yellow },
                )
            );
 
            // set Pieces

            let mut i: u8 = 1;
            loop {
                if i > 42_u8 {
                    break;
                }
                if i < 22_u8 {

                    set!(
                        world,
                        (Piece {
                            game_id,
                            color: Color::White,
                            position: Vec2 { x: 0, y: 0 },
                            piece_id: i
                        })
                    );

                }else{

                    let new_position : u8 = i - 21_u8;

                    set!(
                        world,
                        (Piece {
                            game_id,
                            color: Color::White,
                            position: Vec2 { x: 0, y: 1 },
                            piece_id: new_position
                        })
                    ); 
                }

                i += 1;
            };
                

 
            //the rest of the positions on the board goes here....
 
            game_id
        }
        fn move(
            self: @ContractState,
            curr_position: Vec2,
            next_position: Vec2,
            caller: ContractAddress, //player
            game_id: u32
        ) {
            let world = self.world_dispatcher.read();
            let mut current_piece = get!(world, (game_id, curr_position), (Piece));
            // check if next_position is out of board or not
            assert(!PieceTrait::is_out_of_board(next_position), 'Should be inside board');
 
            // check if this is the right move for this piece type
            // Get piece data from to next_position in the board
            let mut next_position_piece = get!(world, (game_id, next_position), (Piece));
 
            let player = get!(world, (game_id, caller), (Player));
            // check if there is already a piece in next_position
            assert(
                player.is_not_my_piece(next_position_piece.color),
                'Already same color piece exist'
            );
 
            next_position_piece.piece_type = current_piece.piece_type;
            next_position_piece.color = player.color;
            // make current_piece piece none
            current_piece.piece_type = PieceType::None;
            current_piece.color = Color::None;
            set!(world, (next_position_piece));
            set!(world, (current_piece));
 
            // change turn
            let mut game_turn = get!(world, game_id, (GameTurn));
            game_turn.player_color = game_turn.next_turn();
            set!(world, (game_turn));
        }
    }
    }
#[cfg(test)]
mod tests {
    use starknet::class_hash::Felt252TryIntoClassHash;
    // import world dispatcher
    use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};
    // import test utils
    use dojo::test_utils::{spawn_test_world, deploy_contract};
    // import test utils
    use bootcamp::{
        systems::{actions::{actions, IActionsDispatcher, IActionsDispatcherTrait}},
        models::{player::{Player,player}, Tile::{Tile, tile}}
    };

    const PLAYER_ONE: u32 = 1;

    fn player_one_address() -> starknet::ContractAddress {
        starknet::contract_address_const::<0x0>()
    }

    fn setup() -> (IWorldDispatcher, IActionsDispatcher){

        let mut models = array![player::TEST_CLASS_HASH, tile::TEST_CLASS_HASH];
        let world = spawn_test_world(models);

        let contract_address = world.deploy_contract('salt', actions::TEST_CLASS_HASH.try_into().unwrap(), array![].span());

        let actions_system = IActionsDispatcher {contract_address};

        (world, actions_system)
    }

    fn spawn() -> (IWorldDispatcher, IActionsDispatcher){

        starknet::testing::set_contract_address(player_one_address())

        let (world, actions_system) = setup();


        actions_system.spawn();

        (world, actions_system)
    }


    const TILE_X: u16 = 1;
    const TILE_Y: u16 = 1;
    const TILE_COLOR: felt252 = red;


    fn place() -> (WorldDispatcher, ActionsDispatcher) {
        // Set the contract address for a player (assuming this is part of a test setup)
        starknet::testing::set_contract_address(player_one_address());
    
        // Simulate spawning the world and actions system
        let (world, actions_system) = spawn();

        // Paint the tile at the specified location with the specified color
        actions_system.paint(TILE_X, TILE_Y, TILE_COLOR);
    
        // Return the world and actions system
        (world, actions_system)
    }
    
    #[test]
    #[allowable_gas(3000000)]
    fn test_spawn() {
        // Setup world
        let (world, _) = spawn();

        // Assert
        let player = get!(world, (player_one_address()), Player);
        assert(player.address == player_one_address(), "address is wrong");
    }

    #[test]
    #[available_gas(3000000)]
    fn test_place() {
        // Setup world
        let (world, _) = place();

        // Assert
        let tile = get!(world, TILE_X, TILE_Y, Tile);
        assert!(tile.color == TILE_COLOR, "tile not red");
    }


}

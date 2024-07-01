import { useComponentValue, useEntityQuery } from "@dojoengine/react";
import { Entity, Has, HasValue } from "@dojoengine/recs";
import React,{ useEffect, useState,useMemo } from "react";
import "./App.css";
import { Direction } from "./utils";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useDojo } from "./dojo/useDojo";
import { shortString } from "starknet";

interface CellProps {
    x: number;
    y: number;
    color: string;
}

const Cell = ({ x, y, color}: {x:number, y:number,color:string}) => {
    const {
        setup : {
            clientComponents: {Tile},
            client,
        },
        account: { account },
    } = useDojo()

    const tile = useComponentValue(
        Tile,
        getEntityIdFromKeys([BigInt(x), BigInt(y)]),
        {
            x,
            y,
            color: BigInt(shortString.encodeShortString("white"))
        }
    );

    return (
        <div
            onClick={async () => {
                await client.actions.paint({
                    account,
                    x,
                    y,
                    color: BigInt(shortString.encodeShortString(color)),
                });
            }}
            className={`w-12 cursor-pointer duration-300 hover:bg-${color} h-12 border-${color}-100 border-blue-100 flex justify-center bg-${shortString.decodeShortString(tile.color.toString())}-100`}
        >
            <span className="self-center text-black">{`(${x}, ${y})`}</span>
        </div>
    );
    
    
  };
  

function App() {
    const {
        setup: {
            systemCalls: { spawn, paint },
            clientComponents: { Player, Tile },
        },
        account,
    } = useDojo();

    const [clipboardStatus, setClipboardStatus] = useState({
        message: "",
        isError: false,
    });

    const playerQuery = useEntityQuery([
        Has(Player),
        HasValue(Player, {address: BigInt(account?.account.address)})
    ])

    // entity id we are syncing
    const entityId = getEntityIdFromKeys([
        BigInt(account?.account.address),
    ]) as Entity;

    const [color, setColor] = useState('');

    // get current component values
    const player = useComponentValue(Player, playerQuery[0]);
    // const tile = useComponentValue(Tile, entityId);
    // //const directions = useComponentValue(DirectionsAvailable, entityId);

    // console.log("tiles", tile);

     
    const grid = useMemo(() => {
        let tempGrid = [];
        for (let row = 0; row < 15; row++) {
        const cols = [];
        for (let col = 0; col < 15; col++) {
            cols.push(
            <Cell
                key={`${row}-${col}`}
                x={row}
                y={col}
                color={color} // This will be the same for all cells unless individually tracked
            />
            );
        }
        tempGrid.push(
            <div key={row} className="flex flex-wrap">
            {cols}
            </div>
        );
        }
        return tempGrid;
    }, [color]); // Dependency array, useMemo will only re-run if these values change

    
    const handleRestoreBurners = async () => {
        try {
            await account?.applyFromClipboard();
            setClipboardStatus({
                message: "Burners restored successfully!",
                isError: false,
            });
        } catch (error) {
            setClipboardStatus({
                message: `Failed to restore burners from clipboard`,
                isError: true,
            });
        }
    };

    useEffect(() => {
        if (clipboardStatus.message) {
            const timer = setTimeout(() => {
                setClipboardStatus({ message: "", isError: false });
            }, 3000);

            return () => clearTimeout(timer);
        }
    }, [clipboardStatus.message]);

    return (
        <>
            {/* <button onClick={() => account?.create()}>
                {account?.isDeploying ? "deploying burner" : "create burner"}
            </button>
            {account && account?.list().length > 0 && (
                <button onClick={async () => await account?.copyToClipboard()}>
                    Save Burners to Clipboard
                </button>
            )}
            <button onClick={handleRestoreBurners}>
                Restore Burners from Clipboard
            </button>
            {clipboardStatus.message && (
                <div className={clipboardStatus.isError ? "error" : "success"}>
                    {clipboardStatus.message}
                </div>
            )}

            <div className="card">
                <div>{`burners deployed: ${account.count}`}</div>
                <div>
                    select signer:{" "}
                    <select
                        value={account ? account.account.address : ""}
                        onChange={(e) => account.select(e.target.value)}
                    >
                        {account?.list().map((account, index) => {
                            return (
                                <option value={account.address} key={index}>
                                    {account.address}
                                </option>
                            );
                        })}
                    </select>
                </div>
                <div>
                    <button onClick={() => account.clear()}>
                        Clear burners
                    </button>
                    <p>
                        You will need to Authorise the contracts before you can
                        use a burner. See readme.
                    </p>
                </div>
            </div> */}

            <div className="card">
                <button onClick={() => spawn(account.account)}>Spawn</button>
                {/* <div>
                    Moves Left: {moves ? `${moves.remaining}` : "Need to Spawn"}
                </div> */}
                {/* <div>
                    Position:{" "}
                    {position
                        ? `${position?.vec.x}, ${position?.vec.y}`
                        : "Need to Spawn"}
                </div> */}
{/* 
                <div>{moves && moves.last_direction}</div>

                <div>
                    <div>Available Positions</div>
                    {directions?.directions.map((a: any, index: any) => (
                        <div key={index} className="">
                            {a}
                        </div>
                    ))}
                </div> */}
            </div>
            <div>
            {/* Display the current color */}
            <div style={{ color: color, margin: '10px' }}>
                The current color is: {color || 'None'}
            </div>

            {/* Button to set color to red */}
            <button
                className="px-2 py-1 border border-red-500 bg-red-100"
                onClick={() => setColor('red')}
                style={{ color: 'red' }}
            >
                Red
            </button>

            {/* Button to set color to blue */}
            <button
                className="px-2 py-1 border border-blue-500 bg-blue-100"
                onClick={() => setColor('blue')}
                style={{ color: 'blue' }}
            >
                Blue
            </button>
        </div>
        {player?.address.toString() && <div className="mx-auto p-10">{grid}</div>}
        </>
    );
}

export default App;

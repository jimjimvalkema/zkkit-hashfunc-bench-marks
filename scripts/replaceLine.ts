import { ArgumentParser } from 'argparse';
import fs from "fs/promises";
//@ts-ignore
import Bun from "bun";

export interface lineReplacement {
    original: string;
    replacement: string;
}

export async function lineReplacer(filePath:string, lineReplacements: lineReplacement[]) : Promise<void> {
    //const file = await fs.open(filePath, "r")
    const file = await Bun.file(filePath)
    let newFile = ""

    //for await (const line of file.readLines()) {
    for (const line of (await file.text()).split("\n")) {
        const replacement = lineReplacements.find((replacement) => line.startsWith(replacement.original))
        if (replacement) {
            newFile += replacement.replacement + "\n"
        } else {
            newFile += line + "\n"
        }
    }
    //await file.close()
    await fs.writeFile(filePath, newFile);
}

async function main() {
    const parser = new ArgumentParser({
        description: 'quick lil script to replace 1 line',
        usage: `yarn ts-node scripts_dev_op/replaceLine.ts --file contracts/evm/WithdrawVerifier.sol --remove "contract UltraVerifier is BaseUltraVerifier {" --replace "contract WithdrawVerifier is BaseUltraVerifier {"`
    });
    parser.add_argument('-f', '--file', { help: 'file to read', required: true, type: 'str' });
    parser.add_argument('-r', '--remove', { help: 'specify what line to replace', required: true, type: 'str' });
    parser.add_argument('-p', '--replace', { help: 'specify what to replace it with', required: true, type: 'str' });
    const args = parser.parse_args() 

    const lineReplacements = [
        {
            "original"      :args.remove,
            "replacement"   :args.replace
        }
    ]
    await lineReplacer(args.file, lineReplacements)
}
await main()
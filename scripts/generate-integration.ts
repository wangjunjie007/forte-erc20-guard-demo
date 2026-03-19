import { policyModifierGeneration } from "@fortefoundation/forte-rules-engine-sdk";

const policyPath = "policy/transfer-guard.policy.json";
const modifiersPath = "src/RulesEngineClientCustom.sol";
const targetContracts = ["src/ForteGuardedToken.sol"];

policyModifierGeneration(policyPath, modifiersPath, targetContracts);
console.log(`Generated ${modifiersPath} from ${policyPath}`);

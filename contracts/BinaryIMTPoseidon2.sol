// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {InternalBinaryIMT, BinaryIMTData} from "zk-kit-imt-custom-hash/contracts/InternalBinaryIMT.sol";
// import {PoseidonT3} from "poseidon-solidity/PoseidonT3.sol";
import {SNARK_SCALAR_FIELD} from "zk-kit-imt-custom-hash/contracts/Constants.sol";

error ValueGreaterThanSnarkScalarField();
error WrongDefaultZeroIndex();

library BinaryIMTPoseidon2 {
    using InternalBinaryIMT for *;

    uint256 internal constant Z_0 = 0;
    uint256 internal constant Z_1 = 14744269619966411208579211824598458697587494354926760081771325075741142829156;
    uint256 internal constant Z_2 = 7423237065226347324353380772367382631490014989348495481811164164159255474657;
    uint256 internal constant Z_3 = 11286972368698509976183087595462810875513684078608517520839298933882497716792;
    uint256 internal constant Z_4 = 3607627140608796879659380071776844901612302623152076817094415224584923813162;
    uint256 internal constant Z_5 = 19712377064642672829441595136074946683621277828620209496774504837737984048981;
    uint256 internal constant Z_6 = 20775607673010627194014556968476266066927294572720319469184847051418138353016;
    uint256 internal constant Z_7 = 3396914609616007258851405644437304192397291162432396347162513310381425243293;
    uint256 internal constant Z_8 = 21551820661461729022865262380882070649935529853313286572328683688269863701601;
    uint256 internal constant Z_9 = 6573136701248752079028194407151022595060682063033565181951145966236778420039;
    uint256 internal constant Z_10 = 12413880268183407374852357075976609371175688755676981206018884971008854919922;
    uint256 internal constant Z_11 = 14271763308400718165336499097156975241954733520325982997864342600795471836726;
    uint256 internal constant Z_12 = 20066985985293572387227381049700832219069292839614107140851619262827735677018;
    uint256 internal constant Z_13 = 9394776414966240069580838672673694685292165040808226440647796406499139370960;
    uint256 internal constant Z_14 = 11331146992410411304059858900317123658895005918277453009197229807340014528524;
    uint256 internal constant Z_15 = 15819538789928229930262697811477882737253464456578333862691129291651619515538;
    uint256 internal constant Z_16 = 19217088683336594659449020493828377907203207941212636669271704950158751593251;
    uint256 internal constant Z_17 = 21035245323335827719745544373081896983162834604456827698288649288827293579666;
    uint256 internal constant Z_18 = 6939770416153240137322503476966641397417391950902474480970945462551409848591;
    uint256 internal constant Z_19 = 10941962436777715901943463195175331263348098796018438960955633645115732864202;
    uint256 internal constant Z_20 = 15019797232609675441998260052101280400536945603062888308240081994073687793470;
    uint256 internal constant Z_21 = 11702828337982203149177882813338547876343922920234831094975924378932809409969;
    uint256 internal constant Z_22 = 11217067736778784455593535811108456786943573747466706329920902520905755780395;
    uint256 internal constant Z_23 = 16072238744996205792852194127671441602062027943016727953216607508365787157389;
    uint256 internal constant Z_24 = 17681057402012993898104192736393849603097507831571622013521167331642182653248;
    uint256 internal constant Z_25 = 21694045479371014653083846597424257852691458318143380497809004364947786214945;
    uint256 internal constant Z_26 = 8163447297445169709687354538480474434591144168767135863541048304198280615192;
    uint256 internal constant Z_27 = 14081762237856300239452543304351251708585712948734528663957353575674639038357;
    uint256 internal constant Z_28 = 16619959921569409661790279042024627172199214148318086837362003702249041851090;
    uint256 internal constant Z_29 = 7022159125197495734384997711896547675021391130223237843255817587255104160365;
    uint256 internal constant Z_30 = 4114686047564160449611603615418567457008101555090703535405891656262658644463;
    uint256 internal constant Z_31 = 12549363297364877722388257367377629555213421373705596078299904496781819142130;
    uint256 internal constant Z_32 = 21443572485391568159800782191812935835534334817699172242223315142338162256601;

    function _defaultZero(uint256 index) internal pure returns (uint256) {
        if (index == 0) return Z_0;
        if (index == 1) return Z_1;
        if (index == 2) return Z_2;
        if (index == 3) return Z_3;
        if (index == 4) return Z_4;
        if (index == 5) return Z_5;
        if (index == 6) return Z_6;
        if (index == 7) return Z_7;
        if (index == 8) return Z_8;
        if (index == 9) return Z_9;
        if (index == 10) return Z_10;
        if (index == 11) return Z_11;
        if (index == 12) return Z_12;
        if (index == 13) return Z_13;
        if (index == 14) return Z_14;
        if (index == 15) return Z_15;
        if (index == 16) return Z_16;
        if (index == 17) return Z_17;
        if (index == 18) return Z_18;
        if (index == 19) return Z_19;
        if (index == 20) return Z_20;
        if (index == 21) return Z_21;
        if (index == 22) return Z_22;
        if (index == 23) return Z_23;
        if (index == 24) return Z_24;
        if (index == 25) return Z_25;
        if (index == 26) return Z_26;
        if (index == 27) return Z_27;
        if (index == 28) return Z_28;
        if (index == 29) return Z_29;
        if (index == 30) return Z_30;
        if (index == 31) return Z_31;
        if (index == 32) return Z_32;
        revert WrongDefaultZeroIndex();
    }

    function hasher(uint256[2] memory inputs) internal pure returns (uint256) {
        if (inputs[0] >= SNARK_SCALAR_FIELD || inputs[1] >= SNARK_SCALAR_FIELD) {
            revert ValueGreaterThanSnarkScalarField();
        }
        return PoseidonT3.hash(inputs);
    }

    function hasherUnsafe(uint256[2] memory inputs) internal pure returns (uint256) {
        return PoseidonT3.hash(inputs);
    }

    function defaultZero(uint256 index) public pure returns (uint256) {
        return _defaultZero(index);
    }

    function init(BinaryIMTData storage self, uint256 depth, uint256 zero) public {
        if (zero >= SNARK_SCALAR_FIELD) {
            revert ValueGreaterThanSnarkScalarField();
        }
        InternalBinaryIMT._init(self, depth, zero, hasherUnsafe);
    }

    function initWithDefaultZeroes(BinaryIMTData storage self, uint256 depth) public {
        InternalBinaryIMT._initWithDefaultZeroes(self, depth, _defaultZero);
    }

    function insert(BinaryIMTData storage self, uint256 leaf) public returns (uint256) {
        if (leaf >= SNARK_SCALAR_FIELD) {
            revert ValueGreaterThanSnarkScalarField();
        }
        return InternalBinaryIMT._insert(self, leaf, hasherUnsafe, _defaultZero);
    }

    function update(
        BinaryIMTData storage self,
        uint256 leaf,
        uint256 newLeaf,
        uint256[] calldata proofSiblings,
        uint8[] calldata proofPathIndices
    ) public {
        if (leaf >= SNARK_SCALAR_FIELD || newLeaf >= SNARK_SCALAR_FIELD) {
            revert ValueGreaterThanSnarkScalarField();
        }
        InternalBinaryIMT._update(self, leaf, newLeaf, proofSiblings, proofPathIndices, hasher);
    }

    function remove(
        BinaryIMTData storage self,
        uint256 leaf,
        uint256[] calldata proofSiblings,
        uint8[] calldata proofPathIndices
    ) public {
        if (leaf >= SNARK_SCALAR_FIELD) {
            revert ValueGreaterThanSnarkScalarField();
        }
        InternalBinaryIMT._remove(self, leaf, proofSiblings, proofPathIndices, hasher, Z_0);
    }
}

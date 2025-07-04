// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import {InternalBinaryIMT, BinaryIMTData} from "zk-kit-imt-custom-hash/contracts/InternalBinaryIMT.sol";
import {SNARK_SCALAR_FIELD} from "zk-kit-imt-custom-hash/contracts/Constants.sol";

error ValueGreaterThanSnarkScalarField();
error WrongDefaultZeroIndex();



library BinaryIMTHuffPoseidon2 {
    using InternalBinaryIMT for *;

    uint256 internal constant Z_0 = 0x00;
    uint256 internal constant Z_1 = 0x0b63a53787021a4a962a452c2921b3663aff1ffd8d5510540f8e659e782956f1;
    uint256 internal constant Z_2 = 0x0e34ac2c09f45a503d2908bcb12f1cbae5fa4065759c88d501c097506a8b2290;
    uint256 internal constant Z_3 = 0x21f9172d72fdcdafc312eee05cf5092980dda821da5b760a9fb8dbdf607c8a20;
    uint256 internal constant Z_4 = 0x2373ea368857ec7af97e7b470d705848e2bf93ed7bef142a490f2119bcf82d8e;
    uint256 internal constant Z_5 = 0x120157cfaaa49ce3da30f8b47879114977c24b266d58b0ac18b325d878aafddf;
    uint256 internal constant Z_6 = 0x01c28fe1059ae0237b72334700697bdf465e03df03986fe05200cadeda66bd76;
    uint256 internal constant Z_7 = 0x2d78ed82f93b61ba718b17c2dfe5b52375b4d37cbbed6f1fc98b47614b0cf21b;
    uint256 internal constant Z_8 = 0x067243231eddf4222f3911defbba7705aff06ed45960b27f6f91319196ef97e1;
    uint256 internal constant Z_9 = 0x1849b85f3c693693e732dfc4577217acc18295193bede09ce8b97ad910310972;
    uint256 internal constant Z_10 = 0x2a775ea761d20435b31fa2c33ff07663e24542ffb9e7b293dfce3042eb104686;
    uint256 internal constant Z_11 = 0x0f320b0703439a8114f81593de99cd0b8f3b9bf854601abb5b2ea0e8a3dda4a7;
    uint256 internal constant Z_12 = 0x0d07f6e7a8a0e9199d6d92801fff867002ff5b4808962f9da2ba5ce1bdd26a73;
    uint256 internal constant Z_13 = 0x1c4954081e324939350febc2b918a293ebcdaead01be95ec02fcbe8d2c1635d1;
    uint256 internal constant Z_14 = 0x0197f2171ef99c2d053ee1fb5ff5ab288d56b9b41b4716c9214a4d97facc4c4a;
    uint256 internal constant Z_15 = 0x2b9cdd484c5ba1e4d6efcc3f18734b5ac4c4a0b9102e2aeb48521a661d3feee9;
    uint256 internal constant Z_16 = 0x14f44d672eb357739e42463497f9fdac46623af863eea4d947ca00a497dcdeb3;
    uint256 internal constant Z_17 = 0x071d7627ae3b2eabda8a810227bf04206370ac78dbf6c372380182dbd3711fe3;
    uint256 internal constant Z_18 = 0x2fdc08d9fe075ac58cb8c00f98697861a13b3ab6f9d41a4e768f75e477475bf5;
    uint256 internal constant Z_19 = 0x20165fe405652104dceaeeca92950aa5adc571b8cafe192878cba58ff1be49c5;
    uint256 internal constant Z_20 = 0x1c8c3ca0b3a3d75850fcd4dc7bf1e3445cd0cfff3ca510630fd90b47e8a24755;
    uint256 internal constant Z_21 = 0x1f0c1a8fb16b0d2ac9a146d7ae20d8d179695a92a79ed66fc45d9da4532459b3;
    uint256 internal constant Z_22 = 0x038146ec5a2573e1c30d2fb32c66c8440f426fbd108082df41c7bebd1d521c30;
    uint256 internal constant Z_23 = 0x17d3d12b17fe762de4b835b2180b012e808816a7f2ff69ecb9d65188235d8fd4;
    uint256 internal constant Z_24 = 0x0e1a6b7d63a6e5a9e54e8f391dd4e9d49cdfedcbc87f02cd34d4641d2eb30491;
    uint256 internal constant Z_25 = 0x09244eec34977ff795fc41036996ce974136377f521ac8eb9e04642d204783d2;
    uint256 internal constant Z_26 = 0x1646d6f544ec36df9dc41f778a7ef1690a53c730b501471b6acd202194a7e8e9;
    uint256 internal constant Z_27 = 0x064769603ba3f6c41f664d266ecb9a3a0f6567cd3e48b40f34d4894ee4c361b3;
    uint256 internal constant Z_28 = 0x1595bb3cd19f84619dc2e368175a88d8627a7439eda9397202cdb1167531fd3f;
    uint256 internal constant Z_29 = 0x2a529be462b81ca30265b558763b1498289c9d88277ab14f0838cb1fce4b472c;
    uint256 internal constant Z_30 = 0x0c08da612363088ad0bbc78abd233e8ace4c05a56fdabdd5e5e9b05e428bdaee;
    uint256 internal constant Z_31 = 0x14748d0241710ef47f54b931ac5a58082b1d56b0f0c30d55fb71a6e8c9a6be14;
    uint256 internal constant Z_32 = 0x0b59baa35b9dc267744f0ccb4e3b0255c1fc512460d91130c6bc19fb2668568d;
    // uint256 internal constant Z_33 = 0x2c45bb0c3d5bc1dc98e0baef09ff46d18c1a451e724f41c2b675549bb5c80e59;
    // uint256 internal constant Z_34 = 0x121468e6710bf1ffec6d0f26743afe6f88ef55dab40b83ca0a39bc44b196374c;
    // uint256 internal constant Z_35 = 0x2042c32c823a7440ceb6c342f9125f1fe426b02c527cd8fb28c85d02b705e759;
    // uint256 internal constant Z_36 = 0x0d582c10ff8115413aa5b70564fdd2f3cefe1f33a1e43a47bc495081e91e73e5;
    // uint256 internal constant Z_37 = 0x0f55a0d491a9da093eb999fa0dffaf904620cbc78d07e63c6f795c5c7512b523;
    // uint256 internal constant Z_38 = 0x21849764e1aa64b83a69e39d27eedaec2a8f97066e5ddb74634ffdb11388dd9a;
    // uint256 internal constant Z_39 = 0x2e33ee2008411c04b99c24b313513d097a0d21a5040b6193d1f978b8226892d6;
    // uint256 internal constant Z_40 = 0x1fd848aa69e1633722fe249a5b7f53b094f1c9cef9f5c694b073fd1cc5850dfb;
    // uint256 internal constant Z_41 = 0x1a180441acbe2e25177de322888800476d75191e3c2c753300dedf84de7d2053;
    // uint256 internal constant Z_42 = 0x2ac5dda169f6bb3b9ca09bbac34e14c94d1654597db740153a1288d859a8a30a;
    // uint256 internal constant Z_43 = 0x2de9cf8ca22a0c9f7ac822564e7e90726457ffdee6107772e7461aa6dacf876d;
    // uint256 internal constant Z_44 = 0x15e4cf322bd4693b5ba17d7d77599ed6b40e943b15d4b652dcd1b206f57a4c6e;
    // uint256 internal constant Z_45 = 0x02f79c24831208eb014af76127ee58b95cf9598ad1dad9c82e19f10b7fee8f6f;
    // uint256 internal constant Z_46 = 0x19d4d18c572a9b0b503094e1de87b8594e1d37dd1da42acdb3a19bd35f005a3a;
    // uint256 internal constant Z_47 = 0x24d3e3c36e11f6dac11d08927f0a925e2c4c42248a913c18da9f5cc0da73836a;
    // uint256 internal constant Z_48 = 0x131b0345b2f2564b2338810cd8d7b90a8d5a2fcc1a9a8876a494dbe3c8135c6c;
    // uint256 internal constant Z_49 = 0x0e765e363b659fafffce80bef02723bbbea3669cc9b07f327b4fc9c959c169a5;
    // uint256 internal constant Z_50 = 0x0f2d774b6dc7c8c6c49e2056f9f9e77d510637ff52368027fd8326821c83445a;
    // uint256 internal constant Z_51 = 0x16599e0bb19201fa33d4c00c3f7c5189552a26038ee219b1c8b08fd1b16ecd52;
    // uint256 internal constant Z_52 = 0x22f62d7c8204be97acc7644d4b14a422c17e573506e900a4788acbfb8c8b1aba;
    // uint256 internal constant Z_53 = 0x0691a1f6e7dd363914d2754f434659383019fe2a1d10a9ce92d152decccfc5f5;
    // uint256 internal constant Z_54 = 0x1250a6bd4582016e8af7d74a31a7d181864326e50cea97f643b70ec9d94e1efc;
    // uint256 internal constant Z_55 = 0x02d2011d328f63f5cb9eb68a6806f8ce624ceb84a876a390fda61d6d6bb5a530;
    // uint256 internal constant Z_56 = 0x1b593cc9332c0bb29333e5833284e18e765bb17fc0a7718f6b21d8a833a0765b;
    // uint256 internal constant Z_57 = 0x019bffd7d85c0863485890e50a717ebb21d4b888f0268d9c7258a3db25f969d9;
    // uint256 internal constant Z_58 = 0x12340d5bb49b5667c9194321fc364488d0f082a8fb1bc4f1b96359209b1bf110;
    // uint256 internal constant Z_59 = 0x2209d88df4bf41b2e002ff46f8ac45aa4ec8b222f4551c178fe50f99b505681f;
    // uint256 internal constant Z_60 = 0x04f95f7efd61e5dfab009860f0e53b7e65686c5dbb1b1a800d597ec130836f92;
    // uint256 internal constant Z_61 = 0x074b0f589c0d62b3ee0d70fd057f9d0e143a6b888d0a9f60ac1d0f1c77ddf863;
    // uint256 internal constant Z_62 = 0x05e7d0fbf97820e4f7e37899bee6f967bc67f5b396f760665eb5ce76f51cff90;
    // uint256 internal constant Z_63 = 0x0ee294cdea89cdfb6a3fd3f85316222c2e6e7482b9cd052cea388141037acdb5;
    // uint256 internal constant Z_64 = 0x073f3f1b95b5cafa069fe1bb5e08c8586775783cc6a11c35ab0107dbd0437dd6;
    // uint256 internal constant Z_65 = 0x12a604345e9442be58176866c68899249a7c14a777af0938a759826474ebb215;
    // uint256 internal constant Z_66 = 0xb983d964a33bdccf941858b4eed650917cc9c35265f14ec2715dc6999c0489;
    // uint256 internal constant Z_67 = 0x1a1a7fbdc860bcc40d4b3eea4c8f469f991050b9fb6ef33ca3694edc4f36a82b;
    // uint256 internal constant Z_68 = 0x0df2ad5009b0aa7b9cc62d10f9fddc978e28452ef5f3bb3d274743359383592b;
    // uint256 internal constant Z_69 = 0x16e0518517026f2c7cbf14301679bcecd00e8babaf0bda664c49b02dcda6b4dd;
    // uint256 internal constant Z_70 = 0x205e35d27e9528e137e8f93ff50b877d6f0fa3230e1215df6360ef7ca4b3680a;
    // uint256 internal constant Z_71 = 0x2b14a855c417e66c86c9e1bd864e0a5b00d45bbe84e6d93749ef109d25790d9d;
    // uint256 internal constant Z_72 = 0x2cde883b4ec6916a780528e64ab784c3c081ed2d71397c5d739a5bd4f24a8e3c;
    // uint256 internal constant Z_73 = 0x1bf2b15c37a3eb5f94bbf12c10e19a22f3c8ddde72133d9fe32db2be7387a77c;
    // uint256 internal constant Z_74 = 0x1fd2be106c935c189640b47d2ad9deb51ff348845b7e6cf0eca562435735fa67;
    // uint256 internal constant Z_75 = 0x3029a5ede685ae7e42e029a4f1b22a0575d6b5cef84f695a2f987ede9fe41280;
    // uint256 internal constant Z_76 = 0x2c16523888340ddb03fff41ab7a56b492c345a76411e5d3467360264cc5f67;
    // uint256 internal constant Z_77 = 0x2c6d19a82f4a7679d929c99dbbe056cf07e74fe0460e9d5b81226b9b2283d96d;
    // uint256 internal constant Z_78 = 0x2c5164b5c7798ae26796f2374fe1acace1a69b5772352fdd9c09e83b95847e75;
    // uint256 internal constant Z_79 = 0x0d31f8f2a4e34d6731f1042d995d4ab9b3f9dc01e033446521947534ed617886;
    // uint256 internal constant Z_80 = 0x1f1a7feb56222e6eb83bf3beb69f5efcc05d10c2cff3d6c3f5b8134943ef678e;
    // uint256 internal constant Z_81 = 0x24c4aca03d4a952cc1b2879b1241b0669afde82390de9fc8edad89c2fda41014;
    // uint256 internal constant Z_82 = 0x1c0857ed41b1a306a787fd591e14f0190c7332745112e4d4aaa4f71fcdb18b1e;
    // uint256 internal constant Z_83 = 0x145e3cb92e0058bc04394485e73dd1f9ba87c2cc15a3b201c027e43109dbef81;
    // uint256 internal constant Z_84 = 0x26e0aeb64465f3ad7046be46afc13c942be769135549b36c833947b4e0da69df;
    // uint256 internal constant Z_85 = 0x21f428f358cce02f84038fd4cbd838dabd72b8ceed847cde16375f1c98ab81fd;
    // uint256 internal constant Z_86 = 0x0c3e112a2286b468499a5ea53e050bcb848dc0f70c7d758c7602e327746a063b;
    // uint256 internal constant Z_87 = 0x291d939f9e3a70af5d6d2d8caffc34175cbfab587d4e9e293821806149453d9e;
    // uint256 internal constant Z_88 = 0x2e81f77acaf016b7fc5567d50a96773c72743783e7bba0e5a12a4a135485a49f;
    // uint256 internal constant Z_89 = 0x12e0e08c58426173229fb99e97a35c8f75a8c4f30ec5ed8fbe7b00c81765c2ec;
    // uint256 internal constant Z_90 = 0x25ee0b3dc3db03f85b355d34f156066cc1ad50112589092d90de8ebb4017d116;
    // uint256 internal constant Z_91 = 0x0b29d0ddf485319a9bfbf6b263e865a67c6122e7f47ecc482f591f92e4effaf4;
    // uint256 internal constant Z_92 = 0x140f26545084fcd739e0abf03a75d1c889b8dd99818e9ae23ed638a63fee2191;
    // uint256 internal constant Z_93 = 0x2fb6de61ff780b7274373cb13232d4c9ad8487c6ebb1e3121a16ddec2c4b624c;
    // uint256 internal constant Z_94 = 0x0854275e7235881668b5b98251a66d8c9b82af0a6451da41d0eac04d4e7811c8;
    // uint256 internal constant Z_95 = 0x0822679ef57fef500de54d6cba8415ce9ac944d3afb1dd4cacce2b2ff451403f;
    // uint256 internal constant Z_96 = 0x1d0ca0d26b8051fcceaedb7a95f25c4cd5e71ffce3ae1f2942c3612c8f6e80a8;
    // uint256 internal constant Z_97 = 0x2353d576c4d9f118a4bc7b2c492f7164cf173bc2c37d17f7fa6126c7d0094927;
    // uint256 internal constant Z_98 = 0x188e9347138c524bda0413d4ad63350c88ba806491204abd61a285d192d50e14;
    // uint256 internal constant Z_99 = 0x126c2038a88263356a46f4de9a59b538df61a3c4cedee042ba66193debf0d4b7;
    // uint256 internal constant Z_100 = 0x1b34d0aba99f650468f0d3241fab6192755b6ee17d345f3c23f784c365e97e52;
    // uint256 internal constant Z_101 = 0x13f60d322ff331eeb58a3c85acc593c97f8930c1f07e92b9c19772ba6f185221;
    // uint256 internal constant Z_102 = 0x10d2b5662f6977c2cf9b23c1d7dfce6a56ccc7baf7bc7b2cbb505368828888c1;
    // uint256 internal constant Z_103 = 0x1000b1532ad15dab1910284d08588e0ed96b09a95a7b06180bd40f3e43041aa4;
    // uint256 internal constant Z_104 = 0x0e4425e6397061fb0a1cb79d4861ee8e780ec260783d6462dda5109cf13e0311;
    // uint256 internal constant Z_105 = 0x13999b236cd8cb12546b95e2234e5e92f2dbe1ea227ee7ff9477896864d9c26f;
    // uint256 internal constant Z_106 = 0x16253ee85a590b7d7e450d3ef38b6d8d72e57d7985d98fdae9d3e69d280e1490;
    // uint256 internal constant Z_107 = 0x0849dd12c0483e541856ebf80f3fe755a4f4cbc02a3921c2909d04890f9ce86b;
    // uint256 internal constant Z_108 = 0x2f4f55d48db9c60e9b822552c9db290c03cfa51fe52e0980f99fd882bd2e0065;
    // uint256 internal constant Z_109 = 0x26e9c4c282f2aba00a3f528e04abab1e63df8a908636c7295a4f67135c986e75;
    // uint256 internal constant Z_110 = 0x1d5717b6a1d0d20e41d35e2c7d0b4fa001924d91618550026106b4fc2b978b9e;
    // uint256 internal constant Z_111 = 0x16276c3116072ae2d3815ebef6eae3c7418641bc048667418409cb1a36a3c6bd;
    // uint256 internal constant Z_112 = 0x200ace77e0d131b2652e782f50136c4f3e7bd21b7342327715ae96796b0e4785;
    // uint256 internal constant Z_113 = 0x303f0d0ee0cfc4509ac0174c85aad3ee1aab586e90b118f8de5aa446d2aec8ca;
    // uint256 internal constant Z_114 = 0x21d023dac5b44bad38d5b4f08ecc711cc9f9a916ee3a8e9e406236cef888f7e8;
    // uint256 internal constant Z_115 = 0x1ee0da36a81b54a9eef3b4b0a1b2f8d697855a48b8db44478aa2383eb635b218;
    // uint256 internal constant Z_116 = 0x2dbabb204983acc8179b7b3242862961b174d22f4fefcd81e68c6549c9a88cea;
    // uint256 internal constant Z_117 = 0x23954e35feba58a113fa213392abd035c2b032f0b4e83c2f52a83d18e54433bc;
    // uint256 internal constant Z_118 = 0x2aed396db05f304fc6775f10e0aa0dceeefe297e511ad478414eb1ab84844957;
    // uint256 internal constant Z_119 = 0x25221fd64e70bb4c90b30a2fb1852ddaa8704ba4680584651c3c9732f501e138;
    // uint256 internal constant Z_120 = 0x04e4fe96e487b1979011964d97719275a68773ee23ba55fe2f809d69c10c3a22;
    // uint256 internal constant Z_121 = 0x2c212b4c639445a6c03ea31cc755c51433c61afbed9eea3556b36f27cdf344a6;
    // uint256 internal constant Z_122 = 0x249a023bda5b6a8d6b1e3d994693cdd3ad81f0282b95d5a15ddc36b195138e4e;
    // uint256 internal constant Z_123 = 0x156b5cd887b306896b7ca039e2afa02868ba62817d7b7e5d2896ae14e1a9a7e5;
    // uint256 internal constant Z_124 = 0x162d3e89ec9131809bc10150382a744f65af577521cc37c46bd00912f3eb4d31;
    // uint256 internal constant Z_125 = 0x22075061e5564be974e193731c06a4e22cfc8242a38180c732ad2f0d4604e3fe;
    // uint256 internal constant Z_126 = 0x0b6b9c320f299ad3afd75f0d0bd81afbb0e757f8307f61978d5de7817f608327;
    // uint256 internal constant Z_127 = 0x0506e0a856c856e7634ab226160b6a323261a3e0c8810f68e2743a4263b57ee2;
    // uint256 internal constant Z_128 = 0x2413c3e2b026ffff5628832762082690520fc5a22f825e3af1a86cc435901981;
    // uint256 internal constant Z_129 = 0x2cef9a3613e8172d950b3c1cb7cab1224277ad2712ac02e96dc8519794a8ad5f;
    // uint256 internal constant Z_130 = 0x0f636c6a10dbda008e10895d5b588f5b5d01a5da3a09c361c1a0b548b560b220;
    // uint256 internal constant Z_131 = 0x18c09a08d500307171b4f240ce0f2c5e78866ec7e6374a0176047fa890fba0ff;
    // uint256 internal constant Z_132 = 0x0a3cc6a6411731de29dc727f71370d6c9ad89980d868ed69220b8807e76c9f1a;
    // uint256 internal constant Z_133 = 0x199c7b72643a56c5dacc094c5ab51c19ea6d4e2ab5067abd873cfd728483ee3a;
    // uint256 internal constant Z_134 = 0x0a9c91ec9d961021c7f3e816b9aa9a04257acde68474586c8a9d9d5c940807e8;
    // uint256 internal constant Z_135 = 0x14c5fd147f901e87ded8a14a4fc59939bfb72af7f7e67186e733fe9bb2d03eca;
    // uint256 internal constant Z_136 = 0x1acef925c3cca5dc9f0a031563d268374fdb1719c59b743c7ee6667ef6879399;
    // uint256 internal constant Z_137 = 0x0ea860a77c1c5de892c3659365c610d079fa8d064fc0982291d5b2313505b8a2;
    // uint256 internal constant Z_138 = 0x0cf81c182313729421c7b9a627208a70acde524a61589b88630842aec4151fbe;
    // uint256 internal constant Z_139 = 0x03c1dd4555254c7c2663290bee910ae8f7359fe0cc45e306a9df149b9583fc28;
    // uint256 internal constant Z_140 = 0x2380880753bc787886c9330c047d222cc2a90ac6be2fe1bbe69c3be7c83c7b0e;
    // uint256 internal constant Z_141 = 0x1db6521a766a6d998d0502d2543209962f3352d55e72b29656bfc3d7e2a250d8;
    // uint256 internal constant Z_142 = 0x05c4aa57c046dd90cdccc970263f2dec18fa0dac5108e96d9ef1511758d3d191;
    // uint256 internal constant Z_143 = 0x0c879e4b1793ca7ad312adf8d83aa14a3b7df00eff18e9e9b8d1da21dc0b3033;
    // uint256 internal constant Z_144 = 0x2f234d5aab8610df7b41caf56ed7db37efde646138f699c64da49313f944b20b;
    // uint256 internal constant Z_145 = 0x2abb52222822ff819894aa1506aceb69cdd387abb73d541f1e8ba8f971fb4375;
    // uint256 internal constant Z_146 = 0x1d9472930835607a1a5543cc38ab10b3db29aa5bd46d779548a05927fae2531c;
    // uint256 internal constant Z_147 = 0x22b45ca22855701aa0ecb8609bdc31390e8c94cd9935202ed90d90c07e5f6c67;
    // uint256 internal constant Z_148 = 0x0a1f39f29473f6a16b502a67dc2683705e177ef3763ca210b36a6222f201928c;
    // uint256 internal constant Z_149 = 0x156cc79f3ce078aad6e5696dca53bd414daee13f69b6e1843927981c36505697;
    // uint256 internal constant Z_150 = 0x228e1ea054fd72054b743d4d83e8cb1fd688fcf6e988b79cd73c590befbea8c8;
    // uint256 internal constant Z_151 = 0x26b7327ab922821bd4f8140cce34ff4ccea50fbc5422ae813c2656408cce3a70;
    // uint256 internal constant Z_152 = 0x1f88cb99931d78883fc9390abb33404b4b7d45ab032cfabf43c2cba6bf04924c;
    // uint256 internal constant Z_153 = 0x2c9a9e3033be9def3f405a74334e13abda0a9bf0e2dded80e07464946626163c;
    // uint256 internal constant Z_154 = 0x1ffba91116956a6d7499ce126e4d007b26ba57aa42ca8d260b1e6cd7f38541c5;
    // uint256 internal constant Z_155 = 0x04d01766bf4af18c1c993689ba59328da95a06be98204edda80174720e47b975;
    // uint256 internal constant Z_156 = 0x0a3a44d64bcf0c2b158912d887c5993e9568331b7249d98aed3e143c555bee34;
    // uint256 internal constant Z_157 = 0x1b03b3acfb879340d7ded90a8a34d6aaa567e052a02fde21942fee82e8f66410;
    // uint256 internal constant Z_158 = 0x26fa331c2375a0bb32aa7f2084a5ff100db2398c10a3415fb1d082dffd478794;
    // uint256 internal constant Z_159 = 0x27db7d141d06b30011b01150c3a4e29bb43e22eed0d8c7e73219256fad9255f8;
    // uint256 internal constant Z_160 = 0x0577b5b4aa3eaba75b2a919d5d7c63b7258aa507d38e346bf2ff1d48790379ff;
    // uint256 internal constant Z_161 = 0x1ecf79a39cd54940b8a40e32200363848ebb59f2bf6f9b2cfad8b7a2275252d7;
    // uint256 internal constant Z_162 = 0x1f77ab0fed9fea9d9468d14c2984cc349bc1081f722a9ccad1c4eedab59cb99a;
    // uint256 internal constant Z_163 = 0x3022ad3f76364d385ddca01deb2cd983d1e69555cbdad96a011431226df85839;
    // uint256 internal constant Z_164 = 0x125a3b8b46498cf42036267607d53ca65f8646bc10e3674168bdbef5739a099a;
    // uint256 internal constant Z_165 = 0x0757b871d5c7251a372abf890ac352c724c7557d78be026c0759e5676e344674;
    // uint256 internal constant Z_166 = 0x0cfc8c10a56f2f605746f0bfd61307ce6593ccfca9c0d9270b68657b271dfd37;
    // uint256 internal constant Z_167 = 0x1ef253511185f87eaa59b3635f972dc315faf9aaa4d8759e780c6003384d2a24;
    // uint256 internal constant Z_168 = 0x02c833a47eeedfc40c45aac9d970a32195d6f3951402d4f06c39aab8cd025e11;
    // uint256 internal constant Z_169 = 0x24d4e2aaf6d18c7cd6edad7483bb4440a00ed1349a5d7fe1cb298bc055d2d79b;
    // uint256 internal constant Z_170 = 0x0b10c329265f524b498c1a6dca6c24eb61aabbbfc560b36d13341cb3d070326b;
    // uint256 internal constant Z_171 = 0x2142ed992a2adec811ed13f494c4adbebea286705016fa948145ce5506422c34;
    // uint256 internal constant Z_172 = 0x10cb96c256061032fc2885b74eba833405410ed4006a1515e515001b0a4bf569;
    // uint256 internal constant Z_173 = 0x092beb2cf77813eb3230efec31e84c78a49ce215c7ea372e894e612647197328;
    // uint256 internal constant Z_174 = 0x23bca64498e5f68a91a7247eec069b58bc40cf070a691e37c0b5a5efc257c81f;
    // uint256 internal constant Z_175 = 0x1bb98c14f22fc7ae7bb84acd36df1c273a45a96e492346cff4f696197175574b;
    // uint256 internal constant Z_176 = 0x24d8c0207315afe518cbdd2abcfa1e677b25325eacf62ad3872eff2286c279a7;
    // uint256 internal constant Z_177 = 0x224fa532dea57a2e09513a649f175a8d3a7e222e6de300c7c81bac8d39a21bd9;
    // uint256 internal constant Z_178 = 0x1239cafbc1c13b3409318ccba513de878dd9a632dfcd372fe19f71c55a949c07;
    // uint256 internal constant Z_179 = 0x0c46c800a74bf08091213b779623cc43b51c993e9b1ba002156d10c659405c8e;
    // uint256 internal constant Z_180 = 0x0b673097274e11e1e616e8da5d606b57982ef05b916d5ee4d1109279698c6c18;
    // uint256 internal constant Z_181 = 0x10e502e3958270ac685a1563e06ce6d5725de4496ac738506543338131c2b9b2;
    // uint256 internal constant Z_182 = 0x2838b89d5e20a782a0ca8d9f6cacc5fb4c3381323f6b640446ae52ecd30718eb;
    // uint256 internal constant Z_183 = 0x10ab53a4679a5635a35758746dff6c20a34c2b157d3c98624a76e6ba5900c497;
    // uint256 internal constant Z_184 = 0x2712551b30a6f6b5fc76c477ebab36d1c71af433be5483720bdb93fac8bab39c;
    // uint256 internal constant Z_185 = 0x0b8d230a37a720f39aa0b8275c9aedcbfd7354aefedf25bf7d3e14eb4a924d47;
    // uint256 internal constant Z_186 = 0x04fcadfd7913d8252cd21f6a48b550779216b35d7b729b28b7c9289919d2b2f8;
    // uint256 internal constant Z_187 = 0x2aa63a738d03542f8969b3bb2a76878e2c6bf4229246c789e637f4cea850fce5;
    // uint256 internal constant Z_188 = 0x26f1832cc9ca8c4c3b060d41767245c1f2d00908bf03b59cec50cbd8c23d6514;
    // uint256 internal constant Z_189 = 0x275b6211c835914022d291ea5c14c3a49c5e7338c0953b63996423e7605bcd9d;
    // uint256 internal constant Z_190 = 0x2563a8ad67dc98a185fadd83a43c98499175403a75502acb06883b59bab3a7b7;
    // uint256 internal constant Z_191 = 0x1721c3e5b0106d922d6bff750374f4da03a7383f3fadd4cabcc034622145447b;
    // uint256 internal constant Z_192 = 0x2582f948dc4f9e7d9c88ac70d67f8e31d441eb93feecaad7ff345e115cab65fa;
    // uint256 internal constant Z_193 = 0x1218125ed502053d5e8fcad7d135af1f488cde951f7ed8fd2f2d1d5aa6b6557f;
    // uint256 internal constant Z_194 = 0x12f4db8bcce2e0a794f630f421474de9309f309e98caf57a4153591a1fb92caa;
    // uint256 internal constant Z_195 = 0x15c221e247c792e1b920480fae58322346214d7a4f7aa49332c391bd9f05935d;
    // uint256 internal constant Z_196 = 0x17498b427f4f79e7ae2f1f52fcd5d7075ccf267835719e0405a255a6c68962fd;
    // uint256 internal constant Z_197 = 0x10bd44f21bc42f28c0264215b2e28cef9ecb5ec61c2657f5c4717f3b46921267;
    // uint256 internal constant Z_198 = 0x103ebdf65d69ee584d08e0a8510b578acf5d63b2dd975c627fef2b9732a37b50;
    // uint256 internal constant Z_199 = 0x1907b58213078bebbd4f5bc36870d017a37b9bcc312779d42e7c3d48c3d6b258;
    // uint256 internal constant Z_200 = 0x08d7ebea95d4ed8bd1a5f63728fa3a73cb02e630bcce1c096baa805973a642a5;
    // uint256 internal constant Z_201 = 0x19b1ffa7fe94d24f5f28f89d4d553de90699265a330e196f12f18f4a16d2b109;
    // uint256 internal constant Z_202 = 0x0bbda2c2b3d4a91f00ee3517678b1ba9eb3f377c83ef5c4d648f52f4297d5da3;
    // uint256 internal constant Z_203 = 0x2c932d1a015d414203ce921d88103cb1a9b85f2ffeb3ef531b8a065e3aaffa75;
    // uint256 internal constant Z_204 = 0x2ce76bed09cee527377ecb2d2ebd0a6567a644b2559195b48384bafee980c3c1;
    // uint256 internal constant Z_205 = 0x20374ec21f619a7db52b440119e465bc988cb703d1094220b5442875d0dce06c;
    // uint256 internal constant Z_206 = 0x2a135e4bfcd57706409b636f52673b59409c97fe46583330fa7706d627a56474;
    // uint256 internal constant Z_207 = 0x2a47da7c0e5d331c7d8e72f53154f4a13288d6c44b9e6b6717cdd92f312b3353;
    // uint256 internal constant Z_208 = 0x20088d1a50ec9a529fec040e8eb564bed9a1059a520401b785c1ec120abd812c;
    // uint256 internal constant Z_209 = 0x1ae4561f8fcc67bb200062a5d497ada7fe208d651173678a8118984cfeef6937;
    // uint256 internal constant Z_210 = 0x0a9916c139819d31c4f48e106dabfcc7ea769d696c1f6ae446f7d0c98aaf8b75;
    // uint256 internal constant Z_211 = 0x253f6fc8c44d48ad458d5a5c5c30a041a6bf335f8d0f492c2186512c749ca6cb;
    // uint256 internal constant Z_212 = 0x0c2b4fa22420f97803f512ad895ea2164f3f7f2481b56ea774b46088de7ffdb9;
    // uint256 internal constant Z_213 = 0x141224a94708e926075358cc2495c53625040716977f3de892a40cf73c6f2b32;
    // uint256 internal constant Z_214 = 0x29d9ca18613b8a62c02e0e5c1b44e7a2a713a01d73f1708ebb4449162e5f462e;
    // uint256 internal constant Z_215 = 0x1cb18ca10196845b3e352d03bf25945a462abd5633e93bddc212eb01b2a8a223;
    // uint256 internal constant Z_216 = 0x1337a1f4b94b96d08d6f0f41bd68d93181d2d862242f4c70a26e977604ead502;
    // uint256 internal constant Z_217 = 0x05b3fe94a4fd54ceb006d20316a702c3356400879e2414b802440995e88fd906;
    // uint256 internal constant Z_218 = 0x0827171a561f56a9a44d610a8028dd8117b24df85fc9a9ed86a9fba085fa4072;
    // uint256 internal constant Z_219 = 0x06e59c153b62766e95ceecac27d7c3be782195284e3ce5fe5fbeca885b1e0a86;
    // uint256 internal constant Z_220 = 0x0563bc18b1958120edbc2fdb082bbf750d597c384902b8c3e284ce5e2ed5128e;
    // uint256 internal constant Z_221 = 0x050e7b2be79cbb885ee41713e2f4a9e2ed36a896eb19e910d7505b18df08556d;
    // uint256 internal constant Z_222 = 0x10bdd6c482830c456011e8f4036e82687e059decceb53b22d77421116fcbc875;
    // uint256 internal constant Z_223 = 0x0ca16ab680079be1a06de1edcc83d46112feb474ea48604b8926edb8f5a74460;
    // uint256 internal constant Z_224 = 0x204d45636e47ea8e4b2d63a39094d063a9a70926ecdb8cf85aa7e5f52879e4d1;
    // uint256 internal constant Z_225 = 0x0344a9a9ac6fe8d3082148a4579e914fe79abb25b8b6f5539bddeefa6cd48617;
    // uint256 internal constant Z_226 = 0x10bb619f48bb67e01221ad2c8c31af91e64061243c0bb743b88c1cde1b4a99aa;
    // uint256 internal constant Z_227 = 0x01962ae18223718c1d767ec68eb54e28cf33014999fc6096073ff40fdba09c90;
    // uint256 internal constant Z_228 = 0x2a86ac67af928719d810b4470436399096027e78924cc09ba66323667dca868a;
    // uint256 internal constant Z_229 = 0x2ad34c7f80a44548b9c51eb13367827cd2df324aeffaf4603d38c976d37ce4bb;
    // uint256 internal constant Z_230 = 0x1c5b0c9c9058f3c2513c813511461090bbc078d2a5fa5682103ae7ec212dd6c1;
    // uint256 internal constant Z_231 = 0x0a8406a69b30e9dbe6196ba02413175012fbf967442b0c98b8754f4cf17df6d1;
    // uint256 internal constant Z_232 = 0x1315f51ff5ed97b1505216966ac1f9c7022bf070f691e73254a0a49b03cc674c;
    // uint256 internal constant Z_233 = 0x0bde93887352f2cbeebc1eb51e1223beec000e0fbf29fcb96fa6b85b3ad8a3c9;
    // uint256 internal constant Z_234 = 0x0317d157ff1b71f8331affdfc35320bba78fa78025505343e34b582e8379a875;
    // uint256 internal constant Z_235 = 0x1c98890a30f821217ce8a9623dd44f0abe402c3cb0a7c7827b98f3c520a8e22e;
    // uint256 internal constant Z_236 = 0x2c1fc6866d2871f0294ba52d4c65e0bf280ef56881de1c7e5fb1c8c67fe4b978;
    // uint256 internal constant Z_237 = 0x12848d969d12e9d38d10d483292d0c025c8e726bd421ae74fd5657ab6534019d;
    // uint256 internal constant Z_238 = 0x08c28622431c74283c0148b88fa55caa4988d441226cd43a2ef566a42f748eb9;
    // uint256 internal constant Z_239 = 0x258cab390858db57614294d9fcc1b0961b81ad354051f48b98e6d25299dfe82b;
    // uint256 internal constant Z_240 = 0x058faee7a1388f15c39de56da0e6970bbbc7ee5a1c055ecb5b7f656a88809ec4;
    // uint256 internal constant Z_241 = 0x12bbb0fa869235fa6a472a13d5dda543d98b4b977d8fd81cf90d93ea7e8cff2d;
    // uint256 internal constant Z_242 = 0x2d8883b05079a7b25c2ae3e7d3ce7604752c6772e925119b984bc516010c6204;
    // uint256 internal constant Z_243 = 0x295a45fd8e538b8577d0c73c5f1675a0bcf5e60be0243894da37e5a74ee21fbe;
    // uint256 internal constant Z_244 = 0x0493290d3b5d8dc7ebbe478f0506cf986fe7381fd2534b553fb04fb98f2a564f;
    // uint256 internal constant Z_245 = 0x22cc268481d30d7fcda203a9b8bd94872924ace48ad2d2b673afa21e95035913;
    // uint256 internal constant Z_246 = 0x177a0e1b5b3b98e590566368e1b67f6d75aa7db2ac494371fc61e3fe5039aded;
    // uint256 internal constant Z_247 = 0x2abe20b5352006cf643e54abda7ddf07efd0fbaa24df4fc7399c90a855dfec36;
    // uint256 internal constant Z_248 = 0x03b88c3568ca32d6cf32f1dbce2f7e67670f5a7fb9f756428e4f4629917f9ba6;
    // uint256 internal constant Z_249 = 0x11482d51cf3ea88fe054182a540e9e17a6e9c8994181cd540c176afd9fadace0;
    // uint256 internal constant Z_250 = 0x4c3d888bb114e5d0177ede4534a096a8468533c2ac36bb3330d0368bacc0fb;
    // uint256 internal constant Z_251 = 0x09ec86e70598ee56d25ea9bb7b96a440dddba1a81d6c8bb47341609a3b503d5c;
    // uint256 internal constant Z_252 = 0x209c8d12e52452204955b10ef4cf5cc2e7f3ab828d9f0fa71e9177d4efa971ce;
    // uint256 internal constant Z_253 = 0x034108093317ae5daf4b976f864f06cb1421d8959c252313fb8e6eae5aeae9c0;
    // uint256 internal constant Z_254 = 0x0ec9cf7fbcbffa41bc1b25e7569f1bbc85ee742cbe1c6c6f4c6af987b9773f55;
    // uint256 internal constant Z_255 = 0x303f920ed5793fa397856af28077c1416be6bef882c6f307e48085e90bd35a35;
    // uint256 internal constant Z_256 = 0x23937a94d07907793fefe7d375c80ae537233e4feca7028e1e1107803ded93bf;

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
        // if (index == 33) return Z_33;
        // if (index == 34) return Z_34;
        // if (index == 35) return Z_35;
        // if (index == 36) return Z_36;
        // if (index == 37) return Z_37;
        // if (index == 38) return Z_38;
        // if (index == 39) return Z_39;
        // if (index == 40) return Z_40;
        // if (index == 41) return Z_41;
        // if (index == 42) return Z_42;
        // if (index == 43) return Z_43;
        // if (index == 44) return Z_44;
        // if (index == 45) return Z_45;
        // if (index == 46) return Z_46;
        // if (index == 47) return Z_47;
        // if (index == 48) return Z_48;
        // if (index == 49) return Z_49;
        // if (index == 50) return Z_50;
        // if (index == 51) return Z_51;
        // if (index == 52) return Z_52;
        // if (index == 53) return Z_53;
        // if (index == 54) return Z_54;
        // if (index == 55) return Z_55;
        // if (index == 56) return Z_56;
        // if (index == 57) return Z_57;
        // if (index == 58) return Z_58;
        // if (index == 59) return Z_59;
        // if (index == 60) return Z_60;
        // if (index == 61) return Z_61;
        // if (index == 62) return Z_62;
        // if (index == 63) return Z_63;
        // if (index == 64) return Z_64;
        // if (index == 65) return Z_65;
        // if (index == 66) return Z_66;
        // if (index == 67) return Z_67;
        // if (index == 68) return Z_68;
        // if (index == 69) return Z_69;
        // if (index == 70) return Z_70;
        // if (index == 71) return Z_71;
        // if (index == 72) return Z_72;
        // if (index == 73) return Z_73;
        // if (index == 74) return Z_74;
        // if (index == 75) return Z_75;
        // if (index == 76) return Z_76;
        // if (index == 77) return Z_77;
        // if (index == 78) return Z_78;
        // if (index == 79) return Z_79;
        // if (index == 80) return Z_80;
        // if (index == 81) return Z_81;
        // if (index == 82) return Z_82;
        // if (index == 83) return Z_83;
        // if (index == 84) return Z_84;
        // if (index == 85) return Z_85;
        // if (index == 86) return Z_86;
        // if (index == 87) return Z_87;
        // if (index == 88) return Z_88;
        // if (index == 89) return Z_89;
        // if (index == 90) return Z_90;
        // if (index == 91) return Z_91;
        // if (index == 92) return Z_92;
        // if (index == 93) return Z_93;
        // if (index == 94) return Z_94;
        // if (index == 95) return Z_95;
        // if (index == 96) return Z_96;
        // if (index == 97) return Z_97;
        // if (index == 98) return Z_98;
        // if (index == 99) return Z_99;
        // if (index == 100) return Z_100;
        // if (index == 101) return Z_101;
        // if (index == 102) return Z_102;
        // if (index == 103) return Z_103;
        // if (index == 104) return Z_104;
        // if (index == 105) return Z_105;
        // if (index == 106) return Z_106;
        // if (index == 107) return Z_107;
        // if (index == 108) return Z_108;
        // if (index == 109) return Z_109;
        // if (index == 110) return Z_110;
        // if (index == 111) return Z_111;
        // if (index == 112) return Z_112;
        // if (index == 113) return Z_113;
        // if (index == 114) return Z_114;
        // if (index == 115) return Z_115;
        // if (index == 116) return Z_116;
        // if (index == 117) return Z_117;
        // if (index == 118) return Z_118;
        // if (index == 119) return Z_119;
        // if (index == 120) return Z_120;
        // if (index == 121) return Z_121;
        // if (index == 122) return Z_122;
        // if (index == 123) return Z_123;
        // if (index == 124) return Z_124;
        // if (index == 125) return Z_125;
        // if (index == 126) return Z_126;
        // if (index == 127) return Z_127;
        // if (index == 128) return Z_128;
        // if (index == 129) return Z_129;
        // if (index == 130) return Z_130;
        // if (index == 131) return Z_131;
        // if (index == 132) return Z_132;
        // if (index == 133) return Z_133;
        // if (index == 134) return Z_134;
        // if (index == 135) return Z_135;
        // if (index == 136) return Z_136;
        // if (index == 137) return Z_137;
        // if (index == 138) return Z_138;
        // if (index == 139) return Z_139;
        // if (index == 140) return Z_140;
        // if (index == 141) return Z_141;
        // if (index == 142) return Z_142;
        // if (index == 143) return Z_143;
        // if (index == 144) return Z_144;
        // if (index == 145) return Z_145;
        // if (index == 146) return Z_146;
        // if (index == 147) return Z_147;
        // if (index == 148) return Z_148;
        // if (index == 149) return Z_149;
        // if (index == 150) return Z_150;
        // if (index == 151) return Z_151;
        // if (index == 152) return Z_152;
        // if (index == 153) return Z_153;
        // if (index == 154) return Z_154;
        // if (index == 155) return Z_155;
        // if (index == 156) return Z_156;
        // if (index == 157) return Z_157;
        // if (index == 158) return Z_158;
        // if (index == 159) return Z_159;
        // if (index == 160) return Z_160;
        // if (index == 161) return Z_161;
        // if (index == 162) return Z_162;
        // if (index == 163) return Z_163;
        // if (index == 164) return Z_164;
        // if (index == 165) return Z_165;
        // if (index == 166) return Z_166;
        // if (index == 167) return Z_167;
        // if (index == 168) return Z_168;
        // if (index == 169) return Z_169;
        // if (index == 170) return Z_170;
        // if (index == 171) return Z_171;
        // if (index == 172) return Z_172;
        // if (index == 173) return Z_173;
        // if (index == 174) return Z_174;
        // if (index == 175) return Z_175;
        // if (index == 176) return Z_176;
        // if (index == 177) return Z_177;
        // if (index == 178) return Z_178;
        // if (index == 179) return Z_179;
        // if (index == 180) return Z_180;
        // if (index == 181) return Z_181;
        // if (index == 182) return Z_182;
        // if (index == 183) return Z_183;
        // if (index == 184) return Z_184;
        // if (index == 185) return Z_185;
        // if (index == 186) return Z_186;
        // if (index == 187) return Z_187;
        // if (index == 188) return Z_188;
        // if (index == 189) return Z_189;
        // if (index == 190) return Z_190;
        // if (index == 191) return Z_191;
        // if (index == 192) return Z_192;
        // if (index == 193) return Z_193;
        // if (index == 194) return Z_194;
        // if (index == 195) return Z_195;
        // if (index == 196) return Z_196;
        // if (index == 197) return Z_197;
        // if (index == 198) return Z_198;
        // if (index == 199) return Z_199;
        // if (index == 200) return Z_200;
        // if (index == 201) return Z_201;
        // if (index == 202) return Z_202;
        // if (index == 203) return Z_203;
        // if (index == 204) return Z_204;
        // if (index == 205) return Z_205;
        // if (index == 206) return Z_206;
        // if (index == 207) return Z_207;
        // if (index == 208) return Z_208;
        // if (index == 209) return Z_209;
        // if (index == 210) return Z_210;
        // if (index == 211) return Z_211;
        // if (index == 212) return Z_212;
        // if (index == 213) return Z_213;
        // if (index == 214) return Z_214;
        // if (index == 215) return Z_215;
        // if (index == 216) return Z_216;
        // if (index == 217) return Z_217;
        // if (index == 218) return Z_218;
        // if (index == 219) return Z_219;
        // if (index == 220) return Z_220;
        // if (index == 221) return Z_221;
        // if (index == 222) return Z_222;
        // if (index == 223) return Z_223;
        // if (index == 224) return Z_224;
        // if (index == 225) return Z_225;
        // if (index == 226) return Z_226;
        // if (index == 227) return Z_227;
        // if (index == 228) return Z_228;
        // if (index == 229) return Z_229;
        // if (index == 230) return Z_230;
        // if (index == 231) return Z_231;
        // if (index == 232) return Z_232;
        // if (index == 233) return Z_233;
        // if (index == 234) return Z_234;
        // if (index == 235) return Z_235;
        // if (index == 236) return Z_236;
        // if (index == 237) return Z_237;
        // if (index == 238) return Z_238;
        // if (index == 239) return Z_239;
        // if (index == 240) return Z_240;
        // if (index == 241) return Z_241;
        // if (index == 242) return Z_242;
        // if (index == 243) return Z_243;
        // if (index == 244) return Z_244;
        // if (index == 245) return Z_245;
        // if (index == 246) return Z_246;
        // if (index == 247) return Z_247;
        // if (index == 248) return Z_248;
        // if (index == 249) return Z_249;
        // if (index == 250) return Z_250;
        // if (index == 251) return Z_251;
        // if (index == 252) return Z_252;
        // if (index == 253) return Z_253;
        // if (index == 254) return Z_254;
        // if (index == 255) return Z_255;
        // if (index == 256) return Z_256;
        revert WrongDefaultZeroIndex();
    }

    function defaultZero(uint256 index) public pure returns (uint256) {
        return _defaultZero(index);
    }

    function init(
        BinaryIMTData storage self,
        uint256 depth,
        uint256 zero,
        function(uint256[2] memory) view returns (uint256) hasherUnsafe
    ) internal {
        if (zero >= SNARK_SCALAR_FIELD) {
            revert ValueGreaterThanSnarkScalarField();
        }
        InternalBinaryIMT._init(self, depth, zero, hasherUnsafe);
    }

    function initWithDefaultZeroes(BinaryIMTData storage self, uint256 depth) public {
        InternalBinaryIMT._initWithDefaultZeroes(self, depth, _defaultZero);
    }

    function insert(
        BinaryIMTData storage self, 
        uint256 leaf,
        function(uint256[2] memory) view returns (uint256) hasherUnsafe
    ) internal returns (uint256) {
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
        uint8[] calldata proofPathIndices,
        function(uint256[2] memory) view returns (uint256) hasher
    ) internal {
        if (leaf >= SNARK_SCALAR_FIELD || newLeaf >= SNARK_SCALAR_FIELD) {
            revert ValueGreaterThanSnarkScalarField();
        }
        InternalBinaryIMT._update(self, leaf, newLeaf, proofSiblings, proofPathIndices, hasher);
    }

    function remove(
        BinaryIMTData storage self,
        uint256 leaf,
        uint256[] calldata proofSiblings,
        uint8[] calldata proofPathIndices,
        function(uint256[2] memory) view returns (uint256) hasher
    ) internal {
        if (leaf >= SNARK_SCALAR_FIELD) {
            revert ValueGreaterThanSnarkScalarField();
        }
        InternalBinaryIMT._remove(self, leaf, proofSiblings, proofPathIndices, hasher, Z_0);
    }
}

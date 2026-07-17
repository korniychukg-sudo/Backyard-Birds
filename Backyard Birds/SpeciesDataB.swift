import Foundation

// Field guide content, part 2 of 2 — Sparrows, Woodpeckers, Jays & Visitors + Learn content.
enum SpeciesDataB {

    // MARK: - Sparrows & Juncos

    static let sparrows: [BirdSpecies] = [
        BirdSpecies(
            id: "songSparrow",
            name: "Song Sparrow",
            latin: "Melospiza melodia",
            group: .sparrows,
            lengthInches: 4.7...6.7,
            sizeClass: .sparrowSized,
            rarity: .veryCommon,
            months: SpeciesData.allMonths,
            colors: [.brown, .white, .gray],
            habitat: "Brushy edges, wet thickets, and garden borders — rarely far from a bush to dive into.",
            diet: "Insects and seeds taken mostly on or near the ground.",
            feederTip: "Prefers millet scattered under shrubs to hanging feeders.",
            song: "Three or four clear notes, then a buzzy trill — \"maids, maids, maids, put-on-your-tea-kettle-ettle-ettle.\"",
            idTips: [
                "Streaky brown sparrow with streaks converging into a central breast spot.",
                "Broad gray eyebrow and coarse dark whisker stripes.",
                "Pumps its long rounded tail in flight."
            ],
            behavior: "Males learn their songs from neighbors, so each region develops its own dialects.",
            funFact: "Across North America, song sparrows vary so much that 24 subspecies are recognized — desert ones pale, rainforest ones sooty.",
            similarIds: ["houseFinch", "brownThrasher"]
        ),
        BirdSpecies(
            id: "whitethroatedSparrow",
            name: "White-throated Sparrow",
            latin: "Zonotrichia albicollis",
            group: .sparrows,
            lengthInches: 6.3...7.1,
            sizeClass: .sparrowSized,
            rarity: .common,
            months: SpeciesData.coldMonths,
            colors: [.brown, .white, .yellow, .gray],
            habitat: "Winter woods and brushy yards; scratches under feeders from October to May.",
            diet: "Seeds and berries in winter, insects in summer.",
            feederTip: "Loves millet and cracked corn on the ground; kicks leaf litter with both feet at once.",
            song: "A wistful, whistled \"Oh-sweet-Canada-Canada-Canada\" — one of winter's sweetest sounds.",
            idTips: [
                "Crisp white throat patch framed by dark whiskers.",
                "Bold black-and-white (or tan-and-brown) head stripes.",
                "A spot of yellow between the eye and the bill."
            ],
            behavior: "Comes in two color forms, white-striped and tan-striped — and each almost always mates with the opposite form.",
            funFact: "Its two morphs behave differently too: white-striped birds sing more and fight more; tan-striped ones parent more.",
            similarIds: ["whitecrownedSparrow", "songSparrow"]
        ),
        BirdSpecies(
            id: "whitecrownedSparrow",
            name: "White-crowned Sparrow",
            latin: "Zonotrichia leucophrys",
            group: .sparrows,
            lengthInches: 5.9...6.3,
            sizeClass: .sparrowSized,
            rarity: .uncommon,
            months: SpeciesData.coldMonths,
            colors: [.gray, .brown, .black, .white],
            habitat: "Weedy fields, hedgerows, and bare winter gardens.",
            diet: "Seeds, buds, and the occasional insect.",
            feederTip: "A brush pile near a ground scatter of seed makes migrating birds linger for days.",
            song: "Thin sad whistles followed by jumbled buzzy trills; each region has its own accent.",
            idTips: [
                "Bold black-and-white striped crown over a plain gray face and breast.",
                "Pink-orange bill.",
                "Larger and sleeker than most sparrows, often upright and alert."
            ],
            behavior: "Migrating birds can travel 300 miles in a night on the way to Arctic breeding grounds.",
            funFact: "One Alaska study found white-crowns could stay awake nearly two weeks straight during migration season.",
            similarIds: ["whitethroatedSparrow", "chippingSparrow"]
        ),
        BirdSpecies(
            id: "chippingSparrow",
            name: "Chipping Sparrow",
            latin: "Spizella passerina",
            group: .sparrows,
            lengthInches: 4.7...5.9,
            sizeClass: .tiny,
            rarity: .common,
            months: SpeciesData.warmMonths,
            colors: [.brown, .gray],
            habitat: "Lawns with scattered conifers — classic suburban and orchard habitat.",
            diet: "Seeds and small insects picked from short grass.",
            feederTip: "Neat flocks tidy up spilled millet beneath feeders in spring and late summer.",
            song: "A long, dry, mechanical trill on one pitch — like a sewing machine.",
            idTips: [
                "Bright rufous cap, white eyebrow, and crisp black line through the eye.",
                "Clean, unstreaked gray breast.",
                "Small and slim with a longish notched tail."
            ],
            behavior: "Once known for lining nests with horsehair, it still seeks out hair — sometimes from sleeping dogs.",
            funFact: "A chipping sparrow may sing its dry trill more than 3,000 times in a single day.",
            similarIds: ["darkeyedJunco", "songSparrow"]
        ),
        BirdSpecies(
            id: "houseSparrow",
            name: "House Sparrow",
            latin: "Passer domesticus",
            group: .sparrows,
            lengthInches: 5.9...6.7,
            sizeClass: .sparrowSized,
            rarity: .veryCommon,
            months: SpeciesData.allMonths,
            colors: [.brown, .gray, .black],
            habitat: "Cities, farms, parking lots, and eaves — always beside people.",
            diet: "Grain, seeds, crumbs, and summer insects.",
            feederTip: "Happily dominates any feeder; feed millet sparingly if you want variety.",
            song: "Simple, endless \"cheep... cheep... cheep\" from gutters and hedges.",
            idTips: [
                "Male: gray crown, chestnut nape, and a black bib that grows with status.",
                "Female: warm buff-brown with a plain face and pale eyebrow.",
                "Stocky, confident, and always in noisy gangs."
            ],
            behavior: "Takes communal dust baths, leaving little bird-sized craters in dry soil.",
            funFact: "Introduced from Europe in the 1850s, it reached both coasts within 50 years — one of the world's most successful birds.",
            similarIds: ["songSparrow", "houseFinch"]
        ),
        BirdSpecies(
            id: "darkeyedJunco",
            name: "Dark-eyed Junco",
            latin: "Junco hyemalis",
            group: .sparrows,
            lengthInches: 5.5...6.3,
            sizeClass: .sparrowSized,
            rarity: .veryCommon,
            months: SpeciesData.coldMonths,
            colors: [.gray, .white],
            habitat: "Winter yards everywhere; breeds in northern and mountain forests.",
            diet: "Small seeds taken on the ground; some insects in summer.",
            feederTip: "The classic \"snowbird\" — arrives with the first cold fronts and shuffles under feeders all winter.",
            song: "A loose musical trill, softer and more liquid than a chipping sparrow's.",
            idTips: [
                "Slate-gray hood and back with a crisp white belly.",
                "Pale pink bill.",
                "White outer tail feathers flash when it flits away."
            ],
            behavior: "Winter flocks keep strict pecking orders — earlier arrivals outrank later ones all season.",
            funFact: "Juncos are among North America's most numerous birds — an estimated 630 million strong.",
            similarIds: ["grayCatbird", "easternTowhee"]
        ),
        BirdSpecies(
            id: "easternTowhee",
            name: "Eastern Towhee",
            latin: "Pipilo erythrophthalmus",
            group: .sparrows,
            lengthInches: 6.8...8.2,
            sizeClass: .robinSized,
            rarity: .uncommon,
            months: SpeciesData.allMonths,
            colors: [.black, .orange, .white],
            habitat: "Overgrown thickets and shrubby tangles with deep leaf litter.",
            diet: "Seeds, berries, and litter insects.",
            feederTip: "Rarely on feeders themselves — scatter seed near a brushy corner and listen for scratching.",
            song: "A ringing command to \"drink-your-teeeea!\" with a trilled ending.",
            idTips: [
                "Male: jet-black hood and back with warm rufous flanks and white belly.",
                "Female: same pattern in rich chocolate brown.",
                "Striking red eyes."
            ],
            behavior: "Does a two-footed backward hop-scratch that sends leaves flying — you often hear one before you see it.",
            funFact: "The name is its own call — a rising, questioning \"tow-HEE?\" from inside the bushes.",
            similarIds: ["americanRobin", "rosebreastedGrosbeak"]
        ),
    ]

    // MARK: - Woodpeckers

    static let woodpeckers: [BirdSpecies] = [
        BirdSpecies(
            id: "downyWoodpecker",
            name: "Downy Woodpecker",
            latin: "Dryobates pubescens",
            group: .woodpeckers,
            lengthInches: 5.5...6.7,
            sizeClass: .sparrowSized,
            rarity: .veryCommon,
            months: SpeciesData.allMonths,
            colors: [.black, .white, .red],
            habitat: "Nearly any tree — orchards, parks, and even tall weeds and cattails.",
            diet: "Insects and larvae from bark; suet, sunflower, and even hummingbird nectar.",
            feederTip: "The most likely woodpecker at your suet cake; small enough to feed on seed feeders too.",
            song: "A high whinnying rattle that descends at the end, plus a sharp \"pik!\" call.",
            idTips: [
                "Tiny woodpecker: white back, checkered black-and-white wings.",
                "Male has a small red patch on the back of the head.",
                "Stubby bill, much shorter than the head is deep."
            ],
            behavior: "Joins chickadee flocks in winter, using their alarm calls as a neighborhood watch.",
            funFact: "Downies drum on gutters and stovepipes not for food but for volume — it is their version of song.",
            similarIds: ["hairyWoodpecker", "yellowbelliedSapsucker"]
        ),
        BirdSpecies(
            id: "hairyWoodpecker",
            name: "Hairy Woodpecker",
            latin: "Leuconotopicus villosus",
            group: .woodpeckers,
            lengthInches: 7.1...10.2,
            sizeClass: .robinSized,
            rarity: .common,
            months: SpeciesData.allMonths,
            colors: [.black, .white, .red],
            habitat: "Mature forest with big trunks; visits yards with large shade trees.",
            diet: "Wood-boring beetle larvae dug from deep in trunks; suet in winter.",
            feederTip: "A larger, warier suet visitor — often announces itself with a sharp \"peek!\" before landing.",
            song: "A sharp \"peek!\" (stronger than a downy's) and a level, rattling whinny.",
            idTips: [
                "Like a downy scaled up — same pattern, robin-sized body.",
                "Bill nearly as long as the head — the key mark.",
                "Clean white outer tail feathers without spots."
            ],
            behavior: "Follows pileated woodpeckers around, raiding the deep excavations they leave behind.",
            funFact: "Downy and hairy woodpeckers are not close relatives — their matching outfits are a puzzle of evolutionary mimicry.",
            similarIds: ["downyWoodpecker", "redbelliedWoodpecker"]
        ),
        BirdSpecies(
            id: "redbelliedWoodpecker",
            name: "Red-bellied Woodpecker",
            latin: "Melanerpes carolinus",
            group: .woodpeckers,
            lengthInches: 9.4...10.6,
            sizeClass: .jaySized,
            rarity: .common,
            months: SpeciesData.allMonths,
            colors: [.red, .black, .white, .gray],
            habitat: "Deciduous woods and wooded suburbs, spreading steadily northward.",
            diet: "Insects, acorns, fruit — and whole peanuts carried off one at a time.",
            feederTip: "Peanuts and suet bring one swooping in with a rolling \"churr\"; it may stash extras in bark.",
            song: "A rich, rolling \"churr-churr-churr\" and chuckling \"cha-cha-cha.\"",
            idTips: [
                "Zebra-barred black-and-white back.",
                "Red runs over the crown and nape on males, nape only on females.",
                "The namesake red belly is just a faint blush — often invisible."
            ],
            behavior: "Wedges acorns into bark crevices, then hammers them open at leisure.",
            funFact: "Its tongue extends two inches past the bill tip, with a barbed, sticky tip for extracting grubs.",
            similarIds: ["northernFlicker", "hairyWoodpecker"]
        ),
        BirdSpecies(
            id: "northernFlicker",
            name: "Northern Flicker",
            latin: "Colaptes auratus",
            group: .woodpeckers,
            lengthInches: 11.0...12.2,
            sizeClass: .jaySized,
            rarity: .common,
            months: SpeciesData.allMonths,
            colors: [.brown, .black, .red, .yellow],
            habitat: "Open woods and lawns — the woodpecker most often seen on the ground.",
            diet: "Ants above all; a flicker may lap up thousands in one sitting.",
            feederTip: "More likely on your lawn than your feeder; leave an anthill or two and watch.",
            song: "A long \"wick-wick-wick-wick\" rattle and a loud single \"kleer!\"",
            idTips: [
                "Brown, barred back with a black chest crescent and spotted belly.",
                "Flashes golden-yellow under the wings and tail in flight.",
                "Bold white rump patch as it flies away."
            ],
            behavior: "Anting specialist — it crushes ants and preens their formic acid through its feathers as pest control.",
            funFact: "In courtship, rival flickers face off in a bobbing \"fencing duel,\" swinging their bills like sabers.",
            similarIds: ["redbelliedWoodpecker", "mourningDove"]
        ),
        BirdSpecies(
            id: "pileatedWoodpecker",
            name: "Pileated Woodpecker",
            latin: "Dryocopus pileatus",
            group: .woodpeckers,
            lengthInches: 15.8...19.3,
            sizeClass: .crowSized,
            rarity: .uncommon,
            months: SpeciesData.allMonths,
            colors: [.black, .red, .white],
            habitat: "Big woods with dead trees; increasingly ventures into wooded suburbs.",
            diet: "Carpenter ants and beetle larvae chopped from dead wood.",
            feederTip: "A suet feeder near mature trees may one day host this crow-sized giant — an unforgettable visit.",
            song: "A wild, ringing \"kuk-kuk-kuk-kuk\" that rises and falls — pure jungle-movie soundtrack.",
            idTips: [
                "Huge — nearly crow-sized — with a flaming red crest.",
                "Mostly black with bold white neck stripes.",
                "Big white underwing flashes in slow, powerful flight."
            ],
            behavior: "Chisels distinctive rectangular holes so large they can weaken small trees.",
            funFact: "Its abandoned nest holes become homes for owls, ducks, martens, and even bats — a keystone carpenter.",
            similarIds: ["americanCrow", "redbelliedWoodpecker"]
        ),
        BirdSpecies(
            id: "yellowbelliedSapsucker",
            name: "Yellow-bellied Sapsucker",
            latin: "Sphyrapicus varius",
            group: .woodpeckers,
            lengthInches: 7.1...8.7,
            sizeClass: .robinSized,
            rarity: .uncommon,
            months: [4, 9, 10, 11, 12, 1, 2, 3],
            colors: [.black, .white, .red, .yellow],
            habitat: "Young forests in summer; orchards and yard trees during migration and winter.",
            diet: "Tree sap from drilled wells, plus insects that get stuck in it.",
            feederTip: "Look for its calling card instead: neat rows of shallow holes ringing a trunk.",
            song: "A nasal, catlike \"neaah\" and stuttering, irregular drumming — like a drummer losing the beat.",
            idTips: [
                "Rows of sap wells in bark are the giveaway sign.",
                "Red forehead; males add a red throat.",
                "Long white wing stripe on a mostly black-and-white bird."
            ],
            behavior: "Maintains and defends its sap wells all day, licking sap with a brush-tipped tongue.",
            funFact: "Hummingbirds returning in early spring follow sapsuckers and time their arrival to fresh sap wells.",
            similarIds: ["downyWoodpecker", "hairyWoodpecker"]
        ),
    ]

    // MARK: - Jays, Doves & Visitors

    static let jays: [BirdSpecies] = [
        BirdSpecies(
            id: "blueJay",
            name: "Blue Jay",
            latin: "Cyanocitta cristata",
            group: .jays,
            lengthInches: 9.8...11.8,
            sizeClass: .jaySized,
            rarity: .veryCommon,
            months: SpeciesData.allMonths,
            colors: [.blue, .white, .black],
            habitat: "Oak woods, parks, and yards — wherever there are acorns.",
            diet: "Acorns, nuts, seeds, and insects; occasionally eggs.",
            feederTip: "Whole peanuts vanish one after another — a single jay may cache hundreds in a morning.",
            song: "Harsh \"jay! jay!\" alarms, musical \"queedle-queedle\" whistles, and flawless red-tailed hawk impressions.",
            idTips: [
                "Bright blue above with a jaunty crest and black necklace.",
                "White wingbars and white tail corners.",
                "Loud, bold, and usually first to mob a hawk or owl."
            ],
            behavior: "Caches thousands of acorns each fall — forgotten ones become oak trees, replanting forests.",
            funFact: "A jay's blue is structural, not pigment: crush the feather and the color vanishes into brown.",
            similarIds: ["easternBluebird", "indigoBunting"]
        ),
        BirdSpecies(
            id: "americanCrow",
            name: "American Crow",
            latin: "Corvus brachyrhynchos",
            group: .jays,
            lengthInches: 15.8...20.9,
            sizeClass: .crowSized,
            rarity: .veryCommon,
            months: SpeciesData.allMonths,
            colors: [.black],
            habitat: "Everywhere from wilderness to downtown — fields, parks, and parking lots.",
            diet: "Almost anything: grain, insects, carrion, fries.",
            feederTip: "Peanuts in the open may start a lifelong acquaintance — crows remember generous humans.",
            song: "The classic \"caw-caw,\" plus rattles, clicks, and eerily good mimicry.",
            idTips: [
                "All black, right down to the eyes, bill, and legs.",
                "Square-ended tail (a raven's is wedge-shaped).",
                "Struts and hops with swagger; almost always in family groups."
            ],
            behavior: "Lives in extended families — last year's kids help feed this year's chicks.",
            funFact: "Crows recognize individual human faces for years and pass grudges to their offspring.",
            similarIds: ["commonGrackle", "pileatedWoodpecker"]
        ),
        BirdSpecies(
            id: "commonGrackle",
            name: "Common Grackle",
            latin: "Quiscalus quiscula",
            group: .jays,
            lengthInches: 11.0...13.4,
            sizeClass: .jaySized,
            rarity: .veryCommon,
            months: SpeciesData.warmMonths.union([3, 10, 11]),
            colors: [.black, .blue],
            habitat: "Lawns, farm fields, and conifer stands; nests in loose colonies.",
            diet: "Seeds, grain, insects — and nearly anything else it can swallow.",
            feederTip: "Arrives in noisy spring mobs; a weight-sensitive feeder preserves seed for smaller birds.",
            song: "A squeaky, rusty-gate \"readle-eak\" delivered with obvious effort and pride.",
            idTips: [
                "Glossy black with an iridescent bronze body and blue-purple head.",
                "Staring pale-yellow eyes.",
                "Long, keel-shaped tail folded into a V in flight."
            ],
            behavior: "Practices \"anting\" and even dips food in water to soften it before eating.",
            funFact: "Grackles let ants crawl through their feathers to harvest the insects' formic acid as a pesticide.",
            similarIds: ["americanCrow", "redwingedBlackbird"]
        ),
        BirdSpecies(
            id: "redwingedBlackbird",
            name: "Red-winged Blackbird",
            latin: "Agelaius phoeniceus",
            group: .jays,
            lengthInches: 6.7...9.1,
            sizeClass: .robinSized,
            rarity: .common,
            months: SpeciesData.warmMonths.union([3, 10]),
            colors: [.black, .red, .yellow],
            habitat: "Marshes, wet ditches, and pond edges; fans out to feeders in early spring.",
            diet: "Insects in summer, grain and seeds the rest of the year.",
            feederTip: "One of spring's first returning voices — cracked corn draws early males still in winter flocks.",
            song: "A gurgling \"conk-la-reee!\" from every cattail in March.",
            idTips: [
                "Male: glossy black with scarlet-and-yellow shoulder patches.",
                "Female: brown and heavily streaked, like a big fierce sparrow.",
                "Sings from reed tops with epaulets flared wide."
            ],
            behavior: "A male may guard up to 15 nesting females and attacks anything that enters the marsh — herons, hawks, or hikers.",
            funFact: "Winter roosts can mix millions of blackbirds — clouds that show up on weather radar.",
            similarIds: ["commonGrackle", "baltimoreOriole"]
        ),
        BirdSpecies(
            id: "baltimoreOriole",
            name: "Baltimore Oriole",
            latin: "Icterus galbula",
            group: .jays,
            lengthInches: 6.7...7.5,
            sizeClass: .robinSized,
            rarity: .uncommon,
            months: SpeciesData.warmMonths,
            colors: [.orange, .black, .white],
            habitat: "High in open shade trees — elms, maples, and cottonwoods along streets and rivers.",
            diet: "Insects, nectar, and ripe fruit — anything sweet and dark-colored.",
            feederTip: "Halved oranges and a dab of grape jelly, set out by May 1st, can make your yard a regular stop.",
            song: "Rich, flute-like whistled phrases with a distinctive full stop — every male's tune is his own.",
            idTips: [
                "Male: flame-orange body with a solid black hood and back.",
                "Female: saffron-yellow with grayish wings.",
                "Slender, sharp-pointed silver bill."
            ],
            behavior: "Weaves a hanging pouch nest at branch tips — a gray sock swaying in the wind.",
            funFact: "Orioles \"gape\" — stabbing the closed bill into fruit and forcing it open to drink the juice from within.",
            similarIds: ["americanRobin", "eveningGrosbeak"]
        ),
        BirdSpecies(
            id: "mourningDove",
            name: "Mourning Dove",
            latin: "Zenaida macroura",
            group: .jays,
            lengthInches: 9.1...13.4,
            sizeClass: .jaySized,
            rarity: .veryCommon,
            months: SpeciesData.allMonths,
            colors: [.brown, .gray, .black],
            habitat: "Open ground everywhere — wires, rooftops, and bare patches under feeders.",
            diet: "Seeds, seeds, and more seeds — up to 20 percent of body weight daily.",
            feederTip: "Ground-feeding vacuum: fills its crop with millet and cracked corn, then digests on a wire.",
            song: "A soft, mournful \"coo-OO-oo, coo, coo\" often mistaken for an owl.",
            idTips: [
                "Soft gray-tan with black spots on folded wings.",
                "Small round head on a plump body; long pointed tail edged in white.",
                "Wings whistle sharply on takeoff."
            ],
            behavior: "Feeds chicks \"crop milk,\" a nutritious secretion both parents produce.",
            funFact: "That takeoff whistle comes from special wing feathers and doubles as a flock-wide alarm.",
            similarIds: ["northernFlicker", "houseSparrow"]
        ),
        BirdSpecies(
            id: "rubythroatedHummingbird",
            name: "Ruby-throated Hummingbird",
            latin: "Archilochus colubris",
            group: .jays,
            lengthInches: 2.8...3.5,
            sizeClass: .tiny,
            rarity: .common,
            months: SpeciesData.warmMonths,
            colors: [.green, .red, .white],
            habitat: "Gardens and edges with tubular flowers; the East's only regular hummingbird.",
            diet: "Flower nectar and surprising numbers of tiny insects.",
            feederTip: "Mix 1 part white sugar to 4 parts water — no dye — and clean the feeder every few days in heat.",
            song: "No song — squeaky chips, plus the hum of wings beating 50 times a second.",
            idTips: [
                "Tiny, emerald-backed sprite hovering at flowers.",
                "Male's black throat blazes ruby-red when it catches the sun.",
                "Can fly backward and hover motionless."
            ],
            behavior: "Fiercely territorial — one bird may claim a feeder and spend all day chasing off rivals.",
            funFact: "Twice a year it crosses the Gulf of Mexico nonstop — 500 miles on half a gram of fat.",
            similarIds: ["indigoBunting", "americanGoldfinch"]
        ),
    ]

    // MARK: - Birding tips

    static let tips: [BirdingTip] = [
        BirdingTip(
            id: "startWatching",
            title: "How to Start Watching",
            summary: "The whole hobby begins with three habits: look, listen, and hold still.",
            points: [
                "Pick one window with a view of trees or shrubs and make it your watch post.",
                "Spend ten quiet minutes at the same time each day; birds keep schedules too.",
                "Note size, shape, and behavior before color — posture identifies birds at any distance.",
                "Keep this app handy and log every new visitor, even the \"boring\" ones."
            ]
        ),
        BirdingTip(
            id: "feederBasics",
            title: "Feeder Basics",
            summary: "One good feeder, well placed and clean, beats five neglected ones.",
            points: [
                "Black-oil sunflower feeds the widest range of species — start there.",
                "Place feeders either within 3 feet of a window or farther than 10 feet, to prevent window strikes.",
                "Wash feeders with hot soapy water every couple of weeks; sick birds spread disease at dirty ports.",
                "Expect a quiet week after you first hang it — scouts must find it and spread the word."
            ]
        ),
        BirdingTip(
            id: "seedGuide",
            title: "Choosing Seed",
            summary: "Different seeds book different guests.",
            points: [
                "Black-oil sunflower: cardinals, chickadees, finches, nuthatches — the universal ticket.",
                "Nyjer (thistle): goldfinches and siskins on special fine-port feeders.",
                "Peanuts: jays, woodpeckers, titmice; whole ones become jay treasure.",
                "White millet on the ground: sparrows, juncos, doves, buntings.",
                "Skip cheap mixes padded with red milo — most birds just rake it to the ground."
            ]
        ),
        BirdingTip(
            id: "waterWorks",
            title: "Water Works Wonders",
            summary: "A birdbath draws species that never touch seed.",
            points: [
                "Keep water shallow — one to two inches — with a rough surface for grip.",
                "Moving water is irresistible; even a dripping jug multiplies visits.",
                "Refresh every day or two in summer; mosquitoes need only a week.",
                "Robins, waxwings, and warblers may become regulars at water alone."
            ]
        ),
        BirdingTip(
            id: "timing",
            title: "When to Watch",
            summary: "Birds run on sun time — meet them at their rush hours.",
            points: [
                "The first two hours after sunrise are the busiest of the whole day.",
                "A second, smaller rush comes in late afternoon as birds top up before roosting.",
                "The day before a storm front brings frantic feeding — great watching.",
                "May and September migrations can drop surprise guests into any yard overnight."
            ]
        ),
        BirdingTip(
            id: "windowSafety",
            title: "Window Safety",
            summary: "Glass is the yard's biggest hazard — and it is fixable.",
            points: [
                "Birds strike glass that reflects sky and trees; break up the reflection.",
                "Screens, hanging cords, or decals spaced a hand-width apart all work.",
                "Feeders within 3 feet of glass prevent fatal momentum.",
                "If a bird strikes and sits stunned, place it in a ventilated box in the shade and release when alert."
            ]
        ),
        BirdingTip(
            id: "plantsForBirds",
            title: "Plant a Bird Garden",
            summary: "Native plants are a feeder that refills itself.",
            points: [
                "Coneflowers and sunflowers left standing feed finches all winter.",
                "Berry shrubs — serviceberry, dogwood, elderberry — bring waxwings and thrushes.",
                "Oaks host hundreds of caterpillar species: baby-bird food no feeder can match.",
                "Skip fall cleanup where you can; seed heads and leaf litter are winter pantry."
            ]
        ),
        BirdingTip(
            id: "fieldMarks",
            title: "Reading Field Marks",
            summary: "Birders identify birds by a checklist of visual landmarks.",
            points: [
                "Start with size: smaller or bigger than a sparrow, robin, or crow?",
                "Check the bill: thick cone (seed-cracker), thin tweezer (bug-eater), or chisel (woodpecker)?",
                "Scan for wingbars, eye stripes, eye rings, and breast streaks.",
                "Watch behavior: tail pumping, trunk climbing, ground scratching — moves are marks too."
            ]
        ),
    ]

    // MARK: - Glossary

    static let glossary: [GlossaryTerm] = [
        GlossaryTerm(id: "lifeList", term: "Life list", definition: "A birder's running list of every species they have ever identified — the heart of this app's Life List tab."),
        GlossaryTerm(id: "lifer", term: "Lifer", definition: "A species seen and identified for the very first time in your life. Worthy of celebration."),
        GlossaryTerm(id: "fieldMark", term: "Field mark", definition: "A visible feature — wingbar, eye ring, breast spot — used to tell one species from another."),
        GlossaryTerm(id: "crest", term: "Crest", definition: "A tuft of feathers on top of the head that can be raised or flattened, as on cardinals and jays."),
        GlossaryTerm(id: "wingbar", term: "Wingbar", definition: "A contrasting pale stripe across the folded wing, formed by feather tips."),
        GlossaryTerm(id: "eyeRing", term: "Eye ring", definition: "A ring of contrasting feathers around the eye, like a robin's white spectacles."),
        GlossaryTerm(id: "supercilium", term: "Supercilium", definition: "The eyebrow stripe above a bird's eye — bold on Carolina wrens and purple finch females."),
        GlossaryTerm(id: "irruption", term: "Irruption", definition: "A sudden mass movement of northern birds south in winters when food crops fail — siskin and nuthatch invasions."),
        GlossaryTerm(id: "migration", term: "Migration", definition: "Regular seasonal travel between breeding and wintering grounds, often at night."),
        GlossaryTerm(id: "molt", term: "Molt", definition: "The scheduled replacement of feathers. Goldfinches molt from winter olive to summer gold."),
        GlossaryTerm(id: "plumage", term: "Plumage", definition: "A bird's full coat of feathers; many species wear different breeding and winter plumages."),
        GlossaryTerm(id: "juvenile", term: "Juvenile", definition: "A young bird in its first set of true feathers, often streakier and duller than adults."),
        GlossaryTerm(id: "fledgling", term: "Fledgling", definition: "A chick that has just left the nest. Parents are usually nearby — leave it be."),
        GlossaryTerm(id: "brood", term: "Brood", definition: "One family of chicks raised together. Robins may raise three broods a summer."),
        GlossaryTerm(id: "cavityNester", term: "Cavity nester", definition: "A species that nests inside holes — chickadees, bluebirds, wrens, and woodpeckers."),
        GlossaryTerm(id: "cache", term: "Cache", definition: "Hidden food storage. Chickadees, jays, and nuthatches stash thousands of seeds each fall."),
        GlossaryTerm(id: "suet", term: "Suet", definition: "Rendered fat served in cakes — high-energy fuel that woodpeckers and wrens love in winter."),
        GlossaryTerm(id: "nyjer", term: "Nyjer", definition: "Tiny black \"thistle\" seed served in fine-port feeders for goldfinches and siskins."),
        GlossaryTerm(id: "gorget", term: "Gorget", definition: "The iridescent throat patch of a hummingbird, flashing ruby only at the right angle."),
        GlossaryTerm(id: "drumming", term: "Drumming", definition: "A woodpecker's rapid hammering on resonant wood — territorial song, not feeding."),
        GlossaryTerm(id: "anting", term: "Anting", definition: "Rubbing crushed ants through feathers to apply their formic acid as pest control."),
        GlossaryTerm(id: "pishing", term: "Pishing", definition: "A soft \"pish-pish-pish\" sound birders make to lure curious birds into view."),
        GlossaryTerm(id: "roost", term: "Roost", definition: "Where birds sleep — a sheltered branch, dense conifer, or communal winter gathering."),
        GlossaryTerm(id: "territory", term: "Territory", definition: "The area a bird defends for nesting and feeding, proclaimed and patrolled with song."),
    ]
}

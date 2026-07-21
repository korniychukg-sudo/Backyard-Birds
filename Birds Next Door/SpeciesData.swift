import Foundation

// Field guide content, part 1 of 2 — Songbirds, Little Acrobats, Finches.
enum SpeciesData {

    static let all: [BirdSpecies] = songbirds + littleBirds + finches + SpeciesDataB.sparrows + SpeciesDataB.woodpeckers + SpeciesDataB.jays

    static func species(_ id: String) -> BirdSpecies? {
        all.first { $0.id == id }
    }
    static func inGroup(_ group: BirdGroupKind) -> [BirdSpecies] {
        all.filter { $0.group == group }
    }
    static func activeIn(month: Int) -> [BirdSpecies] {
        all.filter { $0.months.contains(month) }
    }

    static let allMonths: Set<Int> = Set(1...12)
    static let warmMonths: Set<Int> = [4, 5, 6, 7, 8, 9]
    static let coldMonths: Set<Int> = [10, 11, 12, 1, 2, 3]

    // MARK: - Songbirds & Thrushes

    static let songbirds: [BirdSpecies] = [
        BirdSpecies(
            id: "northernCardinal",
            name: "Northern Cardinal",
            latin: "Cardinalis cardinalis",
            group: .songbirds,
            lengthInches: 8.3...9.1,
            sizeClass: .robinSized,
            rarity: .veryCommon,
            months: allMonths,
            colors: [.red, .black],
            habitat: "Shrubby yards, hedges, and woodland edges. Rarely far from thick cover.",
            diet: "Seeds, berries, and insects; a champion of sunflower seeds.",
            feederTip: "First at the feeder at dawn and last at dusk. Offer black-oil sunflower on a sturdy tray.",
            song: "A loud, liquid whistle — \"cheer, cheer, cheer\" and \"birdie, birdie, birdie.\" Both sexes sing.",
            idTips: [
                "Male is brilliant red with a black face mask; female is warm buff with red accents.",
                "Tall pointed crest that raises and lowers with mood.",
                "Thick orange-red conical bill built for cracking seeds."
            ],
            behavior: "Pairs stay together all year, and the male often feeds the female seed-to-beak during courtship.",
            funFact: "A cardinal may attack its own reflection in windows and car mirrors for hours, defending territory from an imaginary rival.",
            similarIds: ["houseFinch", "purpleFinch"]
        ),
        BirdSpecies(
            id: "americanRobin",
            name: "American Robin",
            latin: "Turdus migratorius",
            group: .songbirds,
            lengthInches: 9.0...11.0,
            sizeClass: .robinSized,
            rarity: .veryCommon,
            months: allMonths,
            colors: [.orange, .gray, .brown],
            habitat: "Lawns, parks, and open woods; nests on ledges and in shade trees.",
            diet: "Earthworms and insects in summer, fruit and berries in winter.",
            feederTip: "Rarely eats seed. Tempt one with mealworms, chopped fruit, or a shallow birdbath.",
            song: "A cheerful caroling of rising and falling phrases — \"cheerily, cheer-up, cheerio\" — often the first song before sunrise.",
            idTips: [
                "Brick-orange breast with a dark gray back and darker head.",
                "White crescents around the eye and a yellow bill.",
                "Runs a few steps, stops upright, then tilts its head as if listening."
            ],
            behavior: "Hunts worms by sight, cocking its head to spot movement in the grass.",
            funFact: "Robins can produce three successful broods in one summer, and huge flocks gather in winter roosts of up to a quarter-million birds.",
            similarIds: ["easternTowhee", "baltimoreOriole"]
        ),
        BirdSpecies(
            id: "easternBluebird",
            name: "Eastern Bluebird",
            latin: "Sialia sialis",
            group: .songbirds,
            lengthInches: 6.3...8.3,
            sizeClass: .sparrowSized,
            rarity: .common,
            months: allMonths,
            colors: [.blue, .orange, .white],
            habitat: "Open country with scattered perches — meadows, orchards, and big lawns with nest boxes.",
            diet: "Insects caught from a low perch; switches to berries in cold months.",
            feederTip: "Loves live or dried mealworms in a shallow dish. A nest box facing open ground may win a resident pair.",
            song: "A soft, low-pitched warble — \"chur-lee, chur-lee\" — gentle and easy to miss.",
            idTips: [
                "Male is vivid royal blue above with a rusty throat and chest.",
                "Female is gray-buff with subtle blue tinges in wings and tail.",
                "Perches hunched on wires and fence posts, dropping to the grass for insects."
            ],
            behavior: "Hunts by dropping from a perch onto insects, often hovering briefly before the pounce.",
            funFact: "Bluebird numbers rebounded dramatically after volunteers built thousands of nest-box trails across the country.",
            similarIds: ["indigoBunting", "blueJay"]
        ),
        BirdSpecies(
            id: "northernMockingbird",
            name: "Northern Mockingbird",
            latin: "Mimus polyglottos",
            group: .songbirds,
            lengthInches: 8.3...10.2,
            sizeClass: .robinSized,
            rarity: .common,
            months: allMonths,
            colors: [.gray, .white],
            habitat: "Hedges, thickets, and suburban yards with open lawn and high song perches.",
            diet: "Insects in summer, berries in winter; fiercely guards fruiting shrubs.",
            feederTip: "Seldom takes seed but may visit for suet, raisins, or sliced fruit.",
            song: "Endless phrases, each repeated two to six times, borrowed from other birds, car alarms, and squeaky gates. May sing all night.",
            idTips: [
                "Slim gray bird with two white wingbars and flashing white wing patches in flight.",
                "Long tail, often cocked and swung about expressively.",
                "Runs and stops on the lawn, flashing its wings open to startle insects."
            ],
            behavior: "Defends berry bushes and nest sites boldly, diving at cats, dogs, hawks, and people alike.",
            funFact: "A mockingbird keeps learning its whole life and may master over 200 distinct songs.",
            similarIds: ["grayCatbird", "darkeyedJunco"]
        ),
        BirdSpecies(
            id: "cedarWaxwing",
            name: "Cedar Waxwing",
            latin: "Bombycilla cedrorum",
            group: .songbirds,
            lengthInches: 5.5...6.7,
            sizeClass: .sparrowSized,
            rarity: .common,
            months: allMonths,
            colors: [.brown, .yellow, .black],
            habitat: "Anywhere with fruiting trees — junipers, crabapples, serviceberry, and mountain ash.",
            diet: "Berries above all; also catches insects over water in summer.",
            feederTip: "Skips feeders, but a berry tree or a birdbath can bring a whole flock at once.",
            song: "No true song — thin, high \"sreee\" whistles, often given by the whole flock in flight.",
            idTips: [
                "Sleek fawn-brown crest and a neat black bandit mask.",
                "Waxy red tips on the wing feathers and a bright yellow tail band.",
                "Almost always in flocks that strip a berry tree, then vanish."
            ],
            behavior: "Famously polite — flock members pass berries down a row from beak to beak until one bird swallows.",
            funFact: "Waxwings can get tipsy on overwintered fermented berries — occasionally too tipsy to fly straight.",
            similarIds: ["tuftedTitmouse", "northernCardinal"]
        ),
        BirdSpecies(
            id: "grayCatbird",
            name: "Gray Catbird",
            latin: "Dumetella carolinensis",
            group: .songbirds,
            lengthInches: 8.1...9.4,
            sizeClass: .robinSized,
            rarity: .common,
            months: warmMonths,
            colors: [.gray, .black],
            habitat: "Dense tangles, hedgerows, and forest edges; sings from deep inside the thicket.",
            diet: "Insects and berries in about equal measure.",
            feederTip: "May sneak out for grape jelly, raisins, or suet placed near cover.",
            song: "A rambling jumble of squeaks, whistles, and copied phrases — plus an unmistakable cat-like \"mew.\"",
            idTips: [
                "Slate gray all over with a neat black cap.",
                "A hidden patch of rusty red under the tail.",
                "Long tail, often flipped and cocked as it skulks through brush."
            ],
            behavior: "Curious but cautious — often answers a soft \"pish\" sound by popping out of the bushes to investigate.",
            funFact: "Unlike a mockingbird, a catbird rarely repeats itself — its song can run ten minutes without an exact repeat.",
            similarIds: ["northernMockingbird", "darkeyedJunco"]
        ),
        BirdSpecies(
            id: "brownThrasher",
            name: "Brown Thrasher",
            latin: "Toxostoma rufum",
            group: .songbirds,
            lengthInches: 9.1...11.8,
            sizeClass: .jaySized,
            rarity: .uncommon,
            months: warmMonths,
            colors: [.brown, .white],
            habitat: "Thickets, brushy field edges, and shrubby corners of large yards.",
            diet: "Insects flicked from leaf litter; acorns and berries in fall.",
            feederTip: "A ground-level scatter of seed near dense shrubs is the best invitation.",
            song: "Rich musical phrases sung in pairs — \"plant-a-seed, plant-a-seed, bury-it, bury-it\" — from a high, exposed perch.",
            idTips: [
                "Bright rufous above with bold dark streaks on a cream breast.",
                "Long rufous tail and a long, slightly curved bill.",
                "Staring yellow eye gives it a fierce expression."
            ],
            behavior: "Sweeps its bill side to side through leaf litter like a broom, flinging leaves to uncover insects.",
            funFact: "The brown thrasher may have the largest song repertoire of any North American bird — over 1,000 song types.",
            similarIds: ["songSparrow", "carolinaWren"]
        ),
    ]

    // MARK: - Chickadees, Wrens & Nuthatches

    static let littleBirds: [BirdSpecies] = [
        BirdSpecies(
            id: "blackcappedChickadee",
            name: "Black-capped Chickadee",
            latin: "Poecile atricapillus",
            group: .littleBirds,
            lengthInches: 4.7...5.9,
            sizeClass: .tiny,
            rarity: .veryCommon,
            months: allMonths,
            colors: [.black, .white, .gray],
            habitat: "Woods, thickets, and any yard with trees; roosts in tiny cavities.",
            diet: "Insects, spiders, seeds, and berries — half animal, half plant in winter.",
            feederTip: "Takes one sunflower seed at a time, flies off to hammer it open, and comes right back.",
            song: "A clear, whistled \"fee-bee\" song and the famous \"chick-a-dee-dee-dee\" call.",
            idTips: [
                "Black cap and bib with bright white cheeks.",
                "Soft gray back and buffy flanks.",
                "Acrobatic — hangs upside down from twig tips while feeding."
            ],
            behavior: "Caches thousands of seeds each fall and remembers where it hid them for weeks.",
            funFact: "More \"dee\" notes in the alarm call mean a more dangerous predator — it is a graded warning system other species eavesdrop on.",
            similarIds: ["whitebreastedNuthatch", "tuftedTitmouse"]
        ),
        BirdSpecies(
            id: "tuftedTitmouse",
            name: "Tufted Titmouse",
            latin: "Baeolophus bicolor",
            group: .littleBirds,
            lengthInches: 5.5...6.3,
            sizeClass: .tiny,
            rarity: .common,
            months: allMonths,
            colors: [.gray, .white, .orange],
            habitat: "Deciduous woods and leafy neighborhoods; often travels with chickadee flocks.",
            diet: "Insects and seeds; hoards shelled seeds in bark crevices.",
            feederTip: "Bold at feeders — picks the single largest sunflower seed it can find and carries it off.",
            song: "A loud, whistled \"peter-peter-peter,\" repeated up to a dozen times.",
            idTips: [
                "Silver-gray above and white below, with peachy flanks.",
                "Perky gray crest and big black eyes on a plain face.",
                "Small black patch just above the bill."
            ],
            behavior: "Curious and scolding; will hover in front of a window to inspect its own reflection.",
            funFact: "Titmice line their nests with hair plucked boldly from living raccoons, squirrels, dogs — and occasionally people.",
            similarIds: ["blackcappedChickadee", "cedarWaxwing"]
        ),
        BirdSpecies(
            id: "carolinaWren",
            name: "Carolina Wren",
            latin: "Thryothorus ludovicianus",
            group: .littleBirds,
            lengthInches: 4.7...5.5,
            sizeClass: .tiny,
            rarity: .common,
            months: allMonths,
            colors: [.brown, .orange, .white],
            habitat: "Brush piles, ivy, garages, and cluttered porches — anywhere with nooks to explore.",
            diet: "Insects and spiders gleaned from crevices; some suet and peanuts in winter.",
            feederTip: "A suet cake near cover is the surest draw; may also nest in a hanging flower pot or old boot.",
            song: "A ringing, rollicking \"tea-kettle, tea-kettle, tea-kettle\" — astonishingly loud for the bird's size.",
            idTips: [
                "Warm rusty brown above with a buffy-orange breast.",
                "A bold white eyebrow stripe.",
                "Tail often cocked straight up while hopping and poking about."
            ],
            behavior: "Pairs duet and stay bonded year-round, patrolling the same yard together for years.",
            funFact: "Carolina wrens have nested in mailboxes, coat pockets, wreaths, and the pockets of hanging laundry.",
            similarIds: ["houseWren", "songSparrow"]
        ),
        BirdSpecies(
            id: "houseWren",
            name: "House Wren",
            latin: "Troglodytes aedon",
            group: .littleBirds,
            lengthInches: 4.3...5.1,
            sizeClass: .tiny,
            rarity: .common,
            months: warmMonths,
            colors: [.brown],
            habitat: "Yards and gardens with shrubs and cavities; a classic nest-box tenant.",
            diet: "Almost entirely insects and spiders.",
            feederTip: "Ignores food feeders — offer a small nest box with a 1-inch hole instead.",
            song: "An exuberant, bubbling cascade of trills, delivered nonstop through spring mornings.",
            idTips: [
                "Small, plain warm brown bird with a faintly barred wings and tail.",
                "Thin, slightly curved bill.",
                "Almost always moving — tail flicked up, scolding with dry chatter."
            ],
            behavior: "Males build several \"dummy\" stick nests and let the female choose which one to finish.",
            funFact: "House wrens sometimes add spider egg sacs to the nest — the hatching spiders eat the mites that trouble the chicks.",
            similarIds: ["carolinaWren", "pineSiskin"]
        ),
        BirdSpecies(
            id: "whitebreastedNuthatch",
            name: "White-breasted Nuthatch",
            latin: "Sitta carolinensis",
            group: .littleBirds,
            lengthInches: 5.1...5.5,
            sizeClass: .tiny,
            rarity: .common,
            months: allMonths,
            colors: [.gray, .white, .black],
            habitat: "Mature deciduous trees — oaks and maples with rough, furrowed bark.",
            diet: "Insects from bark, plus acorns and seeds wedged into crevices and hammered open.",
            feederTip: "Grabs sunflower seeds and peanuts, then wedges them into bark to \"hatch\" them open with the bill.",
            song: "A nasal, tin-horn \"yank-yank-yank,\" all on one pitch.",
            idTips: [
                "Blue-gray back, clean white face and breast, black cap stripe.",
                "Walks head-first DOWN tree trunks — its signature move.",
                "Short tail and long, slightly upturned bill."
            ],
            behavior: "Descends trunks upside down, spotting food in crevices that up-walking birds miss.",
            funFact: "In winter it sweeps crushed beetles around its nest hole — the chemical smear may mask its scent from squirrels.",
            similarIds: ["redbreastedNuthatch", "blackcappedChickadee"]
        ),
        BirdSpecies(
            id: "redbreastedNuthatch",
            name: "Red-breasted Nuthatch",
            latin: "Sitta canadensis",
            group: .littleBirds,
            lengthInches: 4.3...4.7,
            sizeClass: .tiny,
            rarity: .uncommon,
            months: coldMonths,
            colors: [.gray, .orange, .black, .white],
            habitat: "Conifers first and foremost; visits mixed yards in irruption winters.",
            diet: "Conifer seeds and bark insects; sunflower and suet in winter.",
            feederTip: "In a \"finch winter\" it may become a daily suet and sunflower regular — quick, fearless visits.",
            song: "A high, nasal \"yank-yank,\" faster and tinnier than its larger cousin — like a tiny toy trumpet.",
            idTips: [
                "Rusty-cinnamon underparts and blue-gray back.",
                "Bold black cap plus a black stripe through the eye and white eyebrow.",
                "Smaller and busier than the white-breasted nuthatch."
            ],
            behavior: "Smears sticky conifer resin around its nest entrance and dives through the hole without touching the edges.",
            funFact: "Some autumns bring huge southward \"irruptions\" when the northern cone crop fails — suddenly they are everywhere.",
            similarIds: ["whitebreastedNuthatch", "blackcappedChickadee"]
        ),
    ]

    // MARK: - Finches & Buntings

    static let finches: [BirdSpecies] = [
        BirdSpecies(
            id: "americanGoldfinch",
            name: "American Goldfinch",
            latin: "Spinus tristis",
            group: .finches,
            lengthInches: 4.3...5.1,
            sizeClass: .tiny,
            rarity: .veryCommon,
            months: allMonths,
            colors: [.yellow, .black, .white],
            habitat: "Weedy fields, gardens, and yards with thistle and coneflowers.",
            diet: "Seeds almost exclusively — thistle, sunflower, and garden flower heads.",
            feederTip: "A nyjer (thistle) sock or fine-port tube feeder is goldfinch magic; keep the seed fresh and dry.",
            song: "A long, jumbled series of twitters; in bouncing flight it calls \"po-ta-to-chip!\"",
            idTips: [
                "Summer male is brilliant lemon yellow with a black cap and black wings.",
                "Winter birds turn soft olive-buff — same white wingbars, same small size.",
                "Deeply bouncing, roller-coaster flight."
            ],
            behavior: "One of the latest nesters of all — waits until midsummer thistledown is available for nest lining.",
            funFact: "Goldfinches are strict vegetarians, so cowbird chicks left in their nests fail on the all-seed diet.",
            similarIds: ["eveningGrosbeak", "pineSiskin"]
        ),
        BirdSpecies(
            id: "houseFinch",
            name: "House Finch",
            latin: "Haemorhous mexicanus",
            group: .finches,
            lengthInches: 5.1...5.5,
            sizeClass: .sparrowSized,
            rarity: .veryCommon,
            months: allMonths,
            colors: [.red, .brown],
            habitat: "Buildings, porch lights, hanging baskets, and street trees — a true city finch.",
            diet: "Seeds, buds, and fruit; flocks camp at seed feeders.",
            feederTip: "Arrives in chattering groups and settles in for long feeder sessions, unlike grab-and-go chickadees.",
            song: "A long, cheery warble ending in a slurred, buzzy \"zreee.\"",
            idTips: [
                "Male has a rosy-red head and chest with brown streaky belly and back.",
                "Female is plain gray-brown with blurry streaks and a plain face.",
                "Slightly notched tail and a curved upper edge to the bill."
            ],
            behavior: "Originally a Southwest desert bird — pet-store escapees released in New York in 1940 conquered the East.",
            funFact: "Male redness comes from pigments in food — a poorly fed male molts in orange or even yellow instead.",
            similarIds: ["purpleFinch", "songSparrow"]
        ),
        BirdSpecies(
            id: "purpleFinch",
            name: "Purple Finch",
            latin: "Haemorhous purpureus",
            group: .finches,
            lengthInches: 4.7...6.3,
            sizeClass: .sparrowSized,
            rarity: .uncommon,
            months: coldMonths,
            colors: [.red, .brown, .white],
            habitat: "Coniferous and mixed woods; visits feeders mostly in winter.",
            diet: "Seeds, buds, and berries; loves sunflower at winter feeders.",
            feederTip: "Check every \"house finch\" in winter — a raspberry-soaked one with a clean belly may be a purple finch.",
            song: "A rich, rolling warble, faster and sweeter than a house finch's, without the buzzy ending.",
            idTips: [
                "Male looks dipped in raspberry juice — color washes over head, back, and flanks.",
                "Female shows a bold white eyebrow and crisp dark cheek patch.",
                "Unstreaked white belly separates it from the house finch."
            ],
            behavior: "A shyer, more northern finch that surges south in irregular winter flights.",
            funFact: "Despite the name, there is nothing purple about it — early naturalists used \"purple\" for crimson.",
            similarIds: ["houseFinch", "northernCardinal"]
        ),
        BirdSpecies(
            id: "pineSiskin",
            name: "Pine Siskin",
            latin: "Spinus pinus",
            group: .finches,
            lengthInches: 4.3...5.5,
            sizeClass: .tiny,
            rarity: .uncommon,
            months: coldMonths,
            colors: [.brown, .yellow],
            habitat: "Conifer country; erupts south some winters to swarm thistle feeders.",
            diet: "Small seeds — thistle, birch, alder, and spruce.",
            feederTip: "A nyjer feeder in an irruption winter can host dozens of these streaky gluttons at once.",
            song: "Wheezy twitters with a rising \"zreeeeet\" like a zipper being pulled.",
            idTips: [
                "Heavily streaked brown finch with a sharply pointed bill.",
                "Flashes of yellow in the wing and tail edges.",
                "Travels in tight, chattering flocks with goldfinches."
            ],
            behavior: "Can store seeds in a crop pouch to burn overnight, surviving cold snaps that fell other small birds.",
            funFact: "Siskin winters are boom-or-bust: absent for years, then suddenly hundreds arrive from the boreal forest.",
            similarIds: ["americanGoldfinch", "houseWren"]
        ),
        BirdSpecies(
            id: "indigoBunting",
            name: "Indigo Bunting",
            latin: "Passerina cyanea",
            group: .finches,
            lengthInches: 4.7...5.1,
            sizeClass: .tiny,
            rarity: .uncommon,
            months: warmMonths,
            colors: [.blue],
            habitat: "Brushy field edges, power-line cuts, and roadsides with song perches.",
            diet: "Seeds and insects; white millet at ground feeders during migration.",
            feederTip: "During May migration, scatter white proso millet — a passing male in full indigo is unforgettable.",
            song: "Paired, bouncy phrases — \"sweet-sweet, chew-chew, sweet-sweet\" — sung tirelessly through summer heat.",
            idTips: [
                "Breeding male is deep electric blue all over, darkest on the head.",
                "Female is plain warm brown with the faintest breast streaks.",
                "Small finch shape with a silvery conical bill."
            ],
            behavior: "Sings from the tallest available perch through the hottest hours when other birds have gone quiet.",
            funFact: "Indigo buntings migrate at night, steering by the stars — they learn the sky's rotation as youngsters.",
            similarIds: ["easternBluebird", "blueJay"]
        ),
        BirdSpecies(
            id: "rosebreastedGrosbeak",
            name: "Rose-breasted Grosbeak",
            latin: "Pheucticus ludovicianus",
            group: .finches,
            lengthInches: 7.1...8.3,
            sizeClass: .robinSized,
            rarity: .uncommon,
            months: warmMonths,
            colors: [.black, .white, .red],
            habitat: "Open deciduous woods and big shade trees; feeders during migration.",
            diet: "Insects, seeds, and berries, cracked with that enormous bill.",
            feederTip: "For a week or two each May, sunflower feeders may host these stunners passing through.",
            song: "Like a robin that took voice lessons — richer, sweeter, and faster caroling.",
            idTips: [
                "Male: black head and back, snow-white belly, and a rose-red triangle on the chest.",
                "Female looks like a giant sparrow with a bold white eyebrow.",
                "Huge pale conical bill on both sexes."
            ],
            behavior: "Males share incubation duty — and sometimes sing quietly while sitting on the eggs.",
            funFact: "Museum collectors nicknamed it \"cut-throat\" for the male's red chest patch.",
            similarIds: ["easternTowhee", "downyWoodpecker"]
        ),
        BirdSpecies(
            id: "eveningGrosbeak",
            name: "Evening Grosbeak",
            latin: "Coccothraustes vespertinus",
            group: .finches,
            lengthInches: 6.3...7.1,
            sizeClass: .robinSized,
            rarity: .uncommon,
            months: [11, 12, 1, 2, 3],
            colors: [.yellow, .black, .white, .brown],
            habitat: "Northern conifer forests; sweeps south to feeders in flight years.",
            diet: "Large seeds, buds, and berry pits crushed with massive force.",
            feederTip: "A visiting flock can empty a platform of sunflower seed in an afternoon — a spectacular problem to have.",
            song: "No real song — loud, ringing \"cleer\" calls, like a house sparrow with a megaphone.",
            idTips: [
                "Stocky, big-headed finch with an enormous pale greenish bill.",
                "Male is dusky gold with a bold yellow eyebrow and white wing patches.",
                "Female is soft gray with black-and-white wings."
            ],
            behavior: "Winter flocks roam hundreds of miles in search of seed crops, appearing and vanishing without warning.",
            funFact: "An evening grosbeak can crack a wild cherry pit that would take you a hammer to open.",
            similarIds: ["americanGoldfinch", "baltimoreOriole"]
        ),
    ]
}

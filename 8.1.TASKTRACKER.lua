local switchTaskT = "taskButton"

storage = storage or {}
local STKEY = "lnsTaskTracker"
storage[STKEY] = storage[STKEY] or {
  enabled = true,
  current = nil,
  kills = 0,
  required = 0,
  progress = {} -- salva por task
}
local st = storage[STKEY]
st.progress = st.progress or {}

-- =========================
-- TASKS
-- =========================
local TASKS = {
  goblins = { label="GOBLINS", required=100, iconId=61, creatures={ "Goblin", "Goblin Assassin", "Goblin Leader", "Goblin Scavenger" } },
  trolls = { label="TROLLS", required=100, iconId=15, creatures={ "Troll", "Swamp Troll", "Frost Troll", "Island Troll" } },
  orcs = { label="ORCS", required=250, iconId=5, creatures={ "Orc", "Orc Spearman", "Orc Warrior", "Orc Shaman", "Orc Rider", "Orc Berserker", "Orc Leader", "Orc Warlord" } },
  rotworms = { label="ROT WORMS", required=200, iconId=26, creatures={ "Rotworm", "Carrion Worm" } },
  minotaurs = { label="MINOTAURS", required=300, iconId=25, creatures={ "Minotaur", "Minotaur Archer", "Minotaur Guard", "Minotaur Mage" } },
  dwarfs = { label="DWARFS", required=300, iconId=69, creatures={ "Dwarf", "Dwarf Soldier", "Dwarf Guard", "Dwarf Geomancer" } },
  dworcs = { label="DWORCS", required=300, iconId=216, creatures={ "Dworc Venomsniper", "Dworc Voodoomaster", "Dworc Fleshhunter" } },
  elves = { label="ELVES", required=400, iconId=62, creatures={ "Elf", "Elf Scout", "Elf Arcanist", "Firestarter" } }, -- Elf=62 :contentReference[oaicite:1]{index=1}
  dark_cathedral = { label="DARK CATHEDRAL", required=500, iconId=372, creatures={ "Dark Apprentice", "Dark Magician", "Dark Monk", "Assassin", "Smuggler", "Bandit", "Wild Warrior", "Witch", "Ghost", "Hunter", "Stone Golem", "Demon Skeleton" } }, -- Dark Apprentice=372 :contentReference[oaicite:2]{index=2}
  tombs = { label="TOMBS", required=800, iconId=85, creatures={ "Ghost", "Mummy", "Ghoul", "Demon Skeleton", "Skeleton", "Crypt Shambler" } },
  scarabs = { label="SCARABS", required=600, iconId=83, creatures={ "Scarab" } }, -- Scarab=83 :contentReference[oaicite:3]{index=3}
  cyclops = { label="CYCLOPS", required=500, iconId=22, creatures={ "Cyclops", "Cyclops Smith", "Cyclops Drone" } }, -- Cyclops=22 :contentReference[oaicite:4]{index=4}
  mutateds = { label="MUTATEDS", required=600, iconId=521, creatures={ "Mutated Human", "Mutated Bat", "Mutated Rat", "Mutated Tiger" } }, -- Mutated Human=521 :contentReference[oaicite:5]{index=5}
  coryms = { label="CORYMS", required=400, iconId=916, creatures={ "Corym Charlatan", "Corym Skirmisher", "Corym Vanguard" } }, -- Corym Charlatan=916 :contentReference[oaicite:6]{index=6}
  banuta_surface = { label="BANUTA SURFACE", required=600, iconId=116, creatures={ "Kongra", "Sibang", "Merlkin" } }, -- Kongra=116 :contentReference[oaicite:7]{index=7}
  pirates = { label="PIRATES", required=600, iconId=247, creatures={ "Pirate Marauder", "Pirate Cutthroat", "Pirate Corsair", "Pirate Buccaneer" } }, -- Pirate Marauder=247 :contentReference[oaicite:8]{index=8}
  barbarians = { label="BARBARIANS", required=600, iconId=323, creatures={ "Barbarian Bloodwalker", "Barbarian Brutetamer", "Barbarian Headsplitter", "Barbarian Skullhunter" } }, -- Bloodwalker=323 :contentReference[oaicite:9]{index=9}
  djinns = { label="DJINNS", required=600, iconId=104, creatures={ "Marid", "Efreet", "Green Djinn", "Blue Djinn" } }, -- Marid=104 :contentReference[oaicite:10]{index=10}
  stonerefiners = { label="STONEREFINERS", required=500, iconId=1525, creatures={ "Stonerefiner" } }, -- 1525 :contentReference[oaicite:11]{index=11}
  dragons = { label="DRAGONS", required=500, iconId=34, creatures={ "Dragon", "Dragon Hatchling" } }, -- Dragon=34 :contentReference[oaicite:12]{index=12}
  quaras = { label="QUARAS", required=500, iconId=241, creatures={ "Quara Mantassin", "Quara Mantassin Scout", "Quara Constrictor", "Quara Constrictor Scout", "Quara Pincher", "Quara Pincher Scout", "Quara Predator", "Quara Predator Scout", "Quara Hydromancer", "Quara Hydromancer Scout" } }, -- Mantassin=241 :contentReference[oaicite:13]{index=13}
  drefia_crypts = { label="DREFIA CRYPTS", required=600, iconId=975, creatures={ "Gravedigger", "Zombie", "Blood Hand", "Necromancer" } }, -- Gravedigger=975 :contentReference[oaicite:14]{index=14}
  ancient_scarabs = { label="ANCIENT SCARABS", required=500, iconId=79, creatures={ "Ancient Scarab" } }, -- 79 :contentReference[oaicite:15]{index=15}
  giant_spiders = { label="GIANT SPIDERS", required=500, iconId=38, creatures={ "Giant Spider" } }, -- 38 :contentReference[oaicite:16]{index=16}
  laguna_islands = { label="LAGUNA ISLANDS", required=500, iconId=259, creatures={ "Thornback Tortoise", "Tortoise", "Toad", "Blood Crab" } }, -- Thornback Tortoise=259 :contentReference[oaicite:17]{index=17}
  oramond = { label="ORAMOND", required=1000, iconId=1052, creatures={ "Minotaur Hunter", "Mooh'Tah Warrior", "Minotaur Amazon", "Worm Priestess", "Execowtioner", "Moohtant" } }, -- Minotaur Hunter=1052 :contentReference[oaicite:18]{index=18}
  wyrms = { label="WYRMS", required=1000, iconId=461, creatures={ "Wyrm", "Elder Wyrm" } }, -- Wyrm=461 :contentReference[oaicite:19]{index=19}
  book_world = { label="BOOK WORLD", required=2000, iconId=2673, creatures={ "Bluebeak", "Bramble Wyrmling", "Crusader", "Hawk Hopper", "Headwalker", "Lion Hydra" } }, -- Bluebeak=2673 :contentReference[oaicite:20]{index=20}
  cults = { label="CULTS", required=1500, iconId=1512, creatures={ "Cult Believer", "Vicious Squire", "Cult Enforcer", "Renegade Knight", "Vile Grandmaster", "Cult Scholar", "Hero" } }, -- Cult Believer=1512 :contentReference[oaicite:21]{index=21}
  barkless = { label="BARKLESS", required=1000, iconId=1486, creatures={ "Barkless Devotee", "Barkless Fanatic" } }, -- 1486 :contentReference[oaicite:22]{index=22}
  feyrist_surface = { label="FEYRIST SURFACE", required=1500, iconId=1434, creatures={ "Faun", "Dark Faun", "Nymph", "Pixie", "Pooka", "Twisted Pooka", "Swan Maiden" } }, -- Faun=1434 :contentReference[oaicite:23]{index=23}
  deeplings = { label="DEEPLINGS", required=1000, iconId=772, creatures={ "Deepling Spellsinger", "Deepling Scout", "Deepling Warrior", "Deepling Guard" } }, -- 772 :contentReference[oaicite:24]{index=24}
  wereboars = { label="WEREBOARS", required=1500, iconId=1549, creatures={ "Werefox", "Werebadger", "Wereboar", "Werebear", "Werewolf" } }, -- Werefox=1549 :contentReference[oaicite:25]{index=25}
  minotaur_cults = { label="MINOTAUR CULTS", required=1800, iconId=1508, creatures={ "Minotaur Cult Follower", "Minotaur Cult Prophet", "Minotaur Cult Zealot" } }, -- 1508 :contentReference[oaicite:26]{index=26}
  orc_cults = { label="ORC CULTS", required=2000, iconId=2438, creatures={ "Orc Cult Fanatic", "Orc Cult Inquisitor", "Orc Cult Minion", "Orc Cult Priest", "Orc Cultist" } }, -- 2438 :contentReference[oaicite:27]{index=27}
  feyrist_nightmares = { label="FEYRIST NIGHTMARES", required=2000, iconId=1442, creatures={ "Weakened Frazzlemaw", "Enfeebled Silencer" } }, -- 1442/1443 :contentReference[oaicite:28]{index=28}
  bandits = { label="BANDITS", required=3000, iconId=1119, creatures={ "Glooth Bandit", "Glooth Brigand" } }, -- 1119 :contentReference[oaicite:29]{index=29}
  exotics = { label="EXOTICS", required=3500, iconId=2024, creatures={ "Exotic Cave Spider", "Exotic Bat" } }, -- 2024 :contentReference[oaicite:30]{index=30}
  pirats = { label="PIRATS", required=2000, iconId=2038, creatures={ "Pirat Bombardier", "Pirat Cutthroat", "Pirat Mate", "Pirat Scoundrel" } }, -- 2038 :contentReference[oaicite:31]{index=31}
  werehyaenas = { label="WEREHYAENAS", required=2000, iconId=1963, creatures={ "Werehyaena", "Werehyaena Shaman" } }, -- 1963 :contentReference[oaicite:32]{index=32}
  dragon_lords = { label="DRAGON LORDS", required=2000, iconId=39, creatures={ "Dragon Lord", "Dragon Lord Hatchling" } }, -- 39 :contentReference[oaicite:33]{index=33}
  frost_dragons = { label="FROST DRAGONS", required=2000, iconId=317, creatures={ "Frost Dragon", "Frost Dragon Hatchling" } }, -- 317 :contentReference[oaicite:34]{index=34}
  banuta_deeper = { label="BANUTA DEEPER", required=2000, iconId=120, creatures={ "Medusa", "Serpent Spawn", "Hydra", "Eternal Guardian" } }, -- 120 :contentReference[oaicite:35]{index=35}
  nightmares = { label="NIGHTMARES", required=2000, iconId=33, creatures={ "Nightmare", "Nightmare Scion" } }, -- 33 :contentReference[oaicite:36]{index=36}
  drakens = { label="DRAKENS", required=3000, iconId=673, creatures={ "Draken Abomination", "Draken Elite", "Draken Spellweaver", "Draken Warmaster", "Lizard Legionnaire", "Lizard Magistratus", "Lizard Noble", "Lizard Chosen", "Lizard Dragon Priest", "Lizard High Guard" } }, -- 673 :contentReference[oaicite:37]{index=37}
  the_hive = { label="THE HIVE", required=3000, iconId=785, creatures={ "Waspoid", "Crawler", "Spitter", "Kollos", "Spidris", "Spidris Elite", "Hive Overseer" } }, -- Waspoid=785 :contentReference[oaicite:38]{index=38}
  iksupan = { label="IKSUPAN", required=5000, iconId=2437, creatures={ "Iks Yapunac", "Mitmah Scout", "Mitmah Seer" } }, -- 2437 :contentReference[oaicite:39]{index=39}
  carnivors = { label="CARNIVORS", required=5000, iconId=1723, creatures={ "Lumbering Carnivor", "Spiky Carnivor", "Menacing Carnivor" } }, -- 1723 :contentReference[oaicite:40]{index=40}
  nightmare_isles = { label="NIGHTMARE ISLES", required=3000, iconId=1017, creatures={ "Choking Fear", "Retching Horror", "Silencer" } }, -- 1017 :contentReference[oaicite:41]{index=41}
  warlock = { label="WARLOCK", required=2000, iconId=10, creatures={ "Warlock" } }, -- 10 :contentReference[oaicite:42]{index=42}
  mota = { label="MOTA", required=3000, iconId=291, creatures={ "Fury", "Floating Savant", "Demon", "Retching Horror", "Hellhound" } }, -- Fury=291 :contentReference[oaicite:43]{index=43}
  grim_reapers = { label="GRIM REAPERS", required=3000, iconId=519, creatures={ "Hellspawn", "Grim Reaper" } }, -- Hellspawn=519 :contentReference[oaicite:44]{index=44}
  candia = { label="CANDIA", required=3500, iconId=2535, creatures={ "Candy Horror", "Nibblemaw", "Honey Elemental", "Angry Sugar Fairy", "Candy Floss Elemental", "Goggle Cake" } }, -- 2535 :contentReference[oaicite:45]{index=45}
  lycanthropes = { label="LYCANTHROPES", required=4000, iconId=1965, creatures={ "Werelion", "Werelioness" } }, -- 1965 :contentReference[oaicite:46]{index=46}
  the_void = { label="THE VOID", required=5000, iconId=1696, creatures={ "Breach Brood", "Dread Intruder", "Sparkion", "Reality Reaver" } }, -- Breach Brood=1696 :contentReference[oaicite:47]{index=47}
  asuras = { label="ASURAS", required=5000, iconId=1134, creatures={ "Dawnfire Asura", "Midnight Asura", "Frost Flower Asura" } }, -- 1134 :contentReference[oaicite:48]{index=48}
  buried_cathedral = { label="BURIED CATHEDRAL", required=5000, iconId=1725, creatures={ "Gazer Spectre", "Burster Spectre", "Ripper Spectre", "Thanatursus", "Arachnophobica" } }, -- 1725 :contentReference[oaicite:49]{index=49}
  rathleton_catacombs = { label="RATHLETON CATACOMBS", required=6000, iconId=287, creatures={ "Destroyer", "Dark Torturer", "Demon", "Grim Reaper", "Hellhound", "Hellspawn", "Juggernaut" } }, -- 287 :contentReference[oaicite:50]{index=50}
  roshamuul = { label="ROSHAMUUL", required=8000, iconId=2682, creatures={ "Guzzlemaw", "Frazzlemaw", "Silencer", "Choking Fear", "Retching Horror" } }, -- Guzzlemaw=2682 :contentReference[oaicite:51]{index=51}
  warzone_1 = { label="WARZONE 1", required=3000, iconId=891, creatures={ "Hideous Fungus", "Humongous Fungus" } }, -- 891 :contentReference[oaicite:52]{index=52}
  warzone_2 = { label="WARZONE 2", required=5000, iconId=882, creatures={ "Weeper", "Magma Crawler", "Lost Berserker" } }, -- 882 :contentReference[oaicite:53]{index=53}
  warzone_3 = { label="WARZONE 3", required=5000, iconId=889, creatures={ "Cliff Strider", "Ironblight", "Orewalker" } }, -- 889 :contentReference[oaicite:54]{index=54}
  weretigers = { label="WERETIGERS", required=6000, iconId=2386, creatures={ "Weretiger", "White Weretiger", "Cunning Werepanther" } }, -- 2386 :contentReference[oaicite:55]{index=55}
  winter_elves = { label="WINTER ELVES", required=10000, iconId=1734, creatures={ "Soul-broken Harbinger", "Crazed Winter Vanguard", "Crazed Winter Rearguard", "Arachnophobica" } }, -- 1734 :contentReference[oaicite:56]{index=56}
  summer_elves = { label="SUMMER ELVES", required=8000, iconId=1733, creatures={ "Crazed Summer Rearguard", "Crazed Summer Vanguard", "Insane Siren", "Arachnophobica" } }, -- 1733 :contentReference[oaicite:57]{index=57}
  deathlings = { label="DEATHLINGS", required=4000, iconId=1667, creatures={ "Deathling Scout", "Deathling Spellsinger" } }, -- 1667 :contentReference[oaicite:58]{index=58}
  great_pearl = { label="GREAT PEARL", required=8000, iconId=2259, creatures={ "Foam Stalker", "Two-headed Turtle" } }, -- 2259 :contentReference[oaicite:59]{index=59}
  nagas = { label="NAGAS", required=8000, iconId=2262, creatures={ "Makara", "Naga Archer", "Naga Warrior" } }, -- Makara=2262 :contentReference[oaicite:60]{index=60}
  carnisylvans = { label="CARNISYLVANS", required=8000, iconId=2109, creatures={ "Dark Carnisylvan", "Hulking Carnisylvan", "Poisonous Carnisylvan" } }, -- 2109 :contentReference[oaicite:61]{index=61}
  warzone_4 = { label="WARZONE 4", required=7000, iconId=1546, creatures={ "Chasm Spawn", "Drillworm", "Elder Wyrm", "Lava Lurker" } }, -- 1546 :contentReference[oaicite:62]{index=62}
  warzone_5 = { label="WARZONE 5", required=7000, iconId=1544, creatures={ "Cave Devourer", "High Voltage Elemental", "Tunnel Tyrant" } }, -- 1544 :contentReference[oaicite:63]{index=63}
  warzone_6 = { label="WARZONE 6", required=12000, iconId=1531, creatures={ "Deepworm", "Diremaw", "Humongous Fungus" } }, -- Deepworm=1531 :contentReference[oaicite:64]{index=64}
  seacrest = { label="SEACREST", required=5000, iconId=1096, creatures={ "Seacrest Serpent", "Sea Serpent", "Young Sea Serpent" } }, -- 1096 :contentReference[oaicite:65]{index=65}
  kilmaresh_deeper = { label="KILMARESH DEEPER", required=8000, iconId=1798, creatures={ "Burning Gladiator", "Black Sphinx Acolyte", "Priestess Of The Wild Sun" } }, -- 1798 :contentReference[oaicite:66]{index=66}
  kilmaresh_surface = { label="KILMARESH SURFACE", required=15000, iconId=1808, creatures={ "Sphinx", "Manticore", "Lamassu", "Feral Sphinx", "Crypt Warden", "Young Goanna", "Adult Goanna" } }, -- 1808 :contentReference[oaicite:67]{index=67}
  falcon_bastion = { label="FALCON BASTION", required=16000, iconId=1646, creatures={ "Falcon Knight", "Falcon Paladin" } }, -- 1646 :contentReference[oaicite:68]{index=68}
  kilmaresh_mountains = { label="KILMARESH MOUNTAINS", required=10000, iconId=1821, creatures={ "Ogre Rowdy", "Ogre Ruffian", "Ogre Sage" } }, -- 1821 :contentReference[oaicite:69]{index=69}
  roshamuul_prison = { label="ROSHAMUUL PRISON", required=12000, iconId=1019, creatures={ "Demon Outcast", "Blightwalker", "Plaguesmith", "Dark Torturer", "Hellhound", "Juggernaut" } }, -- 1019 :contentReference[oaicite:70]{index=70}
  cobra_bastion = { label="COBRA BASTION", required=20000, iconId=1775, creatures={ "Cobra Assassin", "Cobra Scout", "Cobra Vizier" } }, -- 1775 :contentReference[oaicite:71]{index=71}
  bulltaur_lair = { label="BULLTAUR LAIR", required=15000, iconId=2448, creatures={ "Bulltaur Alchemist", "Bulltaur Brute", "Bulltaur Forgepriest" } }, -- 2448 :contentReference[oaicite:72]{index=72}
  netherworld = { label="NETHERWORLD", required=15000, iconId=1864, creatures={ "Flimsy Lost Soul", "Mean Lost Soul", "Freakish Lost Soul" } }, -- 1864 :contentReference[oaicite:73]{index=73}
  deep_desert = { label="DEEP DESERT", required=13000, iconId=46, creatures={ "Black Knight", "Guardian of the Sands", "Undead Sun Soldier", "Undead Cobra Scout" } }, -- 46 :contentReference[oaicite:74]{index=74}
  nimmersatts = { label="NIMMERSATT'S", required=20000, iconId=2456, creatures={ "Dragolisk", "Mega Dragon", "Wardragon" } }, -- 2456 :contentReference[oaicite:75]{index=75}
  bashmus = { label="BASHMUS", required=20000, iconId=2100, creatures={ "Bashmu", "Juvenile Bashmu" } }, -- 2100 :contentReference[oaicite:76]{index=76}
  girtablilu = { label="GIRTABLILU", required=15000, iconId=2099, creatures={ "Girtablilu Warrior", "Venerable Girtablilu" } }, -- 2099 :contentReference[oaicite:77]{index=77}
  true_asuras = { label="TRUE ASURAS", required=12000, iconId=1620, creatures={ "True Dawnfire Asura", "True Frost Flower Asura", "True Midnight Asura", "Hellhound" } }, -- 1620 :contentReference[oaicite:78]{index=78}
  ingol = { label="INGOL", required=25000, iconId=2339, creatures={ "Boar Man", "Carnivostrich", "Crape Man", "Harpy", "Liodile", "Rhindeer" } }, -- Boar Man=2339 :contentReference[oaicite:79]{index=79}
  ferumbras_seal = { label="FERUMBRAS SEAL", required=15000, iconId=1197, creatures={ "Vexclaw", "Grimeleech", "Hellflayer" } }, -- 1197 
  warzone_7 = { label="WARZONE 7", required=20000, iconId=2094, creatures={ "Afflicted Strider", "Blemished Spawn", "Eyeless Devourer" } }, -- 2094 :contentReference[oaicite:81]{index=81}
  warzone_8 = { label="WARZONE 8", required=15000, iconId=2095, creatures={ "Lavafungus", "Lavaworm", "Streaked Devourer" } }, -- 2095 :contentReference[oaicite:82]{index=82}
  warzone_9 = { label="WARZONE 9", required=15000, iconId=2096, creatures={ "Cave Chimera", "Tremendous Tyrant", "Varnished Diremaw" } }, -- 2096 :contentReference[oaicite:83]{index=83}
  podzilla = { label="PODZILLA", required=25000, iconId=2539, creatures={ "Rootthing Amber Shaper", "Rootthing Nutshell", "Rootthing Bug Tracker" } }, -- 2539 :contentReference[oaicite:84]{index=84}
  podzilla_deep = { label="PODZILLA DEEP", required=20000, iconId=2543, creatures={ "Quara Looter", "Quara Plunderer", "Quara Raider" } }, -- 2543 :contentReference[oaicite:85]{index=85}
  inferniarchs_castle = { label="INFERNIARCHS CASTLE", required=15000, iconId=2603, creatures={ "Broodrider Inferniarch", "Gorger Inferniarch", "Sineater Inferniarch" } }, -- 2603 :contentReference[oaicite:86]{index=86}
  earth_library = { label="EARTH LIBRARY", required=12000, iconId=1652, creatures={ "Cursed Book", "Ink Blob", "Biting Book" } }, -- Cursed Book=1652 :contentReference[oaicite:87]{index=87}
  ice_library = { label="ICE LIBRARY", required=20000, iconId=1664, creatures={ "Icecold Book", "Squid Warden", "Animated Feather" } }, -- 1664 :contentReference[oaicite:88]{index=88}
  fire_library = { label="FIRE LIBRARY", required=20000, iconId=1663, creatures={ "Burning Book", "Rage Squid", "Guardian Of Tales" } }, -- 1663 
  energy_library = { label="ENERGY LIBRARY", required=20000, iconId=1665, creatures={ "Energetic Book", "Brain Squid", "Energuardian Of Tales" } }, -- 1665 
  furious_crater = { label="FURIOUS CRATER", required=25000, iconId=1929, creatures={ "Vibrant Phantom", "Courage Leech", "Cloak Of Terror" } }, -- 1929 
  dark_thais = { label="DARK THAIS", required=25000, iconId=1927, creatures={ "Many Faces", "Druid’s Apparition", "Knight’s Apparition", "Paladin’s Apparition", "Sorcerer’s Apparition", "Monk’s Apparition", "Distorted Phantom" } }, -- 1927 
  rotten_wasteland = { label="ROTTEN WASTELAND", required=25000, iconId=0, creatures={ } }, -- você não listou criaturas aqui
  claustrophobic_inferno = { label="CLAUSTROPHOBIC INFERNO", required=25000, iconId=1930, creatures={ "Brachiodemon", "Infernal Demon", "Infernal Phantom" } }, -- 1930 
  inferniarchs_catacombs = { label="INFERNIARCHS CATACOMBS", required=25000, iconId=2601, creatures={ "Brinebrute Inferniarch", "Hellhunter Inferniarch", "Spellreaper Inferniarch" } }, -- 2601 
  ebb_and_flow = { label="EBB AND FLOW", required=25000, iconId=1926, creatures={ "Bony Sea Devil", "Turbulent Elemental", "Capricious Phantom" } }, -- 1926 
  crystal_enigma = { label="CRYSTAL ENIGMA", required=30000, iconId=2268, creatures={ "Emerald Tortoise", "Gore Horn", "Gorerilla", "Hulking Prehemoth", "Sabretooth" } }, -- 2268 
  sparkling_pools = { label="SPARKLING POOLS", required=30000, iconId=2275, creatures={ "Headpecker", "Mantosaurus", "Mercurial Menace", "Noxious Ripptor", "Shrieking Cry-stal" } }, -- 2275 
  graveyard = { label="GRAVEYARD", required=30000, iconId=2264, creatures={ "Sulphider", "Sulphur Spouter", "Nighthunter", "Stalking Stalk", "Undertaker" } }, -- Sulphider=2264 
  putrefatory = { label="PUTREFATORY", required=40000, iconId=2394, creatures={ "Meandering Mushroom", "Oozing Carcass", "Rotten Man-maggot", "Sopping Carcass" } }, -- Meandering Mushroom: no snippet com ID apareceu cortado; usei 2394 por sequência (2392/2393 já são Bloated/Rotten). 
  gloom_pillars = { label="GLOOM PILLARS", required=40000, iconId=2379, creatures={ "Converter", "Darklight Construct", "Darklight Emitter", "Wandering Pillar" } }, -- 2379 
  jaded_roots = { label="JADED ROOTS", required=40000, iconId=2392, creatures={ "Bloated Man-maggot", "Mycobiontic Beetle", "Oozing Corpus", "Sopping Corpus" } }, -- 2392 
  darklight_core = { label="DARKLIGHT CORE", required=40000, iconId=2380, creatures={ "Darklight Matter", "Darklight Source", "Darklight Striker", "Walking Pillar" } }, -- 2380 
}

local function norm(s)
  s = tostring(s or ""):lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  s = s:gsub("%s+", " ")
  return s
end

local function smartNormalize(s)
  s = tostring(s or ""):lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  s = s:gsub("^the%s+", "")        -- remove "the "
  s = s:gsub("%s+", " ")           -- limpa espaços duplicados

  if s:sub(-1) == "s" then
    s = s:sub(1, -2)
  end

  return s
end


local function parseHunt(text)
  local msg = tostring(text or "")
  local hunt = msg:match("[Yy]our hunt for%s+([%a%s']+)%s+has begun")
  if not hunt then return nil end

  local normalizedHunt = smartNormalize(hunt)

  for key, cfg in pairs(TASKS) do
    -- compara com key
    if smartNormalize(key) == normalizedHunt then
      return key
    end

    -- compara com label
    if smartNormalize(cfg.label) == normalizedHunt then
      return key
    end
  end

  return nil
end

-- =========================
-- UI PRINCIPAL
-- =========================
taskInterface = setupUI([=[
UIWindow
  size: 250 100
  opacity: 0.95

  Panel
    anchors.fill: parent
    background-color: #0b0b0b
    border: 1 #3b2a10

  Panel
    id: topBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 25
    background-color: #111111

  Label
    id: title
    anchors.centerIn: topBar
    text: [LNS] Task Tracker
    color: orange
    font: verdana-11px-rounded
    text-auto-resize: true

  Button
    id: minimize
    anchors.top: prev.top
    anchors.right: parent.right
    margin-right: 10
    size: 30 15
    text: -
    font: verdana-11px-rounded
    color: orange
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a

  TextList
    id: taskList
    anchors.top: topBar.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: 6
    padding: 2
    image-color: #1b1b1b
    border: 1 #3b2a10
]=], g_ui.getRootWidget())
taskInterface:hide()
local taskList = taskInterface.taskList

taskInterface.minimize.onClick = function()
  if taskList:isVisible() then
    taskList:hide()
    taskInterface:setHeight(35)
    taskInterface.minimize:setText("+")
  else
    taskList:show()
    taskInterface:setHeight(100)
    taskInterface.minimize:setText("-")
  end
end

storage.widgetPos = storage.widgetPos or {}
storage.widgetPos["taskInterface"] = storage.widgetPos["taskInterface"] or {}

-- restaura pos
taskInterface:setPosition({
  x = storage.widgetPos["taskInterface"].x or taskInterface:getX(),
  y = storage.widgetPos["taskInterface"].y or taskInterface:getY()
})



taskInterface.onDragEnter = function(widget, mousePos)
  widget:breakAnchors()
  widget.movingReference = {
    x = mousePos.x - widget:getX(),
    y = mousePos.y - widget:getY()
  }
  return true
end

taskInterface.onDragMove = function(widget, mousePos, moved)
  local parentRect = widget:getParent():getRect()

  local x = math.min(
    math.max(parentRect.x, mousePos.x - widget.movingReference.x),
    parentRect.x + parentRect.width - widget:getWidth()
  )

  local y = math.min(
    math.max(parentRect.y - widget:getParent():getMarginTop(), mousePos.y - widget.movingReference.y),
    parentRect.y + parentRect.height - widget:getHeight()
  )

  widget:move(x, y)
  storage.widgetPos["taskInterface"] = { x = x, y = y }
  return true
end
-- =========================
-- ROW TEMPLATE (layout antigo)
-- =========================
local rowTemplate = [[
UIWidget
  height: 60
  focusable: true
  background-color: alpha
  opacity: 1.00

  UICreature
    id: icon
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 0
    size: 50 50
    margin-top: 0
    visible: true

  Label
    id: spellName
    anchors.left: icon.right
    anchors.top: parent.top
    margin-left: 8
    margin-top: 13
    font: verdana-9px
    color: orange
    text: ""

  Label
    id: distText
    anchors.left: icon.right
    anchors.top: spellName.bottom
    margin-left: 8
    margin-top: 4
    font: verdana-9px
    text-auto-resize: true
    color: #dcdcdc
    text: "0/0"

  Label
    id: mobsText
    anchors.left: distText.right
    anchors.verticalCenter: distText.verticalCenter
    margin-left: 3
    font: verdana-9px
    text-auto-resize: true
    color: #dcdcdc
    text: "KILLS"

  Label
    id: safeText
    anchors.left: mobsText.right
    anchors.verticalCenter: distText.verticalCenter
    margin-left: 8
    font: verdana-9px
    text-auto-resize: true
    color: gray
    text: "[0%]"

  Button
    id: remove
    anchors.right: parent.right
    anchors.top: parent.top
    width: 60
    height: 16
    margin-right: 6
    margin-top: 6
    text: CANCEL
    font: verdana-9px
    color: #FF4040
    image-color: #363636
    image-source: /images/ui/button_rounded
]]

-- =========================
-- Helpers list (igual AttackBot)
-- =========================
local function clearChildren(w)
  local children = w:getChildren() or {}
  for i = #children, 1, -1 do
    children[i]:destroy()
  end
end

local function getProgressKey(taskKey)
  st.progress[taskKey] = st.progress[taskKey] or { kills = 0 }
  st.progress[taskKey].kills = tonumber(st.progress[taskKey].kills or 0) or 0
  return st.progress[taskKey]
end

local function calcPct(kills, req)
  kills = tonumber(kills or 0) or 0
  req = tonumber(req or 0) or 0
  if req <= 0 then return 0 end
  local pct = math.floor((kills * 100) / req)
  if pct < 0 then pct = 0 end
  if pct > 100 then pct = 100 end
  return pct
end

-- =========================
-- REFRESH LIST (ONLINE)
-- =========================
local function refreshList()
  clearChildren(taskList)

  if not st.current or not TASKS[st.current] then
    return
  end

  local cfg = TASKS[st.current]
  local kills = tonumber(st.kills or 0) or 0
  local req = tonumber(st.required or cfg.required) or cfg.required
  if kills > req then kills = req end

  local pct = calcPct(kills, req)
  local done = (kills >= req)

  local row = setupUI(rowTemplate, taskList)

  -- =========================
  -- AQUI É O IMPORTANTE (UICreature)
  -- =========================
  if row.icon and row.icon.setOutfit then
    local outfit = nil

    if player and player.getOutfit then
      local ok, base = pcall(function() return player:getOutfit() end)
      if ok and type(base) == "table" then
        base.type = tonumber(cfg.iconId) or 0
        base.addons = 0
        outfit = base
      end
    end

    outfit = outfit or {
      mount = 0,
      feet = 0,
      legs = 0,
      body = cfg.iconId,
      type = 0,
      auxType = 0,
      addons = 0,
      head = 0
    }

    pcall(function()
      row.icon:setOutfit(outfit)
    end)
  end

  -- =========================

  row.spellName:setText(cfg.label)
  row.distText:setText(kills .. "/" .. req)
  row.mobsText:setText("KILLS")

  row.safeText:setText("[" .. pct .. "%]")
  row.safeText:setColor(done and "#66ff66" or "gray")

  row.remove.onClick = function()
    -- guarda qual task está sendo cancelada
    local key = st.current

    -- limpa progresso salvo dessa task
    if key and st.progress then
      st.progress[key] = nil
    end

    -- reseta estado atual
    st.current = nil
    st.kills = 0
    st.required = 0

    refreshList()
  end
end

-- =========================
-- SET TASK (carrega progresso salvo)
-- =========================
local function setTask(key)
  if not TASKS[key] then return end
  st.current = key
  st.required = TASKS[key].required

  local p = getProgressKey(key)
  st.kills = tonumber(p.kills or 0) or 0
  if st.kills > st.required then st.kills = st.required end

  refreshList()
end

-- =========================
-- AUTO KILL COUNT (salva + atualiza online)
-- =========================
local function addKill()
  local row = setupUI(rowTemplate, taskList)
  if not st.current or not TASKS[st.current] then return end

  st.kills = (tonumber(st.kills or 0) or 0) + 1
  if st.kills > st.required then st.kills = st.required end

  local p = getProgressKey(st.current)
  p.kills = st.kills

  refreshList()
end

local function isTaskCreatureName(mobName)
  if not st.current or not TASKS[st.current] then return false end
  mobName = norm(mobName)

  for _, cname in ipairs(TASKS[st.current].creatures) do
    if mobName == norm(cname) then
      return true
    end
  end
  return false
end

local function extractLootMobName(text)
  local mobName = nil
  local reg = { "Loot of a (.*):", "Loot of an (.*):", "Loot of the (.*):", "Loot of (.*):" }
  for i = 1, #reg do
    local _, _, m = string.find(text, reg[i])
    if m then
      mobName = m
      break
    end
  end
  return mobName
end

local function handleLootText(text)
  if not (storage[HUD_PANEL_STORAGE] and storage[HUD_PANEL_STORAGE].switches and storage[HUD_PANEL_STORAGE].switches.taskTracker) then return end
  if not st.current then return end
  if type(text) ~= "string" then return end

  local mobName = extractLootMobName(text)
  if not mobName then return end

  if not isTaskCreatureName(mobName) then return end

  addKill()
end

onTalk(function(name, level, mode, text, channelId, pos)
  if channelId == 11 then
    handleLootText(text)
  end
end)

onTextMessage(function(mode, text)
  handleLootText(text)
end)

-- =========================
-- CAPTURA Ragnar (ONLINE)
-- =========================
onTalk(function(name, level, mode, text)
  if not name then return end
  if norm(name) ~= "ragnar" then return end

  local key = parseHunt(text)
  if key then
    setTask(key)
  end
end)

onTextMessage(function(mode, text)
  local key = parseHunt(text)
  if key then
    setTask(key)
  end
end)

-- INIT
if st.current and TASKS[st.current] then
  setTask(st.current) -- recarrega progresso salvo e desenha
else
  refreshList()
end
randomise();

enum SelectType
{
    Player,
    Opponent,
    Character,
    Team,
    All
}

function Card(_textLatin, _textPolish, _textEffect, _selectType, _effect) constructor
{
    textLatin = _textLatin;
    textPolish = _textPolish;
    textEffect = _textEffect;
    selectType = _selectType;
    effect = _effect;
}

cardTypes = [];

trzezwoscJestStanemPrzejsciowym = new Card (
    "Serviatus status brevis est",
    "Trzeźwość jest stanem przejściowym",
    "Status: pijany",
    SelectType.Character,
    function(character) 
    {
        character.addEffect(StatusEffect.Drunk);
    }
)

//TODO: Nwm Miko czegoś chyba nie skończył
poraPic = new Card (
    "Nunc est bibendum!",
    "Pora pić!",
    "Status drużyny: pijany",
    SelectType.Team,
    function(team) 
    {
        team.addEffect(StatusEffect.Drunk);
    }
)

//TODO: Jakaś iteracja powszystkich
kazdyUlegaSwoimNamietnosciom = new Card (
    "Trahit sua quemque voluptas",
    "Każdy ulega swoim namiętnościom",
    "Status wszystkich: miłość",
    SelectType.Team,
    function() 
    {
        addEffect(StatusEffect.InLove);
    }
)

zycieJestWalka = new Card (
    "Vivere militare est",
    "Życie jest walką",
    "Ustawia ATK na HP",
    SelectType.Character,
    function(character) 
    {
        character.atk = character.hp;
    }
)

nienawidzeIKocham = new Card (
    "Odi et amo",
    "Nienawidzę i kocham",
    "Status: gniew, Status: miłość",
    SelectType.Character,
    function(character) 
    {
        character.addEffect(StatusEffect.Angry);
        character.addEffect(StatusEffect.InLove);
    }
)

zycieSlowoKsztalci = new Card (
    "Viva vox docet",
    "Życie słowo kształci",
    "Ustawia INT na HP",
    SelectType.Character,
    function(character) 
    {
        character.int = character.hp;
    }
)

jedyniePismo = new Card (
    "Sola scriptura",
    "Jedynie Pismo",
    "Ustaw debatę INT",
    SelectType.All,
    function() 
    {
        o_gameManager.roundType = FightType.Debate;
        o_gameManager.rewriteTextCombatOrDebate();
    }
)

//TODO: Dodać wybór dwóch dowolnych postaci
powtarzamCoUslyszakem = new Card (
    "Relata refero",
    "Powtarzam, co usłyszałem",
    "Skopiuj INT",
    SelectType.All,
    function(character1, character2) 
    {
        character1.int = character2.int;
    }
)

// Potencjalny rework, że +1INT tylko jak przestraszony i czyści przestraszenie
odwazSieBycMadrym = new Card (
    "Sapere aude",
    "Odważ się być mądrym",
    "+1 INT",
    SelectType.Character,
    function(character) 
    {
        character.int++;
    }
)

//TODO: Iteracja po wszystkich i zabicie pijanych
pijanstwoGubiGorzejOdMiecza = new Card (
    "Plures crapula quam gladius perdidit",
    "Pijaństwo gubi gorzej od miecza",
    "Zabij pijanych",
    SelectType.All,
    function() 
    {
    }
)

brodaRosnieRozumuNiePrzybywa = new Card (
    "Barba crescit, caput nescit",
    "Broda rośnie, rozumu nie przybywa",
    "-1 INT, +1 AGE",
    SelectType.Character,
    function(character) 
    {
        character.int--;
        character.age++;
    }
)

slowaISlowaNicPonadto = new Card (
    "Verba et voces praetereaque nihil",
    "Słowa i słowa, nic ponadto",
    "Ustaw walkę ATK",
    SelectType.All,
    function() 
    {
        o_gameManager.roundType = FightType.Combat;
        o_gameManager.rewriteTextCombatOrDebate();
    }
)

//TODO: Add select type deadman
poSmierciNieCzasNaPrzyjemnosci = new Card (
    "Post mortem est nulla voluptas",
    "Po śmierci nie czas na przyjemności",
    "Ożyw zmarłego bohatera",
    SelectType.All,
    function() 
    {
    }
)

//TODO: Iterowanie po wszystkich i sprawdzanie statusu
//Potencjalny rework że +1HP gdy jest gniew i wtedy go usuwa
najlepszymLekarstwemJestSpokoj = new Card (
    "Optimum medicamentum quies est",
    "Najlepszym lekarstwem jest spokój",
    "+1 HP jeśli nie ma statusu gniew",
    SelectType.All,
    function() 
    {
    }
)

toCoSzkodziUczy = new Card (
    "Quae nocent, docent",
    "To, co szkodzi, uczy",
    "+1 INT, -1 HP",
    SelectType.All,
    function(character) 
    {
        character.int++;
        character.hp--;
    }
)

//TODO: insta win
alboZwyciezacAlboUmierac = new Card (
    "Aut vincere, aut mori",
    "Albo zwyciężać, albo umierać",
    "50%: wygrana, 50%: śmierć",
    SelectType.Player,
    function(character) 
    {
        if (choose(false, true))
        {
            //insta win
        }
        else 
        {
        	character.die();
        }
    }
)

//TODO: Iterowanie po wszystkich i sprawdzanie statusu
miloscNajlepszymNauczycielem = new Card (
    "Amor magister optimus",
    "Miłość najlepszym nauczycielem",
    "+1 INT jeśli nie ma statusu miłość",
    SelectType.All,
    function() 
    {
    }
)

//TODO: Iterowanie po wszystkich i sprawdzanie statusu
winoRozpalaGniew = new Card (
    "Vinum incendit iras",
    "Wino rozpala gniew",
    "Status: gniew jeśli ma statusu pijany",
    SelectType.All,
    function() 
    {
    }
)

//TODO: Iterowanie po wszystkich i sprawdzanie statusu
zakochaniSaJakSzalency = new Card (
    "Amantes amentes",
    "Zakochani są jak szaleńcy",
    "+1 ATK jeśli ma statusu miłość",
    SelectType.All,
    function() 
    {
    }
)

//TODO: Iterowanie po wszystkich i sprawdzanie hp
//Ewentualny rework
podobneLeczySiePodobnym = new Card (
    "Similia similibus curantur",
    "Podobne leczy się podobnym",
    "+1 HP dla bohaterów ze wspólną liczbą HP",
    SelectType.All,
    function() 
    {
    }
)

//TODO: Dodać wybór dwóch dowolnych postaci
okoZaOkoZabZaZab = new Card (
    "Oculum pro oculo, dentem pro dente",
    "Oko za oko, ząb za ząb",
    "-1 HP dla bohatera i wroga",
    SelectType.All,
    function(character1, character2) 
    {
        character1.hp--;
        character2.hp--;
    }
)

//TODO: Iterowanie po wszystkich i sprawdzanie statusu
//Potencjalny rework na sprawdzanie stanu choroby
zdrowieChoregoNajwyzszymPrawem = new Card (
    "Salus aegroti suprema lex esto",
    "Zdrowie chorego najwyższym prawem",
    "+2 HP",
    SelectType.Character,
    function(character) 
    {
        character.hp++;
    }
)

//TODO: Dodać wybór dwóch dowolnych postaci
//Potencjalnie dodać pozostałe parametry
uPrzyjaciolWszystkoJestWspolne = new Card (
    "Amicorum omnia communia",
    "U przyjaciół wszystko jest wspólne",
    "Uśrednij statystyki dwóch bohaterów",
    SelectType.All,
    function(character1, character2) 
    {
        var avgHP = ceil((character1.hp + character2.hp) / 2);
        var avgATK = ceil((character1.atk + character2.atk) / 2);
        var avgINT = ceil((character1.int + character2.int) / 2);
        var avgDEF = ceil((character1.def + character2.def) / 2);
        var avgDEX = ceil((character1.dex + character2.dex) / 2);
        
        character1.hp = avgHP;
        character1.atk = avgATK;
        character1.int = avgINT;
        character1.def = avgDEF;
        character1.dex = avgDEX;
        
        character2.hp = avgHP;
        character2.atk = avgATK;
        character2.int = avgINT;
        character2.def = avgDEF;
        character2.dex = avgDEX;
    }
)

//TODO: insta win
jedenZaWszystkich = new Card (
    "Unus pro multis",
    "Jeden za wszystkich",
    "Zabij członka zespołu za wygraną",
    SelectType.Player,
    function(character) 
    {
        character.die();
        //insta win
    }
)

//TODO: iteracja po wojownikach aby sprawdzić parametry
zycieBezNaukiSmierciaJest = new Card (
    "Vita sine litteris mors est",
    "Życie bez nauki śmiercią jest",
    "Zabij wszystkich wojowników z INT = 0",
    SelectType.All,
    function(character) 
    {
        character.die();
        //insta win
    }
)

ostrzezonyUzbrojony = new Card (
    "Praemonitus, praemunitus",
    "Ostrzeżony, uzbrojony",
    "+1 DEF",
    SelectType.Character,
    function(character) 
    {
        character.def++;
    }
)

niechPijeAlboNiechSobieIdzie = new Card (
    "Aut bibat, aut abeat",
    "Niech pije albo niech sobie idzie",
    "50%: status: pijany, 50%: śmierć",
    SelectType.Character,
    function(character) 
    {
        if (choose(false, true))
        {
            character.addEffect(StatusEffect.Drunk);
        }
        else 
        {
        	character.die();
        }
    }
)

//TODO: Iterowanie po wszystkich aby usunąć statusy
//ewentualnie refactor do tylko drużyny / jednego bohatera
//ewentualnie refactor z dodaniem capu na statystyki
czystaTablica = new Card (
    "Tabula rasa",
    "Czysta tablica",
    "Usuń wszystkie statusy",
    SelectType.All,
    function() 
    {
    }
)

wiemZeNicNieWiem = new Card (
    "Scio me nihil scire",
    "Wiem, że nic nie wiem",
    "-1 INT",
    SelectType.Character,
    function(character) 
    {
        character.int--;
    }
)

//TODO: iteracja po wojownikach aby sprawdzić parametry
kazdyKtoSieWywyzszaBedziePonizony = new Card (
    "Omnis qui se exaltat, humiliabitur",
    "Każdy, kto się wywyższa, będzie poniżony",
    "Ustaw najwyższą statystykę na 0",
    SelectType.All,
    function() 
    {
    }
)

douczajacSieNieustannieDochodzeDoStarosci = new Card (
    "Assidue addiscens ad senium venio",
    "Douczając się nieustannie dochodzę do starości",
    "+1 INT, +1 AGE",
    SelectType.Character,
    function(character) 
    {
        character.int++;
        character.age++;
    }
)

array_push(cardTypes,
zycieJestWalka,
nienawidzeIKocham,
zycieSlowoKsztalci,
jedyniePismo
)
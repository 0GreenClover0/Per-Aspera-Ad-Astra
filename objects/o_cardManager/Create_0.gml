randomise();

astraDrawn = false;
chancesForAstra = 0;
perRoundIncrease = 1.5;

c_babyPink = make_colour_rgb(255, 188, 199);
c_gold = make_colour_rgb(224, 205, 94);
c_sea = make_colour_rgb(96, 219, 137);
c_tie = make_colour_rgb(215, 123, 186);

function getAstraChancePerCard()
{
    return chancesForAstra * perRoundIncrease;
}

enum SelectType
{
    Player,
    Opponent,
    Character,
    Team,
    Duo,
    All
}

function Card(_textLatin, _textPolish, _textEffect, _selectType, _effect, _color = o_cardManager.c_babyPink, _index = 0) constructor
{
    textLatin = _textLatin;
    textPolish = _textPolish;
    textEffect = _textEffect;
    selectType = _selectType;
    effect = _effect;
    color = _color;
    index = _index;
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

poraPic = new Card (
    "Nunc est bibendum!",
    "Pora pić!",
    "Status drużyny: pijany",
    SelectType.Team,
    function(team) 
    {
        var numberOfWarriorsInTeam = array_length(team);
        
        for (var i = 0; i < numberOfWarriorsInTeam; i++)
        {
            team[i].addEffect(StatusEffect.Drunk);
        }   
    },
    c_tie,
    3
)

kazdyUlegaSwoimNamietnosciom = new Card (
    "Trahit sua quemque voluptas",
    "Każdy ulega swoim namiętnościom",
    "Status wszystkich: zakochany",
    SelectType.All,
    function() 
    {
        var numberOfPlayers = array_length(o_gameManager.playerCharacters);
        var numberOfEnemies = array_length(o_gameManager.enemiesCharacters);
        
        for (var i = 0; i < numberOfPlayers; i++)
        {
            o_gameManager.playerCharacters[i].addEffect(StatusEffect.InLove);
        }
        
        for (var i = 0; i < numberOfEnemies; i++)
        {
            o_gameManager.enemiesCharacters[i].addEffect(StatusEffect.InLove);
        }
    },
    c_gold,
    1
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
    "Status: wściekły + zakochany",
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

powtarzamCoUslyszakem = new Card (
    "Relata refero",
    "Powtarzam, co usłyszałem",
    "Skopiuj INT",
    SelectType.Duo,
    function(character1, character2) 
    {
        character1.int = character2.int;
    },
    c_sea,
    2
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

pijanstwoGubiGorzejOdMiecza = new Card (
    "Plures crapula quam gladius perdidit",
    "Pijaństwo gubi gorzej od miecza",
    "Zabij pijanych",
    SelectType.All,
    function() 
    {
        var numberOfPlayers = array_length(o_gameManager.playerCharacters);
        var numberOfEnemies = array_length(o_gameManager.enemiesCharacters);
        
        for (var i = numberOfPlayers - 1; i >= 0; i--)
        {
            if (o_gameManager.playerCharacters[i].hasEffect(StatusEffect.Drunk))
            {
                o_gameManager.kill(o_gameManager.playerCharacters[i]);
            }
        }
        
        for (var i = numberOfEnemies - 1; i >= 0; i--)
        {
            if (o_gameManager.enemiesCharacters[i].hasEffect(StatusEffect.Drunk))
            {
                o_gameManager.kill(o_gameManager.enemiesCharacters[i]);
            }
        }
    },
    c_gold,
    1
)

brodaRosnieRozumuNiePrzybywa = new Card (
    "Barba crescit, caput nescit",
    "Broda rośnie, rozumu nie przybywa",
    "-1 INT, +1 WIEK",
    SelectType.Character,
    function(character) 
    {
        character.int--;
        character.aging();
    }
)

//SUS
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

poSmierciNieCzasNaPrzyjemnosci = new Card (
    "Post mortem est nulla voluptas",
    "Po śmierci nie czas na przyjemności",
    "Ożyw szkieleta do pomocy",
    SelectType.All,
    function() 
    {
        var rowMultiply = array_length(o_gameManager.playerCharacters);
        var characterInstance = instance_create_depth(o_gameManager.playerColumn - rowMultiply * 1500, o_gameManager.startRow + o_gameManager.rowIncrement * rowMultiply, 1, o_character);
        characterInstance.team = Team.Player;
        characterInstance.isSkeletor = true;
        characterInstance.randomizeParameters(10);
        characterInstance.startY = o_gameManager.startRow + o_gameManager.rowIncrement * rowMultiply;
        characterInstance.vizualizationY = o_gameManager.startRow + o_gameManager.rowIncrement * rowMultiply + 100;
        array_push(o_gameManager.playerCharacters, characterInstance);
    },
    c_aqua
)

//Potencjalny rework że +1HP gdy jest gniew i wtedy go usuwa
najlepszymLekarstwemJestSpokoj = new Card (
    "Optimum medicamentum quies est",
    "Najlepszym lekarstwem jest spokój",
    "+1 HP jeśli nie ma statusu wściekły",
    SelectType.All,
    function() 
    {
        var numberOfPlayers = array_length(o_gameManager.playerCharacters);
        var numberOfEnemies = array_length(o_gameManager.enemiesCharacters);
        
        for (var i = 0; i < numberOfPlayers; i++)
        {
            if (!o_gameManager.playerCharacters[i].hasEffect(StatusEffect.Angry))
            {
                o_gameManager.playerCharacters[i].hp++;
            }
        }
        
        for (var i = 0; i < numberOfEnemies; i++)
        {
            if (!o_gameManager.enemiesCharacters[i].hasEffect(StatusEffect.Angry))
            {
                o_gameManager.enemiesCharacters[i].hp++;
            }
        }
    },
    c_gold,
    1
)

toCoSzkodziUczy = new Card (
    "Quae nocent, docent",
    "To, co szkodzi, uczy",
    "+1 INT, -1 HP",
    SelectType.Character,
    function(character) 
    {
        character.int++;
        character.hp--;
        
        if (character.hp <= 0)
        {
            o_gameManager.kill(character);
        }
    }
)

alboZwyciezacAlboUmierac = new Card (
    "Aut vincere, aut mori",
    "Albo zwyciężać, albo umierać",
    "50%: wygrana, 50%: śmierć",
    SelectType.Player,
    function(character) 
    {
        if (choose(false, true))
        {
            for (var i = array_length(o_gameManager.enemiesCharacters) - 1; i >= 0; i--)
            {
                o_gameManager.kill(o_gameManager.enemiesCharacters[i]);
            }
        }
        else 
        {
            o_gameManager.kill(character);
        }
    }
)

miloscNajlepszymNauczycielem = new Card (
    "Amor magister optimus",
    "Miłość najlepszym nauczycielem",
    "+1 INT jeśli ma status zakochany",
    SelectType.All,
    function() 
    {
        var numberOfPlayers = array_length(o_gameManager.playerCharacters);
        var numberOfEnemies = array_length(o_gameManager.enemiesCharacters);
        
        for (var i = 0; i < numberOfPlayers; i++)
        {
            if (o_gameManager.playerCharacters[i].hasEffect(StatusEffect.InLove))
            {
                o_gameManager.playerCharacters[i].int++;
            }
        }
        
        for (var i = 0; i < numberOfEnemies; i++)
        {
            if (o_gameManager.enemiesCharacters[i].hasEffect(StatusEffect.InLove))
            {
                o_gameManager.enemiesCharacters[i].int++;
            }
        }
    },
    c_gold,
    1
)

winoRozpalaGniew = new Card (
    "Vinum incendit iras",
    "Wino rozpala gniew",
    "Status: wściekły jeśli ma status pijany",
    SelectType.All,
    function() 
    {
        var numberOfPlayers = array_length(o_gameManager.playerCharacters);
        var numberOfEnemies = array_length(o_gameManager.enemiesCharacters);
        
        for (var i = 0; i < numberOfPlayers; i++)
        {
            if (o_gameManager.playerCharacters[i].hasEffect(StatusEffect.Drunk))
            {
                o_gameManager.playerCharacters[i].addEffect(StatusEffect.Angry);
            }
        }
        
        for (var i = 0; i < numberOfEnemies; i++)
        {
            if (o_gameManager.enemiesCharacters[i].hasEffect(StatusEffect.Drunk))
            {
                o_gameManager.enemiesCharacters[i].addEffect(StatusEffect.Angry);
            }
        }
    },
    c_gold,
    1
)

zakochaniSaJakSzalency = new Card (
    "Amantes amentes",
    "Zakochani są jak szaleńcy",
    "+1 ATK jeśli ma status zakochany",
    SelectType.All,
    function() 
    {
        var numberOfPlayers = array_length(o_gameManager.playerCharacters);
        var numberOfEnemies = array_length(o_gameManager.enemiesCharacters);
        
        for (var i = 0; i < numberOfPlayers; i++)
        {
            if (o_gameManager.playerCharacters[i].hasEffect(StatusEffect.InLove))
            {
                o_gameManager.playerCharacters[i].atk++;
            }
        }
        
        for (var i = 0; i < numberOfEnemies; i++)
        {
            if (o_gameManager.enemiesCharacters[i].hasEffect(StatusEffect.InLove))
            {
                o_gameManager.enemiesCharacters[i].atk++;
            }
        }
    },
    c_gold,
    1
)

//TODO: Iterowanie po wszystkich i sprawdzanie hp
//Ewentualny rework
//podobneLeczySiePodobnym = new Card (
    //"Similia similibus curantur",
    //"Podobne leczy się podobnym",
    //"+1 HP dla bohaterów ze wspólną liczbą HP",
    //SelectType.All,
    //function()
    //{
        //
        //for (var i = 0; )
    //}
//)

okoZaOkoZabZaZab = new Card (
    "Oculum pro oculo, dentem pro dente",
    "Oko za oko, ząb za ząb",
    "-1 HP dla dwóch wojowników",
    SelectType.Duo,
    function(character1, character2) 
    {
        character1.hp--;
        character2.hp--;
        
        if (character1.hp <= 0)
        {
            o_gameManager.kill(character1);
        }
        
        if (character2.hp <= 0)
        {
            o_gameManager.kill(character2);
        }
    },
    c_sea,
    2
)

zdrowieChoregoNajwyzszymPrawem = new Card (
    "Salus aegroti suprema lex esto",
    "Zdrowie chorego najwyższym prawem",
    "+2 HP",
    SelectType.Character,
    function(character) 
    {
        character.hp += 2;
    }
)

//Potencjalnie dodać pozostałe parametry
uPrzyjaciolWszystkoJestWspolne = new Card (
    "Amicorum omnia communia",
    "U przyjaciół wszystko jest wspólne",
    "Uśrednij statystyki dwóch wojowników",
    SelectType.Duo,
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
    },
    c_sea,
    2
)

jedenZaWszystkich = new Card (
    "Unus pro multis",
    "Jeden za wszystkich",
    "Zabij członka zespołu za wygraną",
    SelectType.Player,
    function(character) 
    {
        o_gameManager.kill(character);
        
        var numberOfEnemies = array_length(o_gameManager.enemiesCharacters);
        for (var i = numberOfEnemies - 1; i >= 0; i--)
        {
            o_gameManager.kill(o_gameManager.enemiesCharacters[i]);
        }
    }
)

zycieBezNaukiSmierciaJest = new Card (
    "Vita sine litteris mors est",
    "Życie bez nauki śmiercią jest",
    "Zabij wszystkich wojowników z INT <= 0",
    SelectType.All,
    function() 
    {
        var numberOfPlayers = array_length(o_gameManager.playerCharacters);
        var numberOfEnemies = array_length(o_gameManager.enemiesCharacters);
        
        for (var i = numberOfPlayers - 1; i >= 0; i--)
        {
            if (o_gameManager.playerCharacters[i].int <= 0)
            {
                o_gameManager.kill(o_gameManager.playerCharacters[i]);
            }
        }
        
        for (var i = numberOfEnemies - 1; i >= 0; i--)
        {
            if (o_gameManager.enemiesCharacters[i].int <= 0)
            {
                o_gameManager.kill(o_gameManager.enemiesCharacters[i]);
            }
        }
    },
    c_gold,
    1
)

ostrzezonyUzbrojony = new Card (
    "Praemonitus, praemunitus",
    "Ostrzeżony, uzbrojony",
    "+1 OBR",
    SelectType.Character,
    function(character) 
    {
        character.def++;
    }
)

niechPijeAlboNiechSobieIdzie = new Card (
    "Aut bibat, aut abeat",
    "Niech pije albo niech sobie idzie",
    "50% status: pijany, 50% śmierć",
    SelectType.Character,
    function(character) 
    {
        if (choose(false, true))
        {
            character.addEffect(StatusEffect.Drunk);
        }
        else 
        {
            o_gameManager.kill(character);
        }
    }
)

//ewentualnie refactor do tylko drużyny / jednego bohatera
//ewentualnie refactor z dodaniem capu na statystyki
czystaTablica = new Card (
    "Tabula rasa",
    "Czysta tablica",
    "Usuń wszystkie statusy",
    SelectType.All,
    function() 
    { 
       var numberOfPlayers = array_length(o_gameManager.playerCharacters);
       var numberOfEnemies = array_length(o_gameManager.enemiesCharacters);
       
       for (var i = 0; i < numberOfPlayers; i++)
       {
            o_gameManager.playerCharacters[i].removeAllEffect();
       }
       
       for (var i = 0; i < numberOfEnemies; i++)
       {
            o_gameManager.enemiesCharacters[i].removeAllEffect();
       }
    },
    c_gold,
    1
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

kazdyKtoSieWywyzszaBedziePonizony = new Card (
    "Omnis qui se exaltat, humiliabitur",
    "Każdy, kto się wywyższa, będzie poniżony",
    "Ustaw najwyższą statystykę na 0",
    SelectType.All,
    function() 
    {
        var highestValue = 0;
        var numberOfPlayers = array_length(o_gameManager.playerCharacters);
        var numberOfEnemies = array_length(o_gameManager.enemiesCharacters);
    
        for (var i = 0; i < numberOfPlayers; i++)
        {
            var player = o_gameManager.playerCharacters[i];
            highestValue = max(highestValue, player.atk, player.int, player.def, player.dex);
        }
    
        for (var i = 0; i < numberOfEnemies; i++)
        {
            var enemy = o_gameManager.enemiesCharacters[i];
            highestValue = max(highestValue, enemy.atk, enemy.int, enemy.def, enemy.dex);
        }
        
        for (var i = 0; i < numberOfPlayers; i++)
        {
            var player = o_gameManager.playerCharacters[i];
            if (player.atk == highestValue) {player.atk = 0;}
            if (player.int == highestValue) {player.int = 0;}
            if (player.def == highestValue) {player.def = 0;}
            if (player.dex == highestValue) {player.dex = 0;}
        }
    
        for (var i = 0; i < numberOfEnemies; i++)
        {
            var enemy = o_gameManager.enemiesCharacters[i];
            if (enemy.atk == highestValue) {enemy.atk = 0;}
            if (enemy.int == highestValue) {enemy.int = 0;}
            if (enemy.def == highestValue) {enemy.def = 0;}
            if (enemy.dex == highestValue) {enemy.dex = 0;}
        }
    },
    c_gold,
    1
)

douczajacSieNieustannieDochodzeDoStarosci = new Card (
    "Assidue addiscens ad senium venio",
    "Douczając się nieustannie dochodzę do starości",
    "+1 INT, +1 WIEK",
    SelectType.Character,
    function(character) 
    {
        character.int++;
        character.aging();
    }
)

//TODO: Wygrana or smth;
przezTrudyDoGwiazd = new Card (
    "Per Aspera Ad Astra",
    "Przez Trudy Do Gwiazd",
    "!WYGRYWASZ!",
    SelectType.All,
    function() 
    {
        game_end();
    }
)

array_push(cardTypes,
    trzezwoscJestStanemPrzejsciowym,
    poraPic,
    kazdyUlegaSwoimNamietnosciom,
    zycieJestWalka,
    nienawidzeIKocham,
    zycieSlowoKsztalci,
    jedyniePismo,
    powtarzamCoUslyszakem,
    odwazSieBycMadrym,
    pijanstwoGubiGorzejOdMiecza,
    brodaRosnieRozumuNiePrzybywa,
    slowaISlowaNicPonadto,
    poSmierciNieCzasNaPrzyjemnosci,
    najlepszymLekarstwemJestSpokoj,
    toCoSzkodziUczy,
    alboZwyciezacAlboUmierac,
    miloscNajlepszymNauczycielem,
    winoRozpalaGniew,
    zakochaniSaJakSzalency,
    okoZaOkoZabZaZab,
    zdrowieChoregoNajwyzszymPrawem,
    uPrzyjaciolWszystkoJestWspolne,
    jedenZaWszystkich,
    zycieBezNaukiSmierciaJest,
    ostrzezonyUzbrojony,
    niechPijeAlboNiechSobieIdzie,
    czystaTablica,
    wiemZeNicNieWiem,
    kazdyKtoSieWywyzszaBedziePonizony,
    douczajacSieNieustannieDochodzeDoStarosci,
)
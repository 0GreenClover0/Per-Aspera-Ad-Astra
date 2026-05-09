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
    }
)

kazdyUlegaSwoimNamietnosciom = new Card (
    "Trahit sua quemque voluptas",
    "Każdy ulega swoim namiętnościom",
    "Status wszystkich: miłość",
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

//Potencjalny rework że +1HP gdy jest gniew i wtedy go usuwa
najlepszymLekarstwemJestSpokoj = new Card (
    "Optimum medicamentum quies est",
    "Najlepszym lekarstwem jest spokój",
    "+1 HP jeśli nie ma statusu gniew",
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
    }
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
            o_gameManager.kill(character);
        }
    }
)

miloscNajlepszymNauczycielem = new Card (
    "Amor magister optimus",
    "Miłość najlepszym nauczycielem",
    "+1 INT jeśli ma status miłość",
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
    }
)

winoRozpalaGniew = new Card (
    "Vinum incendit iras",
    "Wino rozpala gniew",
    "Status: gniew jeśli ma statusu pijany",
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
    }
)

zakochaniSaJakSzalency = new Card (
    "Amantes amentes",
    "Zakochani są jak szaleńcy",
    "+1 ATK jeśli ma statusu miłość",
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
        o_gameManager.kill(character);
        //insta win
    }
)

zycieBezNaukiSmierciaJest = new Card (
    "Vita sine litteris mors est",
    "Życie bez nauki śmiercią jest",
    "Zabij wszystkich wojowników z INT = 0",
    SelectType.All,
    function() 
    {
        var numberOfPlayers = array_length(o_gameManager.playerCharacters);
        var numberOfEnemies = array_length(o_gameManager.enemiesCharacters);
        
        for (var i = numberOfPlayers - 1; i >= 0; i--)
        {
            if (o_gameManager.playerCharacters[i].int == 0)
            {
                o_gameManager.kill(o_gameManager.playerCharacters[i]);
            }
        }
        
        for (var i = numberOfEnemies - 1; i >= 0; i--)
        {
            if (o_gameManager.enemiesCharacters[i].int == 0)
            {
                o_gameManager.kill(o_gameManager.enemiesCharacters[i]);
            }
        }
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
    //trzezwoscJestStanemPrzejsciowym,
    //poraPic,
    //kazdyUlegaSwoimNamietnosciom,
    //zycieJestWalka,
    //nienawidzeIKocham,
    //zycieSlowoKsztalci,
    jedyniePismo,
    //
    //odwazSieBycMadrym,
    //pijanstwoGubiGorzejOdMiecza,
    //brodaRosnieRozumuNiePrzybywa,
    slowaISlowaNicPonadto,
    // 
    //najlepszymLekarstwemJestSpokoj,
    //toCoSzkodziUczy,
    //
    //miloscNajlepszymNauczycielem,
    //winoRozpalaGniew,
    //zakochaniSaJakSzalency,
    //
    //
    //
    //
    //
    //zycieBezNaukiSmierciaJest,
    //ostrzezonyUzbrojony,
    //niechPijeAlboNiechSobieIdzie,
    //czystaTablica,
    //wiemZeNicNieWiem,
    //kazdyKtoSieWywyzszaBedziePonizony,
    //douczajacSieNieustannieDochodzeDoStarosci,
)
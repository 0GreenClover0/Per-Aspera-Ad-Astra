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
    "Status nienawiść, status miłość",
    SelectType.Character,
    function(character) 
    {
        character.atk = character.hp;
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

array_push(cardTypes,
zycieJestWalka,
nienawidzeIKocham,
zycieSlowoKsztalci,
jedyniePismo
)
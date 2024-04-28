--- STEAMODDED HEADER
--- MOD_NAME: Hand of Six
--- MOD_ID: HandOfSix
--- MOD_AUTHOR: [ilikecheese]
--- MOD_DESCRIPTION: Allows the player to play six cards in one hand rather than five, and adds all the new possible hands this creates. Credit to Luna for the planet art!
--- PRIORITY: 100
--- BADGE_COLOUR: 708391

----------------------------------------------
------------MOD CODE -------------------------

local new_hands = {
    {name = "Flush Six",         mult = 18,  chips = 180, level_mult = 5, level_chips = 75, example = {{'H_A', true},{'H_A', true},{'H_A', true},{'H_A', true},{'H_A', true},{'H_A', true}}, desc = {"6 cards with the same rank and suit"}},
    {name = "Flusher House",     mult = 15,  chips = 160, level_mult = 4, level_chips = 65, example = {{'C_9', true},{'C_9', true},{'C_9', true},{'C_9', true},{'C_7', true},{'C_7', true}}, desc = {"A Four of a Kind and a Pair with", "all cards sharing the same suit"}},
    {name = "Two Flush Triple",  mult = 15,  chips = 155, level_mult = 4, level_chips = 60, example = {{'D_K', true},{'D_K', true},{'D_K', true},{'D_4', true},{'D_4', true},{'D_4', true}}, desc = {"A Two of a Triple with all", "cards sharing the same suit"}},
    {name = "Six of a Kind",     mult = 15,  chips = 150, level_mult = 4, level_chips = 60, example = {{'H_A', true},{'H_A', true},{'C_A', true},{'C_A', true},{'D_A', true},{'S_A', true}}, desc = {"6 cards with the same rank"}},
    {name = "Straighter Flush",  mult = 10,  chips = 120, level_mult = 3, level_chips = 55, example = {{'H_T', true},{'H_9', true},{'H_8', true},{'H_7', true},{'H_6', true},{'H_5', true}}, desc = {"6 cards in a row (consecutive ranks) with", "all cards sharing the same suit"}},
    {name = "Fuller House",      mult = 9,   chips = 100, level_mult = 3, level_chips = 50, example = {{'H_J', true},{'C_J', true},{'D_J', true},{'S_J', true},{'C_5', true},{'D_5', true}}, desc = {"A Four of a Kind and a Pair"}},
    {name = "Two of a Triple",   mult = 6,   chips = 50,  level_mult = 2, level_chips = 40, example = {{'H_A', true},{'S_A', true},{'D_A', true},{'H_T', true},{'C_T', true},{'S_T', true}}, desc = {"Two Three of a Kinds with different ranks"}},
    {name = "Flusher",           mult = 6,   chips = 45,  level_mult = 2, level_chips = 25, example = {{'S_A', true},{'S_J', true},{'S_9', true},{'S_8', true},{'S_7', true},{'S_3', true}}, desc = {"6 cards that share the same suit"}},
    {name = "Straighter",        mult = 6,   chips = 40,  level_mult = 2, level_chips = 35, example = {{'H_T', true},{'D_9', true},{'H_8', true},{'C_7', true},{'S_6', true},{'D_5', true}}, desc = {"6 cards in a row (consecutive ranks)"}},
    {name = "Three Pair",        mult = 3,   chips = 35,  level_mult = 2, level_chips = 20, example = {{'S_Q', true},{'C_Q', true},{'S_5', true},{'D_5', true},{'H_4', true},{'C_4', true}}, desc = {"3 pairs of cards with different ranks"}}
}

function add_localization()
    for _, v in ipairs(new_hands) do
        G.localization.misc.poker_hands[v.name] = v.name
        G.localization.misc.poker_hand_descriptions[v.name] = v.desc
    end
    init_localization()
end

function set_played_hand_size(size)
    add_to_highlighted_ref = CardArea.add_to_highlighted

    CardArea.add_to_highlighted = function(self, card, silent)
        if self.config.type ~= 'shop' and self.config.type ~= 'joker' and self.config.type ~= 'consumeable' then
            if #self.highlighted >= size then
                card:highlight(false)
            else
                self.highlighted[#self.highlighted+1] = card
                card:highlight(true)
                if not silent then play_sound('cardSlide1') end
            end
            if self == G.hand and G.STATE == G.STATES.SELECTING_HAND then
                self:parse_highlighted()
            end
        else
            add_to_highlighted_ref(self, card, silent)
        end
    end

    G.FUNCS.can_play = function(e)
        if #G.hand.highlighted <= 0 or G.GAME.blind.block_play or #G.hand.highlighted > size then 
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.BLUE
            e.config.button = 'play_cards_from_highlighted'
        end
    end
end

function edit_global_hand_list()
    for _, v in ipairs(new_hands) do
        table.insert(G.handlist, v.name)
    end
end

function add_planets()
    local hand_of_six = SMODS.findModByID('HandOfSix')

    local sprite_planets = SMODS.Sprite:new('new_planets', hand_of_six.path, 'planets.png', 71, 95, 'asset_atli')
    sprite_planets:register()

    local haumea = SMODS.Planet:new("Haumea", 'haumea', {hand_type = 'Three Pair', softlock = true}, {x = 0, y = 0}, nil, nil, nil, nil, nil, nil, true, 'new_planets')
    local varuna = SMODS.Planet:new("Varuna", 'varuna', {hand_type = 'Two of a Triple', softlock = true}, {x = 1, y = 0}, nil, nil, nil, nil, nil, nil, true, 'new_planets')
    local orcus = SMODS.Planet:new("Orcus", 'orcus', {hand_type = 'Fuller House', softlock = true}, {x = 2, y = 0}, nil, nil, nil, nil, nil, nil, true, 'new_planets')
    local salacia = SMODS.Planet:new("Salacia", 'salacia', {hand_type = 'Straighter', softlock = true}, {x = 3, y = 0}, nil, nil, nil, nil, nil, nil, true, 'new_planets')
    local varda = SMODS.Planet:new("Varda", 'varda', {hand_type = 'Six of a Kind', softlock = true}, {x = 4, y = 0}, nil, nil, nil, nil, nil, nil, true, 'new_planets')
    local makemake = SMODS.Planet:new("Makemake", 'makemake', {hand_type = 'Flusher', softlock = true}, {x = 0, y = 1}, nil, nil, nil, nil, nil, nil, true, 'new_planets')
    local gonggong = SMODS.Planet:new("Gonggong", 'Gonggong', {hand_type = 'Two Flush Triple', softlock = true}, {x = 1, y = 1}, nil, nil, nil, nil, nil, nil, true, 'new_planets')
    local quaoar = SMODS.Planet:new("Quaoar", 'quaoar', {hand_type = 'Flusher House', softlock = true}, {x = 2, y = 1}, nil, nil, nil, nil, nil, nil, true, 'new_planets')
    local sedna = SMODS.Planet:new("Sedna", 'sedna', {hand_type = 'Straighter Flush', softlock = true}, {x = 3, y = 1}, nil, nil, nil, nil, nil, nil, true, 'new_planets')
    local ixion = SMODS.Planet:new("Ixion", 'ixion', {hand_type = 'Flush Six', softlock = true}, {x = 4, y = 1}, nil, nil, nil, nil, nil, nil, true, 'new_planets')
    
    haumea:register()
    varuna:register()
    orcus:register()
    salacia:register()
    varda:register()
    makemake:register()
    gonggong:register()
    quaoar:register()
    sedna:register()
    ixion:register()
    SMODS.injectPlanets()
end

local evaluate_poker_hand_ref = evaluate_poker_hand
local new_evaluate_poker_hand = function(hand)
    local results = evaluate_poker_hand_ref(hand)
    
    for _, v in ipairs(new_hands) do
        results[v.name] = {}
    end

    local get_flusher = function(hand) 
        local ret = {}
        local suits = {
        "Spades",
        "Hearts",
        "Clubs",
        "Diamonds"
        }
        if #hand < 6 then return ret else
        for j = 1, #suits do
            local t = {}
            local suit = suits[j]
            local flush_count = 0
            for i=1, #hand do
            if hand[i]:is_suit(suit, nil, true) then flush_count = flush_count + 1;  t[#t+1] = hand[i] end 
            end
            if flush_count >= 6 then
            table.insert(ret, t)
            return ret
            end
        end
        return {}
        end
    end

    local get_straighter = function(hand) 
        local ret = {}
        if #hand < 6 then return ret else 
        local t = {}
        local IDS = {}
        for i=1, #hand do
            local id = hand[i]:get_id()
            if id > 1 and id < 15 then
            if IDS[id] then
                IDS[id][#IDS[id]+1] = hand[i]
            else
                IDS[id] = {hand[i]}
            end
            end
        end
    
        local straight_length = 0
        local straighter = false
        local can_skip = next(find_joker('Shortcut')) 
        local skipped_rank = false
        for j = 1, 14 do
            if IDS[j == 1 and 14 or j] then
            straight_length = straight_length + 1
            skipped_rank = false
            for k, v in ipairs(IDS[j == 1 and 14 or j]) do
                t[#t+1] = v
            end
            elseif can_skip and not skipped_rank and j ~= 14 then
                skipped_rank = true
            else
            straight_length = 0
            skipped_rank = false
            if not straighter then t = {} end
            if straighter then break end
            end
            if straight_length >= 6 then straighter = true end 
        end
        if not straighter then return ret end
        table.insert(ret, t)
        return ret
        end
    end

    if #hand > 5 then
        if next(get_X_same(6,hand)) and next(get_flusher(hand)) then
            results["Flush Six"] = get_X_same(6,hand)
        end

        if next(get_X_same(6,hand)) then
            results["Six of a Kind"] = get_X_same(6,hand)
        end

        if next(get_X_same(4,hand)) and next(get_X_same(2,hand)) and next(get_flusher(hand)) then
            local fh_hand = {}
            local fh_4 = get_X_same(4,hand)[1]
            local fh_2 = get_X_same(2,hand)[1]
            for i=1, #fh_4 do
                fh_hand[#fh_hand+1] = fh_4[i]
            end
            for i=1, #fh_2 do
                fh_hand[#fh_hand+1] = fh_2[i]
            end
            table.insert(results["Flusher House"], fh_hand)
        end

        if #get_X_same(3,hand) == 2 and next(get_flusher(hand)) then
            local fh_hand = {}
            local fh_3a = get_X_same(3,hand)[1]
            local fh_3b = get_X_same(3,hand)[2]
            for i=1, #fh_3a do
                fh_hand[#fh_hand+1] = fh_3a[i]
            end
            for i=1, #fh_3b do
                fh_hand[#fh_hand+1] = fh_3b[i]
            end
            table.insert(results["Two Flush Triple"], fh_hand)
        end

        if next(get_flusher(hand)) and next(get_straighter(hand)) then
            local _s, _f, ret = get_straighter(hand), get_flusher(hand), {}
            for _, v in ipairs(_f[1]) do
                ret[#ret+1] = v
            end
            for _, v in ipairs(_s[1]) do
                local in_straight = nil
                for _, vv in ipairs(_f[1]) do
                if vv == v then in_straight = true end
                end
                if not in_straight then ret[#ret+1] = v end
            end
        
            results["Straighter Flush"] = {ret}
        end

        if next(get_X_same(4,hand)) and next(get_X_same(2,hand)) then
            local fh_hand = {}
            local fh_4 = get_X_same(4,hand)[1]
            local fh_2 = get_X_same(2,hand)[1]
            for i=1, #fh_4 do
                fh_hand[#fh_hand+1] = fh_4[i]
            end
            for i=1, #fh_2 do
                fh_hand[#fh_hand+1] = fh_2[i]
            end
            table.insert(results["Fuller House"], fh_hand)
        end

        if #get_X_same(3,hand) == 2 then
            local fh_hand = {}
            local fh_3a = get_X_same(3,hand)[1]
            local fh_3b = get_X_same(3,hand)[2]
            for i=1, #fh_3a do
                fh_hand[#fh_hand+1] = fh_3a[i]
            end
            for i=1, #fh_3b do
                fh_hand[#fh_hand+1] = fh_3b[i]
            end
            table.insert(results["Two of a Triple"], fh_hand)
        end

        if next(get_flusher(hand)) then
            results["Flusher"] = get_flusher(hand)
        end

        if next(get_straighter(hand)) then
            results["Straighter"] = get_straighter(hand)
        end

        if #get_X_same(2,hand) == 3 then
            local fh_hand = {}
            local r = get_X_same(2,hand)
            local fh_2a = r[1]
            local fh_2b = r[2]
            local fh_2c = r[3]
            for i=1, #fh_2a do
                fh_hand[#fh_hand+1] = fh_2a[i]
            end
            for i=1, #fh_2b do
                fh_hand[#fh_hand+1] = fh_2b[i]
            end
            for i=1, #fh_2c do
                fh_hand[#fh_hand+1] = fh_2c[i]
            end
            table.insert(results["Three Pair"], fh_hand)
        end
    end

    -- ensure new hand register for effects that check for containing two pair

    if results["Three Pair"][1] then
        results["Two Pair"] = {
            results["Three Pair"][1], 
            results["Three Pair"][2], 
            results["Three Pair"][3],
            results["Three Pair"][4]
        }
    end

    if results["Two of a Triple"][1] then
        results["Two Pair"] = {
            results["Two of a Triple"][1], 
            results["Two of a Triple"][2], 
            results["Two of a Triple"][4],
            results["Two of a Triple"][5]
        }
    end

    if results["Fuller House"][1] then
        results["Two Pair"] = {
            results["Fuller House"][1], 
            results["Fuller House"][2], 
            results["Fuller House"][5],
            results["Fuller House"][6]
        }
    end

    -- ensure six of a kind registers for effects that check for containing any x of a kind

    if results["Six of a Kind"][1] then
        results["Five of a Kind"] = {
            results["Six of a Kind"][1], 
            results["Six of a Kind"][2], 
            results["Six of a Kind"][3], 
            results["Six of a Kind"][4], 
            results["Six of a Kind"][5]
        }
        results["Four of a Kind"] = {
            results["Five of a Kind"][1], 
            results["Five of a Kind"][2], 
            results["Five of a Kind"][3], 
            results["Five of a Kind"][4]
        }
        results["Three of a Kind"] = {
            results["Four of a Kind"][1], 
            results["Four of a Kind"][2], 
            results["Four of a Kind"][3]
        }
        results["Pair"] = {
            results["Three of a Kind"][1], 
            results["Three of a Kind"][2]
        }
    end
    
    return results
end

local new_create_UIBox_current_hands = function(simple)
    local hands = {}

    local ordered_hands = {}
    for k, v in pairs(G.GAME.hands) do
        ordered_hands[v.order] = k
    end

    for k, v in ipairs(ordered_hands) do
        hands[k] = create_UIBox_current_hand_row(v, simple)
    end

    local t = {
        n = G.UIT.ROOT, 
        config = {align = "cm", minw = 3, padding = 0.1, r = 0.1, colour = G.C.CLEAR}, 
        nodes = {{
            n = G.UIT.R, 
            config = {align = "cm", padding = 0.04}, 
            nodes = hands
        }},
    }

    return t
end

local new_get_poker_hand_info = function(_cards)
    local poker_hands = evaluate_poker_hand(_cards)
    local scoring_hand = {}
    local text, disp_text, loc_disp_text = 'NULL', 'NULL', 'NULL'

    local ordered_hands = {}
    for k, v in pairs(G.GAME.hands) do
        ordered_hands[v.order] = k
    end

    for _, v in ipairs(ordered_hands) do
        if next(poker_hands[v]) then
            text = v
            scoring_hand = poker_hands[v][1]
            break
        end
    end

    disp_text = text

    if text == 'Straight Flush' then
        local min = 10
        for j = 1, #scoring_hand do
            if scoring_hand[j]:get_id() < min then min =scoring_hand[j]:get_id() end
        end
        if min >= 10 then 
            disp_text = 'Royal Flush'
        end
    end
    if text == 'Straighter Flush' then
        local min = 9
        for j = 1, #scoring_hand do
            if scoring_hand[j]:get_id() < min then min =scoring_hand[j]:get_id() end
        end
        if min >= 9 then 
            disp_text = 'Imperial Flush'
        end
    end

    loc_disp_text = localize(disp_text, 'poker_hands')
    return text, loc_disp_text, poker_hands, scoring_hand, disp_text
end

init_game_object_ref = Game.init_game_object
new_init_game_object = function()
    rv = init_game_object_ref()

    for _, new_hand in ipairs(new_hands) do
        local hand_to_insert = {
            visible = true, 
            order = 1, 
            mult = new_hand.mult, 
            chips = new_hand.chips, 
            s_mult = new_hand.mult, 
            s_chips = new_hand.chips, 
            level = 1, 
            l_mult = new_hand.level_mult, 
            l_chips = new_hand.level_chips, 
            played = 0, 
            played_this_round = 0, 
            example = new_hand.example
        }
        for k, v in pairs(rv.hands) do
            if v.s_chips * v.s_mult < hand_to_insert.s_chips * hand_to_insert.s_mult then
                v.order = v.order + 1
            else
                hand_to_insert.order = hand_to_insert.order + 1
            end
        end

        rv.hands[new_hand.name] = hand_to_insert
    end

    return rv
end

function SMODS.INIT.HandOfSix()
    add_localization()
    set_played_hand_size(6)
    edit_global_hand_list()
    add_planets()
    
    evaluate_poker_hand = new_evaluate_poker_hand
    create_UIBox_current_hands = new_create_UIBox_current_hands
    G.FUNCS.get_poker_hand_info = new_get_poker_hand_info
    Game.init_game_object = new_init_game_object
end

----------------------------------------------
------------MOD CODE END----------------------
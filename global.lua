deck_default = {}
deck_exploding = {}
deck_defuse = {}
deck_imploding = {}
single_imploding_before = {}
single_imploding_after = {}
deck_streaking = {}
single_streaking = {}

deck_default_guid = 'd8428f'
deck_exploding_guid = '0eae9d'
deck_defuse_guid = '329f35'

deck_imploding_guid = '17df01'
deck_streaking_guid = 'b8db4f'

default_box_guid = '1ae83c'
nsfw_box_guid = '282589'

instructions_book_eng_guid = '1d41bd'
instructions_book_esp_guid = '5a3f0e'

turn_signal_guid = '7a3b65'
single_streaking_guid = '11c500'
single_imploding_before_guid = '2d5acc'
single_imploding_after_guid = '973c0f'

checker_guid = 'b9f95b'

scripted_zone_guid = 'a708c1'
defuse_scripted_zone_guid = 'c7e370'
exploding_scripted_zone_guid = '4261dc'

script_card_n_guid = {'4261dc','a12864','16445c','16ab9d','18d3cf'}

upper_text_row_guid = 'd7b5e1'
lower_text_row_guid = 'f348d1'

players = {}
num_players = 0
player_colors = {}

exploding = true
nsfw = false
imploding = false
streaking = false

blindfoldToggle = true
english = true

lang = {
  ENGLISH = {
    CLEAR = "Clear deck",
    START = "Start",
    FIRST = "starts!",
    DRAW = "Draw",
    DRAWMSG = "has drawn a card",
    SHUFFLE = "Shuffle",
    BLINDFOLD = "Blindfold oponents",
    BLINDFOLDED = "Oponents have been blindfolded",
    UNBLINDFOLDED = "Oponents have been unblindfolded",
    SEETHEFUTURE3 = "See the future (x3)\nAlter the future (x3)",
    SEETHEFUTURE5 = "See the future (x5)\nAlter the future (x5)",
    CATOMICBOMB = "Catomic bomb",
    DRAWFROMBOTTOM = "Draw from the bottom",
    SWAPTOPBOTTOM = "Swap top and bottom",
    RETURNCARDS = "Return cards"
  },
  SPANISH = {
    CLEAR = "Limpiar mesa",
    START = "Comenzar",
    FIRST = "empieza!",
    DRAW = "Robar",
    DRAWMSG = "ha robado una carta",
    SHUFFLE = "Barajar",
    BLINDFOLD = "Cegar oponentes",
    BLINDFOLDED = "Los oponentes han sido cegados",
    UNBLINDFOLDED = "Los oponentes ya pueden ver",
    SEETHEFUTURE3 = "Ver el futuro (x3)\nAlterar el futuro (x3)",
    SEETHEFUTURE5 = "Ver el futuro (x5)\nAlterar el futuro (x5)",
    CATOMICBOMB = "Bomba gatómica",
    DRAWFROMBOTTOM = "Robar del fondo",
    SWAPTOPBOTTOM = "Intercambiar extremos",
    RETURNCARDS = "Devolver cartas"
  }
}

deck_pos = {
  position = {-25.4,0.8,1},
  rotation = {0,180,180},
}

defuse_pos = {
  position = {-33.5,0.8,1},
  rotation = {0,180,0},
}

exploding_pos = {
  position = {-17.25,0.8,1},
  rotation = {0,180,0},
}

checker_pos = {
  position = {-17.2,1.1,15.2},
  rotation = {0,270,0},
}

function onLoad()

  -- BOXES
  default_box = getObjectFromGUID(default_box_guid)
  nsfw_box = getObjectFromGUID(nsfw_box_guid)

  -- OTHER OBJECTS
  instructions_book = getObjectFromGUID(instructions_book_eng_guid)
  checker = getObjectFromGUID(checker_guid)

  game_board = getObjectFromGUID(game_board_guid)
  turn_signal = getObjectFromGUID(turn_signal_guid)
  scripted_zone = getObjectFromGUID(scripted_zone_guid)
  defuse_scripted_zone = getObjectFromGUID(defuse_scripted_zone_guid)
  exploding_scripted_zone = getObjectFromGUID(exploding_scripted_zone_guid)

  upper_row_text = getObjectFromGUID(upper_text_row_guid)
  lower_row_text = getObjectFromGUID(lower_text_row_guid)

  -- (Instantiating buttons)
  crearBoton(checker, 'NSFW', 'setNSFW', {-7.5, 0.2, 0})
  crearBoton(checker, 'Imploding Kittens', 'setImploding', {-4.5, 0.2, 0})
  crearBoton(checker, 'Streaking Kittens', 'setStreaking', {-1.5, 0.2, 0})
  crearBoton(checker, 'English', 'setEnglish', {1.5, 0.2, 2.6}, 2600)
  crearBoton(checker, 'Español', 'setSpanish', {1.5, 0.2, -2.6}, 2600)
  crearBoton(checker, 'Start', 'prepararPartida', {11, 0.2, 0})
end

function setEnglish()
  if (english) then
    broadcastToAll("Language already set to english", {1,1,1})
  else
    english = true
    broadcastToAll("Language set to english", {1,1,1})
  end
  instructions_book.setPosition({-33.5,-8,15.23}) -- Hides it under the table
  instructions_book.setLock(true)
  instructions_book = getObjectFromGUID(instructions_book_eng_guid)
  instructions_book.setPosition({-33.5,0.96,15.23})
  instructions_book.setLock(false)
end

function setSpanish()
  if (not english) then
    broadcastToAll("Idioma ya en español", {1,1,1})
  else
    english = false
    broadcastToAll("Idioma cambiado a español", {1,1,1})
    if (nsfw) then
      broadcastToAll("NSFW sólo está disponible en inglés por el momento, ¡lo siento!", {1,1,1})
    end
  end
  instructions_book.setPosition({-33.5,-8,15.23}) -- Hides it under the table
  instructions_book.setLock(true)
  instructions_book = getObjectFromGUID(instructions_book_esp_guid)
  instructions_book.setPosition({-33.5,0.96,15.23})
  instructions_book.setLock(false)
end

function setNSFW()
  if (english) then
    nsfw = not nsfw
    if (nsfw) then
      broadcastToAll("Cards will be NSFW", {1,1,1})
    else
      broadcastToAll("Cards will be default", {1,1,1})
    end
  else
      broadcastToAll("NSFW sólo está disponible en inglés por el momento, ¡lo siento!", {1,1,1})
  end
end

function setImploding()
  imploding = not imploding
  if (english) then
    if (imploding) then
      broadcastToAll("Imploding Kittens added", {1,1,1})
    else
      broadcastToAll("Imploding Kittens removed", {1,1,1})
    end
  else
    if (imploding) then
      broadcastToAll("Imploding Kittens añadido", {1,1,1})
    else
      broadcastToAll("Imploding Kittens eliminado", {1,1,1})
    end
  end
end

function setStreaking()
  streaking = not streaking
  if (english) then
    if (streaking) then
      broadcastToAll("Streaking Kittens added", {1,1,1})
    else
      broadcastToAll("Streaking Kittens removed", {1,1,1})
    end
  else
    if (streaking) then
      broadcastToAll("Streaking Kittens añadido", {1,1,1})
    else
      broadcastToAll("Streaking Kittens eliminado", {1,1,1})
    end
  end
end

function getPlayers()
    players = getSeatedPlayers()
    for v, k in ipairs(players) do
      num_players = num_players + 1
      player_colors[v] = k
    end
end

function prepararPartida()
  -- Select the Language
  if (english) then
    lang = lang['ENGLISH']
  else
    lang = lang['SPANISH']
  end

  -- Clear the board
  checker.clearButtons()
  checker.setPositionSmooth(checker_pos.position)
  checker.setRotationSmooth(checker_pos.rotation)

  -- Takes out the three main stacks
  for i=1,8 do
    default_box.takeObject({
      index = english == true and 8 or 0,
      position = {x = 20, y = 2+i/3, z = 7.11},
      callback_function = function (obj) obj.destruct() end
    })
  end

  if (nsfw) then
    nsfw_box.takeObject(deck_pos)
    nsfw_box.takeObject(defuse_pos)
    nsfw_box.takeObject(exploding_pos)

    for i=0,2 do
      default_box.takeObject({
        position = {x = 10, y = 2+i/3, z = 7.11},
        callback_function = function (obj) obj.destruct() end
      })
    end

  else
    default_box.takeObject(deck_pos)
    default_box.takeObject(defuse_pos)
    default_box.takeObject(exploding_pos)
  end

  Wait.frames(function () empezarPartida () end, 200)
end


function empezarPartida()
  deck_default = scripted_zone.getObjects()[1]
  deck_defuse = defuse_scripted_zone.getObjects()[1]
  deck_exploding = exploding_scripted_zone.getObjects()[1]

  -- Set the player count
  getPlayers()

  if (imploding) then
    single_imploding_after = objectFromBox("IMPLODING AFTER", default_box)
    default_box.takeObject({
      position = {37.5,1,19.3}, -- Table corner
      rotation = deck_pos.rotation,
      guid = single_imploding_after['guid']
    })

    deck_imploding = objectFromBox("IMPLODING DECK", default_box)
    default_box.takeObject({
      position = deck_pos.position,
      rotation = deck_pos.rotation,
      guid = deck_imploding['guid']
    })
  end

  if (streaking) then
    deck_streaking = objectFromBox("STREAKING DECK", default_box)
    default_box.takeObject({
      position = deck_pos.position,
      rotation = deck_pos.rotation,
      guid = deck_streaking['guid']
    })

    streaking_exploding = objectFromBox("STREAKING EXPLODING", default_box)
    default_box.takeObject({
      position = exploding_pos.position,
      rotation = exploding_pos.rotation,
      guid = streaking_exploding['guid']
    })
  end

  --Shuffle all cards to deal out the action cards
  Wait.frames(function ()
    deck_default = scripted_zone.getObjects()[1]
    deck_defuse = defuse_scripted_zone.getObjects()[1]
    deck_exploding = exploding_scripted_zone.getObjects()[1]

    deck_default.shuffle()
    deck_exploding.shuffle()
    deck_defuse.shuffle()
  end, 90)

  Wait.frames(function ()
    -- Give each player the corresponding cards
    deck_default = scripted_zone.getObjects()[1]
    if (not imploding and not streaking) then
      deck_default.dealToAll(4)
    elseif (imploding) then
      deck_default.dealToAll(6)
    elseif (streaking) then
      deck_default.dealToAll(7)
    end

    -- Give each player 1 defuse card
    deck_defuse.dealToAll(1)
  end, 180)


  Wait.frames(function ()
    -- Put in the kittens (num_players - 1 or -2)
    local center = deck_default.getPosition()
    local params = {}
    params.position = center
    params.position.y = 2
    params.rotation = {180, 0, 0}

    single_imploding_before = objectFromBox("IMPLODING BEFORE", default_box)
    if (not imploding and not streaking) then
      for i=1,num_players-1 do
        deck_exploding.takeObject(params)
      end
    elseif (imploding and not streaking) then
      default_box.takeObject({
        position = deck_pos.position,
        rotation = deck_pos.rotation,
        guid = single_imploding_before['guid']
      })
      for i=1, num_players-2 do
        deck_exploding.takeObject(params)
      end
    elseif (streaking and not imploding) then
      for i=1,num_players do
        deck_exploding.takeObject(params)
      end
    elseif (imploding and streaking) then
      default_box.takeObject({
        position = deck_pos.position,
        rotation = deck_pos.rotation,
        guid = single_imploding_before['guid']
      })
      for i=1,num_players-1 do
        deck_exploding.takeObject(params)
      end
    end
    instruction_pos = instructions_book.getPosition()
  end, 270)

  Wait.frames(function ()
    --Create the cleanup button
    deck_defuse = defuse_scripted_zone.getObjects()[1]
    deck_default.setName("")
    local button = {}
    button.click_function = 'limpiarMesa'
    button.label = lang['START']
    button.position = {1.5, 0.6, 2.6}
    button.width = 2600
    button.height = 500
    button.font_size = 350
    deck_defuse.createButton(button)
  end, 360)
end

function limpiarMesa()
  default_box.destruct()
  nsfw_box.destruct()
  deck_default = scripted_zone.getObjects()[1]
  deck_defuse = defuse_scripted_zone.getObjects()[1]
  deck_exploding = exploding_scripted_zone.getObjects()[1]

  -- remove the start button
  deck_defuse.clearButtons()

  --Remove the unused decks
  if (deck_exploding != null) then
    deck_exploding.destruct()
  else
    exploding_scripted_zone.getObjects()[1].destruct()

  end

  -- reinsert the corresponding defuses
  if (num_players > 2) then
      deck_default.putObject(deck_defuse)
  else
      new_defuse = deck_defuse.cut(2)
      deck_default.putObject(new_defuse[2])
      deck_defuse.destruct()
  end

  crearControlesCartas()

  -- Shuffle the actions deck again
  Wait.frames(function() deck_default.shuffle() end, 60)
  --[[The 60 frames wait before shuffling prevents the exploding
  kitten being on top if buttons are pressed too fast]]

  -- Chooses a random player to start
  broadcastToAll(Player.getPlayers()[math.random(#Player.getPlayers())].steam_name.." "..lang['FIRST'], {1,1,1})
end

function crearControlesCartas()
  -- Coordinate values that determine the position releative to the checker
  col_1 = 0
  col_2 = -12
  col_3 = -24

  -- default card actions are in the 1st column
  crearBoton(checker, lang['SHUFFLE'], 'barajar', {-5, 0.2, col_1})
  crearBoton(checker, lang['BLINDFOLD'], 'cegarOponentes', {-2, 0.2, col_1})
  crearBoton(checker, lang['SEETHEFUTURE3'], 'verElFuturo3', {1, 0.2, col_1})
  crearBoton(checker, lang['DRAW'], 'robar', {21, 0.2, 8.25}, 2100)

  if (imploding) then -- imploding card actions are in the 2nd column
    crearBoton(checker, lang['DRAWFROMBOTTOM'], 'robarDelFondo', {-5, 0.2, col_2})
  end

  if (streaking) then -- streaking card actions are in the 3rd colun
    crearBoton(checker, lang['SWAPTOPBOTTOM'], 'intercambiaArribaAbajo', {-5, 0.2, col_3})
    crearBoton(checker, lang['SEETHEFUTURE5'], 'verElFuturo5', {1, 0.2, col_3})
    crearBoton(checker, lang['CATOMICBOMB'], 'bombaGatomica', {-2, 0.2, col_3})
  end
  turn_signal.setPosition({-5.1, 1.05, 15.2})
  turn_signal.setLock(false)
end

function verElFuturo3(objectButtonClicked, playerColorClicked)
  checker.clearButtons()
  blindfoldToggle = true
  cegarOponentes(objectButtonClicked, playerColorClicked)
  deck_default = scripted_zone.getObjects()[1]
  deck_pos = deck_default.getPosition()
  num = 24.3 -- first card is put 24 units away from deck, 2nd is 16 away and 3rd is 8 away

  Wait.frames(function ()
    upper_row_text.setValue('____________          ____________          ____________                                                                    ')
    lower_row_text.setValue('____________          ____________          ____________                                                                    ')
  end, 100)


  for i=0, 2 do
    showCard()
  end
  crearBoton(checker, lang['RETURNCARDS'], 'devolver3', {4, 0.2, col_1})
end

  function verElFuturo5(objectButtonClicked, playerColorClicked)
    checker.clearButtons()
    blindfoldToggle = true
    cegarOponentes(objectButtonClicked, playerColorClicked)
    deck_default = scripted_zone.getObjects()[1]
    deck_pos = deck_default.getPosition()
    num = 40.5

    Wait.frames(function ()
      upper_row_text.setValue('____________          ____________          ____________          ____________          ____________')
      lower_row_text.setValue('____________          ____________          ____________          ____________          ____________')
    end, 100)

    for i=0, 4 do
      showCard()
    end
  crearBoton(checker, lang['RETURNCARDS'], 'devolver5', {4, 0.2, col_3})
end

function showCard()
    deck_default = scripted_zone.getObjects()[1]
    flip = {
      x = 0,
      y = 180,
      z = 0
    }

    card_position = {
      x = deck_pos.x + num,
      y = deck_pos.y+1.5,
      z = deck_pos.z,
    }

    deck_default.takeObject({
      position = card_position,
      callback_function = function (obj)
        obj.setRotationSmooth(flip, false, false)
      end
    })

    num = num - 8.1
end

function returnCard(i)
  scripted_card_n = getObjectFromGUID(script_card_n_guid[i])
  card = scripted_card_n.getObjects()[1]
  if (card != nil) then -- prevents errors when there are less than n cards left
    flip = {
      x = 0,
      y = 180,
      z = 180
    }
    card.setRotationSmooth(flip, false, false)
    --[[Sets the card upside down. A better option than flip() since it doesn't
    flip the card twice if it's already flipped]]

    card.setPositionSmooth(
    {
      x = deck_pos.x,
      y = deck_pos.y + 0.5 + i/4,
      z = deck_pos.z,
    },
    false, false)
  end

end

function devolver(pos_in_table)
  for i=1, pos_in_table do
    returnCard(i)
  end

  upper_row_text.setValue(' ')
  lower_row_text.setValue(' ')

  checker.removeButton(0)
  crearControlesCartas()
end

function devolver3(objectButtonClicked, playerColorClicked)
  devolver(3)
  blindfoldToggle = false
  cegarOponentes(objectButtonClicked, playerColorClicked)
end

function devolver5(objectButtonClicked, playerColorClicked)
  devolver(5)
  blindfoldToggle = false
  cegarOponentes(objectButtonClicked, playerColorClicked)
end

function barajar()
  deck_default = scripted_zone.getObjects()[1]
  deck_default.shuffle()
end

function robar(objectButtonClicked, playerColorClicked)
  deck_default = scripted_zone.getObjects()[1]
  deck_default.deal(1,playerColorClicked)
  broadcastToAll(Player[playerColorClicked].steam_name .. " " .. lang['DRAWMSG'], {1,1,1})
end

function cegarOponentes(objectButtonClicked, playerColorClicked)
  if (blindfoldToggle == true) then
    broadcastToColor(lang['BLINDFOLDED'], playerColorClicked, {1,1,1})
  else
    broadcastToColor(lang['UNBLINDFOLDED'], playerColorClicked, {1,1,1})
  end

  playerList = Player.getPlayers()
  for _, playerReference in ipairs(playerList) do
    -- toggles blindfold status of all players except the clicker
    if (playerReference['color'] != 'Grey' and playerReference['color'] != playerColorClicked) then
      if (blindfoldToggle == true) then
        playerReference.blindfolded = true
      else
        playerReference.blindfolded = false
      end
    end
  end
  blindfoldToggle = not blindfoldToggle
end


function robarDelFondo(objectButtonClicked, playerColorClicked)
  deck_default = scripted_zone.getObjects()[1]
  handPosition = Player[playerColorClicked].getHandTransform(1)['position']
  params = {
    position = handPosition,
    smooth = true,
    top = false,
    callback_function = function(obj) obj.flip() end,
  }
  deck_default.takeObject(params)
end

function intercambiaArribaAbajo()
  deck_default = scripted_zone.getObjects()[1]
  deck_pos = deck_default.getPosition()
  -- 1. Separating the first card
  deck_default.takeObject({
    position = {
      x = deck_pos.x+7,
      y = deck_pos.y,
      z = deck_pos.z,
    },
    callback_function = function(obj) secondStep(obj) end

  })

  -- obj = former first card

  -- 2. Putting the last card on top of the deck
  function secondStep(obj)
    deck_default.takeObject({
      position = deck_default.getPosition(),
      top = false,
    })

    -- 3. Putting the deck on top of the individual card
    Wait.frames(function () obj.putObject(deck_default) end, 10)
  end
end

function bombaGatomica()
  deck_default = scripted_zone.getObjects()[1]
  deck_default.shuffle()
  cards_table = deck_default.getObjects()
  deck_pos = deck_default.getPosition()
  Wait.frames(takeOutExploding, 30)
end

function takeOutExploding()
  x = 0
  for i, card in pairs(cards_table) do
    if (card['description'] == 'exploding') then
      deck_default.takeObject({
        position = {
          --[[The position could be entirely deck_pos, this vertical
          movement is to make the animation more natural]]
          x = deck_pos.x,
          y = deck_pos.y + 2,
          z = deck_pos.z,
        },

        index = i - x - 1
      })
      --[[Every time we remove a card, indexes shift by 1. We keep the
      count here to offset the .takeObject the corresponding ammount]]
      x = x + 1
    end
    Wait.frames(function () end, 5)
  end
end

function crearBoton(objeto, texto, funcion, posicionRelativa, reduccionHorizontal)
  if (reduccionHorizontal == nil) then reduccionHorizontal = 0 end
  local button = {}
  button.click_function = funcion
  button.label = texto
  button.position = posicionRelativa
  button.width = 4800 - reduccionHorizontal
  button.height = 1000
  button.font_size = 450
  button.rotation = {0,270,0}

  objeto.createButton(button)
end

function objectFromBox(name, box)
    -- Aux function, needed since object's GUIDs change when they are added/removed to the box.
    decks = box.getObjects()
    for k,v in pairs(decks) do
      if string.find(v['name'], name) or v['name'] == 'Card Custom' then -- There is a spanish card without name, so it's "Card Custom"
        return decks[k]
      end
    end
end

function printError(str)
    print('[ff0000][ERROR][-] ' .. str)
end

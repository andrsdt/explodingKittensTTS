deck_default = {}
deck_default_guid = 'd8428f'

deck_exploding = {}
deck_exploding_guid = '0eae9d'

deck_defuse = {}
deck_defuse_guid = '329f35'

deck_imploding = {}
deck_imploding_guid = '17df01'
deck_streaking = {}
deck_streaking_guid = 'b8db4f'

instructions_book_guid = '5a3f0e'
turn_signal_guid = '7a3b65'
single_streaking_guid = '11c500'
single_imploding_before_guid = '2d5acc'
single_imploding_after_guid = '973c0f'
all_explodings_guid = {'b5aa73','af2021','11c500','d04758','9ddd38'}

bloque_modo_guid = 'b9f95b'
scripted_zone_guid = 'a708c1'
script_card_n_guid = {'4261dc','a12864','16445c','16ab9d','18d3cf'}

upper_text_row_guid = 'd7b5e1'
lower_text_row_guid = 'f348d1'

players = {}
num_players = 0
player_colors = {}

exploding = true
imploding = false
streaking = false

function onLoad()

  -- DEFAULT CARDS
  deck_default = getObjectFromGUID(deck_default_guid)
  deck_exploding = getObjectFromGUID(deck_exploding_guid)
  deck_defuse = getObjectFromGUID(deck_defuse_guid)

  -- IMPLODING KITTENS CARDS
  deck_imploding = getObjectFromGUID(deck_imploding_guid)
  single_imploding_before = getObjectFromGUID(single_imploding_before_guid)
  single_imploding_after = getObjectFromGUID(single_imploding_after_guid)

  -- STREAKING KITTENS CARDS
  deck_streaking = getObjectFromGUID(deck_streaking_guid)
  single_streaking = getObjectFromGUID(single_streaking_guid)

  -- OTHER OBJECTS
  instructions_book = getObjectFromGUID(instructions_book_guid)
  bloque_modo = getObjectFromGUID(bloque_modo_guid)

  game_board = getObjectFromGUID(game_board_guid)
  turn_signal = getObjectFromGUID(turn_signal_guid)
  scripted_zone = getObjectFromGUID(scripted_zone_guid)
  deck_pos = deck_default.getPosition()

  upper_row_text = getObjectFromGUID(upper_text_row_guid)
  lower_row_text = getObjectFromGUID(lower_text_row_guid)

  -- (Instantiating buttons)
  crearBoton(bloque_modo, 'Exploding Kittens', 'setExploding', {-5, 0.2, 0})
  crearBoton(bloque_modo, 'Imploding Kittens', 'setImploding', {-2, 0.2, 0})
  crearBoton(bloque_modo, 'Streaking Kittens', 'setStreaking', {1, 0.2, 0})
  crearBoton(bloque_modo, 'All expansions', 'setAll', {4, 0.2, 0})
end

function setExploding()
  empezarPartida()
end

function setImploding()
  imploding = true
  empezarPartida()
end

function setStreaking()
  streaking = true
  empezarPartida()
end

function setAll()
  imploding = true
  streaking = true
  empezarPartida()
end

function getPlayers()
    players = getSeatedPlayers()
    num_players = 0
    for v, k in ipairs(players) do
      num_players = num_players + 1
      player_colors[v] = k
    end
end

function empezarPartida()
  -- Clear the board
  bloque_modo.clearButtons()

  if (not imploding) then
    getObjectFromGUID(deck_imploding_guid).destruct()
    getObjectFromGUID(single_imploding_before_guid).destruct()
    getObjectFromGUID(single_imploding_after_guid).destruct()
  end

  if (not streaking) then
    getObjectFromGUID(deck_streaking_guid).destruct()
    getObjectFromGUID(single_streaking_guid).destruct()
  end

  -- Set the player count
  getPlayers()

  -- Mix the decks

  imploding_pos = deck_imploding.getPosition()
  if (imploding) then
    deck_default.putObject(deck_imploding)
    single_imploding_after.setPositionSmooth(imploding_pos)
  end

  if (streaking) then
    deck_exploding.putObject(single_streaking)
    deck_default.putObject(deck_streaking)
  end

  instruction_pos = instructions_book.getPosition()
  turn_signal.setPositionSmooth({
    x = instruction_pos.x,
    y = instruction_pos.y + 1,
    z = instruction_pos.z,
  })

  --Shuffle all cards to deal out the action cards
  deck_default.shuffle()
  deck_exploding.shuffle()
  deck_defuse.shuffle()

  -- Give each player the corresponding cards
  if (not imploding and not streaking) then
    deck_default.dealToAll(4)
  elseif (imploding) then
    deck_default.dealToAll(6)
  elseif (streaking) then
    deck_default.dealToAll(7)
  end

  -- Give each player 1 defuse card
  deck_defuse.dealToAll(1)

  -- Put in the kittens (num_players - 1 or -2)
  local center = deck_default.getPosition()
  local params = {}
  params.position = center
  params.position.y = 2
  params.rotation = {180, 0, 0}

  if (not imploding and not streaking) then
    for i=1,num_players-1 do
      deck_exploding.takeObject(params)
    end
  elseif (imploding and not streaking) then
    deck_default.putObject(single_imploding_before)
    for i=1, num_players-2 do
      deck_exploding.takeObject(params)
    end
  elseif (streaking and not imploding) then
    for i=1,num_players do
      deck_exploding.takeObject(params)
    end
  elseif (imploding and streaking) then
    deck_default.putObject(single_imploding_before)
    for i=1,num_players-1 do
      deck_exploding.takeObject(params)
    end
  end

  --Create the cleanup button
  local button = {}
  button.click_function = 'limpiarMesa'
  button.label = 'Comenzar'
  button.position = {1.5, 0.6, 2.6}
  button.width = 2600
  button.height = 500
  button.font_size = 350
  deck_defuse.createButton(button)
end

function limpiarMesa()
    -- remove the start button
    deck_defuse.clearButtons()

    --Remove the unused decks
    if (deck_exploding != null) then
      deck_exploding.destruct()
    else
        --[[ If there is only 1 card left of the deck, deck_exploding won't exist
        anymore so we try to destruct each exploding kitten card individually]]
      for i, exploding_guid in ipairs(all_explodings_guid) do
        pcall(function () getObjectFromGUID(exploding_guid).destruct() end)
      end
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
    Wait.frames(function() deck_default.shuffle() end, 100)
    --[[The 100 frames wait before shuffling prevents the exploding
    kitten being on top if buttons are pressed too fast]]

    -- Chooses a random player to start
    broadcastToAll("Empieza ".. Player.getPlayers()[math.random(#Player.getPlayers())].steam_name, {1,1,1})
end

function crearControlesCartas()
  -- Coordinate values that determine the position releative to the checker
  col_1 = 0
  col_2 = -12
  col_3 = -24

  -- default card actions are in the 1st column
  crearBoton(bloque_modo, 'Barajar', 'barajar', {-5, 0.2, col_1})
  crearBoton(bloque_modo, 'Cegar a oponentes', 'cegarOponentes', {-2, 0.2, col_1})
  crearBoton(bloque_modo, 'Ver el futuro (x3)\nAlterar el futuro (x3)', 'verElFuturo3', {1, 0.2, col_1})

  if (imploding) then -- imploding card actions are in the 2nd column
    crearBoton(bloque_modo, 'Roba del fondo', 'robarDelFondo', {-5, 0.2, col_2})
  end

  if (streaking) then -- streaking card actions are in the 3rd colun
    crearBoton(bloque_modo, 'Intercambia extremos', 'intercambiaArribaAbajo', {-5, 0.2, col_3})
    crearBoton(bloque_modo, 'Ver el futuro (x5)\nAlterar el futuro (x5)', 'verElFuturo5', {1, 0.2, col_3})

    crearBoton(bloque_modo, 'Bomba gatómica', 'bombaGatomica', {-2, 0.2, col_3})

  end
end

function verElFuturo3(objectButtonClicked, playerColorClicked)
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
  crearBoton(bloque_modo, 'Devolver', 'devolver3', {4, 0.2, col_1})
end

  function verElFuturo5(objectButtonClicked, playerColorClicked)
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
  crearBoton(bloque_modo, 'Devolver', 'devolver5', {4, 0.2, col_3})
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

  -- removes the button after clicking it.
  -- workaround to track the position. Removes the last added button
  botones = bloque_modo.getButtons()
  bloque_modo.removeButton(#botones-1)
end

function devolver3(objectButtonClicked, playerColorClicked)
  devolver(3)
  cegarOponentes(objectButtonClicked, playerColorClicked, true)
end

function devolver5(objectButtonClicked, playerColorClicked)
  devolver(5)
  cegarOponentes(objectButtonClicked, playerColorClicked, true)
end

function barajar()
  deck_default = scripted_zone.getObjects()[1]
  deck_default.shuffle()
end

function cegarOponentes(objectButtonClicked, playerColorClicked, devolverVision)
  playerList = Player.getPlayers()
  for _, playerReference in ipairs(playerList) do
    -- toggles blindfold status of all players except the clicker
    if (playerReference['color'] != 'Grey' and playerReference['color'] != playerColorClicked) then
      if (devolverVision) then
        playerReference.blindfolded = false
      else
        playerReference.blindfolded = not playerReference.blindfolded
      end
    end
  end
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

function crearBoton(objeto, texto, funcion, posicionRelativa)
  local button = {}
  button.click_function = funcion
  button.label = texto
  button.position = posicionRelativa
  button.width = 4800
  button.height = 1000
  button.font_size = 450
  button.rotation = {0,270,0}

  objeto.createButton(button)
end

function printError(str)
    print('[ff0000][ERROR][-] ' .. str)
end
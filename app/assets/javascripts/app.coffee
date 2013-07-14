current_match = 1
ANIMATION_SPEED = 300

init = ->
  current_match = parseInt($('#current_game').text())
  show_statistics()
  $("#pins .pin").animate({bottom: -19;}, 2*ANIMATION_SPEED)
  $("#right_arrow").animate({bottom: -20;}, 4*ANIMATION_SPEED)
  $("#bottom_arrow").animate({bottom: -40;}, 4*ANIMATION_SPEED)

  $("a#new_game_link").bind 'click', (event) =>
    new_game()

  $("#pins .pin").bind 'click', (event) ->
    toggle_pin($(this))

  $("#right_arrow").bind 'click', (event) ->
    advance_game()

  $("#bottom_arrow").bind 'click', (event) ->
    knock_down_all_pins()

  $( document ).keydown (event) ->
    if event.which > 48 and event.which < 58
      toggle_pin($("#pin"+(event.which-48)))
    if event.which is 48
      toggle_pin($("#pin10"))

  $( document ).shortkeys({
    'a': knock_down_all_pins,
    's': advance_game
  })

new_game = ->
  $.post window.location.href, (data) ->
    $("#scoreboard").append(data)
    current_match += 1
    reset_all_pins()
    show_statistics()

advance_game = ->
  current_game_id = $("#match#{current_match}top").data('game-id')
  path = "#{window.location.pathname}/#{current_game_id}"
  $.post path,
    id: current_game_id,
    _method: "PUT",
    score: count_collapsed_pins() 
  , ((data) ->

    $("#match#{current_match}top, #match#{current_match}bottom").remove()
    $("#scoreboard").append(data)
    if $("#match#{current_match}bottom").data('advance-frame')
      reset_all_pins()
    if $("#match#{current_match}bottom").data('new-game')
      new_game()
    show_statistics()
  )
  
toggle_pin = (pin) ->
  if pin.attr('data-visible') is '0'
    pin.attr('data-visible', '1')
    pin.animate({bottom: -19;}, ANIMATION_SPEED)
  else
    pin.attr('data-visible', '0')
    pin.animate({bottom: -100;}, ANIMATION_SPEED)

show_statistics = ->

  $("#current_game").text('' + current_match)
  $("#current_frame").text($("#match#{current_match}top").data('frame'))
  $("#current_ball").text($("#match#{current_match}top").data('ball'))  

reset_all_pins = ->
  $("#pins .pin").each (index) ->
    $(this).attr('data-visible', '1')
    $(this).animate({bottom: -19;}, ANIMATION_SPEED)
  true

knock_down_all_pins = ->
  $("#pins .pin").each (index) ->
    $(this).attr('data-visible', '0')
    $(this).animate({bottom: -100;}, ANIMATION_SPEED)
  true

count_collapsed_pins = ->
  $('#pins .pin[data-visible="0"]').size()

$(document).ready ->
  init()

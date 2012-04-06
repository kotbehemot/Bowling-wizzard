current_match = 1
current_frame = 1
current_ball = 1
visible_current_ball = 1
visible_current_frame = 1
total_score = 0
current_frame_score = 0
previous_frame_score = 0
previous2_frame_score = 0
current_strike = false
current_spare = false
previous_strike = false
previous2_strike = false
previous_spare = false
ANIMATION_SPEED = 300

init = ->
  
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

  $( document ).shortkeys({
    'a': knock_down_all_pins,
    's': advance_game
  })

new_game = ->
  $("#match" + current_match + "_summary").text('' + total_score)
  current_match += 1
  current_frame = 1
  current_ball = 1
  total_score = 0
  visible_current_ball = 1
  visible_current_frame = 1
  current_frame_score = 0
  previous_frame_score = 0
  previous2_frame_score = 0
  current_strike = false
  current_spare = false
  previous_strike = false
  previous2_strike = false
  previous_spare = false
  add_new_match_row()
  reset_all_pins()
  show_statistics()



advance_game = ->
  pins_knocked_down_this_turn = count_collapsed_pins()
  current_score = pins_knocked_down_this_turn - current_frame_score
  current_frame_score = current_frame_score + current_score
  total_score = total_score + current_score

  if previous_strike and current_frame < 11
    $("#match" + current_match + "_frame" + (current_frame-1) + "_field4").text(current_frame_score + previous_frame_score);
    total_score = total_score + current_score
  if previous_spare and visible_current_ball is 1
    $("#match" + current_match + "_frame" + (current_frame-1) + "_field4").text(current_frame_score + previous_frame_score);
    total_score = total_score + current_score
  if previous2_strike and previous_strike
    $("#match" + current_match + "_frame" + (current_frame-2) + "_field4").text(current_frame_score + previous_frame_score + previous2_frame_score)
    if current_frame < 12
      total_score = total_score + current_score

  if current_score is 0
    current_score = "-"
  if current_frame_score is 10 and (current_frame > 10)
    current_score = 'X'
    reset_all_pins()
  if current_frame_score is 10 and visible_current_ball is 1
    current_score = "X"
    current_strike = true
  if current_frame < 11 and current_frame_score is 10 and current_ball is 2
    current_score = "/"
    current_spare = true

  $("#match" + current_match + "_frame" + visible_current_frame + "_field" + visible_current_ball).text(current_score);

  tmp_current_frame_score = current_frame_score
  if current_frame > 10
    tmp_current_frame_score = tmp_current_frame_score + previous_frame_score
  if current_frame is 12
    tmp_current_frame_score = tmp_current_frame_score + previous2_frame_score

  $("#match" + current_match + "_frame" + visible_current_frame + "_field4").text(tmp_current_frame_score);
  
  current_ball = current_ball + 1
  visible_current_ball = visible_current_ball + 1

  if pins_knocked_down_this_turn is 10 or current_frame > 10 or current_ball > 2
    advance_frame()
  if current_frame > 12 or (current_frame is 11 and previous_strike is false and previous_spare is false) or (current_frame > 11 and previous_strike is false and previous2_strike is false)
    new_game()

  show_statistics()

toggle_pin = (pin) ->
  if pin.attr('data-visible') is '0'
    pin.attr('data-visible', '1')
    pin.animate({bottom: -19;}, ANIMATION_SPEED)
  else
    pin.attr('data-visible', '0')
    pin.animate({bottom: -100;}, ANIMATION_SPEED)

show_statistics = ->

  $("#current_game").text('' + current_match)
  $("#current_frame").text('' + visible_current_frame)
  $("#current_ball").text('' + visible_current_ball)
  $("#match" + current_match + "_summary").text('' + total_score)

advance_frame = ->
  reset_all_pins()
  current_frame = current_frame + 1
  current_ball = 1
  visible_current_ball = current_ball
  visible_current_frame = current_frame
  previous2_frame_score = previous_frame_score
  previous_frame_score = current_frame_score
  current_frame_score = 0
  previous2_strike = previous_strike
  previous_strike = current_strike
  previous_spare = current_spare
  current_strike = false
  current_spare = false

  if visible_current_frame is 11
    visible_current_frame = 10
    if previous_strike
      visible_current_ball = 2
    else
      visible_current_ball = 3
  if visible_current_frame is 12
    visible_current_frame = 10
    visible_current_ball = 3

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

add_new_match_row = ->
  new_row = $("#new_match_template").clone(false)
  new_row.find('[id*="match0"]').andSelf().each ->
    $(this).attr('id', replace_ids_in_template);
  new_row.find('#match' + current_match + 'title').text('Game ' + current_match)
  $("#scoreboard").append(new_row.find("#match" + current_match + 'top'))
  $("#scoreboard").append(new_row.find("#match" + current_match + 'bottom'))

replace_ids_in_template = (i, id) ->
  id.replace('match0','match'+current_match);

$(document).ready ->
  init()

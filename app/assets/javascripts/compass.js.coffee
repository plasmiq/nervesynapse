# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$timer = ''
jQuery ->
  $timer = $('#timer')
  $image = $('#body_compass .image')
  if $image.length > 0
    getImage(false)

ran_out_of_time = true

travel = ($img) ->
  $img.click (e)->
    $img.unbind 'click'
    ran_out_of_time = false
    $timer.stop()
    getImage($img, e)

getImage = (prevImg, e) ->
  $image = $('#body_compass .image')
  $.ajax
    type: 'get'
    url: '/compass/get_image'
    data:
      click_area: getClickArea(prevImg, e)
    dataType: 'json'
    success: (data) ->
      newImg = new Image()
      $newImg = $(newImg)
      $newImg.hide()
      newImg.onload = ->
        #Bind click to new image
        travel($newImg)

        $image.append($newImg)

        marginTop = ((window.innerHeight / 2) - ($newImg.height() / 2)) - 40
        $newImg.css('margin-top', marginTop + 'px')

        if prevImg
          prevImg.remove()
          $newImg.fadeIn()
        else
          $newImg.fadeIn()
        $timer.width('21px')
        ran_out_of_time = true
        $newImg.css('display', 'block')
        $timer.animate {
          width: '605px'
        }, 3000, ->
          if ran_out_of_time == true
            window.location.replace($image.attr('data_finish_url'))
      newImg.src = data.src

getClickArea = ($img, e) ->
  return '' unless $img
  w = $img.width()
  h = $img.height()
  x = e.pageX - $img.offset().left
  y = e.pageY - $img.offset().top
  col = parseInt(x / (w / 3)) + 1
  row = parseInt(y / (h / 3))
  return col + (row * 3)

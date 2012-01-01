# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $image = $('#body_compass .image')
  if $image.length > 0
    getImage(false)

travel = ($img) ->
  $img.click (e)->
    $loader = $('.ajax_loader')
    $loader.fadeIn()
    $img.unbind 'click'
    getImage($img, e)

getImage = (prevImg, e) ->
  $image = $('#body_compass .image')
  $loader = $('.ajax_loader')
  $.ajax
    type: 'get'
    url: '/compass/get_image'
    data:
      click_area: getClickArea(prevImg, e)
    dataType: 'json'
    success: (data) ->
      newImg = new Image()
      $newImg = $(newImg)
      newImg.onload = ->
        travel($newImg)
        $newImg.hide()
        $image.append($newImg)
        $loader.fadeOut()

        marginTop = ((window.innerHeight / 2) - ($newImg.height() / 2)) - 40
        $newImg.css('margin-top', marginTop + 'px')
        $newImg.css('display', 'block')

        if prevImg
          prevImg.fadeOut()
          $newImg.delay(500).fadeIn()
        else
          $newImg.fadeIn()
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

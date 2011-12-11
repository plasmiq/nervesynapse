# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $image = $('#body_compass .image')
  if $image.length > 0
    getImage(false)

travel = ($img) ->
  $img.click ->
    getImage($img)

getImage = (prevImg) ->
  $image = $('#body_compass .image')
  $.ajax
    type: 'get'
    url: '/compass/get_image'
    dataType: 'json'
    success: (data) ->
      newImg = new Image()
      $newImg = $(newImg)
      newImg.onload = ->
        travel($newImg)
        $newImg.hide()
        $image.append($newImg)
        if prevImg
          prevImg.fadeOut()
          $newImg.delay(500).fadeIn()
        else
          $newImg.fadeIn()
      newImg.src = data.src
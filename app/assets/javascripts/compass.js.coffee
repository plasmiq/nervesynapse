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
        $prevImg = $(prevImg)

        #Bind click to new image
        travel($newImg)

        $image.append($newImg)

        width = $newImg.width()
        height = $newImg.height()
        start_width = width * 0.5
        start_height = height * 0.5
        start_top = ((window.innerHeight / 2) - (start_height / 2)) - 40
        start_left = (window.innerWidth / 2) - (start_width / 2)
        end_top = ((window.innerHeight / 2) - (height / 2)) - 40
        end_left = ((window.innerWidth / 2) - (width / 2))

        $prevImg.css('z-index', '1000')
        $newImg.css('z-index', '100')
        $newImg.css('top', start_top + 'px')
        $newImg.css('left', start_left + 'px')
        $newImg.css('opacity', '0')
        $newImg.css('width', start_width)
        $newImg.css('height', start_height)

        if prevImg
          prevImgWidth = $prevImg.width()
          prevImgHeight = $prevImg.height()
          endPrevImgWidth = prevImgWidth * 2
          endPrevImgHeight = prevImgHeight * 2
          prevImgTop = $prevImg.position().top
          prevImgLeft = $prevImg.position().left
          endPrevImgTop = prevImgTop - ((endPrevImgHeight - prevImgHeight) / 2)
          endPrevImgLeft = prevImgLeft - ((endPrevImgWidth - prevImgWidth) / 2)

          $prevImg.animate {
            width: endPrevImgWidth + 'px'
            height: endPrevImgHeight + 'px'
            top: endPrevImgTop + 'px'
            left: endPrevImgLeft + 'px'
            opacity: '0'
          }, 1000, ->
            $prevImg.remove()
            $newImg.css('z-index', '1000')
          $newImg.delay(100).show()
          $newImg.delay(200).animate {
            opacity: '1'
            width: width + 'px'
            height: height + 'px'
            top: end_top + 'px'
            left: end_left + 'px'
          }, 1000
        else
          $newImg.show()
          $newImg.animate {
            opacity: '1'
            width: width + 'px'
            height: height + 'px'
            top: end_top + 'px'
            left: end_left + 'px'
          }, 1000
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

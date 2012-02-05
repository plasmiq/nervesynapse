# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$timer = ''
jQuery ->
  if($('.body_compass_index').length > 0)
    $timer = $('#timer')
    $image = $('#body_compass .image')
    $('#container').height(window.innerHeight - 50)
    #new Cursor
    getImage(false)


class Cursor2
  constructor: (e)->
    @cursor = $('#cursor')
    @mouseX = e.clientX
    @mouseY = e.clientY
    @setCursorPosition()
    @clickAnimation()


  setCursorPosition:  ->
    @cursor.css('top', @mouseY - 50).css('left', @mouseX).show()

  clickAnimation: ->
    _this = @
    $('body').addClass('no_cursor')
    @cursor.animate {
      width: '72px',
      height: '72px'
      top: ((_this.mouseY - 50) - 16) + 'px'
      left: (_this.mouseX - 16) + 'px'
    }, {
      duration: 200,
      complete: ->
        _this.cursor.hide().width(36).height(36).css('top', '0').css('left', '0')
        $('body').removeClass('no_cursor')
    }

class Cursor
  constructor: ->
    @cursor = $('#cursor')
    @container = $('#container')
    @headerWidth = 50
    @mouseX = 0
    @mouseY = 0
    @realTimeLoop = ''
    @trackMouse()
    @startRealTimeLoop()
    @bindSubstrateClick()

  startRealTimeLoop: ->
    _this = @
    @realTimeLoop = setInterval(
      ->
        _this.loopProcess()
      ,10
    )

  stopRealTimeLoop: ->
    clearInterval(@realTimeLoop)

  loopProcess: ->
    @setCursorPosition()

  trackMouse: ->
    _this = @
    @container.bind 'mousemove', (e) ->
      _this.mouseX = e.clientX
      _this.mouseY = e.clientY

  setCursorPosition: (e) ->
    @cursor.css('top', (@mouseY - 50) - 16).css('left', @mouseX - 16)

  clickAnimation: (e) ->
    _this = @
    _e = e
    @container.unbind('mousemove')
    @stopRealTimeLoop()
    @cursor.animate {
      width: '72px',
      height: '72px'
      top: ((@mouseY - 50) - 36) + 'px'
      left: (@mouseX - 36) + 'px'
    }, {
      duration: 200,
      complete: ->
        _this.cursor.width(36).height(36)
        _this.trackMouse()
        _this.startRealTimeLoop()
    }

  bindSubstrateClick: ->
    _this = @
    @cursor.bind 'click', (e) ->
      $image = $('.image img')
      $imagePosition = $image.position()
      $imageLeft = $imagePosition.left
      $imageRight = $imageLeft + $image.width()
      $imageTop = $imagePosition.top + _this.headerWidth
      $imageBottom = $imageTop + $image.height()

      #Check if image was clicked
      if e.pageX >= $imageLeft and e.pageX <= $imageRight and
         e.pageY >= $imageTop and e.pageY <= $imageBottom
        _this.clickAnimation(e)
        $image.click()




ran_out_of_time = true

travel = ($img) ->
  $img.click (e)->
    $img.unbind 'click'
    ran_out_of_time = false
    $timer.stop()
    new Cursor2(e)
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
          travel($newImg)
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
          }, 1000, ->
            travel($newImg)
        $timer.width('21px')
        ran_out_of_time = true
        $newImg.css('display', 'block')
        $timer.delay(1000).animate {
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

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if($('.body_compass_index').length > 0)
    $image = $('#body_compass .image')
    $('#container').height(window.innerHeight - 50)
    #getImage(false)
    t = new Travel()
    t.start()


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

class TravleImage
  constructor: (element) ->
    @$image = $(element)

class Travel
  constructor: ->
    @$image = $('#body_compass .image')
    @$newImg = ''
    @$timer = $('#timer')
    @$prevImg = ''
    @e = ''
    @ran_out_of_time = true
  positionAndShowNewImage: ->

  start: ->
    _this = @
    $.ajax
      type: 'get'
      url: '/compass/get_entry_point'
      dataType: 'json'
      success: (data) ->
        newImg = new Image()
        _this.$newImg = $(newImg)
        _this.$newImg.hide()
        newImg.onload = ->
          #Bind click to new image

          _this.$image.append(_this.$newImg)

          width = _this.$newImg.width()
          height = _this.$newImg.height()
          start_width = width * 0.5
          start_height = height * 0.5
          start_top = ((window.innerHeight / 2) - (start_height / 2)) - 40
          start_left = (window.innerWidth / 2) - (start_width / 2)
          end_top = ((window.innerHeight / 2) - (height / 2)) - 40
          end_left = ((window.innerWidth / 2) - (width / 2))

          _this.$newImg.css('z-index', '100')
          _this.$newImg.css('top', start_top + 'px')
          _this.$newImg.css('left', start_left + 'px')
          _this.$newImg.css('opacity', '0')
          _this.$newImg.css('width', start_width)
          _this.$newImg.css('height', start_height)
          _this.$newImg.show()
          _this.$newImg.animate {
            opacity: '1'
            width: width + 'px'
            height: height + 'px'
            top: end_top + 'px'
            left: end_left + 'px'
          }, 1000, ->
            _this.bindClick()
          _this.$timer.width('21px')
          _this.ran_out_of_time = true
          _this.$newImg.css('display', 'block')
          _this.$timer.delay(1000).animate {
            width: '605px'
          }, 3000, ->
            if _this.ran_out_of_time == true
              window.location.replace(_this.$image.attr('data_finish_url'))
        newImg.src = data.src
  nextStep: ->
    _this = @
    $.ajax
      type: 'get'
      url: '/compass/get_image'
      data:
        click_area: _this.getClickArea()
      dataType: 'json'
      success: (data) ->
        newImg = new Image()
        _this.$newImg = $(newImg)
        _this.$newImg.hide()
        newImg.onload = ->
          #Bind click to new image

          _this.$image.append(_this.$newImg)

          width = _this.$newImg.width()
          height = _this.$newImg.height()
          start_width = width * 0.5
          start_height = height * 0.5
          start_top = ((window.innerHeight / 2) - (start_height / 2)) - 40
          start_left = (window.innerWidth / 2) - (start_width / 2)
          end_top = ((window.innerHeight / 2) - (height / 2)) - 40
          end_left = ((window.innerWidth / 2) - (width / 2))

          _this.$prevImg.css('z-index', '1000')
          _this.$newImg.css('z-index', '100')
          _this.$newImg.css('top', start_top + 'px')
          _this.$newImg.css('left', start_left + 'px')
          _this.$newImg.css('opacity', '0')
          _this.$newImg.css('width', start_width)
          _this.$newImg.css('height', start_height)

          _this.bindClick()
          prevImgWidth = _this.$prevImg.width()
          prevImgHeight = _this.$prevImg.height()
          endPrevImgWidth = prevImgWidth * 2
          endPrevImgHeight = prevImgHeight * 2
          prevImgTop = _this.$prevImg.position().top
          prevImgLeft = _this.$prevImg.position().left
          endPrevImgTop = prevImgTop - ((endPrevImgHeight - prevImgHeight) / 2)
          endPrevImgLeft = prevImgLeft - ((endPrevImgWidth - prevImgWidth) / 2)

          _this.$prevImg.animate {
            width: endPrevImgWidth + 'px'
            height: endPrevImgHeight + 'px'
            top: endPrevImgTop + 'px'
            left: endPrevImgLeft + 'px'
            opacity: '0'
          }, 1000, ->
            _this.$prevImg.remove()
            _this.$newImg.css('z-index', '1000')
          _this.$newImg.delay(100).show()
          _this.$newImg.delay(200).animate {
            opacity: '1'
            width: width + 'px'
            height: height + 'px'
            top: end_top + 'px'
            left: end_left + 'px'
          }, 1000

          _this.$timer.width('21px')
          _this.ran_out_of_time = true
          _this.$newImg.css('display', 'block')
          _this.$timer.delay(1000).animate {
            width: '605px'
          }, 3000, ->
            if _this.ran_out_of_time == true
              window.location.replace(_this.$image.attr('data_finish_url'))
        newImg.src = data.src

  bindClick: ->
    _this = @
    @$newImg.bind 'click', (e) ->
      _this.$newImg.unbind 'click'
      _this.ran_out_of_time = false
      _this.$timer.stop()
      new Cursor2(e)
      #getImage($img, e)
      _this.e = e
      _this.$prevImg = _this.$newImg
      _this.nextStep()

  getClickArea: ->
    w = @$prevImg.width()
    h = @$prevImg.height()
    x = @e.pageX - @$prevImg.offset().left
    y = @e.pageY - @$prevImg.offset().top
    col = parseInt(x / (w / 3)) + 1
    row = parseInt(y / (h / 3))
    return col + (row * 3)

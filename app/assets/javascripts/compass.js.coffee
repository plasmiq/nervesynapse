# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if($('.body_compass_index').length > 0)
    $('body').mousemove (e) ->
      $('body').attr('data-x', e.pageX)
      $('body').attr('data-y', e.pageY)
    $image = $('#body_compass .image')
    $('#container').height(window.innerHeight - 50)
    #getImage(false)
    t = new Travel()
    t.start()


class TravelElement
  constructor: (element) ->
    @$e           = $(element)
    @width        = @$e.width()
    @height       = @$e.height()
    @start_width  = @width * 0.5
    @start_height = @height * 0.5
    @start_top    = ((window.innerHeight / 2) - (@start_height / 2)) - 40
    @start_left   = (window.innerWidth / 2) - (@start_width / 2)
    @end_top      = ((window.innerHeight / 2) - (@height / 2)) - 40
    @end_left     = ((window.innerWidth / 2) - (@width / 2))
    @setCss()

  setCss: ->
    @$e.css('z-index', '100')
    @$e.css('top', @start_top + 'px')
    @$e.css('left', @start_left + 'px')
    @$e.css('opacity', '0')
    @$e.css('width', @start_width)
    @$e.css('height', @start_height)

  show: ->
    @$e.show()

  displayBlock: ->
    @$e.css('display', 'block')


class Travel
  constructor: ->
    @$image = $('#body_compass .image')
    @$newImg = ''
    @$timer = $('#timer')
    @$prevImg = ''
    @e = ''
    @ran_out_of_time = true
    @$click_area = $('#click_area')
    @currentImage = ''
    @clickedArea = ''

    @$click_area.hide()

  prepareClickGrid: ->
    cssObj = {
      'top': @currentImage.end_top + 'px',
      'left': @currentImage.end_left + 'px',
      'width': @currentImage.width + 'px'
      'height': @currentImage.height + 'px'
    }
    @$click_area.css(cssObj)

    _width = parseInt((@currentImage.width - 4) / 3)
    _height = parseInt((@currentImage.height - 4) / 3)

    _width_diff = @currentImage.width - ((_width * 3) + 4)
    _height_diff = @currentImage.height - ((_height * 3) + 4)

    @$click_area.find('.area').css('width', _width + 'px')
    @$click_area.find('.area.top:last, .area.middle:last, .area.bottom:last').css('width', (_width + _width_diff) + 'px')

    @$click_area.find('.area').css('height', _height + 'px')
    @$click_area.find('.area.bottom').css('height', (_height + _height_diff) + 'px')

    @$click_area.find('.area .bg').css('width', _width + 'px')
    @$click_area.find('.area.top:last, .area.middle:last, .area.bottom:last').find('.bg').css('width', (_width + _width_diff) + 'px')

    @$click_area.find('.area .bg').css('height', _height + 'px')
    @$click_area.find('.area.bottom .bg').css('height', (_height + _height_diff) + 'px')

    $('.area').mouseover (e) ->
      left_1 = $(@).offset().left
      top_1 = $(@).offset().top
      left_2 = $(@).width() + left_1
      top_2 = $(@).height() + top_1
      cursorX = e.pageX or $('body').attr('data-x')
      cursorY = e.pageY or $('body').attr('data-y')
      if(cursorX >= left_1 and cursorX <= left_2 and cursorY >= top_1 and cursorY <= top_2)
        $(@).addClass('selected')

    $('.area').mouseout ->
      $(@).removeClass('selected')

  showClickGrid: ->
    @$click_area.show()
    $('.area').trigger('mouseover')


  start: ->
    _this = @
    $.ajax
      type: 'get'
      url: '/compass/get_entry_point'
      data:
        substrate_id: $('#entry_point_substrate_id').attr('value')
        weave_id: $('#entry_point_weave_id').attr('value')
      dataType: 'json'
      success: (data) ->
        newImg = new Image()
        _this.$newImg = $(newImg)
        _this.$newImg.hide()
        newImg.onload = ->
          _this.$image.append(_this.$newImg)
          _this.currentImage = new TravelElement(_this.$newImg)
          _this.currentImage.show()
          _this.prepareClickGrid()

          #START SHOWING IMAGE
          _this.currentImage.$e.animate {
            opacity: '1'
            width: _this.currentImage.width + 'px'
            height: _this.currentImage.height + 'px'
            top: _this.currentImage.end_top + 'px'
            left: _this.currentImage.end_left + 'px'
          }, 1000, ->
            _this.showClickGrid()
            _this.bindClick()
          #END SHOWING IMAGE

          #RESTET TIMER
          _this.$timer.width('21px')
          _this.ran_out_of_time = true
          _this.currentImage.displayBlock()
          _this.$timer.delay(1500).animate {
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
        click_area: _this.clickedArea
      dataType: 'json'
      success: (data) ->
        newImg = new Image()
        _this.$newImg = $(newImg)
        _this.$newImg.hide()
        newImg.onload = ->
          _this.$image.append(_this.$newImg)
          _this.currentImage = new TravelElement(_this.$newImg)
          _this.currentImage.show()
          _this.prepareClickGrid()

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
            _this.currentImage.$e.css('z-index', '1000')
          _this.currentImage.$e.delay(100).show()
          _this.currentImage.$e.delay(200).animate {
            opacity: '1'
            width: _this.currentImage.width + 'px'
            height: _this.currentImage.height + 'px'
            top: _this.currentImage.end_top + 'px'
            left: _this.currentImage.end_left + 'px'
          }, 1000, ->
            _this.showClickGrid()
            _this.bindClick()

          _this.$timer.width('21px')
          _this.ran_out_of_time = true
          _this.currentImage.$e.css('display', 'block')
          _this.$timer.delay(1500).animate {
            width: '605px'
          }, 3000, ->
            if _this.ran_out_of_time == true
              window.location.replace(_this.$image.attr('data_finish_url'))
        newImg.src = data.src

  bindClick: ->
    _this = @
    @$click_area.find('.area').bind 'click', (e) ->
      _this.$click_area.hide()
      _this.clickedArea = $(@).data('id')
      _this.$click_area.find('.area').unbind 'click'
      _this.ran_out_of_time = false
      _this.$timer.stop()
      #getImage($img, e)
      _this.e = e
      _this.$prevImg = _this.$newImg
      _this.nextStep()

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
    @$click_area.find('.area').css('width', ((@currentImage.width / 3)) + 'px')
    @$click_area.find('.area').css('height', ((@currentImage.height / 3)) + 'px')

  showClickGrid: ->
    @$click_area.fadeIn(200)


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
          _this.$timer.delay(1000).animate {
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
      new Cursor2(e)
      #getImage($img, e)
      _this.e = e
      _this.$prevImg = _this.$newImg
      _this.nextStep()

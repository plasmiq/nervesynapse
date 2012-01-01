# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $bodyWelcome = $('#body_welcome')

  if $bodyWelcome.length > 0
    $wrapper = $bodyWelcome.find('#wrapper')
    if $wrapper.length > 0
      $wrapper.height window.innerHeight

    $footer = $bodyWelcome.find('#footer')
    $footerContent = $footer.find('.content')
    $infoLink = $footer.find('a.info')
    $infoLink.click ->
      if $footer.hasClass('open')
        $footer.animate {
          bottom: '-560px'
        }, 500, ->
          $footer.removeClass('open')
        $footerContent.fadeOut(500)
      else
        $footer.animate {
          bottom: '0'
        }, 500, ->
          $footer.addClass('open')
        $footerContent.fadeIn(1000)

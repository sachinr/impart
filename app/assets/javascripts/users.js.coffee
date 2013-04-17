$ ->
  $(document).on 'click', '.js_confirm_user', (e) ->
    element = $(e.target)
    console.log element.data('url')
    $.post(element.data('url'), confirmed: element.is(':checked'))

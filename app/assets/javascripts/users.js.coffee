$ ->
  $(document).on 'click', '.js_confirm_user', (e) ->
    element = $(e.target)
    console.log element.data('url')
    $.ajax
      url: element.data('url')
      data: { confirmed: element.is(':checked') }
      method: 'PUT'

  $(document).on 'click', '.js_change_user_role', (e) ->
    element = $(e.target)
    console.log element.data('url')
    $.ajax
      url: element.data('url')
      method: 'PUT'

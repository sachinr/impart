$ ->
  $('.js-reply-link').click (e) ->
    e.preventDefault()
    element = $(e.target)
    element.toggleClass('hasForm')
    if element.hasClass('hasForm')
      commentableId = element.data('commentable-id')
      template = $('.comment-template').html()
      element.after(template)
      element.next().find('#comment_commentable_id:first').val(commentableId)
      element.next().find('#comment_commentable_type').val('Comment')
    else
      element.next('form:first').remove()

  $(document).on 'click', '.js_comment_submit_button',  (e) ->
    e.preventDefault()
    element = $(e.target)
    form = element.parents('form:first')
    $.post(form.attr('action'), form.serialize()).done (data) ->
      form.replaceWith(data)


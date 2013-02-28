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

  $(document).on 'click', '.js-comment-vote', (e) ->
    e.preventDefault()
    element = $(e.target)
    direction = element.data('direction')
    commentId = element.data('comment-id')

    $.post "/comments/#{commentId}/comment_votes", {direction: direction}, ->
      alert "success"
    .fail (xhr) ->
      console.log $.parseJSON(xhr.responseText).errors

$ ->
  $(document).on 'click', '.js-comment-reply-link', (e) ->
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

  $(document).on 'click', '.js-comment-delete-link', (e) ->
    e.preventDefault()
    element = $(e.target)
    commentId = element.data('commentable-id')
    if confirm('Are you sure?')
      $.ajax(
        type: 'DELETE'
        url: "/comments/#{commentId}"
        dataType: 'json').done(window.location.reload())

  $(document).on 'click', '.js_comment_submit_button',  (e) ->
    e.preventDefault()
    element = $(e.target)
    form = element.parents('form:first')
    $.post(form.attr('action'), form.serialize()).done (data) ->
      if form.parents('.post-comment-form').length > 0
        form.after(data)
      else
        form.replaceWith(data)

  $(document).on 'click', '.js-comment-vote', (e) ->
    e.preventDefault()
    element = $(e.target).parent('a')
    direction = element.data('direction')
    commentId = element.data('comment-id')

    $.post "/comments/#{commentId}/comment_votes", {direction: direction}, (data) ->
      element.parents('ul:first').replaceWith(data)
    .fail (xhr) ->
      if xhr.status == 401
        window.location.pathname = '/users/sign_in/'
      console.log $.parseJSON(xhr.responseText).errors

  $(document).on 'focus', '.js-index-create-comment', (e) ->
    $(e.target).attr('rows', 3)
    $(e.target).parents('.comment-list').find('.js-index-submit-comment').show()

  $(document).on 'focusout', '.js-index-create-comment', (e) ->
    unless $(e.target).val() != ''
      $(e.target).attr('rows', 1)
      $('.js-index-submit-comment').hide()

  $(document).on 'click', '.js-index-delete-comment', (e) ->
    e.preventDefault()
    url = $(e.target).parents('a:first').data('url')
    parentComment = $(e.target).parents('.comment-list')
    if confirm('Are you sure?')
      $.ajax(
        type: 'POST'
        url: url
        data: { _method: 'delete' }
        dataType: 'json').success(parentComment.remove())

  $(document).on 'click', '.js-show-comment-form', (e) ->
    $(e.target).parents('.article').find('.comment-form').toggle()

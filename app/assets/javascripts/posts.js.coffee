$ ->
  $('.js_upvote').click (e) ->
    element = $(e.target).parent('a')
    hostname = document.location.hostname
    postId = element.data('post-id')

    $.post "/posts/#{postId}/post_votes", (data) ->
      element.toggleClass('voted')
      element.siblings('.upvote_count').html(data)
    .fail (xhr) ->
      if xhr.status == 401
        window.location.pathname = '/users/sign_in/'
      console.log $.parseJSON(xhr.responseText).errors

  $(document).on 'focusout', '#post_url', (e) ->
    if $(e.target).val() == ''
      $('.js-content-fetcher').addClass('hidden')
    else
      $('.js-content-fetcher').removeClass('hidden')

  $(document).on 'click', '.js-content-fetcher', (e) ->
    e.preventDefault()
    url = $(e.target).data('url')
    $(e.target).button('loading')
    $.ajax(
      type: 'GET',
      url: url,
      data: { url: $('#post_url').val() }
      ).done((data) ->
        $(e.target).button('reset')
        $('#post_title').val(data['title'])
      )

  $(document).on 'click', '.js-fetch-description', (e) ->
    e.preventDefault()
    if $(e.target).hasClass('open')
      $(e.target).toggleClass('open')
      $(e.target).parents('tr').find('.index-post-description').html('')
    else
      url = $(e.target).data('url')
      $.ajax(
        type: 'GET',
        url: url,
        ).done((data) ->
          $(e.target).toggleClass('open')
          $(e.target).parents('tr').find('.index-post-description').html(data)
        )


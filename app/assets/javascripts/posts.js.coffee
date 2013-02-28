$ ->
  $('.js_upvote').click (e) ->
    element = $(e.target)
    hostname = document.location.hostname
    postId = element.data('post-id')

    $.post "posts/#{postId}/post_votes", ->
      alert "success"
    .fail (xhr) ->
      console.log $.parseJSON(xhr.responseText).errors

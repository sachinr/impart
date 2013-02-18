$ ->
  $('.js_upvote').click (e) ->
    element = $(e.target)
    hostname = document.location.hostname
    postId = element.data('postId')

    $.post "posts/#{postId}/post_votes", ->
      alert "success"
    .fail (xhr) ->
      console.log $.parseJSON(xhr.responseText).errors

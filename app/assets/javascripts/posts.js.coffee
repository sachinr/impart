$ ->
  $('.js_upvote').click (e) ->
    element = $(e.target)
    hostname = document.location.hostname
    postId = element.data('post-id')

    $.post "/posts/#{postId}/post_votes", (data) ->
      element.siblings('.post_votes').html(data)
    .fail (xhr) ->
      console.log $.parseJSON(xhr.responseText).errors

  converter = Markdown.getSanitizingConverter()
  if converter?
    editor = new Markdown.Editor(converter)
    editor.run()

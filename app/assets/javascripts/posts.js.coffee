$ ->
  $('.js_upvote').click (e) ->
    element = $(e.target).parent('a')
    hostname = document.location.hostname
    postId = element.data('post-id')

    $.post "/posts/#{postId}/post_votes", (data) ->
      element.siblings('.upvote_count').html(data)
    .fail (xhr) ->
      console.log $.parseJSON(xhr.responseText).errors

  if $(".wmd-panel").length > 0
    converter = Markdown.getSanitizingConverter()
    editor = new Markdown.Editor(converter)
    editor.run()

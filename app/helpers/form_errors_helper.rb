module FormErrorsHelper
  def error_notification
    return if object.errors.empty?

    @template.content_tag :div, :class => "alert alert-error" do
      @template.pluralize(object.errors.count, "errors") +
      " prohibited this #{object_name.to_s.humanize.downcase} from being saved."
    end
  end unless ActionView::Helpers::FormBuilder.method_defined?(:error_notification)

  def error_messages_for(attribute)
    error_messages = object.errors[attribute]

    return if error_messages.empty?

    @template.content_tag :div, :class => "alert alert-error" do
      error_messages.map { |message| object.errors.full_message(attribute, message) }.to_sentence
    end
  end unless ActionView::Helpers::FormBuilder.method_defined?(:error_messages_for)
end

ActionView::Helpers::FormBuilder.send(:include, FormErrorsHelper)

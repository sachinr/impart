module ControlGroupHelper
  class ControlGroupBuilder
    def initialize(template, attribute, form)
      @template = template
      @attribute = attribute
      @form = form
    end

    def has_errors?
      @form.object.respond_to?(:errors) && @form.object.errors[@attribute].any?
    end

    def error_messages(default_help)
      if has_errors?
        @template.content_tag :span,
          @form.object.errors[@attribute].to_sentence,
          :class => "help-inline"
      else
        @template.content_tag :span,
          default_help, :class => "help-inline"
      end
    end

    def method_missing(name, *args, &block)
      if @form.respond_to?(name)
        @form.__send__(name, *args, &block)
      else
        super
      end
    end
  end

  module FormBuilderExtensions
    def control_group(attribute, &block)
      builder = ControlGroupBuilder.new(@template, attribute, self)
      @template.content_tag :div, @template.capture(builder, &block),
                            :class => "control-group #{'error' if builder.has_errors?}"
    end
  end
end

ActionView::Helpers::FormBuilder.send(:include, ControlGroupHelper::FormBuilderExtensions)

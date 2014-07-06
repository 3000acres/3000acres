# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :bootstrap3, :tag => 'div', :class => 'form-group', :error_class => 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.use :input, :wrap_with => { :tag => 'div', :class => 'controls col-xs-12 col-sm-7 col-md-6 col-lg-5' }
    b.use :error, :wrap_with => { :tag => 'span', :class => 'help-block' }
    b.use :hint,  :wrap_with => { :tag => 'p', :class => 'help-block clearfix col-xs-12 col-sm-8 col-sm-offset-4 col-md-6 col-md-offset-4 col-lg-6 col-lg-offset-3' }
  end

  config.wrappers :prepend, tag: 'div', class: "control-group", error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-prepend' do |prepend|
        prepend.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    end
  end

  config.wrappers :append, tag: 'div', class: "control-group", error_class: 'error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-append' do |append|
        append.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-inline' }
    end
  end

  config.wrappers :checkbox, :tag => 'div', :class => 'control-group', :error_class => 'error' do |b|
    b.use :tag => 'div', :class => 'controls' do |ba|
      ba.use :label_input
    end
  end

  config.form_class = "form-horizontal"
  config.label_class = "col-xs-12 col-sm-4 col-md-4 col-lg-3 control-label"
  config.input_class = "form-control"
  config.button_class = 'btn btn-default'
  config.default_wrapper = :bootstrap3



end

class ApplicationPresenter
  include ActionView::Helpers
  include ActionView::Context
  include Rails.application.routes.url_helpers

  attr_reader :context

  def initialize(context)
    @context = context
  end

  def current_user
    context.current_user
  end
end
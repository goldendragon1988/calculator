module ResponseConcern
  extend ActiveSupport::Concern

  private

  def render_create
    render(:create, status: :created)
  end

  def render_failure_message
    render(json: { message: 'Bad request' }, status: :bad_request)
  end

  def render_forbidden
    render(json: { message: 'Forbidden access' }, status: :forbidden)
  end

  def record_not_found
    render(json: { message: 'Record not found' }, status: :not_found)
  end

  def render_success(resource = {}, status = 200, options = {})
    opts = { json: resource, status: status }.merge(options)
    render(opts)
  end

  def render_errors(resource, status = 400)
    render(json: { message: resource.errors.full_messages }, status: status, root: 'errors')
  end

  def render_message(message, status = 200)
    render(json: { message: message }, status: status)
  end
end
class ExceptionsController < ApplicationController
  def unhandled_exception
    exception = env['action_dispatch.exception']
    status_code = ActionDispatch::ExceptionWrapper.new(env, exception).status_code

    if status_code == 404
      render_not_found
    else
      render_internal_error
    end
  end

  private

  def render_internal_error
    render status: :internal_error, json: {
      error: 'internal_error',
      error_description: 'An internal error occurred, contact the site administrator'
    }
  end
end

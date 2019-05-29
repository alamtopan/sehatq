# frozen_string_literal: true

module Versions
  # https://gist.github.com/oki/006b2a49e26b04256d69
  class ErrorFormatter
    def self.call(e, _backtrace, _options, _env, _original_exception)
      # { message_x: message, backtrace_x: backtrace }
      {
        data: nil,
        status: {
          success: false,
          message: e,
          code: 400
        }
      }.to_json
    end
  end
end
  
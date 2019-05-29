module Versions::V1::Entities
  class PaginatedEntity < Grape::Entity
    def self.represent(object, options={})
      if options[:child]
        response = super(object, options)
      else
        if options[:pagination]
          page = options[:page] || 1
          page = 1 if page.to_i <= 0
          per_page = options[:per_page] || 10
          object = object.page(page).per(per_page)
          per_page = object.size
          current_page = object.current_page
          total_entries = object.total_count
          total_pages = object.total_pages

          response = {
            data: super(object, options),
            pagination: {
              current_page: current_page,
              per_page: per_page,
              total_entries: total_entries,
              total_pages: total_pages
            },
            status: {
              success: true,
              message: options[:message],
            }
          }
        else
          response = {
            data: super(object, options),
            status: {
              success: true,
              message: options[:message],
            }
          }
        end
      end

      response
    end

    def show?(options, key)
      if options[:include].present?
        _include = options[:include]
        _includes = _include.split(/\s*,\s*/)
        return true if _includes.include? key
      end

      false
    end
  end
end
  
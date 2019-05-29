module OrderModule
  module Filter
    extend ActiveSupport::Concern

    module ClassMethods
      def search_by(options={})
        results = order(created_at: :desc)

        if options[:keywords].present?
          query_options = [
            "LOWER(orders.invoice) LIKE LOWER(:key)",
            "LOWER(orders.status) LIKE LOWER(:key)"
          ].join(' OR ')
          results = results.where(query_options, {key: "%#{options[:keywords]}%"})
        end

        return results
      end
    end
  end
end
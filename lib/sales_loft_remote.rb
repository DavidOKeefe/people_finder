class SalesLoftRemote
  attr_reader :page, :per_page, :last_cached_at

  def initialize(options = {})
    @page = options.fetch(:page, 1)
    @per_page = options.fetch(:per_page, 100)
    @last_cached_at = options.fetch(:last_cached_at, DateTime.current - 10.years)
  end

  def people
    resp = HTTParty.get('https://api.salesloft.com/v2/people.json',
                        query: query,
                        headers: headers)

    log_error('#people', resp) if resp.keys.include?('error')

    resp
  end

  private

  def query
    {
      'page' => page,
      'per_page' => per_page,
      'updated_at[gt]' => last_cached_at
    }
  end

  def headers
    {
      'authorization' => "Bearer #{bearer_token}"
    }
  end

  def bearer_token
    @bearer_token ||= ENV['BEARER_TOKEN']
  end

  def log_error(method, resp)
    error_message = resp.fetch('error')
    Rails.logger.error "#{self.class}#{method} failed with the following error: #{error_message}"
  end
end

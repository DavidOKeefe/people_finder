class CachePeopleWorker
  include Sidekiq::Worker
  sidekiq_options unique_for: 1.day

  attr_reader :page, :began_caching_at

  def perform(page = nil, began_caching_at = nil)
    @page = page
    @began_caching_at = began_caching_at || DateTime.current.to_s

    resp = remote.people
    people_data = resp.fetch('data', [])
    update_people(people_data)

    next_page = resp.dig('metadata', 'paging', 'next_page')

    if next_page.nil?
      update_last_cached_at
    else
      self.class.perform_async(next_page, began_caching_at)
    end
  end

  private

  def update_people(people_data)
    people_data.each do |person_data|
      person = Person.where(sales_loft_id: person_data['id']).first_or_initialize
      person.email = person_data['email_address']
      person.full_name = person_data['display_name']
      person.title = person_data['title']
      person.save
    end
  end

  def update_last_cached_at
    person_meta_data.update(last_cached_at: began_caching_at)
  end

  def last_cached_at
    person_meta_data.last_cached_at
  end

  def person_meta_data
    @person_meta_data ||= PersonMetaData.first_or_create
  end

  def remote
    SalesLoftRemote.new(query_options)
  end

  def query_options
    options = {}
    options[:page] = page if page.present?
    options[:last_cached_at] = last_cached_at if last_cached_at.present?
    options
  end
end

require 'bonus_code_service'

class Product < ActiveRecord::Base
  # SQLite does not support enum, unfortunately
  STATUS  = {pre_loaded: 0, via_service: 1}
  SERVICE = {none: 0, TV: 1, RTG: 2}

  validates :title,   presence: true, length: {minimum: 1, maximum: 255}
  validates :status,  presence: true, numericality: true, inclusion: {in: STATUS.values}
  validates :service, presence: true, numericality: true, inclusion: {in: SERVICE.values}

  has_many  :bonus_codes, dependent: :destroy, class_name: 'BonusCode'

  def bonus_codes_loaded?
    !self.bonus_codes.count.zero?
  end

  def bonus_codes_via_service?
    self.status == STATUS[:via_service] && self.service != SERVICE[:none]
  end

  def try_fetch_bonus_codes
    # Check if service is available and if codes codes are not already loaded
    self.bonus_codes_via_service? && !self.bonus_codes_loaded? or return

    # Fetch codes from a specific remote service
    service_class = Object.const_get('BonusCodeService::' + SERVICE.invert[self.service].to_s)
    fetched_codes = service_class.fetch(self.id) or return

    # Pre-load the codes
    self.bonus_codes.create(fetched_codes.map {|code| {code: code} })
  end
end

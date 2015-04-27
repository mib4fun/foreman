module Nic
  class Interface < Base

    attr_accessible :ip

    validates :ip, :uniqueness => true, :format => {:with => Net::Validations::IP_REGEXP}, :allow_blank => true

    validate :normalize_ip

    validates :attached_to, :presence => true, :if => Proc.new { |o| o.virtual && o.instance_of?(Nic::Managed) && !o.bridge? }

    attr_accessible :name, :subnet_id, :subnet, :domain_id, :domain

    # Don't have to set a hostname for each interface, but it must be unique if it is set.
    before_validation :normalize_name

    validates :name,  :uniqueness => {:scope => :domain_id},
              :allow_nil => true,
              :allow_blank => true,
              :format => {:with => Net::Validations::HOST_REGEXP}

    # aliases and vlans require identifiers so we can differentiate and properly configure them
    validates :identifier, :presence => true, :if => Proc.new { |o| o.virtual? && o.managed? && o.instance_of?(Nic::Managed) }

    belongs_to :subnet
    belongs_to :domain

    validate :alias_subnet

    delegate :network, :to => :subnet

    def vlanid
      self.tag.blank? ? self.subnet.vlanid : self.tag
    end

    def bridge?
      !!bridge
    end

    def bridge
      attrs[:bridge]
    end

    def alias?
      self.virtual? && self.identifier.present? && self.identifier.include?(':')
    end

    protected

    def alias_subnet
      if self.managed? && self.alias? && self.subnet && self.subnet.boot_mode != Subnet::BOOT_MODES[:static]
        errors.add(:subnet_id, _('subnet boot mode is not %s' % _(Subnet::BOOT_MODES[:static])))
      end
    end

    def uniq_fields_with_hosts
      super + (self.virtual? ? [] : [:ip])
    end

    def normalize_ip
      self.ip = Net::Validations.normalize_ip(ip)
    end

    def normalize_name
      self.name = Net::Validations.normalize_hostname(name) if self.name.present?
    end

  end
end

require_dependency 'nic/managed'

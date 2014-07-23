class TemplateKind < ActiveRecord::Base
  validates_lengths_from_database
  has_many :config_templates
  has_many :os_default_templates
  validates :name, :presence => true, :uniqueness => true
end

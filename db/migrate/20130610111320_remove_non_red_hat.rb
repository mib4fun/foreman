# BZ#971463 - remove non-Red Hat default content
class RemoveNonRedHat < ActiveRecord::Migration
  def up
    Medium.destroy_all

    ConfigTemplate.all.each do |tmpl|
      next if tmpl.snippet? && tmpl.name != 'vmware'
      next if tmpl.name.start_with? 'PXE'
      next if tmpl.name.include? 'Kickstart'
      next if tmpl.name.include? 'Grubby'
      tmpl.destroy
    end

    rhr = ConfigTemplate.find_by_name('redhat_register')
    rhr.template = rhr.template.gsub('spacewalk', 'satellite').gsub('Spacewalk/Satellite', 'Satellite').gsub('Spacewalk', 'Satellite')
    rhr.save!

    Ptable.destroy_all("name NOT LIKE 'RedHat%'")
  end

  def down
    # not implemented
  end
end

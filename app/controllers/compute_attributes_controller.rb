class ComputeAttributesController < ApplicationController

  def new
    @set = ComputeAttribute.new(:compute_profile_id => params[:compute_profile_id].to_i,
                                              :compute_resource_id => params[:compute_resource_id].to_i)
  end

  def create
    clear_deleted_records
    @set = ComputeAttribute.new(params[:compute_attribute])
    if @set.save
      process_success :success_redirect => request.referer || compute_profile_path(@set.compute_profile)
    else
      process_error
    end
  end

  def edit
    @set = ComputeAttribute.find_by_id(params[:id])
  end

  def update
    clear_deleted_records
    @set = ComputeAttribute.find(params[:id])
    if @set.update_attributes!(params[:compute_attribute])
      process_success :success_redirect => request.referer || compute_profile_path(@set.compute_profile)
    else
      process_error
    end
  end

  private

  def clear_deleted_records
    base = params['compute_attribute'].fetch('vm_attrs', {})
    if (attrs = base.fetch('nics_attributes', {})).present?
      delete_removed_records(attrs)
    end
    if (attrs = base.fetch('interfaces_attributes', {})).present?
      delete_removed_records(attrs)
    end
    if (attrs = base.fetch('volumes_attributes', {})).present?
      delete_removed_records(attrs)
    end
  end

  def delete_removed_records(base)
    base.each do |key, value|
      if value['_delete'] == '1'
        base.delete(key)
      end
    end

  end
end

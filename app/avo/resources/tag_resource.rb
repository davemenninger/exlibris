class TagResource < Avo::BaseResource
  self.title = :name
  self.includes = []
  self.search_query = ->(params:) do
    scope.containing(params[:q])
  end
  self.resolve_query_scope = ->(model_class:) do
    model_class.by_name
  end

  field :name, as: :text, required: true, sortable: true, link_to_resource: true
  field :short_description, as: :text, visible: ->(resource:) { resource.model.tag_category&.short_description_required }, required: ->(resource:) { resource.model.tag_category&.short_description_required }, hide_on: :index
  field :order, as: :number, sortable: true

  field :description, as: :trix, always_show: true, attachments_disabled: true

  field :tag_category, as: :belongs_to
  field :entries, as: :has_many

  filter TagCategoryFilter
end

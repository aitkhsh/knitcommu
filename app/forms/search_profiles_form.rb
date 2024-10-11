class SearchProfilesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name_or_body, :string
  attribute :username, :string
  attribute :tag, :string

  def search
    scope = Profile.distinct
    scope = scope.name_contain(name_or_body).or(scope.body_contain(name_or_body)) if name_or_body.present?
    scope = scope.username_contain(username) if username.present?
    scope = scope.tag_contain (tag) if tag.present?
  end
end

class SearchBoardsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title_or_body, :string
  attribute :username, :string
  attribute :tag, :string

  def search
    scope = Board.distinct
    scope = scope.title_contain(title_or_body).or(scope.body_contain(title_or_body)) if title_or_body.present?
    scope = scope.username_contain(username) if username.present?
    scope = scope.tag_contain (tag) if tag.present?
  end
end

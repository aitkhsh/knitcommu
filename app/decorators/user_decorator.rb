class UserDecorator < Draper::Decorator
  delegate_all
  # last_nameとfirst_nameのカラムを無くしたので必要なくなりました。
  # def full_name
  #   "#{object.last_name} #{object.first_name}"
  # end
end

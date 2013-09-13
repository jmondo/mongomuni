class Route
  include Mongoid::Document

  field :tag, type: String
  field :title, type: String
  field :tracking, type: Boolean, default: false
end

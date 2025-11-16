class ParseLog < ApplicationRecord
  has_one_attached :eml_file

  has_one :customer

  enum :status, { pending: "pending", precessing: "processing", success: "success", failure: "failure" }
end

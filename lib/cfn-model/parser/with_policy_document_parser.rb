# frozen_string_literal: true

require 'cfn-model/model/iam_policy'
require 'cfn-model/model/policy_document'
require_relative 'policy_document_parser'

class WithPolicyDocumentParser
  def parse(cfn_model:, resource:)
    resource.policy_document = PolicyDocumentParser.new.parse(cfn_model, resource.policyDocument)
    resource
  end
end

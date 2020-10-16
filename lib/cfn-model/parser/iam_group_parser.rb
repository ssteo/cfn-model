# frozen_string_literal: true

require 'cfn-model/model/iam_role'
require 'cfn-model/model/policy'
require 'cfn-model/model/references'
require_relative 'policy_document_parser'

class IamGroupParser
  def parse(cfn_model:, resource:)
    iam_group = resource

    iam_group.policy_objects = iam_group.policies.map do |policy|
      next unless policy.has_key? 'PolicyName'

      new_policy = Policy.new
      new_policy.policy_name = References.resolve_value(cfn_model, policy['PolicyName'])
      new_policy.policy_document = PolicyDocumentParser.new.parse(cfn_model, policy['PolicyDocument'])
      new_policy
    end.reject { |policy| policy.nil? }
    iam_group
  end
end

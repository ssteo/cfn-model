require 'spec_helper'
require 'cfn-model/parser/cfn_parser'

describe CfnParser, :elb do
  before :each do
    @cfn_parser = CfnParser.new
  end

  context 'a template with an ELB and an attached security group' do
    it 'returns a LoadBalancer with security group object in securityGroups field' do
      expected_load_balancer = load_balancer_with_open_http_ingress

      test_templates('elasticloadbalancing_loadbalancer/elb_with_sg').each do |test_template|
        cfn_model = @cfn_parser.parse IO.read(test_template)

        expect(cfn_model.resources_by_type('AWS::ElasticLoadBalancing::LoadBalancer').first).to eq expected_load_balancer
      end
    end
  end

  context 'a template with an ELB and a conditional policy on listener' do
    it 'returns a LoadBalancer' do
      json_test_templates('elasticloadbalancing_loadbalancer/load_balancer_with_conditional_policy_names').each do |test_template|
        cfn_model = @cfn_parser.parse IO.read(test_template)

        expect(cfn_model.resources_by_type('AWS::ElasticLoadBalancing::LoadBalancer').first.appCookieStickinessPolicy).to eq(
            [ {'PolicyName' => 'AppStickiness', 'CookieName' => 'unclefreddie'} ]
        )
      end
    end
  end

  # context 'a template with an ELB2 and only 1 subnet' do
  #   it 'raises an error' do
  #     yaml_test_templates('elasticloadbalancingv2_loadbalancer/elb2_with_one_subnet').each do |test_template|
  #       expect {
  #         _ = @cfn_parser.parse IO.read(test_template)
  #       }.to raise_error 'Load Balancer must have at least two subnets: MyLoadBalancer'
  #     end
  #   end
  # end

  context 'a template with an ELB and an attached security group' do
    it 'returns a LoadBalancer with security group object in securityGroups field' do
      expected_load_balancer = load_balancer2_with_open_http_ingress

      yaml_test_templates('elasticloadbalancingv2_loadbalancer/elb2_with_sg').each do |test_template|
        cfn_model = @cfn_parser.parse IO.read(test_template)

        expect(cfn_model.resources_by_type('AWS::ElasticLoadBalancingV2::LoadBalancer').first).to eq expected_load_balancer
      end
    end
  end

  context 'a template with an ELB and an attached security group list' do
    it 'returns a LoadBalancer with security group object in securityGroups field' do
      expected_load_balancer = load_balancer_with_open_http_ingress_and_comma_delimited_sg

      json_test_templates('elasticloadbalancing_loadbalancer/elb_with_sg_list').each do |test_template|
        cfn_model = @cfn_parser.parse IO.read(test_template)

        expect(cfn_model.resources_by_type('AWS::ElasticLoadBalancing::LoadBalancer').first).to eq expected_load_balancer
      end
    end
  end

  context 'a template with a network load balancer' do
    it 'returns a LoadBalancer of a network type' do
      expected_load_balancer = network_load_balancer

      yaml_test_templates('elasticloadbalancingv2_loadbalancer/network_load_balancer').each do |test_template|
        cfn_model = @cfn_parser.parse IO.read(test_template)

        expect(cfn_model.resources_by_type('AWS::ElasticLoadBalancingV2::LoadBalancer').first).to eq expected_load_balancer
      end
    end
  end
end

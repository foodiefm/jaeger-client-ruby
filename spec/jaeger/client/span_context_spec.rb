require 'spec_helper'

RSpec.describe Jaeger::Client::SpanContext do
  describe '.create_from_parent_context' do
    let(:parent) do
      described_class.new(
        trace_id: trace_id,
        parent_id: nil,
        span_id: parent_span_id,
        flags: parent_flags
      )
    end
    let(:trace_id) { 'trace-id' }
    let(:parent_span_id) { 'span-id' }
    let(:parent_flags) { described_class::Flags::SAMPLED }

    it 'has same trace ID' do
      context = described_class.create_from_parent_context(parent)
      expect(context.trace_id).to eq(trace_id)
    end

    it 'has same parent span id as parent id' do
      context = described_class.create_from_parent_context(parent)
      expect(context.parent_id).to eq(parent_span_id)
    end

    it 'has same its own span id' do
      context = described_class.create_from_parent_context(parent)
      expect(context.span_id).to_not eq(parent_span_id)
    end

    it 'has parent flags' do
      context = described_class.create_from_parent_context(parent)
      expect(context.flags).to eq(parent_flags)
    end
  end

  describe 'flags' do
    let(:trace_id) { 'trace-id' }
    let(:parent_span_id) { 'span-id' }
    let(:context) { described_class.new(span_id: 'span-id', trace_id: trace_id, flags: 0) }

    it 'should set  debug flag' do
      context.debug = true
      expect(context.debug?).to be_truthy
      context.debug = false
      expect(context.debug?).to be_falsey
    end

    it 'should set sampled flag' do
      context.sampled= true
      expect(context.sampled?).to be_truthy
      context.sampled = false
      expect(context.sampled?).to be_falsey
    end
  end
end

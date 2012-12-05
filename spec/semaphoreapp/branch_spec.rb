require 'spec_helper'

describe Semaphoreapp::Branch do
  let(:project_hash_id) { ':hash_id' }

  describe ".build" do

    context "with a hash" do

      let(:test_hash){ fixture(:branches).first }

      subject{ Semaphoreapp::Branch.build(test_hash, project_hash_id) }

      it "should call build_from_hash" do
        Semaphoreapp::Branch.should_receive(:build_from_hash).with(test_hash, project_hash_id)
        subject
      end

    end

    context "with an array" do

      let(:test_array){ fixture(:branches) }
      subject{ Semaphoreapp::Branch.build(test_array, project_hash_id) }

      it "should call build_from_array" do
        Semaphoreapp::Branch.should_receive(:build_from_array).with(test_array, project_hash_id)
        subject
      end

    end

  end

  describe ".build_from_hash" do

    let(:test_hash){ fixture(:branches).first }
    subject{ Semaphoreapp::Branch.build_from_hash(test_hash, project_hash_id) }

    it{ should be_an_instance_of Semaphoreapp::Branch }

    fixture(:branches).first.each do |key, value|
      it "should have attribute #{key}" do
        subject.send(key).should == value
      end
    end

  end

  describe ".build_from_array" do

    let(:test_array){ fixture(:branches) }
    subject{ Semaphoreapp::Branch.build_from_array(test_array, project_hash_id) }

    it{ should be_an_instance_of Array }

    it "should call build_from_hash for all the hashes in the array" do
      test_array.each do |test_hash|
        Semaphoreapp::Branch.should_receive(:build_from_hash).with(test_hash, project_hash_id)
      end

      subject
    end

  end

  describe ".all_by_project_hash_id" do
    let(:hash_id) { ':hash_id' }
    let(:branches) { fixture(:branches) }
    subject{ Semaphoreapp::Branch.all_by_project_hash_id(hash_id) }
    before{ Semaphoreapp::JsonApi.stub(:get_branches).and_return(branches) }

    it "should get branches JSON from the API" do
      Semaphoreapp::JsonApi.should_receive(:get_branches).with(hash_id)
      subject
    end

    it "should call Branch.build with an array of branches" do
      Semaphoreapp::Branch.should_receive(:build).with(branches, hash_id)
      subject
    end

    it{ should be_an_instance_of Array }
  end

end

require 'spec_helper'
require 'rebeka'



describe "Rebeka main specs" do
	let(:rb) do 
		Rebeka.new
	end

	let(:csv_loader) do
		Rjb::load("#{Dir.pwd}/lib/weka.jar", jvmargs=["-Xmx1000M"])
		loader = Rjb::import("weka.core.converters.CSVLoader").new
		file = Rjb::import("java.io.File").new("electronics_final.csv")
		loader.setFile(file)
		instances = loader.getDataSet()
		instances.setClassIndex(instances.numAttributes() - 1)
		instances
	end

	before(:each) do
		rb
		csv_loader
	end

	context "Rebeka Initializer" do
		it "should be able to initialize rebeka with weka.jar" do
			rb.should_not be_nil
		end
	end

	context "Creating classifiers" do
		it "should be able to convert from csv to instances" do
			@instances = rb.to_instances "electronics_final.csv"
			@instances.getClass().getName().should == "weka.core.Instances"
		end

		it "should create the classifier given some instances and evaluate a single instance " do	
			classifier = rb.create_classifier csv_loader
			classifier.getClass().getName().should == "weka.classifiers.functions.SMO"
			evaluation = rb.evaluate_single_instance classifier, csv_loader.instance(0)
			evaluation_split = evaluation.toString().split ","
			evaluation_string = evaluation_split.last
			evaluation_string.should be_a_kind_of(String)
		end
	end	
end
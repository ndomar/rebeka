## Ruby - weka wrapper

require 'rjb'

## the function takes in some trained model, exports it to .model file
class Rebeka
	##TODO fix directory of weka.jar
	dir = "D:/rebeka/lib/weka.jar"
	Rjb::load(dir, jvmargs=["-Xmx1000M"])
	puts dir
	puts Dir.pwd
	def to_model classifier, name
		Rjb::import("weka.core.SerializationHelper").write(name + ".model", classifier)
	end
	## the function returns .model file with a certain name
	def get_model name
		Rjb::import("weka.core.SerializationHelper").read(name + ".model")
	end

	## the function returns a trained classifier given instances as an input
	def create_classifier instances
		classifier = Rjb::import("weka.classifiers.functions.SMO").new
		classifier.buildClassifier(instances)
		classifier
	end

	## the function reads a csv file and returns the created instances
	def to_instances instances_csv
		instances_file = get_file instances_csv
	  get_csv_loader instances_file
	end

	def get_csv_loader instances_file
		csv_loader = Rjb::import("weka.core.converters.CSVLoader").new
		csv_loader.setFile(instances_file)
		instances = csv_loader.getDataSet()
		instances.setClassIndex(instances.numAttributes() - 1)
		instances
	end

	## the function evaluates a single instance given the classifier name and the instance, it returns a labeled
	## evaluated instance
	def evaluate_single_instance classifier, instance
		label = classifier.classifyInstance(instance)
		instance.setClassValue(label)
		instance
	end

	## function returns a java object of the file with a certain name.
	def get_file name
		Rjb::import("java.io.File").new(name)
	end

	## given an instance, it returns the class of this instance (class attribute should always be the last one.)
	def get_class instance
		instance.toString.split(",")[instance.numAttributes() - 1]
	end
end
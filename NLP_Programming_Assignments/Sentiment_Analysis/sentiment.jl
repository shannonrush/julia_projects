# A version of the sentiment analysis programming assignment
# for the Coursera Stanford Natural Language Processing course
# 
# Performs sentiment analysis on IMDB movie reviews for positive and negative attitude
# Trains a classifier with random 80% of the data and is tested with the remaining 20%

load("hashtable.jl")

function add_example(label,words,counts)
  # increase pos or neg count based on label
  counts[strcat(label,"_count")] += 1

  for word in words
    # add to vocab set
    add(counts["vocab"],word)
    
    # increase appropriate MegaText HashTable
    increase_count(counts[strcat(label,"_megatext")],word)
  end
end

function calculate_once(counts)
  counts["vocab_count"] = length(counts["vocab"])
  counts["pos_megatext_count"] = sum_vals(counts["pos_megatext"])
  counts["neg_megatext_count"] = sum_vals(counts["neg_megatext"])
  num_reviews = float(counts["pos_count"]+counts["neg_count"])
  counts["prob_pos_prior"] = counts["pos_count"]/num_reviews
  counts["prob_neg_prior"] = counts["neg_count"]/num_reviews
end

function train_test_data(filename)
  text = readall(open("data/imdb1/$filename"))
  reviews = shuffle!(split(text,"#*#*#*#*#",true))
  splitIndex = int(0.8*length(reviews))
  train = reviews[[1:splitIndex]]
  test = reviews[[splitIndex+1:end]]
  return (train,test)
end

function classify(words, counts)
  # probability of the prior times the product of the probability of each word given the class
  prob_pos = log(counts["prob_pos_prior"])
  prob_neg = log(counts["prob_neg_prior"])
  
  for word in words
    # probability of word given class is the number of times the word appears in the class megatext + 1
    # divided by the number of all words in that megatext + vocab count
    prob_pos += log((get(counts["pos_megatext"],word,0)+1.0)/(counts["pos_megatext_count"]+counts["vocab_count"]))
    prob_neg += log((get(counts["neg_megatext"],word,0)+1.0)/(counts["neg_megatext_count"]+counts["vocab_count"]))
  end
  
  return prob_pos > prob_neg ? "pos" : "neg"
end

function readFiles(counts)
  # assign random 80% of pos and random 80% of neg reviews to trainingData
  # assign remainder to testingData
  
  # will allow for multiple txt files in different labeled directories starting with something like this: 
  # run(`ls data` > `filenames.txt`)
  # when > is implemented like | is now 
  
  # until then all reviews are grouped in posFile.txt and negFile.txt delimited by #*#*#*#*#
  
  (pos_train,pos_test) = train_test_data("posFile.txt")
  (neg_train,neg_test) = train_test_data("negFile.txt")
  
  for review in [pos_train,neg_train]
    lines = split(review,"\n",true)
    word_array = []
    for line in lines
      word_array = [word_array,split(line," ",true)]
    end
    label = contains(pos_train,review) ? "pos" : "neg"
    add_example(label,word_array,counts)
  end
  
  # now that the training is complete we can do a little calculating
  calculate_once(counts)
  
  # and use the test data to determine the accuracy of the classifier
  counts["correct"] = 0
  for test_review in [pos_test,neg_test]
    lines = split(test_review,"\n",true)
    word_array = []
    for line in lines
      word_array = [word_array,split(line," ",true)]
    end
    guess = classify(word_array,counts)
    actual = contains(pos_test,test_review) ? "pos" : "neg"
    if guess==actual
      counts["correct"] += 1
    end
  end
  print("ACCURACY: ")
  total = length(pos_test)+length(neg_test)
  print(float(counts["correct"]/total))
end

function initialize()
  counts = HashTable()
  counts["vocab"] = Set()
  counts["pos_count"] = 0.0
  counts["neg_count"] = 0.0
  counts["pos_megatext"] = HashTable() 
  counts["neg_megatext"] = HashTable()
  readFiles(counts)
end

# Initialize 
  
initialize()





 
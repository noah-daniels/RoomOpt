class Population {

  // Define variables.
  School school;
  int[] rooms;
  int empty;

  float mc;

  int generations;

  DNA[] instances;
  ArrayList<DNA> matingPool;

  Population(int _popSize, float _mc, int[] _rooms, int _empty) {

    school = new School(_empty);
    rooms = _rooms;
    empty = _empty;

    mc = _mc;

    instances = new DNA[_popSize];
    for (int i = 0; i < instances.length; i++) {
      instances[i] = new DNA(school, rooms, false); //loop through the array en create new DNA instances.
    }

    // Set default values
    matingPool = new ArrayList<DNA>();
    generations = 0;
  }
  
  // Create the matingPool to later draw from
  void naturalSelection() {
    
    matingPool.clear(); //clear the previous matingPool.
    
    float maxFitness = getBest().fitness; //find the highest fitness of the current generation to normalise the fitness later on.
     
    // Distribute DNA instances according to fitness over the matingPool.
    //loop through all DNA instances
    for(int i = 0; i < instances.length; i++) {
      int n = floor(map(instances[i].fitness, 0, maxFitness, 0, 500)); //set n to the normalised fitness of the selected instance.
      for(int j = 0; j < n; j++) {
        matingPool.add(instances[i]); //place the selected instance n-times in the matingPool
      }
    }
  }
  
  // Create the new population with 2 random DNA instances from the matingPool
  void generateNew() {

    //create the matingPool to draw from.
    naturalSelection(); 

    //loop through all DNA instances
    for (int i = 0; i < instances.length; i++) {
      //pick 2 random parents.
      int a = floor(random(matingPool.size())); //generate random index for matingPool.
      int b = floor(random(matingPool.size())); //generate random index for matingPool.
      DNA parentA = matingPool.get(a); //select first parent with the random index.
      DNA parentB = matingPool.get(b); //select second parent with the random index.

      //make child.
      DNA child = parentA.crossOver(parentB); //make a child by crossing the two parents.
      child.mutate(mc); //mutate the child.
      instances[i] = child; //add the child to the population
    }
    generations++; //increase the generation.
  }

  // Return highest ranking DNA instance
  DNA getBest() {

    //reset variables
    float maxFitness = 0;
    int index = 0;

    calcFitness();

    //loop through all DNA instances
    for (int i = 0; i < instances.length; i++) {
      //if selected instance's fitness is higher than the current maxFitness
      if (instances[i].fitness > maxFitness) {
        maxFitness = instances[i].fitness; //set previous highest fitness to new highest fitness.
        index = i; //save the index of the currently highest ranking DNA instance.
      }
    }

    return instances[index]; //return the highest ranking DNA instance.
  }

  void calcFitness() {
    for(int i = 0; i < instances.length; i++) {
      instances[i].calcFitness();  //calculate fitness on selected instance.
    }
  }

  void newRandPop() {
    for (int i = 0; i < instances.length; i++) {
      instances[i] = new DNA(school, rooms, false); //loop through the array en create new DNA instances.
    }
  }
  
  void displayAll(int x, int y) {
  
  
  }
}
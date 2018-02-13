// Define public varibales.
PFont f;
PFont fBold;
Population population; //controlls everything

DNA best;

boolean render;

void setup() {

  // Setup display stuff
  size(1200, 700); //create window.
  frameRate(60);
  f = createFont("Courier", 12, true); //create font.
  fBold = createFont("Courier-Bold", 12, true); //create bold font.

  

  // Create population;
  int popSize = 2000; //the size of the population.
  float mutationChance = 0.00015; //the chance each gene has to mutate and ignore the parents.
  int[] rooms = {8, 6, 6, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 2, 2}; //test1-80
  //int[] rooms = {6, 5, 5, 5, 5, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 2}; //test2-60
  //int[] rooms = {6, 5, 5, 4, 4, 4, 4, 3, 3, 3, 3, 2}; //test1-40
  int empty = 3; //test1-80 & test2-60
  //int empty = 6; //test1-40

  population = new Population(popSize, mutationChance, rooms, empty);
  best = population.getBest();

  render = true;
}

void draw() {

  // Set display stuff.
  background(255); //cear screen
  textFont(f); //set font.
  textAlign(LEFT); //set textAlign.
  fill(0); //set color with which to fill shapes

  population.generateNew();

  if (render) {

    best = population.getBest();


    textFont(fBold);
    text("best configuration:", 20, 30);
    textFont(f);
    String a = "fitness: " + nf(best.fitness, 7, 3) + " | ";
    text(a, 20, 50);
    float spacing = 20 + textWidth(a);
    for (int i = 0; i < 5; i++) {
      String s = str(best.fitnessArg[i]) + (i<4 ? ", " : "");
      text(s, spacing, 50);
      spacing += textWidth(s);
    }
    text("/" + population.school.studentCount, spacing, 50);


    best.displayConfig(20, 100);
  }
  
  population.displayAll(500, 100);

  //text(population.mc, 20, height-60);

  text("fps: " + int(frameRate), 20, height-40);
  text("Time: " + nf(millis()/60000, 2) + ":" + nf(millis()/1000, 2), 20, height-20);
}

void mousePressed() {
  population.newRandPop();
  best = population.getBest();
}

void keyPressed() {
  //n: (78) next generation
  //m: (77) mutation overdrive
  //r: (82) don't render

  if (keyCode == 78) {
    population.generateNew();
    best = population.getBest();
  }
  if (keyCode == 77) {
    //population.mc = population.mc==0.005?0.0005:0.005;
  }
  if (keyCode == 82) {
    render = !render;
  }
}
class DNA {

  Student[][] genes;

  int[] rooms;
  School school;

  float fitness;
  int[] fitnessArg = new int[5];

  DNA(School _school, int[] _rooms, boolean child) {

    school = _school;
    rooms = _rooms;

    genes = new Student[rooms.length][];

    fillGenes(child);
  }

  void fillGenes(boolean child) {

    ArrayList<Student> g = school.getAll();

    for (int i = 0; i < genes.length; i++) {

      genes[i] = new Student[rooms[i]];
      if (!child) {
        for (int j = 0; j < genes[i].length; j++) {
          int index = floor(random(g.size()));
          //println(i + ", " + j + ": " + index);
          genes[i][j] = g.get(index);
          g.remove(index);
        }
      }
    }
  }

  void calcFitness() {
    int top = 0; //how many times someone is with a friend
    int not = 0; //how many times someone is with an enemy
    int sex = 0; //hom many times someone is with the wrong gender
    int sol = 0; //how many people are alone
    int any = 0; //how many poeple are with at least 1 friend

    for (int i = 0; i < genes.length; i++) {
      int fakes = 0;
      for (int j = 0; j < genes[i].length; j++) {
        Student tester = genes[i][j];
        int friends = 0;

        if (!tester.empty) {
          String[] top3 = tester.top3;
          String[] not3 = tester.not3;
          boolean gender = tester.gender;
          for (int k = 0; k < genes[i].length; k++) {
            Student test = genes[i][k];
            if (k!=j && !test.empty) {
              for (int l = 0; l < top3.length; l++) {
                if (test.id.equals(top3[l])) {
                  top++;
                  friends++;
                }
              }
              for (int l = 0; l < not3.length; l++) {
                if (test.id.equals(not3[l])) not++;
              }
              if (gender != test.gender) sex++;
            }
          }

          if (friends > 0) any++;
        } else fakes++;
      }
      if (fakes == genes[i].length-1) sol++;
    }

    float score = 0;
    
    int sc = school.studentCount;

    score = top*8;

    if (not == 0) score*=1.5;
    if (sol != 0) score*=0;
    
    if (sex != 0) score*=map(sex, 0, 2*sc, 4, 0);
    if (sex==0) score*=10;
    
    if (any!=sc) score*=pow(map(any, 0, sc, 0, 3), 2);
    if (any==sc) score*=10;

    //fitness = max(sqrt(score), 1);
    fitness = score;

    int[] out = {top, not, sex, sol, any};
    fitnessArg = out;
  }

  int GenesLength() {
    int total = 0;
    for (int i = 0; i < genes.length; i++) total += genes[i].length;
    return total;
  }

  // Combine the genes of the parents to make a child. called in generateNew().
  DNA crossOver(DNA parent) {
    DNA child = new DNA(school, rooms, true); //create the child.

  
    IntDict indices = new IntDict();
    for (int i = 0; i < genes.length; i++) {
      for (int j = 0; j < genes[i].length; j++) {
        Student c = genes[i][j];
        indices.set(c.id + "-i", i);
        indices.set(c.id + "-j", j);
      }
    }

    //print(indices);

    for (int i = 0; i < genes.length; i++) {
      for (int j = 0; j < genes[i].length; j++) {
        Student b = parent.genes[i][j];

        int ai = indices.get(b.id+"-i");
        int aj = indices.get(b.id+"-j");

        boolean ago = child.genes[ai][aj]==null;
        boolean bgo = child.genes[i][j]==null;

        if (random(1)<0.5 && ago) {
          child.genes[ai][aj] = b;
        } else if (bgo) {
          child.genes[i][j] = b;
        } else {
          ai = 0;
          aj = 0;
          while (child.genes[ai][aj]!=null) {
            aj++;
            if (aj>rooms[ai]-1) {
              ai++;
              aj = 0;
            }
          }
          child.genes[ai][aj] = b;
        }
        
        
      }
    }

    return child; //return the child.
  }

  // Mutate random gene. called in generateNew().
  void mutate(float mc) {

    // For each gene there is a chance mc that it will switch with another gene
    for (int i = 0; i < genes.length; i++) {
      for (int j = 0; j < genes[i].length; j++) {
        if (random(1) < mc) {
          int random1 = floor(random(genes.length));
          int random2 = floor(random(genes[random1].length));
          Student tempa = genes[i][j];
          Student tempb = genes[random1][random2];
          genes[i][j] = tempb;
          genes[random1][random2] = tempa;
        }
      }
    }
  }

  void displayConfig(int x, int y) {
    float su = textWidth('A'); //spacing unit

    line(x+8*su, y-8, x+8*su, y-18+20*genes.length);

    for (int i = 0; i < genes.length; i++) {

      int count = 0;
      float textX = x + 9*su;

      for (int j = 0; j < genes[i].length; j++) {
        //if (!genes[i][j].empty) {
        //  fill(genes[i][j].gender ? color(0, 0, 200):color(200, 0, 0));
        //  String t = genes[i][j].name + ((j==genes[i].length-1 || (j==genes[i].length-2&&genes[i][genes[i].length-1].empty)) ? "" : ", ");
        //  text(t, textX, y+i*20);
        //  textX += textWidth(t);
        //  count++;
        //}

        String t = "";
        if (genes[i][j].empty) {
          t+="EMPTY";
          fill(0, 100, 0);
        } else {
          t+=genes[i][j].name; 
          fill(genes[i][j].gender ? color(0, 0, 200):color(200, 0, 0));
          count++;
        }
        t+=(j==genes[i].length-1? "" : ", ");
        text(t, textX, y+i*20);
        textX += textWidth(t);
      }

      fill(0, 0, 0);

      text("[  /  ]", x, y+i*20);
      fill(count==genes[i].length ? 0: 100, 0, 0);
      text(nf(count, 2), x+su, y+i*20);
      fill(0, 0, 0);
      textFont(fBold);
      text(nf(genes[i].length, 2), x+4*su, y+i*20);
      textFont(f);
    }
  }
}
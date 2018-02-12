class School {

  ArrayList<Student> allStudents;

  int studentCount;

  School(int empty) {

    // Store JSON data in 'students' array

    JSONArray json = loadJSONArray(sketchPath()+"/test2-80.json");

    studentCount = json.size();

    allStudents = new ArrayList<Student>(studentCount+empty);

    for (int i=0; i<studentCount; i++) {
      allStudents.add(new Student(json.getJSONObject(i)));
    }
    for (int i=0; i<empty; i++) {
      allStudents.add(new Student(true));
    }
  }

  ArrayList<Student> getAll() {
    return new ArrayList<Student>(allStudents);
  }
}
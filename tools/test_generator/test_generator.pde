void setup() {
  surface.setVisible(false);

  int size = 8; //max 12

  JSONArray output = new JSONArray();

  Table fnm = loadTable(dataPath("fn-m.csv"));
  Table fnf = loadTable(dataPath("fn-f.csv"));
  Table ln = loadTable(dataPath("ln.csv"));
  
  int year = ceil(random(6));
  
  String[] groups = {"WEW", "HUW", "EB", "KA", "STW", "EI"};
  String[] subGroups = {"ASO", "BSO", "TSO"};

  // Load 'data/new.json' both into an array (input) and an object (template)
  JSONArray input = loadJSONArray(sketchPath("test2.json"));

  // Generate the basic json for every student in class i (name, surname, gender, class, id)
  for (int i = 0; i < size; i++) {
    boolean gender = i%2==0 ? true : false;
    char genderChar = gender?'M':'F';

    String group = str(year)+groups[floor(i/2)];  
    String subGroup = str(year)+subGroups[floor(i/4)]+'-'+genderChar; 

    for (int j = 0; j < input.size(); j++) {
      JSONObject json = new JSONObject();

      String name;
      String surname = ln.getString(floor(random(500)), 0);

      if (gender) name = fnm.getString(floor(random(500)), 0);
      else name = fnf.getString(floor(random(500)), 0);

      json.setString("name", name);
      json.setString("surname", surname);

      json.setBoolean("gender", gender);
      
      json.setString("group", group); //e.g: "5WEW"
      json.setString("subgroup", subGroup); //e.g: "5ASO"

      //json.setString("original", input.getJSONObject(j).getString("name")+"-" + i);

      String id = name.toUpperCase() + surname.toUpperCase() + group + genderChar;

      json.setString("id", id);

      output.setJSONObject(i*input.size()+j, json);
    }
  }

  // Generate 'top3' & 'not3' for every student;
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < input.size(); j++) {
      JSONObject original = input.getJSONObject(j);

      String[] top3o = original.getJSONArray("top3").getStringArray();
      String[] not3o = original.getJSONArray("not3").getStringArray();

      JSONArray top3 = new JSONArray();
      JSONArray not3 = new JSONArray();

      for (int k = 0; k < top3o.length; k++) {
        if (!top3o[k].equals("")) {
          String top3k = top3o[k];
          boolean b = top3k.indexOf("b")>0;
          int index = ( i*input.size() + (int(top3k.substring(0, top3k.length()-1)) % 10) + (b?4*input.size():0) ) % output.size();
          String id = output.getJSONObject(index).getString("id");
          top3.setString(k, id);
        }
      }
      for (int k = 0; k < not3o.length; k++) {
        if (!not3o[k].equals("")) {
          String not3k = not3o[k];
          boolean b = not3k.indexOf("b")>0;
          int index = ( i*input.size() + (int(not3k.substring(0, not3k.length()-1)) % 10) + (b?4*input.size():0) ) % output.size();
          String id = output.getJSONObject(index).getString("id");
          not3.setString(k, id);
        }
      }

      output.setJSONObject(i*input.size()+j, output.getJSONObject(i*input.size()+j).setJSONArray("top3", top3));
      output.setJSONObject(i*input.size()+j, output.getJSONObject(i*input.size()+j).setJSONArray("not3", not3));
    }
  }

  saveJSONArray(output, "final.json");

  exit();
}
class Student {
  
  String name;
  String surname;
  
  String year;
  boolean gender;
  
  String id;
  
  boolean empty;
  
  String[] top3;
  String[] not3;
  
  JSONObject json;
  
  Student(JSONObject json_) {
    
    json = json_;
    
    name = json.getString("name");
    surname = json.getString("surname");
    
    year = json.getString("class");
    gender = json.getBoolean("gender");
    
    id = json.getString("id");
    
    empty = false;
    
    top3 = json.getJSONArray("top3").getStringArray();
    not3 = json.getJSONArray("not3").getStringArray();
  }
  
  Student(boolean _empty) {
    
    name = "_";
    gender = true;
    
    empty = _empty;
    
    id = nf(floor(random(1000000)), 7);
 
    top3 = new String[3];
    not3 = new String[3];
  }
  
}
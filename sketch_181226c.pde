class GraphObject {
  
  int xPos;
  int yPos;
  int Stage;
  
  String notes;
  
  GraphObject(int x, int y, String notesArray) {
   
    xPos = x;
    yPos = y;
    
    notes = notesArray;
    
  }
  
}


int trigger = 0;
int numStages = 5;
ArrayList<GraphObject> gObjects = new ArrayList<GraphObject>();
int stepDuration = 1000;
int pruningThreshold = 3;
int fadeRatio = 50;

void setup() {
  size(500, 500);
  noStroke();
  background(0);
}

void draw() {
  
  if(millis() > trigger){
  
       
       for (GraphObject g : gObjects)  {

          println(g.xPos + "," + g.yPos + " -> " + g.notes + " " + g.Stage);
          
          if(g.Stage > numStages){
            continue;
          }
          if(g.Stage == numStages){
            fill(0);
          }
          else{
            fill(255 - (g.Stage * fadeRatio));
          
          }
           ellipse(g.xPos, g.yPos, 80, 80);
          g.Stage++;
       
    } // close of for
    
    
    
    
    trigger = millis() + stepDuration;
    
    
    // when we have a few elements, purge the array a little bit
    if(gObjects.size() > pruningThreshold){
      println("about to clean");
      for(int i = 0; i < pruningThreshold; i++){
        if(gObjects.get(i).Stage > numStages){
          println("removing " + i);
          gObjects.remove(i);
        }
      }
      println("gObjects size is now " + gObjects.size());
    }
     
  }
  
}


void mouseClicked() {
  GraphObject gObj = new GraphObject(mouseX, mouseY, "E5B5C5");
  gObjects.add(gObj);
  println("item count is now " + gObjects.size());
}

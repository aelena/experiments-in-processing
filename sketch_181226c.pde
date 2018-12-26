import processing.sound.*;

// basic class for sonic and graphic objects on canvas
class GraphObject {
  
  int xPos;
  int yPos;
  int Stage;
  
  IntList notes;
  String notesInput;
  
  GraphObject(int x, int y, String notesInput) {
   
    xPos = x;
    yPos = y;
    
    notes = new IntList(int(split(notesInput, ',')));
    notes.shuffle();
  }
  
}

// ===================================================

// parameters for audio
// Oscillator and envelope 
TriOsc triOsc;
Env env; 

// Times and levels for the ASR envelope
float attackTime = 0.001;
float sustainTime = 0.4;
float sustainLevel = 1.2;
float releaseTime = 2.2;

// note sequences
String [] soundBank = {
  
  "54,55,57,59",
  "58,60,61,64",
  "54,61,57,66",
  "56,59,64,49"
  
  
};

// ===================================================

// parameters for graphic stuff
int trigger = 0;
int numStages = 5;
ArrayList<GraphObject> gObjects = new ArrayList<GraphObject>();
int stepDuration = 1000;
int pruningThreshold = 3;
int fadeRatio = 50;
Reverb reverb;


// ===================================================

void setup() {
  size(500, 500);
  noStroke();
  background(0);
   // Create triangle wave and envelope 
  triOsc = new TriOsc(this);
  env  = new Env(this);

  
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
            if(g.Stage < 3){
              triOsc.play(midiToFreq(g.notes.array()[g.Stage]), 0.8, 0, (g.Stage % 2 == 0 ? 0.3 : 0.7));
              env.play(triOsc, attackTime, sustainTime, sustainLevel, releaseTime);
          
            }
            else {
              if(g.Stage == 3){
                triOsc.play(midiToFreq(g.notes.array()[g.Stage]), 0.8, 0, 0.5);
                env.play(triOsc, attackTime, sustainTime, sustainLevel, releaseTime + 1.0);
              }
            }
            
          
          }
           ellipse(g.xPos, g.yPos, 80, 80);
          g.Stage++;
       
    } // close of for
    
    
    
    
    trigger = millis() + stepDuration;
    
    
    // when we have a few elements, purge the array a little bit
    //if(gObjects.size() > pruningThreshold){
    //  println("about to clean");
    //  for(int i = 0; i < pruningThreshold; i++){
    //    if(gObjects.get(i).Stage > numStages){
    //      println("removing " + i);
    //      gObjects.remove(i);
    //    }
    //  }
    //  println("gObjects size is now " + gObjects.size());
    //}
     
  }
  
}


void mouseClicked() {
  println(soundBank[(int)random(0, soundBank.length)]);
  GraphObject gObj = new GraphObject(mouseX, mouseY, soundBank[(int)random(0, soundBank.length)]);
  gObjects.add(gObj);
  println("item count is now " + gObjects.size());
}

// This function calculates the respective frequency of a MIDI note
float midiToFreq(int note) {
  return (pow(2, ((note-69)/12.0)))*440;
}

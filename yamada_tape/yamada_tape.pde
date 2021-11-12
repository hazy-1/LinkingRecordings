import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;

// for Recording
AudioInput in;
AudioRecorder[] recorder = new AudioRecorder[100];
boolean recorded = false;

// for Playback
AudioOutput out;
FilePlayer[] player = new FilePlayer[100];

int record_no = 0;
int player_count = 0;

int flag;

boolean playFlag = false;

void setup(){
  size(500, 500);
  background(255);

  minim = new Minim(this);
  // beat = new AudioPlayer[3];

  in = minim.getLineIn(Minim.MONO, 2048);
  out = minim.getLineOut(Minim.MONO);
}

void draw(){ 
  background(255); 
  stroke(255);

  if(playFlag){
      playFunc();
  }

}

void keyReleased()
{
  if (key == 'r' ){
      player_count = 0;
      recFunc();
  }
  
  if (key == 's' ){
      saveFunc();
  }

  if(key ==  'p'){
    //   playFunc();
    playFlag = true;
  }
}

void recFunc() {
    recorder[record_no] = minim.createRecorder(in, "data/myrecording" + record_no + ".wav");
    recorder[record_no].beginRecord();
}

void saveFunc() {
    if(recorder[record_no].isRecording()) {
        recorder[record_no].endRecord();
        // recorded = true;

        player[record_no] = new FilePlayer(recorder[record_no].save());
        player[record_no].patch(out);

        record_no++;

        print(record_no);
    }
}

void playFunc() {
    player[player_count].play();

    if(player[player_count].position() >= player[player_count].length()) {
        player_count++;

        if(player_count >= record_no){
            playFlag = false;
            player_count = 0;

            for(int i = 0;  i < record_no; i++){
                player[i].cue(0);
            }
        }
    }
}
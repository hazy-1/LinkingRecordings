import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;

// for Recording
AudioInput in;
AudioRecorder[] recorder = new AudioRecorder[100];

// for Playback
AudioOutput out;
FilePlayer[] player = new FilePlayer[100];

//レコードする配列番号の保持
int record_no = 0;

//再生中の配列番号の保持
int player_count = 0;

int rec_flag_count = 0;

//再生可能状態の判別
boolean playFlag = false;

void setup(){
  size(500, 500);
  background(255);

  minim = new Minim(this);

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

void keyPressed() {
  rec_flag_count++;
  
  if (rec_flag_count == 1 && key == 'r' )
  { 
    if(player[0] != null){
        player[player_count].pause();
        playFlag = false;
        player_count = 0;
    }
    recFunc();
  }
}

void keyReleased()
{
  rec_flag_count = 0;

  if (key == 'r' )
  { 
    saveFunc();
    if(player[0] != null){
        playFlag = true;
    }
  }
}

void recFunc() {
    recorder[record_no] = minim.createRecorder(in, "data/myrecording" + record_no + ".wav");
    recorder[record_no].beginRecord();
}

void saveFunc() {
    if(recorder[record_no].isRecording()) {
        recorder[record_no].endRecord();

        player[record_no] = new FilePlayer(recorder[record_no].save());
        player[record_no].patch(out);

        record_no++;
    }
}

void playFunc() {
    delay(500);
    player[player_count].play();

    if(player[player_count].position() >= player[player_count].length()) {
        player[player_count].pause();
        player[player_count].cue(0);
        player_count++;

        if(player_count == record_no){
            player_count = 0;
        }
    }
}
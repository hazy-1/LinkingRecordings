import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;

// 録音できるデータ数
int max_record = 100;

// for Recording
AudioInput in;
AudioRecorder[] recorder = new AudioRecorder[max_record];

// for Playback
AudioOutput out;
FilePlayer[] player = new FilePlayer[max_record];
File file;

//レコードする配列番号の保持
int record_no = 0;

//再生中の配列番号の保持
int player_count = 0;

int rec_flag_count = 0;

//再生可能状態の判別
boolean play_flag = false;

void setup(){
  size(500, 500);
  background(255);

  minim = new Minim(this);

  in = minim.getLineIn(Minim.MONO, 2048);
  out = minim.getLineOut(Minim.MONO);

  checkFileExist();
}

void draw(){ 
  background(255); 
  stroke(255);

  if(play_flag){
      playFunc();
  }
}

void keyPressed() {
  rec_flag_count++;
  
  if (rec_flag_count == 1 && key == 'r' )
  { 
    if(player[0] != null){
        player[player_count].pause();
        play_flag = false;
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
        play_flag = true;
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

// 既に録音データがあるかをチェック
void checkFileExist() {
  // 確認対象のファイル名を保持
  String  file_name;

  // 既に録音データがあるかを判別
  boolean file_exist;

  for(int i = 0; i < max_record; i++) {
    file_name = "Documents/WORK/LinkingRecordings/yamada_tape2/data/myrecording" + i + ".wav";

    file = new File(file_name);
    file_exist = file.exists();

    if(file_exist == true){
      player[record_no] = new FilePlayer(minim.loadFileStream("data/myrecording" + record_no + ".wav"));
      player[record_no].patch(out);
      record_no++;

      if(i == 0 || file_exist == true){
        play_flag = true;
      }
    }
    else if(file_exist == false){
      return;
    }
  }
}

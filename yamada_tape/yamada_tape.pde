import ddf.minim.*;
import ddf.minim.ugens.*;
Minim minim;

// シリアル通信用のライブラリをインポート
import processing.serial.*;
Serial port;

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

// 奇数or偶数をカウントするために、キーを押した回数を保持
int key_count;

boolean press_flag = false;
boolean release_flag = false;

//再生可能状態の判別
boolean play_flag = false;

void setup()  {
  size(500, 500);
  background(255);

  minim = new Minim(this);

  in = minim.getLineIn(Minim.MONO, 2048);
  out = minim.getLineOut(Minim.MONO);

  checkFileExist();

  port = new Serial(this, "/dev/cu.usbmodem101", 9600);
}

void draw()  { 
  // background(255); 
  // stroke(255);

  onPushButton();

  if(play_flag) {
    playFunc();
  }
}

// void keyReleased() {
//   if (key == 'r' ) {
//       key_count++;

//       if(key_count % 2 == 1) {
//         if(player[0] != null) { 
//             player[player_count].pause();
//             play_flag = false;
//             player_count = 0;
//         }
//         recFunc();
//       }
//       else if(key_count % 2 == 0) {
//         saveFunc();

//         if(player[0] != null) {
//             play_flag = true;
//         }
//       }
//   }
// }

void onPushButton() {
  if (port.available() > 0 ) {
    
    // シリアルデータ受信
    if(press_flag ==  false && port.read() == 0) {
      press_flag = true;
    }
    else if(press_flag == true && port.read() == 1){
      release_flag = true;
    }
    else {
      return;
    }

    if(press_flag == true && release_flag == true) {
      press_flag = false;
      release_flag = false;
      key_count++;

      if(key_count % 2 == 1) {
        if(player[0] != null) { 
            player[player_count].pause();
            play_flag = false;
            player_count = 0;
        }
        recFunc();
      }
      else if(key_count % 2 == 0) {
        saveFunc();

        if(player[0] != null) {
            play_flag = true;
        }
      }
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

        if(player_count == record_no) {
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
    file_name = "Documents/WORK/LinkingRecordings/yamada_tape/data/myrecording" + i + ".wav";

    file = new File(file_name);
    file_exist = file.exists();

    if(file_exist == true) {
      player[record_no] = new FilePlayer(minim.loadFileStream("data/myrecording" + record_no + ".wav"));
      player[record_no].patch(out);
      record_no++;

      if(i == 0 || file_exist == true) {
        play_flag = true;
      }
    }
    else if(file_exist == false) {
      return;
    }
  }
}

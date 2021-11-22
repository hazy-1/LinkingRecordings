import processing.serial.*;

Serial port;

void setup() {
  size(300, 300);

  port = new Serial(this, "/dev/cu.usbmodem101", 9600);
}

void draw(){
    if (port.available() > 0 ) {
        // シリアルデータ受信
        int in_data = port.read();

        print(in_data);
    }
}

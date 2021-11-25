#include <Keyboard.h>

const int DIN_PIN = 7;

char ctrlKey = KEY_LEFT_GUI;

void setup() {
  
  pinMode( DIN_PIN, INPUT_PULLUP );
  Keyboard.begin();

  Serial.begin(9600);
  
}

void loop() {
  if(digitalRead(DIN_PIN) == 1)
  {
    Keyboard.releaseAll();
  }
  else if(digitalRead(DIN_PIN) == 0)
  {
    Keyboard.press('r');
  }
  
  delay(100);
}

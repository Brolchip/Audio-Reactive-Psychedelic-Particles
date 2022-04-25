//Define variable 'potValue' which reads sesnor values from Analog Input 1
const int potValue = A1;   



void setup() {
  // Initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

void loop() {
 //Print sensor values to Serial monitor
 Serial.println(analogRead(potValue));
}

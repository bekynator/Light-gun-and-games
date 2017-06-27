int raw = 0;
bool SendVibration = false;

void setup() {
  Serial.begin(9600);
  pinMode(A0, INPUT ); //photoresistor
  pinMode(2, INPUT_PULLUP); //gun trigger
  pinMode(7, OUTPUT); //rumble
}
void loop() {
  raw = analogRead(A0);
  int sensorVal = digitalRead(2);
  
  if (SendVibration == true)
  {
	SendVibration = false;
	digitalWrite(7, LOW); 
  }
  
  if (sensorVal == LOW)
  {
	SendVibration = true;
    Serial.println("SHOT");
    digitalWrite(7, HIGH); 
  }

  Serial.println(raw);
  delay(150);
}

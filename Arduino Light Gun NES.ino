int raw = 0;
void setup() {
  Serial.begin(9600);
  pinMode(A0, INPUT ); //photoresistor
  pinMode(2, INPUT_PULLUP); //gun trigger
  pinMode(7, OUTPUT); //rumble
}
void loop() {
  raw = analogRead(A0);
  int sensorVal = digitalRead(2);
  
  if (sensorVal == LOW)
  {
    Serial.println("SHOT");
    digitalWrite(7, HIGH); 
  } 
  else 
  {
    digitalWrite(7, LOW); 
  }

  Serial.println(raw);
  delay(200);
}

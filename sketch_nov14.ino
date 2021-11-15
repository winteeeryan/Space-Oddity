//slider
int sliderPin = A2;
int sliderValue;

// 2 buttons
int pin2 = D2;
int pin1 = D3;
int pin2State = 0;
int pin1State = 0;

// 3 sensors
int pin3 = A0;
int pin3Value;

// set up pin numbers for echo pin and trigger pins:
int trigPin = 11;
int echoPin = 12;
int pin4Value;

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Serial.begin (9600);
  delay(500);

}  

void loop() {
  sliderValue = analogRead(sliderPin);
  pin1State = digitalRead (pin1);
  pin2State = digitalRead (pin2);
  pin3Value = analogRead (pin3);
  
  // take the trigger pin low to start a pulse:
  digitalWrite(trigPin, LOW);
  // delay 2 microseconds:
  delayMicroseconds(2);
  // take the trigger pin high:
  digitalWrite(trigPin, HIGH);
  // delay 10 microseconds:
  delayMicroseconds(10);
  // take the trigger pin low again to complete the pulse:
  digitalWrite(trigPin, LOW);
 
  // listen for a pulse on the echo pin:
  long duration = pulseIn(echoPin, HIGH);
  // calculate the distance in cm.
  //Sound travels approx.0.0343 microseconds per cm.,
  // and it's going to the target and back (hence the /2):
  int distance = (duration * 0.0343) / 2;

  Serial.print(sliderValue);
  Serial. print(",");
  Serial. print (pin1State);
  Serial. print(",");
  Serial. print(pin2State);
  Serial. print(",");
  Serial. print(pin3Value);
  Serial. print(",");
  Serial. println(distance);
  pin4Value = distance;
  
  // a short delay between readings:
  delay(100);
  }
